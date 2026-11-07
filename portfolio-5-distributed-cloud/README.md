# Portfolio 5: Distributed and Cloud Database Exercise

Describe or demonstrate a distributed or cloud database approach for the [university portal](../CASE_STUDY.md).

This activity uses PostgreSQL logical replication in a local Docker Compose network. The primary accepts writes; the application routes reporting reads to the subscriber. No hosted cloud account is required.

## Working files

- [Publisher and subscriber architecture](architecture.md)
- [Docker Compose setup](compose.yaml)
- [Publication and subscription SQL](primary-publication.sql), [subscriber setup](subscriber-subscription.sql)
- [Write, read, and replication-status checks](write-primary.sql), [verify-replica.sql], [status-primary.sql], [status-replica.sql]
- [Pause replication](pause-replication.sql) and [resume replication](resume-replication.sql)
- [Run results](run-results.md)

## Evidence

- Logical-replication architecture and local Compose configuration
- Initial copy, streaming status, and publisher/subscriber outputs
- A paused-replication stale-read demonstration and catch-up after resuming
- Discussion of consistency, read routing, availability, failover, and sequence limitations

Captured output is linked from [run-results.md](run-results.md).

Start with `docker compose up -d`, then run the subscription setup as described in [run-results.md](run-results.md). This is a local teaching demo; the fixed credentials in the Compose and SQL setup files are for disposable containers only.
