# Distributed and Cloud Database Run Results

The Compose setup used PostgreSQL 16.14 logical replication between a publisher and subscriber. The primary was seeded from Portfolio 1; the subscriber received the initial table copy through the subscription.

## Run sequence

1. Start both services: `docker compose -f compose.yaml up -d`.
2. Wait for `primary` and `replica` to become healthy. Both init scripts create the same schema; only the primary loads the Portfolio 1 sample rows.
3. Create the subscription: `docker compose -f compose.yaml exec -T replica psql -U postgres -d mit8103_portfolio5 -f /p5/subscriber-subscription.sql`.
4. Wait until `status-replica.sql` shows a running worker and the initial table copy completes.
5. Capture publisher status using `status-primary.sql` and replica contents using `verify-replica.sql`.
6. Run `pause-replication.sql` on the replica, update the publisher with `write-primary.sql`, and capture the stale value from `verify-replica.sql`.
7. Run `resume-replication.sql`, wait for the updated value to appear on the replica, then capture the caught-up status.
8. Stop and remove the disposable environment with `docker compose -f compose.yaml down -v`.

## Environment

- Publisher and subscriber both used PostgreSQL 16.14 ([version output](postgres-version.txt)).
- `p5_subscription` connected with state `streaming` and `sync_state = async`.
- The subscriber apply worker was running, and publisher/receiver LSNs matched after catch-up.
- Initial synchronization copied 4 students; section 901 initially had capacity 3.

## Observed results

- While the subscription was disabled, the publisher changed section 901 capacity from 3 to 4, while the subscriber still returned 3.
- After the subscription was enabled, the subscriber returned capacity 4 and still showed all 4 students.
- This demonstrates eventual consistency: the subscriber served a stale value while replication was paused, then caught up after replication resumed.

Captured output:

- [Paused subscription](pause-output.txt), [publisher write](primary-write-output.txt), and [stale replica read](replica-stale-output.txt)
- [Resumed subscription](resume-output.txt) and [replica after catch-up](replica-caught-up-output.txt)
- [Publisher status](status-primary-output.txt) and [subscriber status](status-replica-output.txt)
