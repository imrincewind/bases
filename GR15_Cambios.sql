--Punto B-a

CREATE OR REPLACE FUNCTION FN_GR15_controlarCantJueces()
returns trigger AS $$
DECLARE
BEGIN
if((select c.cantJueces
from GR15_competencia c
where (c.idCompetencia = new.idCompetencia)) <
(select count (jc.nrodoc) 
from GR15_juezcompetencia jc
where (jc.idCompetencia = new.idCompetencia)))
THEN
RAISE EXCEPTION 'La competencia seleccionada ya posee la cantidad de jueces necesarios';
else return new;
end if;
return new;
end;$$
language 'plpgsql';


--TRIGGER

CREATE TRIGGER tr_controlarcantjueces 
AFTER INSERT ON gr15_juezcompetencia 
FOR EACH ROW EXECUTE PROCEDURE fn_gr15_controlarcantjueces();

--Punto B-b cambiar de lugar las cosas, probablemente a equipodeportista probablemente ghacer un alter table para que la fecha NOT null

CREATE OR REPLACE FUNCTION FN_GR15_controlarCantEquiposAnual()
returns trigger AS $$
DECLARE
BEGIN
if((
select count (distinct i.id)
from  gr15_inscripcion i
where (i.tipoDoc = new.tipoDoc)
and (i.nroDoc = new.nroDoc)
and (i.equipo_id IS NOT null)
and (new.equipo_id IS NOT null)
and (extract (year from i.fecha)) = (extract (year from new.fecha))) > 3)
THEN
RAISE EXCEPTION 'El deportista no puede inscribirse en un nuevo equipo, ya se inscribió a más de 3 dentro de este año';

else return new;
end if;
return new;
end;$$
language 'plpgsql';

--TRIGGER

CREATE TRIGGER tr_controlarCantEquiposAnual 
AFTER INSERT ON gr15_inscripcion 
FOR EACH ROW EXECUTE PROCEDURE fn_gr15_controlarCantEquiposAnual();

--Punto B-c

CREATE OR REPLACE FUNCTION FN_GR15_controlarFechaLimite()
returns trigger AS $$
DECLARE
BEGIN
if((select c.fechaLimiteInscripcion
from GR15_competencia c
where (c.idCompetencia = new.idCompetencia)) < (new.fecha))
THEN
RAISE EXCEPTION 'Imposible realizar la inscripción, pues la fecha de inscripción ya expiró';
else return new;
end if;
return new;
end;$$
language 'plpgsql';


--TRIGGER

CREATE TRIGGER tr_controlarFechaLimite
AFTER INSERT ON gr15_inscripcion 
FOR EACH ROW EXECUTE PROCEDURE fn_gr15_controlarFechaLimite();

--Punto B-d

alter table gr15_categoria
add constraint edadMinima
check ((edadMaxima - edadMinima) >=10);

--Punto B-e

alter table gr15_inscripcion
add constraint equipo
check ( ((tipoDoc IS NULL) AND (nroDoc IS NULL)) AND (Equipo_id IS NOT null ) 
OR ((tipoDoc IS NOT NULL) AND (nroDoc IS NOT NULL)) AND (Equipo_id IS null ));

--Punto B-f

--FALTAAAAA


--punto B-g



CREATE OR REPLACE FUNCTION FN_GR15_controlarCompetenciaGrupal()
returns trigger AS $$
DECLARE
BEGIN
if((select c.individual
from GR15_competencia c
where (c.idCompetencia = new.idCompetencia)) = 1')
and (new.Equipo_id IS NOT NULL)
THEN
RAISE EXCEPTION 'Imposible realizar la inscripción, pues la competencia a al que se quiere inscribir es individual';
else if((select c.individual
from GR15_competencia c
where (c.idCompetencia = new.idCompetencia)) = '0')
and (new.Equipo_id IS NULL)
THEN
RAISE EXCEPTION 'Imposible realizar la inscripción, pues la competencia a al que se quiere inscribir es grupal';
else return new;
end if;
end if;
return new;
end;$$
language 'plpgsql';


--TRIGGER

CREATE TRIGGER tr_controlarCompetenciaGrupal
AFTER INSERT ON gr15_inscripcion 
FOR EACH ROW EXECUTE PROCEDURE fn_gr15_controlarCompetenciaGrupal();

