/*
    GENERAR CUOTAS Y DESCUENTOS PARA UN PERIODO (AAAAMM)
*/
SET SERVEROUTPUT ON;
DECLARE
  v_monto number(12,4);
  v_tipocambio number(18,4);
  v_valorcuotaclp number(10,0);
  V_CONT NUMBER(8,0);
  V_TIPOSOCIO NUMBER(4,0);
  V_SEXO VARCHAR2(1);
  V_FENAC DATE;
  V_EDAD NUMBER(10,0);
  V_PERIODO NUMBER(6,0);
  BEGIN
    
    V_PERIODO := 202006;

    select valor into v_monto from valor_cuota_social where fefinvig is null;    
    select tasacambio into v_tipocambio from tasa_cambio where codmoneda = 'UF' and fecambio = to_date('2020-05-31', 'yyyy-MM-dd');
    select round(v_monto * v_tipocambio) into v_valorcuotaclp from dual;

    dbms_output.put_line('v_monto: ' || v_monto || ', v_tipocambio:' || v_tipocambio || ',v_valorcuotaclp' || v_valorcuotaclp);

    FOR SOCIO IN (select IDSOCIO, RUT, DV, NOMBRES, APATERNO from SOCIO) LOOP
        dbms_output.put_line('Nombre:' || socio.NOMBRES);
        
        insert into pso_cuota (IDSOCIO, PERIODO, MONTO_BRUTO, MONTO_DSCTO, MONTO_NETO, MONTO_ABONO, IDPAGADOR, ESTADO, OBSERVACION, FECRE, FEMOD)
        values (SOCIO.IDSOCIO, V_PERIODO, v_valorcuotaclp, 0,  v_valorcuotaclp, null, SOCIO.IDSOCIO, 'PEN', 'Cuota de Junio 2020', sysdate, null);
    END LOOP;

    SELECT COUNT(1) INTO V_CONT  FROM PSO_CUOTA;
    DBMS_OUTPUT.PUT_LINE('V_CONT: ' || V_CONT);

    FOR PC IN (SELECT IDSOCIO FROM PSO_CUOTA) LOOP
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

        IF (V_EDAD >= 60) THEN
            DBMS_OUTPUT.PUT_LINE('ADULTO MAYOR');
            UPDATE PSO_CUOTA
            SET MONTO_NETO = 0.4 * MONTO_BRUTO,
            MONTO_DSCTO = MONTO_BRUTO - 0.4 * MONTO_BRUTO
            WHERE IDSOCIO = PC.IDSOCIO;
        END IF;        
    END LOOP;

    INSERT INTO CUOTA 
    SELECT SQ_CUOTA.NEXTVAL, IDSOCIO, PERIODO, MONTO_BRUTO, MONTO_DSCTO, MONTO_NETO, MONTO_ABONO, IDPAGADOR, ESTADO, OBSERVACION, FECRE, FEMOD 
    FROM PSO_CUOTA;
END;

SELECT * FROM CUOTA;
SELECT * FROM CUOTA WHERE MONTO_DSCTO > 0;

SELECT S.NOMBRES, S.APATERNO, C.MONTO_BRUTO, C.MONTO_DSCTO, C.MONTO_NETO, T.GLOSA
FROM CUOTA C, SOCIO S, TIPO_SOCIO T
WHERE S.IDSOCIO = C.IDSOCIO
      AND T.IDTIPO = S.TIPOSOCIO
      AND MONTO_DSCTO > 0;

