select * from tasa_cambio;

select * from valor_cuota_social;

update valor_cuota_social set fecre = fecre - 180;

update valor_cuota_social set valor = 1.29, fecre = to_date('2019-10-01','yyyy-MM-dd'), observacion = null;

--update valor_cuota_social set valor = 1.29

update valor_cuota_social set fefinvig = to_date('2020-03-30','yyyy-MM-dd') where idvalcuota = 2;

truncate table valor_cuota_social;

insert into valor_cuota_social values (1, 1.1, 'UF', to_date('2019-10-15','yyyy-MM-dd'), to_date('2019-10-25','yyyy-MM-dd'), to_date('2020-01-20','yyyy-MM-dd'), null);
insert into valor_cuota_social values (2, 1.3, 'UF', to_date('2020-01-15','yyyy-MM-dd'), to_date('2020-01-31','yyyy-MM-dd'), to_date('2020-03-25','yyyy-MM-dd'), null);
insert into valor_cuota_social values (3, 0.74, 'UF', to_date('2020-03-15','yyyy-MM-dd'), to_date('2020-03-31','yyyy-MM-dd'), null, 'Cuota durante pandemia');

update valor_cuota_social set fefinvig = to_date('2020-01-30','yyyy-MM-dd') where idvalcuota = 2;
commit;

update valor_cuota_social set fevig = to_date('2020-03-31','yyyy-MM-dd') where idvalcuota = 1;

select * from valor_cuota_social;

select * from socio;

select * from cuota
select * from tasa_cambio;

truncate table cuota;

insert into cuota
select SQ_CUOTA.NEXTVAL, IDSOCIO, 202006, 20000, 0,  20000, null, IDSOCIO, 'PEN', 'Cuota de Mayo 2020', sysdate, null
from socio;

select * from valor_cuota_social where fefinvig is null;

select tasacambio from tasa_cambio where codmoneda = 'UF' and fecambio = to_date('2020-05-31', 'yyyy-MM-dd');

FOR socio IN (select RUT, NOMBRES, APATERNO
                         from socio) LOOP

    dbms_output.put_line('Nombre:' || socio.NOMBRES);

END LOOP;




