CREATE OR REPLACE PACKAGE PKG_SOCIO_CUOTAS_CALCULO AS

TYPE REFCURSOR IS REF CURSOR;

PROCEDURE PRC_GENERAR_CUOTA(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2);
PROCEDURE PRC_GENERAR_CUOTA_PSO(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2);

PROCEDURE PRC_GENERAR_CUOTA_PSO_PRUEBA(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2);

END PKG_SOCIO_CUOTAS_CALCULO;
/


CREATE OR REPLACE PACKAGE BODY PKG_SOCIO_CUOTAS_CALCULO AS

TYPE REFCURSOR IS REF CURSOR;

PROCEDURE PRC_GENERAR_CUOTA(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2)  IS
  v_monto number(12,4);
  v_tipocambio number(18,4);
  v_valorcuotaclp number(10,0);
  BEGIN
    P_ERRCOD:=0;
    P_ERRMSG:='';

    select valor into v_monto from valor_cuota_social where fefinvig is null;    
    select tasacambio into v_tipocambio from tasa_cambio where codmoneda = 'UF' and fecambio = to_date('2020-05-31', 'yyyy-MM-dd');
    select round(v_monto * v_tipocambio) into v_valorcuotaclp from dual;

    dbms_output.put_line('v_monto: ' || v_monto);
    dbms_output.put_line('v_tipocambio: ' || v_tipocambio);
    dbms_output.put_line('v_valorcuotaclp: ' || v_valorcuotaclp);

    FOR SOCIO IN (select IDSOCIO, RUT, DV, NOMBRES, APATERNO from SOCIO) LOOP

        dbms_output.put_line('Nombre:' || socio.NOMBRES);
        
        insert into cuota (IDCUOTA, IDSOCIO, PERIODO, MONTO_BRUTO, MONTO_DSCTO, MONTO_NETO, MONTO_ABONO, IDPAGADOR, ESTADO, OBSERVACION, FECRE, FEMOD)
        values (SQ_CUOTA.NEXTVAL, SOCIO.IDSOCIO, P_PERIODO, v_valorcuotaclp, 0,  v_valorcuotaclp, null, SOCIO.IDSOCIO, 'PEN', 'Cuota de Junio 2020', sysdate, null);

    END LOOP;

  END;
  
  PROCEDURE PRC_GENERAR_CUOTA_PSO(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2)  IS
  v_monto number(12,4);
  v_tipocambio number(18,4);
  v_valorcuotaclp number(10,0);
  V_CONT NUMBER(8,0);
  V_TIPOSOCIO NUMBER(4,0);
  V_SEXO VARCHAR2(1);
  BEGIN
    P_ERRCOD:=0;
    P_ERRMSG:='';

    select valor into v_monto from valor_cuota_social where fefinvig is null;    
    select tasacambio into v_tipocambio from tasa_cambio where codmoneda = 'UF' and fecambio = to_date('2020-05-31', 'yyyy-MM-dd');
    select round(v_monto * v_tipocambio) into v_valorcuotaclp from dual;

    dbms_output.put_line('v_monto: ' || v_monto);
    dbms_output.put_line('v_tipocambio: ' || v_tipocambio);
    dbms_output.put_line('v_valorcuotaclp: ' || v_valorcuotaclp);

    FOR SOCIO IN (select IDSOCIO, RUT, DV, NOMBRES, APATERNO from SOCIO) LOOP

        dbms_output.put_line('Nombre:' || socio.NOMBRES);
        
        --La idea es grabar todas las cuotas en tabla paso, luego hacer los calculos respectivos y grabarlas en la tabla cuota
        --¿Un insert a la tabla paso es diferente?
        insert into pso_cuota (IDSOCIO, PERIODO, MONTO_BRUTO, MONTO_DSCTO, MONTO_NETO, MONTO_ABONO, IDPAGADOR, ESTADO, OBSERVACION, FECRE, FEMOD)
        values (SOCIO.IDSOCIO, P_PERIODO, v_valorcuotaclp, 0,  v_valorcuotaclp, null, SOCIO.IDSOCIO, 'PEN', 'Cuota de Junio 2020', sysdate, null);
        
    END LOOP;
    
     SELECT COUNT(1) INTO V_CONT  FROM PSO_CUOTA;
     DBMS_OUTPUT.PUT_LINE('V_CONT: ' || V_CONT);
    
    /*Hacer unos if consultando si el idSocio de un socio en especifico es Becado = 2, Colaborador= 3 y Honorario = 5
    entonces dejar cuota en 0, ya que estos tipos de socios no pagan cuotas*/
    
    FOR PC IN (SELECT IDSOCIO FROM PSO_CUOTA) LOOP
        SELECT TIPOSOCIO, SEXO INTO V_TIPOSOCIO, V_SEXO FROM SOCIO WHERE IDSOCIO = PC.IDSOCIO;  
        
        IF(V_TIPOSOCIO = 2 OR V_TIPOSOCIO = 3 OR V_TIPOSOCIO = 5 ) THEN
            UPDATE PSO_CUOTA
            SET MONTO_NETO = 0,
            MONTO_DSCTO = MONTO_BRUTO
            WHERE IDSOCIO = PC.IDSOCIO;
        END IF;
        
        IF(V_TIPOSOCIO = 4) THEN
            UPDATE PSO_CUOTA
            SET MONTO_NETO = 10000,
            MONTO_DSCTO = MONTO_BRUTO - 10000
            WHERE IDSOCIO = PC.IDSOCIO;
        END IF;
        
        IF(V_SEXO = 'F') THEN
            UPDATE PSO_CUOTA
            SET MONTO_NETO = 0.5 * MONTO_BRUTO,
            MONTO_DSCTO = MONTO_BRUTO - 0.5 * MONTO_BRUTO
            WHERE IDSOCIO = PC.IDSOCIO;
        END IF;
        
    END LOOP;
    
    INSERT INTO CUOTA 
    SELECT SQ_CUOTA.NEXTVAL, IDSOCIO, PERIODO, MONTO_BRUTO, MONTO_DSCTO, MONTO_NETO, MONTO_ABONO, IDPAGADOR, ESTADO, OBSERVACION, FECRE, FEMOD 
    FROM PSO_CUOTA;
    
    
    /*Agregar al if mencionado anteriormente los casos de tipoSocio Estudiante = 4 y mujer (sexo = F) aplicar el descuento 
    correspondiente*/
    
    /*Finalmente de los if insertar las cuotas definitivas en la tabla Cuota*/

  END;
  
  
  
  
  PROCEDURE PRC_GENERAR_CUOTA_PSO_PRUEBA(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2) IS
  v_monto number(12,4);
  v_tipocambio number(18,4);
  v_valorcuotaclp number(10,0);
  V_CONT NUMBER(8,0);
  V_TIPOSOCIO NUMBER(4,0);
  V_SEXO VARCHAR2(1);
  V_FENAC DATE;
  V_EDAD NUMBER(10,0);
  BEGIN
    P_ERRCOD:=0;
    P_ERRMSG:='';

    select valor into v_monto from valor_cuota_social where fefinvig is null;    
    select tasacambio into v_tipocambio from tasa_cambio where codmoneda = 'UF' and fecambio = to_date('2020-06-20', 'yyyy-MM-dd');
    select round(v_monto * v_tipocambio) into v_valorcuotaclp from dual;

    dbms_output.put_line('v_monto: ' || v_monto);
    dbms_output.put_line('v_tipocambio: ' || v_tipocambio);
    dbms_output.put_line('v_valorcuotaclp: ' || v_valorcuotaclp);

    FOR SOCIO IN (select IDSOCIO, RUT, DV, NOMBRES, APATERNO from SOCIO) LOOP

        dbms_output.put_line('Nombre:' || socio.NOMBRES);
        
        --La idea es grabar todas las cuotas en tabla paso, luego hacer los calculos respectivos y grabarlas en la tabla cuota
        --¿Un insert a la tabla paso es diferente?
        insert into pso_cuota (IDSOCIO, PERIODO, MONTO_BRUTO, MONTO_DSCTO, MONTO_NETO, MONTO_ABONO, IDPAGADOR, ESTADO, OBSERVACION, FECRE, FEMOD)
        values (SOCIO.IDSOCIO, P_PERIODO, v_valorcuotaclp, 0,  v_valorcuotaclp, null, SOCIO.IDSOCIO, 'PEN', 'Cuota de Junio 2020', sysdate, null);
        
    END LOOP;
    
     SELECT COUNT(1) INTO V_CONT  FROM PSO_CUOTA;
     DBMS_OUTPUT.PUT_LINE('V_CONT: ' || V_CONT);
    
        
    FOR PC IN (SELECT IDSOCIO FROM PSO_CUOTA) LOOP
        SELECT TIPOSOCIO, SEXO, FENAC INTO V_TIPOSOCIO, V_SEXO, V_FENAC FROM SOCIO WHERE IDSOCIO = PC.IDSOCIO;  
        --CALCULAR AÑO ACTUAL - FECHA DE NACIMIENTO = EDAD
        --V_EDAD = (SYSDATE - V_FENAC);
        
        --BECADO ID=2 - COLABORADOR ID=3 - HONORARIO ID=5 NO PAGAN
        IF(V_TIPOSOCIO = 2 OR V_TIPOSOCIO = 3 OR V_TIPOSOCIO = 5 ) THEN
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
        --DBMS_OUTPUT.PUT_LINE('V_EDAD: ' || V_EDAD);
        
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
    
    
    /*Agregar al if mencionado anteriormente los casos de tipoSocio Estudiante = 4 y mujer (sexo = F) aplicar el descuento 
    correspondiente*/
    
    /*Finalmente de los if insertar las cuotas definitivas en la tabla Cuota*/

  END;
  

END PKG_SOCIO_CUOTAS_CALCULO;
/
