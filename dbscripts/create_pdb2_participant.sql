
create table flighttest(text VARCHAR2(100));
create table flights(id NUMBER, available NUMBER);
insert into flights values(1,2);
create or replace package dbms_flight_cbk as
function request(saga_id in RAW, saga_sender IN VARCHAR2, payload IN JSON DEFAULT NULL) return JSON;
procedure after_rollback(saga_id in RAW, saga_sender IN varchar2, payload IN JSON DEFAULT NULL);
end dbms_flight_cbk;
/

create or replace package body dbms_flight_cbk as
function request(saga_id in RAW, saga_sender IN VARCHAR2, payload IN JSON DEFAULT NULL) return JSON as
response JSON;
tickets NUMBER;
begin
  insert into flighttest values(saga_sender);
  insert into flighttest values(json_serialize(payload));
  select available into tickets from flights where id = 1;
  IF tickets > 0 THEN
    response := json('[{"result":"success"}]');
  ELSE
    response := json('[{"result":"failure"}]');
  END IF;
  update flights set available = available - 1 where id = 1;
  return response;
end;
/
  
procedure after_rollback(saga_id in RAW, saga_sender IN varchar2, payload IN JSON DEFAULT NULL)as
begin
  update flights set available = available + 1 where id = 1;
end;
end dbms_flight_cbk;
/

--Add participant
begin 
  dbms_saga_adm.add_participant(participant_name=> 'FlightPLSQL' ,  dblink_to_broker=> 'SAGAPDB1.PRIVATEK8SNET.K8SNET.ORACLEVCN.COM',mailbox_schema=> 'pdb_adm',broker_name=> 'TEST', callback_package => 'dbms_flight_cbk' , dblink_to_participant=> 'SAGAPDB2.PRIVATEK8SNET.K8SNET.ORACLEVCN.COM');
end;
/

create table hoteltest(text VARCHAR2(100));
create table hotels(id NUMBER, available NUMBER);
insert into hotels values(1,2);
create or replace package dbms_hotel_cbk as
function request(saga_id in RAW, saga_sender IN VARCHAR2, payload IN JSON DEFAULT NULL) return JSON;
procedure after_rollback(saga_id in RAW, saga_sender IN varchar2, payload IN JSON DEFAULT NULL);
end dbms_hotel_cbk;
/

create or replace package body dbms_hotel_cbk as
function request(saga_id in RAW, saga_sender IN VARCHAR2, payload IN JSON DEFAULT NULL) return JSON as
response JSON;
tickets NUMBER;
begin
  insert into hoteltest values(saga_sender);
  insert into hoteltest values(json_serialize(payload));
  select available into tickets from hotels where id = 1;
  IF tickets > 0 THEN
    response := json('[{"result":"success"}]');
  ELSE
    response := json('[{"result":"failure"}]');
  END IF;
  update hotels set available = available - 1 where id = 1;
  return response;
end;
/
  
procedure after_rollback(saga_id in RAW, saga_sender IN varchar2, payload IN JSON DEFAULT NULL)as
begin
  update hotels set available = available + 1 where id = 1;
end;
end dbms_hotel_cbk;
/

--Add participant
begin
  dbms_saga_adm.add_participant(participant_name=> 'HotelPLSQL' ,  dblink_to_broker=> 'SAGAPDB1.PRIVATEK8SNET.K8SNET.ORACLEVCN.COM',mailbox_schema=> 'pdb_adm',broker_name=> 'TEST', callback_package => 'dbms_hotel_cbk' , dblink_to_participant=> 'SAGAPDB2.PRIVATEK8SNET.K8SNET.ORACLEVCN.COM');
end;
/
  
create table cartest(text VARCHAR2(100));
create table cars(id NUMBER, available NUMBER);
insert into cars values(1,2);
create or replace package dbms_car_cbk as
function request(saga_id in RAW, saga_sender IN VARCHAR2, payload IN JSON DEFAULT NULL) return JSON;
procedure after_rollback(saga_id in RAW, saga_sender IN varchar2, payload IN JSON DEFAULT NULL);
end dbms_car_cbk;
/
