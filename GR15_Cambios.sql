--Punto B-a

CREATE OR REPLACE FUNCTION TRFN_GR15_controlarCantJueces()
returns trigger AS $$
DECLARE
BEGIN
if((select c.cantJueces
from GR15_competencia c
where (c.idCompetencia = new.idCompetencia)) >
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

CREATE TRIGGER tr_gr15_controlarcantjueces 
AFTER INSERT ON gr15_juezcompetencia 
FOR EACH ROW EXECUTE PROCEDURE fn_gr15_controlarcantjueces();

--Punto B-b 

CREATE OR REPLACE FUNCTION TRFN_GR15_controlarCantEquiposAnual()
returns trigger AS $$
DECLARE
BEGIN
if((
select count (ed.id)
from gr15_equipodeportista ed
where ed.tipodoc = new.tipodoc
and ed.nrodoc = new.nrodoc
and (extract (year from ed.fecha_inscripcion)) = (extract (year from new.fecha_inscripcion))) > 3)
THEN
RAISE EXCEPTION 'El deportista no puede inscribirse en un nuevo equipo, ya se inscribió a más de 3 dentro de este año';

else return new;
end if;
return new;
end;$$
language 'plpgsql';

--TRIGGER

CREATE TRIGGER tr_gr15_controlarCantEquiposAnual 
AFTER INSERT ON gr15_equipodeportista 
FOR EACH ROW EXECUTE PROCEDURE trfn_gr15_controlarCantEquiposAnual();

--Punto B-c

CREATE OR REPLACE FUNCTION TRFN_GR15_controlarFechaLimite()
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

CREATE TRIGGER tr_gr15_controlarFechaLimite
AFTER INSERT ON gr15_inscripcion 
FOR EACH ROW EXECUTE PROCEDURE trfn_gr15_controlarFechaLimite();

--Punto B-d

alter table gr15_categoria
add constraint edadMinima
check ((edadMaxima - edadMinima) <10);

--Punto B-e

alter table gr15_inscripcion
add constraint gr15_equipo
check ( ((tipoDoc IS NULL) AND (nroDoc IS NULL)) AND (Equipo_id IS NOT null ) 
OR ((tipoDoc IS NOT NULL) AND (nroDoc IS NOT NULL)) AND (Equipo_id IS null ));

--Punto B-f


CREATE OR REPLACE FUNCTION TRFN_GR15_controlarJuezDeportista()
returns trigger AS $$
DECLARE
BEGIN
if((new.idCompetencia in (select jc.idCompetencia
from gr15_juezcompetencia jc
where jc.tipodoc = new.tipodoc
and jc.nrodoc = new.nrodoc)))
THEN
RAISE EXCEPTION 'Imposible realizar la inscripción, quien se quiere inscribir es juez de la misma';
else return new;
end if;
return new;
end;$$
language 'plpgsql';


--TRIGGER

CREATE TRIGGER tr_gr15_controlarJuezDeportista
AFTER INSERT ON gr15_inscripcion 
FOR EACH ROW EXECUTE PROCEDURE trfn_gr15_controlarJuezDeportista();


--punto B-g



CREATE OR REPLACE FUNCTION TRFN_GR15_controlarCompetenciaGrupal()
returns trigger AS $$
DECLARE
BEGIN
if((select c.individual
from GR15_competencia c
where (c.idCompetencia = new.idCompetencia)) = '1')
and (new.Equipo_id IS NOT NULL)
THEN
RAISE EXCEPTION 'Imposible realizar la inscripción, pues la competencia a la que se quiere inscribir es individual';
else if((select c.individual
from GR15_competencia c
where (c.idCompetencia = new.idCompetencia)) = '0')
and (new.Equipo_id IS NULL)
THEN
RAISE EXCEPTION 'Imposible realizar la inscripción, pues la competencia a la que se quiere inscribir es grupal';
else return new;
end if;
end if;
return new;
end;$$
language 'plpgsql';


--TRIGGER

CREATE TRIGGER tr_gr15_controlarCompetenciaGrupal
AFTER INSERT ON gr15_inscripcion 
FOR EACH ROW EXECUTE PROCEDURE trfn_gr15_controlarCompetenciaGrupal();


--CREACION DE VISTAS
--PUNTO D1
create view vw_gr15_ordenarCompenciasPorDisciplinas 
as select * 
from gr15_competencia
order by cdodisciplina;



--d2 revisar
create view vw_gr15_mostrarCompetenciasConDeportistasSinclasificar
as select distinct c.idcompetencia
from gr15_competencia c, gr15_clasificacioncompetencia cc, gr15_inscripcion i
where  i.idcompetencia = cc.idcompetencia
and i.tipodoc = cc.tipodoc 
and i.nrodoc = cc.nrodoc
and cc.puntosGeneral is null
or cc.puntosCategoria is null;


--- otra parte que puede ayudar al d2

SELECT distinct i.idcompetencia
FROM gr15_clasificacioncompetencia cc
LEFT JOIN gr15_inscripcion i
ON cc.idcompetencia = i.idcompetencia
where cc.nrodoc is not = i.nrodoc
and cc.tipodoc is not = i.nrodoc;



--d3 anda joya, ver si se puede mejorar el tema de los nombres, trando de acortar, ej, gr15_deportista d, tira errores
create view vw_gr15_mostrarPuntosDeportistaAnioActual
as SELECT gr15_deportista.nrodoc ,sum( gr15_clasificacioncompetencia.puntoscategoria) as puntos_categoria, sum(gr15_clasificacioncompetencia.puntosgeneral) as puntos_general
FROM gr15_deportista 
INNER JOIN gr15_clasificacioncompetencia on ( gr15_deportista.nrodoc = gr15_clasificacioncompetencia.nrodoc)
where gr15_clasificacioncompetencia.idcompetencia in (SELECT distinct cc.idCompetencia
FROM gr15_clasificacioncompetencia cc, gr15_competencia c 
WHERE date_part('year', c.fecha) = date_part('year', CURRENT_DATE))
group by gr15_deportista.nrodoc;