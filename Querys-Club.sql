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



