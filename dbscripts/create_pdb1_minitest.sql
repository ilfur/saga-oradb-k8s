create table mbtest (text varchar2(2000));
create or replace package mb_cbk as
procedure response(saga_id in raw, saga_sender in varchar2, payload in JSON default null);
end mb_cbk;
create or replace package body mb_cbk as
procedure response(saga_id in RAW, saga_sender IN varchar2, payload IN JSON DEFAULT NULL) as
begin
  insert into mbtest values(saga_sender);
  insert into mbtest values(json_serialize(payload));
end;
end mb_cbk;
/
  
begin
  dbms_saga_adm.add_broker(broker_name => 'MBBroker', broker_schema => 'pdb_adm');
  dbms_saga_adm.add_coordinator(coordinator_name => 'MBCoordinator', mailbox_schema => 'pdb_adm', broker_name => 'MBBroker', dblink_to_coordinator => 'SAGAPDB1.PRIVATEK8SNET.K8SNET.ORACLEVCN.COM');
  dbms_saga_adm.add_participant(participant_name => 'MBInitiator',   coordinator_name => 'MBCoordinator' ,   dblink_to_broker => 'SAGAPDB1.PRIVATEK8SNET.K8SNET.ORACLEVCN.COM' ,   mailbox_schema => 'pdb_adm' ,   broker_name => 'MBBroker' ,   callback_package => 'mb_cbk' ,   dblink_to_participant => 'SAGAPDB1.PRIVATEK8SNET.K8SNET.ORACLEVCN.COM');
end;
/
