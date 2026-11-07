SELECT subname,
       pid IS NOT NULL AS worker_running,
       received_lsn,
       latest_end_lsn,
       latest_end_time
FROM pg_stat_subscription;
