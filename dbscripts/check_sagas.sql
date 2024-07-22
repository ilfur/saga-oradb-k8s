select id, name, broker_topic, queue_type from dba_saga_brokers;
select id, name, broker_name, coordinator, queue_type from dba_saga_participants;

SELECT id, initiator, coordinator, status FROM dba_sagas;
SELECT id, initiator, coordinator, status FROM dba_hist_sagas;
