declare
  saga_id RAW(16);
  request JSON;
begin
  saga_id := dbms_saga.begin_saga('TravelAgencyPLSQL', timeout=>10);
  request := json('{"flight":"United"}');
  dbms_saga.send_request(saga_id, 'FlightPLSQL', request);
  request := json('{"hotel":"Accor"}');
  dbms_saga.send_request(saga_id, 'HotelPLSQL', request);
end;
/
