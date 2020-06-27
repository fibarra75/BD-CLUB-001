--GENERAR 500 SOCIOS    
/*
   500 JUGADORES
   
   10%: Mayores de 70
   15%: Entre 60 y 69
   40%: Entre 40 y 59       
   30%:Entre 25 y 40
   5%: Menores de 25
*/
SET SERVEROUTPUT ON;
DECLARE
    TYPE REFCURSOR IS REF CURSOR;
    V_NOMBRE NVARCHAR2(80);
    V_APATERNO NVARCHAR2(60);
    V_ID NUMBER(4,0);
    V_EDAD NUMBER(6,0);
    CURSOR C1 IS
    SELECT RUT, DV, FENAC FROM (SELECT RUT, DV, FENAC FROM CLIENTE_EXT WHERE (SYSDATE - FENAC)/365 >= 70) C WHERE ROWNUM <= 50;
    CURSOR C2 IS
    SELECT RUT, DV, FENAC FROM (SELECT RUT, DV, FENAC FROM CLIENTE_EXT WHERE (SYSDATE - FENAC)/385 >= 60 AND (SYSDATE - FENAC)/365 < 70) C WHERE ROWNUM <= 75;
    CURSOR C3 IS
    SELECT RUT, DV, FENAC FROM (SELECT RUT, DV, FENAC FROM CLIENTE_EXT WHERE (SYSDATE - FENAC)/365 >= 40 AND (SYSDATE - FENAC)/365 < 60) C WHERE ROWNUM <= 200;
    CURSOR C4 IS
    SELECT RUT, DV, FENAC FROM (SELECT RUT, DV, FENAC FROM CLIENTE_EXT WHERE (SYSDATE - FENAC)/365 >= 25 AND (SYSDATE - FENAC)/365 < 40) C WHERE ROWNUM <= 150;
    CURSOR C5 IS
    SELECT RUT, DV, FENAC FROM (SELECT RUT, DV, FENAC FROM CLIENTE_EXT WHERE (SYSDATE - FENAC)/365 >= 12 AND (SYSDATE - FENAC)/365 < 25) C WHERE ROWNUM <= 25;
BEGIN

    INSERT INTO PSO_JUGADOR_ATP
    SELECT * FROM JUGADOR_ATP;
    
    --CREA SOCIOS SEGUN CONDICION DEL CURSO C1
    FOR C IN C1 LOOP       
       SELECT RNK, NOMBRE, APATERNO INTO V_ID, V_NOMBRE, V_APATERNO FROM (SELECT RNK, NOMBRE, APATERNO FROM PSO_JUGADOR_ATP ORDER BY DBMS_RANDOM.RANDOM) A WHERE ROWNUM < 2;
       
       SELECT (SYSDATE - C.FENAC)/365 INTO V_EDAD FROM DUAL;
       DBMS_OUTPUT.PUT_LINE('EDAD:' || V_EDAD || ',RUT:' || C.RUT || ',DV:' || C.DV || ', Nombre:' || V_NOMBRE || ',fenac:' || C.FENAC);
        
       PKG_SOCIO_CRUD.PRC_CREAR_SOCIO_EXT(C.RUT,C.DV,V_NOMBRE, V_APATERNO, NULL, 'M', C.FENAC, null, null, 6);
        
       DELETE FROM PSO_JUGADOR_ATP WHERE RNK = V_ID;
    END LOOP;
    
    --CREA SOCIOS SEGUN CONDICION DEL CURSO C2
    FOR C IN C2 LOOP       
       SELECT RNK, NOMBRE, APATERNO INTO V_ID, V_NOMBRE, V_APATERNO FROM (SELECT RNK, NOMBRE, APATERNO FROM PSO_JUGADOR_ATP ORDER BY DBMS_RANDOM.RANDOM) A WHERE ROWNUM < 2;
       
       SELECT (SYSDATE - C.FENAC)/365 INTO V_EDAD FROM DUAL;
       DBMS_OUTPUT.PUT_LINE('EDAD:' || V_EDAD || ',RUT:' || C.RUT || ',DV:' || C.DV || ', Nombre:' || V_NOMBRE || ',fenac:' || C.FENAC);
        
       PKG_SOCIO_CRUD.PRC_CREAR_SOCIO_EXT(C.RUT,C.DV,V_NOMBRE, V_APATERNO, NULL, 'M', C.FENAC, null, null, 6);
        
       DELETE FROM PSO_JUGADOR_ATP WHERE RNK = V_ID;
    END LOOP;    
    
    --CREA SOCIOS SEGUN CONDICION DEL CURSO C3
    FOR C IN C3 LOOP       
       SELECT RNK, NOMBRE, APATERNO INTO V_ID, V_NOMBRE, V_APATERNO FROM (SELECT RNK, NOMBRE, APATERNO FROM PSO_JUGADOR_ATP ORDER BY DBMS_RANDOM.RANDOM) A WHERE ROWNUM < 2;
       
       SELECT (SYSDATE - C.FENAC)/365 INTO V_EDAD FROM DUAL;
       DBMS_OUTPUT.PUT_LINE('EDAD:' || V_EDAD || ',RUT:' || C.RUT || ',DV:' || C.DV || ', Nombre:' || V_NOMBRE || ',fenac:' || C.FENAC);
        
       PKG_SOCIO_CRUD.PRC_CREAR_SOCIO_EXT(C.RUT,C.DV,V_NOMBRE, V_APATERNO, NULL, 'M', C.FENAC, null, null, 6);
        
       DELETE FROM PSO_JUGADOR_ATP WHERE RNK = V_ID;
    END LOOP;
    
    --CREA SOCIOS SEGUN CONDICION DEL CURSO C4
    FOR C IN C4 LOOP       
       SELECT RNK, NOMBRE, APATERNO INTO V_ID, V_NOMBRE, V_APATERNO FROM (SELECT RNK, NOMBRE, APATERNO FROM PSO_JUGADOR_ATP ORDER BY DBMS_RANDOM.RANDOM) A WHERE ROWNUM < 2;
       
       SELECT (SYSDATE - C.FENAC)/365 INTO V_EDAD FROM DUAL;
       DBMS_OUTPUT.PUT_LINE('EDAD:' || V_EDAD || ',RUT:' || C.RUT || ',DV:' || C.DV || ', Nombre:' || V_NOMBRE || ',fenac:' || C.FENAC);
        
       PKG_SOCIO_CRUD.PRC_CREAR_SOCIO_EXT(C.RUT,C.DV,V_NOMBRE, V_APATERNO, NULL, 'M', C.FENAC, null, null, 6);
        
       DELETE FROM PSO_JUGADOR_ATP WHERE RNK = V_ID;
    END LOOP;
    
    --CREA SOCIOS SEGUN CONDICION DEL CURSO C5
    FOR C IN C5 LOOP       
       SELECT RNK, NOMBRE, APATERNO INTO V_ID, V_NOMBRE, V_APATERNO FROM (SELECT RNK, NOMBRE, APATERNO FROM PSO_JUGADOR_ATP ORDER BY DBMS_RANDOM.RANDOM) A WHERE ROWNUM < 2;
       
       SELECT (SYSDATE - C.FENAC)/365 INTO V_EDAD FROM DUAL;
       DBMS_OUTPUT.PUT_LINE('EDAD:' || V_EDAD || ',RUT:' || C.RUT || ',DV:' || C.DV || ', Nombre:' || V_NOMBRE || ',fenac:' || C.FENAC);
        
       PKG_SOCIO_CRUD.PRC_CREAR_SOCIO_EXT(C.RUT,C.DV,V_NOMBRE, V_APATERNO, NULL, 'M', C.FENAC, null, null, 6);
        
       DELETE FROM PSO_JUGADOR_ATP WHERE RNK = V_ID;
    END LOOP;
    
    --ACTUALIZA EL TIPO DE SOCIO, SEGÚN LA CONDICIÓN
    FOR S IN (SELECT * FROM (SELECT IDSOCIO FROM SOCIO WHERE TIPOSOCIO = 6 
              AND (SYSDATE - FENAC)/365 < 25
              ORDER BY DBMS_RANDOM.RANDOM) WHERE ROWNUM < 15) LOOP
        DBMS_OUTPUT.PUT_LINE('IDSOCIO:' || S.IDSOCIO);
        --TIPOSOCIO = 2 = Becado
        UPDATE SOCIO SET TIPOSOCIO = 2 WHERE IDSOCIO = S.IDSOCIO;
    END LOOP;
    
    --ACTUALIZA EL TIPO DE SOCIO, SEGÚN LA CONDICIÓN
    FOR S IN (SELECT * FROM (SELECT IDSOCIO FROM SOCIO WHERE TIPOSOCIO = 6 ORDER BY DBMS_RANDOM.RANDOM) WHERE ROWNUM < 6) LOOP
        DBMS_OUTPUT.PUT_LINE('IDSOCIO:' || S.IDSOCIO);

        --TIPOSOCIO = 3 = Colaborador
        UPDATE SOCIO SET TIPOSOCIO = 3 WHERE IDSOCIO = S.IDSOCIO;
    END LOOP;
    
    --ACTUALIZA EL TIPO DE SOCIO, SEGÚN LA CONDICIÓN
    FOR S IN (SELECT * FROM (SELECT IDSOCIO FROM SOCIO WHERE TIPOSOCIO = 6 
              AND (SYSDATE - FENAC)/365 >= 50
              ORDER BY DBMS_RANDOM.RANDOM) WHERE ROWNUM < 15) LOOP
        DBMS_OUTPUT.PUT_LINE('IDSOCIO:' || S.IDSOCIO);

        --TIPOSOCIO = 5 = Honorario
        UPDATE SOCIO SET TIPOSOCIO = 5 WHERE IDSOCIO = S.IDSOCIO;
    END LOOP;
    
    --ACTUALIZA EL TIPO DE SOCIO, SEGÚN LA CONDICIÓN
    FOR S IN (SELECT * FROM (SELECT IDSOCIO FROM SOCIO WHERE TIPOSOCIO = 6
              AND (SYSDATE - FENAC)/365 < 27
              ORDER BY DBMS_RANDOM.RANDOM) WHERE ROWNUM < 10) LOOP
        DBMS_OUTPUT.PUT_LINE('IDSOCIO:' || S.IDSOCIO);

        --TIPOSOCIO = 4 = Estudiante
        UPDATE SOCIO SET TIPOSOCIO = 4 WHERE IDSOCIO = S.IDSOCIO;
    END LOOP;    
    
END;

SELECT * FROM TIPO_SOCIO;

TRUNCATE TABLE SOCIO;

SELECT COUNT(1) FROM SOCIO;

SELECT ROUND((SYSDATE - FENAC)/365) FROM SOCIO;

SELECT
(SELECT count(1) FROM SOCIO WHERE (SYSDATE - FENAC)/365 < 25) A1,
(SELECT count(1) FROM SOCIO WHERE (SYSDATE - FENAC)/365 >= 25 AND (SYSDATE - FENAC)/365 < 40) A2,
(SELECT count(1) FROM SOCIO WHERE (SYSDATE - FENAC)/365 >= 40 AND (SYSDATE - FENAC)/365 < 60) A3,
(SELECT count(1) FROM SOCIO WHERE (SYSDATE - FENAC)/365 >= 60 AND (SYSDATE - FENAC)/365 < 70) A4,
(SELECT count(1) FROM SOCIO WHERE (SYSDATE - FENAC)/365 >= 70) A5
FROM DUAL;

SELECT S.TIPOSOCIO, t.glosa, COUNT(1) 
FROM SOCIO S, TIPO_SOCIO T
WHERE t.idtipo = s.tiposocio
GROUP BY TIPOSOCIO, t.glosa;

SELECT COUNT(1) FROM CLIENTE_EXT WHERE (SYSDATE - FENAC)/365 <= 25;

SELECT COUNT(1) FROM CLIENTE_EXT WHERE (SYSDATE - FENAC)/365 > 25 AND (SYSDATE - FENAC)/365 <= 40;

SELECT COUNT(1) FROM CLIENTE_EXT WHERE (SYSDATE - FENAC)/365 >= 65;

SELECT * FROM (SELECT NOMBRE, APATERNO, EDAD FROM JUGADOR_ATP ORDER BY DBMS_RANDOM.RANDOM) WHERE ROWNUM < 2;
