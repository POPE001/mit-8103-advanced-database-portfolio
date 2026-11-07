# Transactions and Concurrency Run Results

The demonstrations ran in a fresh, disposable PostgreSQL 16.14 database using the Portfolio 1 schema and seed rows.

## Commit and rollback

Run [transaction-examples.sql](transaction-examples.sql). The commit persisted student 1001's email change. The rollback discarded student 1002's temporary email change; the original email remained. Full output is in [transaction-examples-output.txt](transaction-examples-output.txt).

## Unprotected last-seat race

1. Run [reset-concurrency-case.sql](reset-concurrency-case.sql). Section 901 has capacity 3 and starts with 2 active enrolments.
2. Launch two `psql` sessions concurrently, using student IDs 1003 and 1004 with section ID 901, and run [naive-enrolment-attempt.sql](naive-enrolment-attempt.sql) in each.
3. Run [verify-concurrency.sql](verify-concurrency.sql). Both sessions saw 2 active enrolments and each inserted one row, leaving 4 active enrolments against capacity 3. The result is in [naive-verify.txt](naive-verify.txt); session output is in [naive-session-1003.txt](naive-session-1003.txt) and [naive-session-1004.txt](naive-session-1004.txt).

## Row-locking control

1. Run [reset-concurrency-case.sql](reset-concurrency-case.sql) again.
2. Launch the same two sessions concurrently with [locked-enrolment-attempt.sql](locked-enrolment-attempt.sql).
3. Run [verify-concurrency.sql](verify-concurrency.sql). Student 1003 registered; student 1004's insert affected zero rows. The second session waited about 1.58 seconds to acquire the section lock, then saw the committed enrolment. The final count is 3 active enrolments against capacity 3, with no seat remaining. See [locked-verify.txt](locked-verify.txt) and the [session outputs](locked-session-1003.txt), [session 1004](locked-session-1004.txt).

An independent lock-wait check held the section row for six seconds; the second session waited about 5.2 seconds to acquire it. Its output is in [session A](lock-wait-session-a.txt) and [session B](lock-wait-session-b.txt).

## Explanation

The unprotected version stores the seat count in each client's `psql` variable before a delay. Both clients therefore make the insert decision using the same count. The protected version locks the `course_section` row with `SELECT ... FOR UPDATE` before checking the count. That serialises seat allocation for the section; after the first transaction commits, the waiting transaction's later count statement sees the new enrolment under PostgreSQL's `READ COMMITTED` isolation level.
