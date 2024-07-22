set linesize 150
column name format a20
column coordinator format a20
column start_time format a32
column finalization_time format a32
column initiator format a18
column broker_name format a5
column broker_topic format a10
  
select name, broker_topic, queue_type from dba_saga_brokers;
select name, broker_name, coordinator from dba_saga_participants;

SELECT start_time, initiator, coordinator, status FROM dba_sagas;
SELECT start_time, finalization_time, duration, initiator, coordinator, status FROM dba_hist_sagas;
