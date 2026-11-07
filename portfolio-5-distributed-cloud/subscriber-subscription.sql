CREATE SUBSCRIPTION p5_subscription
    CONNECTION 'host=primary port=5432 dbname=mit8103_portfolio5 user=replicator password=portfolio5_replica_demo'
    PUBLICATION p5_publication
    WITH (copy_data = true, create_slot = true, enabled = true);
