CREATE OR REPLACE PACKAGE PKG_SOCIO_CRUD AS

TYPE REFCURSOR IS REF CURSOR;

FUNCTION FNC_LISTA_SOCIOS RETURN REFCURSOR;
PROCEDURE PRC_LISTA_SOCIOS(P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2, P_DATA  OUT REFCURSOR);

FUNCTION FNC_OBTIENE_SOCIO(P_IDSOCIO IN NUMBER) RETURN REFCURSOR;
PROCEDURE PRC_OBTIENE_SOCIO(P_IDSOCIO IN NUMBER, P_DATA  OUT REFCURSOR);
PROCEDURE PRC_OBTIENE_SOCIO_X_RUT(P_RUT IN NUMBER, P_DATA  OUT REFCURSOR);

PROCEDURE PRC_CREAR_SOCIO(P_RUT IN NUMBER, P_DV IN NUMBER, P_NOMBRES IN NVARCHAR2, P_APATERNO IN NVARCHAR2, P_AMATERNO IN NVARCHAR2, P_SEXO IN varchar2, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2);
PROCEDURE PRC_CREAR_SOCIO_EXT(P_RUT IN NUMBER, P_DV IN NUMBER, P_NOMBRES IN NVARCHAR2, P_APATERNO IN NVARCHAR2, P_AMATERNO IN NVARCHAR2, P_SEXO IN varchar2, P_FENAC IN DATE, P_CORREO IN NVARCHAR2, P_NROCELULAR IN NUMBER);

PROCEDURE PRC_MODIFICAR_SOCIO(P_RUT IN NUMBER, P_NOMBRES IN NVARCHAR2, P_APATERNO IN NVARCHAR2, P_AMATERNO IN NVARCHAR2, P_SEXO IN varchar2, P_FENAC IN DATE, P_CORREO IN NVARCHAR2, P_NROCELULAR IN NUMBER);

PROCEDURE PRC_ELIMINAR_SOCIO(P_RUT IN NUMBER);
PROCEDURE PRC_ELIMINAR_SOCIO_X_ID(P_ID IN NUMBER);

END PKG_SOCIO_CRUD;
/


CREATE OR REPLACE PACKAGE BODY PKG_SOCIO_CRUD AS


FUNCTION FNC_LISTA_SOCIOS RETURN REFCURSOR IS
  CUR REFCURSOR;
  BEGIN

        OPEN CUR FOR      
        SELECT *
        FROM SOCIO;

        RETURN CUR;
  END;

PROCEDURE PRC_LISTA_SOCIOS(P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2, P_DATA OUT REFCURSOR) IS
  BEGIN
        OPEN P_DATA FOR
            SELECT
            A.IDSOCIO      IDSOCIO,
            A.RUT          RUT,
            A.DV           DV,
            A.NOMBRES      NOMBRES,
            A.APATERNO     APATERNO,
            A.AMATERNO     AMATERNO,
            A.SEXO         SEXO,
            A.FENAC        FENAC,
            A.CORREO       CORREO,
            A.NROCELULAR   NROCELULAR,
            A.TIPOSOCIO    TIPOSOCIO,
            A.IDESTADO     IDESTADO,
            A.FECRE        FECRE,
            A.FEMOD        FEMOD
            FROM SOCIO A;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            P_ERRCOD := 0;
            P_ERRMSG := SQLERRM;        
          WHEN OTHERS THEN
            P_ERRCOD := 1;
            P_ERRMSG := SQLERRM;            
  END;

FUNCTION FNC_OBTIENE_SOCIO(P_IDSOCIO IN NUMBER) RETURN REFCURSOR IS
  CUR REFCURSOR;
  BEGIN

        OPEN CUR FOR      
        SELECT *
        FROM SOCIO where IDSOCIO = P_IDSOCIO;

        RETURN CUR;
  END;

PROCEDURE PRC_OBTIENE_SOCIO(P_IDSOCIO IN NUMBER, P_DATA  OUT REFCURSOR) IS
  BEGIN
        OPEN P_DATA FOR
        SELECT
        A.IDSOCIO      IDSOCIO,
        A.RUT          RUT,
        A.DV           DV,
        A.NOMBRES      NOMBRES,
        A.APATERNO     APATERNO,
        A.AMATERNO     AMATERNO,
        A.SEXO         SEXO,
        A.FENAC        FENAC,
        A.CORREO       CORREO,
        A.NROCELULAR   NROCELULAR,
        A.TIPOSOCIO    TIPOSOCIO,
        A.IDESTADO     IDESTADO,
        A.FECRE        FECRE,
        A.FEMOD        FEMOD
        FROM SOCIO A
        WHERE A.IDSOCIO = P_IDSOCIO;
  END;

  PROCEDURE PRC_OBTIENE_SOCIO_X_RUT(P_RUT IN NUMBER, P_DATA  OUT REFCURSOR) IS
  BEGIN
    OPEN P_DATA FOR
        SELECT
        A.IDSOCIO      IDSOCIO,
        A.RUT          RUT,
        A.DV           DV,
        A.NOMBRES      NOMBRES,
        A.APATERNO     APATERNO,
        A.AMATERNO     AMATERNO,
        A.SEXO         SEXO,
        A.FENAC        FENAC,
        A.CORREO       CORREO,
        A.NROCELULAR   NROCELULAR,
        A.TIPOSOCIO    TIPOSOCIO,
        A.IDESTADO     IDESTADO,
        A.FECRE        FECRE,
        A.FEMOD        FEMOD
        FROM SOCIO A
        WHERE a.RUT = P_RUT;
  END;

PROCEDURE PRC_CREAR_SOCIO(P_RUT IN NUMBER, P_DV IN NUMBER, P_NOMBRES IN NVARCHAR2, P_APATERNO IN NVARCHAR2, P_AMATERNO IN NVARCHAR2, P_SEXO IN varchar2, P_ERRCOD OUT NUMBER, P_ERRMSG OUT VARCHAR2) IS
  V_CORR NUMBER;
  V_CONT NUMBER;
  BEGIN
    P_ERRCOD:=0;
    P_ERRMSG:='';
    V_CONT:= 0;
    
    SELECT COUNT(1) INTO V_CONT FROM SOCIO WHERE RUT = P_RUT;
    
    IF V_CONT = 0 THEN    
        --SELECT MAX(IDSOCIO) + 1 INTO V_CORR FROM SOCIO;
        SELECT SQ_SOCIO.NEXTVAL INTO V_CORR FROM DUAL;
    
        INSERT INTO SOCIO (IDSOCIO,RUT,DV,NOMBRES,APATERNO,AMATERNO,SEXO,FENAC,CORREO,NROCELULAR,TIPOSOCIO,IDESTADO,FECRE,FEMOD)
        VALUES (V_CORR,P_RUT,P_DV,P_NOMBRES,P_APATERNO,P_AMATERNO,P_SEXO,null,null,null,1,1,sysdate,null);
    ELSE
        P_ERRCOD:=1;
        P_ERRMSG:= 'El socio existe';
    END IF;

  END;

PROCEDURE PRC_CREAR_SOCIO_EXT(P_RUT IN NUMBER, P_DV IN NUMBER, P_NOMBRES IN NVARCHAR2, P_APATERNO IN NVARCHAR2, P_AMATERNO IN NVARCHAR2, P_SEXO IN varchar2, P_FENAC IN DATE, P_CORREO IN NVARCHAR2, P_NROCELULAR IN NUMBER) IS
V_CORR NUMBER;
  BEGIN
    --SELECT MAX(IDSOCIO) + 1 INTO V_CORR FROM SOCIO;
    SELECT SQ_SOCIO.NEXTVAL INTO V_CORR FROM DUAL;

    INSERT INTO SOCIO (IDSOCIO,RUT,DV,NOMBRES,APATERNO,AMATERNO,SEXO,FENAC,CORREO,NROCELULAR,TIPOSOCIO,IDESTADO,FECRE,FEMOD)
    VALUES (V_CORR,P_RUT,P_DV,P_NOMBRES,P_APATERNO,P_AMATERNO,P_SEXO,P_FENAC,P_CORREO,P_NROCELULAR,1,1,sysdate,null);

  END;

PROCEDURE PRC_MODIFICAR_SOCIO(P_RUT IN NUMBER, P_NOMBRES IN NVARCHAR2, P_APATERNO IN NVARCHAR2, P_AMATERNO IN NVARCHAR2, P_SEXO IN varchar2, P_FENAC IN DATE, P_CORREO IN NVARCHAR2, P_NROCELULAR IN NUMBER) IS
BEGIN
    UPDATE SOCIO
    SET 
    NOMBRES = P_NOMBRES,
    APATERNO = P_APATERNO,
    AMATERNO = P_AMATERNO,
    SEXO = P_SEXO,
    FENAC = P_FENAC,
    CORREO = P_CORREO,
    NROCELULAR = P_NROCELULAR
    WHERE RUT = P_RUT;
END;

PROCEDURE PRC_ELIMINAR_SOCIO(P_RUT IN NUMBER) IS
BEGIN
    DELETE FROM SOCIO
    WHERE RUT = P_RUT;
END;

PROCEDURE PRC_ELIMINAR_SOCIO_X_ID(P_ID IN NUMBER) IS
BEGIN
    DELETE FROM SOCIO
    WHERE IDSOCIO = P_ID;
END;

END PKG_SOCIO_CRUD;
/
