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

select * from socio;
SELECT * FROM JUGADOR_ATP where rownum < 10;

select A.* from (select ROWNUM as IDCLTE, RUT, DV, FENAC from cliente_pso) A where A.IDCLTE = 10000;

SELECT TRUNC(DBMS_RANDOM.VALUE(1,51)) random_numbers FROM dual CONNECT BY level <=6;

SELECT TRUNC(DBMS_RANDOM.VALUE(1,1000)) random_numbers FROM dual;

truncate table socio;
select * from socio;

SELECT MIN(IDCLTE), MAX(IDCLTE) FROM CLIENTE_EXT;

SET SERVEROUTPUT ON;
DECLARE
    TYPE REFCURSOR IS REF CURSOR;
    V_CONT NUMBER(8,0);
    V_RAND NUMBER(8,0);
    V_MIN NUMBER(8,0);
    V_MAX NUMBER(8,0);
    V_RUT NUMBER(10,0);
    V_DV VARCHAR2(1);
    V_FECHA date;
    CURSOR JUGADORES IS
    SELECT RNK, NOMBRE, APATERNO, EDAD FROM JUGADOR_ATP WHERE RNK < 301 ORDER BY RNK ASC;

BEGIN
    SELECT COUNT(1) into V_CONT FROM CLIENTE_EXT;   
   
    SELECT MIN(IDCLTE), MAX(IDCLTE) INTO V_MIN, V_MAX FROM CLIENTE_EXT;
    
    DBMS_OUTPUT.PUT_LINE('V_CONT: ' || V_CONT || ', V_MIN:' || V_MIN);
    
    FOR J IN JUGADORES LOOP
    
        SELECT TRUNC(DBMS_RANDOM.VALUE(V_MIN,V_CONT)) INTO V_RAND FROM DUAL;
        
        --select rut, dv, fenac into v_rut, v_dv, v_fecha from cliente_pso where rownum = v_rand;
        SELECT A.RUT, A.DV, A.FENAC into V_RUT, V_DV, V_FECHA FROM CLIENTE_EXT A WHERE A.IDCLTE = V_RAND;
    
        DBMS_OUTPUT.PUT_LINE('RUT:' || V_RUT || ',DV:' || V_DV || ', Nombre:' || J.NOMBRE || ',fenac:' || V_FECHA);
        
        PKG_SOCIO_CRUD.PRC_CREAR_SOCIO_EXT(V_RUT,V_DV,J.NOMBRE, J.APATERNO, NULL, 'M', V_FECHA, null, null);
        
    END LOOP;    
END;

select * from cliente_pso;

select * from cliente_ext;

INSERT INTO CLIENTE_EXT
SELECT SQ_CLTE.NEXTVAL, RUT, DV, FENAC from CLIENTE_PSO;

SELECT * FROM CLIENTE_EXT order by IDCLTE asc;

SELECT MIN(IDCLTE), MAX(IDCLTE) FROM CLIENTE_EXT;
select * from socio;
truncate table socio;

SELECT RNK, NOMBRE, APATERNO, EDAD FROM JUGADOR_ATP WHERE RNK < 11 ORDER BY RNK ASC;

select count(1) from socio order by idsocio asc;
select * from socio order by idsocio asc;
SELECT * FROM CUOTA;
TRUNCATE TABLE CUOTA;

SET SERVEROUTPUT ON;
DECLARE
    V_PERIODO NUMBER(6,0) := 202006;
    V_MONTO number(12,4);
    V_TIPOCAMBIO number(18,4);
    V_VALORCUOTACLP number(10,0);    
BEGIN

    SELECT VALOR INTO V_MONTO FROM VALOR_CUOTA_INICAL WHERE FEFINVIG IS NULL;    
    SELECT TASACAMBIO INTO V_TIPOCAMBIO FROM TASA_CAMBIO WHERE CODMONEDA = 'UF' AND FECAMBIO = TO_DATE('2020-05-31', 'yyyy-MM-dd');
    SELECT ROUND(V_MONTO * V_TIPOCAMBIO) INTO V_VALORCUOTACLP FROM DUAL;
   
    FOR SOCIO IN (SELECT IDSOCIO, RUT, NOMBRES, APATERNO FROM SOCIO WHERE ROWNUM < 20) LOOP
        DBMS_OUTPUT.PUT_LINE('NOMBRES:' ||SOCIO.NOMBRES);
        INSERT INTO CUOTA
        VALUES (SQ_CUOTA.NEXTVAL,SOCIO.IDSOCIO,V_PERIODO,V_VALORCUOTACLP,0,V_VALORCUOTACLP,0,SOCIO.IDSOCIO,'PEN','Cuota de Junio 2020',SYSDATE,NULL);
    END LOOP;    
   
END;

DROP TABLE JUGADOR_ATP;
SELECT * FROM JUGADOR_ATP;

select * from socio order by idsocio asc;
select count(1) from socio order by idsocio asc;

SELECT * FROM JUGADOR_ATP;
select * from cliente_ext order by idclte asc;

select * from valor_cuota_social;
select * from tasa_cambio;
select * from socio;
--truncate table socio;
select * from cuota;
select * from jugador_atp;
--truncate table jugador_atp
select * from CLIENTE_EXT;
select count(1) from CLIENTE_EXT;
--truncate table CLIENTE_EXT
SELECT MIN(IDCLTE), MAX(IDCLTE) FROM CLIENTE_EXT;

-------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
    TYPE REFCURSOR IS REF CURSOR;
    V_CONT NUMBER(8,0);
    V_RAND NUMBER(8,0);
    V_MIN NUMBER(8,0);
    V_MAX NUMBER(8,0);
    V_RUT NUMBER(10,0);
    V_DV VARCHAR2(1);
    V_FECHA date;
    CURSOR JUGADORES IS
    SELECT RNK, NOMBRE, APATERNO, EDAD FROM JUGADOR_ATP WHERE RNK < 301 ORDER BY RNK ASC;

BEGIN
    SELECT COUNT(1) into V_CONT FROM CLIENTE_EXT;   
   
    SELECT MIN(IDCLTE), MAX(IDCLTE) INTO V_MIN, V_MAX FROM CLIENTE_EXT;
    
    DBMS_OUTPUT.PUT_LINE('V_CONT: ' || V_CONT || ', V_MIN:' || V_MIN);
    
    FOR J IN JUGADORES LOOP
    
        SELECT TRUNC(DBMS_RANDOM.VALUE(V_MIN,V_CONT)) INTO V_RAND FROM DUAL;
        
        DBMS_OUTPUT.PUT_LINE('V_RAND: ' || V_RAND);
        
        SELECT A.RUT, A.DV, A.FENAC into V_RUT, V_DV, V_FECHA FROM CLIENTE_EXT A WHERE A.IDCLTE = V_RAND;
    
        DBMS_OUTPUT.PUT_LINE('RUT:' || V_RUT || ',DV:' || V_DV || ', Nombre:' || J.NOMBRE || ',fenac:' || V_FECHA);
        
        PKG_SOCIO_CRUD.PRC_CREAR_SOCIO_EXT(V_RUT,V_DV,J.NOMBRE, J.APATERNO, NULL, 'M', V_FECHA, null, null);
        
    END LOOP;    
END;

SELECT * FROM CLIENTE_EXT A WHERE A.IDCLTE = 19317;

SELECT * FROM CLIENTE_EXT order by idclte desc;

grant select on cliente_ext to club002;
grant select on jugador_atp to club002;

truncate table cliente_ext;
truncate table jugador_atp;

insert into cliente_ext
select * from club.cliente_ext;

insert into jugador_atp
select * from club.jugador_atp;

select count (1) from socio;
select * from socio;

select * from cuota;




