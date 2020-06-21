CREATE OR REPLACE PACKAGE PKG_SOCIO_CUOTAS_CALCULO AS

TYPE REFCURSOR IS REF CURSOR;

PROCEDURE PRC_GENERAR_CUOTA(P_PERIODO IN NUMBER, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2);

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
    
    FOR socio IN (select RUT, NOMBRES, APATERNO
                         from SOCIO) LOOP

        dbms_output.put_line('Nombre:' || socio.NOMBRES);

    END LOOP;


    insert into cuota
    select SQ_CUOTA.NEXTVAL, IDSOCIO, P_PERIODO, v_valorcuotaclp, 0,  v_valorcuotaclp, null, IDSOCIO, 'PEN', 'Cuota de Junio 2020', sysdate, null
    from socio;

  END;

END PKG_SOCIO_CUOTAS_CALCULO;
/
