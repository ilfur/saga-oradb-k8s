begin
  dbms_saga_adm.add_broker(broker_name => 'TEST', broker_schema => 'pdb_adm');
end;
/
  
//demo1: cloud bank transfer

--begin
--  dbms_saga_adm.add_coordinator(coordinator_name => 'CloudBankCoordinator', mailbox_schema => 'pdb_adm', broker_name => 'TEST', dblink_to_coordinator => null);
--  dbms_saga_adm.add_participant(participant_name => 'CloudBank', coordinator_name => 'CloudBankCoordinator' , dblink_to_broker => null , mailbox_schema => 'pdb_adm' , broker_name => 'TEST', dblink_to_participant => 'SAGAPDB1.PRIVATEK8SNET.K8SNET.ORACLEVCN.COM');
--end;

//demo2: travel agency bookings
create table travelagencytest(text VARCHAR2(100));

create or replace package dbms_ta_cbk as
procedure response(saga_id in raw, saga_sender in varchar2, payload in JSON default null);
end dbms_ta_cbk;
/
  
create or replace package body dbms_ta_cbk as
procedure response(saga_id in RAW, saga_sender IN varchar2, payload IN JSON DEFAULT NULL) as
booking_result VARCHAR2(10);
begin
  insert into travelagencytest values(saga_sender);
  insert into travelagencytest values(json_serialize(payload));
  booking_result := json_value(payload, '$.result');
  IF booking_result = 'success' THEN
    dbms_saga.commit_saga('TravelAgencyPLSQL', saga_id);
  ELSE
    dbms_saga.rollback_saga('TravelAgencyPLSQL', saga_id);
  END IF;
end;
end dbms_ta_cbk;
/


begin
    dbms_saga_adm.add_coordinator(coordinator_name => 'TravelCoordinator', mailbox_schema => 'pdb_adm', broker_name => 'TEST', dblink_to_coordinator => 'SAGA1');
    dbms_saga_adm.add_participant(participant_name => 'TravelAgencyPLSQL',   coordinator_name => 'TravelCoordinator' ,   dblink_to_broker => 'SAGA1' ,   mailbox_schema => 'pdb_adm' ,   broker_name => 'TEST' ,   callback_package => 'dbms_ta_cbk' ,   dblink_to_participant => 'SAGA1');
end;
/
