CREATE OR REPLACE PACKAGE PKG_SOCIO_PROCESOS AS
TYPE REFCURSOR IS REF CURSOR;

PROCEDURE PRC_GENERAR_CUOTAS(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2);

END PKG_SOCIO_PROCESOS;
/


CREATE OR REPLACE PACKAGE BODY PKG_SOCIO_PROCESOS AS

PROCEDURE PRC_GENERAR_CUOTAS(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2) IS
  V_MONTO NUMBER(12,4):=0;
  V_TIPOCAMBIO NUMBER(18,4):=0;
  V_VALORCUOTACLP NUMBER(10,0):=0;
  V_CONT NUMBER(8,0);
  V_TIPOSOCIO NUMBER(4,0);
  V_SEXO VARCHAR2(1);
  V_FENAC DATE;
  V_EDAD NUMBER(10,0);
  V_PERIODO NUMBER(6,0);
  V_CODMON VARCHAR2(3);
  BEGIN
    V_PERIODO := P_PERIODO; 

    SELECT VALOR, CODMONEDA INTO V_MONTO, V_CODMON FROM VALOR_CUOTA_SOCIAL WHERE FEFINVIG IS NULL;

    V_VALORCUOTACLP := V_MONTO;

    IF (V_CODMON = 'UF') THEN
        SELECT TASACAMBIO INTO V_TIPOCAMBIO FROM TASA_CAMBIO WHERE CODMONEDA = 'UF' AND FECAMBIO = TO_DATE('2020-05-31', 'yyyy-MM-dd');
        SELECT ROUND(V_MONTO * V_TIPOCAMBIO) INTO V_VALORCUOTACLP FROM DUAL;
        DBMS_OUTPUT.PUT_LINE('V_MONTO: ' || V_MONTO || ', V_TIPOCAMBIO:' || V_TIPOCAMBIO || ',V_VALORCUOTACLP' || V_VALORCUOTACLP);
    END IF;

    DBMS_OUTPUT.PUT_LINE('V_CODMON:' || V_CODMON || ',V_MONTO: ' || V_MONTO || ', V_TIPOCAMBIO:' || V_TIPOCAMBIO || ',V_VALORCUOTACLP' || V_VALORCUOTACLP);

    INSERT INTO PSO_CUOTA
    SELECT IDSOCIO, V_PERIODO, V_VALORCUOTACLP, 0, V_VALORCUOTACLP, NULL, IDSOCIO, 'PEN', 'Cuota de Junio 2020', SYSDATE, NULL
    FROM SOCIO;

    SELECT COUNT(1) INTO V_CONT  FROM PSO_CUOTA;
    DBMS_OUTPUT.PUT_LINE('V_CONT: ' || V_CONT);

    FOR PC IN (SELECT IDSOCIO, MONTO_BRUTO, MONTO_NETO FROM PSO_CUOTA) LOOP
        SELECT TIPOSOCIO, SEXO, FENAC INTO V_TIPOSOCIO, V_SEXO, V_FENAC FROM SOCIO WHERE IDSOCIO = PC.IDSOCIO;  

        --BECADO ID=2 - COLABORADOR ID=3 - HONORARIO ID=5 NO PAGAN
        IF(V_TIPOSOCIO = 2 OR V_TIPOSOCIO = 3 OR V_TIPOSOCIO = 5) THEN
            UPDATE PSO_CUOTA
            SET MONTO_NETO = 0,
            MONTO_DSCTO = MONTO_BRUTO
            WHERE IDSOCIO = PC.IDSOCIO;
        END IF;

        --ESTUDIANTE ID=4 PAGA 50%
        IF(V_TIPOSOCIO = 4) THEN
            UPDATE PSO_CUOTA
            SET MONTO_NETO = 0.5 * MONTO_BRUTO,
            MONTO_DSCTO = MONTO_BRUTO - 0.5 * MONTO_BRUTO
            WHERE IDSOCIO = PC.IDSOCIO;
        END IF;

        --MUJERES PAGAN 60%
        IF(V_SEXO = 'F') THEN
            UPDATE PSO_CUOTA
            SET MONTO_NETO = 0.6 * MONTO_BRUTO,
            MONTO_DSCTO = MONTO_BRUTO - 0.6 * MONTO_BRUTO
            WHERE IDSOCIO = PC.IDSOCIO;
        END IF;

        SELECT (SYSDATE - V_FENAC)/365 INTO V_EDAD FROM DUAL;

        IF (V_TIPOSOCIO = 6 AND V_EDAD >= 60) THEN
            DBMS_OUTPUT.PUT_LINE('ADULTO MAYOR' || ',V_TIPOSOCIO:' || V_TIPOSOCIO || ',PC.MONTO_NETO:' || PC.MONTO_NETO || ',PC.MONTO_BRUTO:' || PC.MONTO_BRUTO);            
            IF (PC.MONTO_NETO > 0.6 * PC.MONTO_BRUTO) THEN            
                UPDATE PSO_CUOTA
                SET MONTO_NETO = 0.6 * MONTO_BRUTO,
                MONTO_DSCTO = MONTO_BRUTO - 0.6 * MONTO_BRUTO
                WHERE IDSOCIO = PC.IDSOCIO;
            END IF;
        END IF;        
    END LOOP;

    INSERT INTO CUOTA 
    SELECT SQ_CUOTA.NEXTVAL, IDSOCIO, PERIODO, MONTO_BRUTO, MONTO_DSCTO, MONTO_NETO, MONTO_ABONO, IDPAGADOR, ESTADO, OBSERVACION, FECRE, FEMOD 
    FROM PSO_CUOTA
    WHERE PERIODO = P_PERIODO;
  END;
END PKG_SOCIO_PROCESOS;
/
