# Portfolio 3: Transactions and Concurrency

Demonstrate transaction behaviour using operations from the [university portal](../CASE_STUDY.md).

The workload uses the limited-seat section from Portfolio 1. It first shows the race when two `READ COMMITTED` transactions check the last seat without a lock, then protects the same operation by locking the section row.

## Working files

- [Commit and rollback examples](transaction-examples.sql)
- [Reset the last-seat scenario](reset-concurrency-case.sql)
- [Unprotected enrolment attempt](naive-enrolment-attempt.sql)
- [Locked enrolment attempt](locked-enrolment-attempt.sql)
- [Concurrency verification query](verify-concurrency.sql)
- [Run results](run-results.md)
- [Commit and rollback output](transaction-examples-output.txt)
- [Unprotected session outputs](naive-session-1003.txt), [session 1004](naive-session-1004.txt), and [overbooking result](naive-verify.txt)
- [Protected session outputs](locked-session-1003.txt), [session 1004](locked-session-1004.txt), and [final seat count](locked-verify.txt)
- [Standalone row-lock wait check](lock-wait-session-a.txt) and [waiting session](lock-wait-session-b.txt)

## Planned evidence

- Transactions that commit and roll back
- Two-session reproduction of overbooking under `READ COMMITTED` without a row lock
- The row-locking control and output showing only one registration succeeds
- A short explanation of the observed behaviour

Run these scripts only in a disposable database created from the Portfolio 1 schema and seed data. The concurrency attempt scripts require two simultaneous `psql` sessions. Recorded output and the conclusions are in [run-results.md](run-results.md).
