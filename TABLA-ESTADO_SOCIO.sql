CREATE TABLE "ESTADO_SOCIO" 
(	"IDSESTADO" NUMBER(10,0), 
"GLOSA" NVARCHAR2(80), 
"FECRE" DATE, 
"FEMOD" DATE
);
REM INSERTING into ESTADO_SOCIO
SET DEFINE OFF;
Insert into ESTADO_SOCIO (IDSESTADO,GLOSA,FECRE,FEMOD) values ('1','Ingresado',to_date('23/06/20','DD/MM/RR'),null);
Insert into ESTADO_SOCIO (IDSESTADO,GLOSA,FECRE,FEMOD) values ('2','Activo',to_date('23/06/20','DD/MM/RR'),null);
Insert into ESTADO_SOCIO (IDSESTADO,GLOSA,FECRE,FEMOD) values ('3','Congelado',to_date('23/06/20','DD/MM/RR'),null);
Insert into ESTADO_SOCIO (IDSESTADO,GLOSA,FECRE,FEMOD) values ('4','Castigado',to_date('23/06/20','DD/MM/RR'),null);
Insert into ESTADO_SOCIO (IDSESTADO,GLOSA,FECRE,FEMOD) values ('5','Retirado',to_date('23/06/20','DD/MM/RR'),null);
Insert into ESTADO_SOCIO (IDSESTADO,GLOSA,FECRE,FEMOD) values ('6','Expulsado',to_date('23/06/20','DD/MM/RR'),null);
--------------------------------------------------------
--  Constraints for Table ESTADO_SOCIO
--------------------------------------------------------

ALTER TABLE "ESTADO_SOCIO" MODIFY ("IDSESTADO" NOT NULL ENABLE);
ALTER TABLE "ESTADO_SOCIO" MODIFY ("GLOSA" NOT NULL ENABLE);
ALTER TABLE "ESTADO_SOCIO" MODIFY ("FECRE" NOT NULL ENABLE);
