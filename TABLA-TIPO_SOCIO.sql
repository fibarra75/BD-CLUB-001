CREATE TABLE "TIPO_SOCIO" 
(	"IDTIPO" NUMBER(10,0), 
"GLOSA" NVARCHAR2(80), 
"FECRE" DATE, 
"FEMOD" DATE
);
REM INSERTING into TIPO_SOCIO
SET DEFINE OFF;
Insert into TIPO_SOCIO (IDTIPO,GLOSA,FECRE,FEMOD) values ('1','Visita',to_date('23/06/20','DD/MM/RR'),null);
Insert into TIPO_SOCIO (IDTIPO,GLOSA,FECRE,FEMOD) values ('2','Becado',to_date('23/06/20','DD/MM/RR'),null);
Insert into TIPO_SOCIO (IDTIPO,GLOSA,FECRE,FEMOD) values ('3','Colaborador',to_date('23/06/20','DD/MM/RR'),null);
Insert into TIPO_SOCIO (IDTIPO,GLOSA,FECRE,FEMOD) values ('4','Estudiante',to_date('23/06/20','DD/MM/RR'),null);
Insert into TIPO_SOCIO (IDTIPO,GLOSA,FECRE,FEMOD) values ('5','Honorario',to_date('23/06/20','DD/MM/RR'),null);
Insert into TIPO_SOCIO (IDTIPO,GLOSA,FECRE,FEMOD) values ('6','Normal',to_date('23/06/20','DD/MM/RR'),null);
--------------------------------------------------------
--  Constraints for Table TIPO_SOCIO
--------------------------------------------------------

ALTER TABLE "TIPO_SOCIO" MODIFY ("IDTIPO" NOT NULL ENABLE);
ALTER TABLE "TIPO_SOCIO" MODIFY ("GLOSA" NOT NULL ENABLE);
ALTER TABLE "TIPO_SOCIO" MODIFY ("FECRE" NOT NULL ENABLE);
