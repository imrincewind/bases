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
FOR EACH ROW EXECUTE PROCEDURE trfn_gr15_controlarcantjueces();

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

--punto bh algo de aca debe servir, la consulta devuelve bien los valores del select A falta ver como triggearlo y cuando y donde
--puede haber una forma más sencilla, que retorne todos los id de deportistas (para comprobar que sus puntos sean iguales)
-- solo buscando dentro de la tabla clasificacioncompetencia y sacando los nrodoc y tipodoc de los que matchen los campos
-- de puntos y... contando la cantidad de matches ahi(  de eso) se podria igualar a un sum de esto que esta hecho, es decir,
-- misma competencia, mismos puntos ej 2 jugadores, equipo jugadores 2 2=2 quiere decir que todos los jugadores del equipo
-- tienen los mismos puntos...
--pero puede tirar error si se le cargó mal los puntos a otro
--- habría dos con los mismos puntos en una misma competencia peero no serian los mismos dos que del otro lado...
--- el tema que se complica es comparar más de un campo... sino se podría ver de hacer todos los campos por separado...
--- una cosa que leí fue los triggers anidados... por ahi uno anida a otro donde se vaya  comprovando cada uno de los campos
-- reflexiones...
CREATE OR REPLACE FUNCTION TRFN_GR15_controlarIgualdadPuntosDeportistasMismoEquipo()
returns trigger AS $$
DECLARE
BEGIN
if((
select count (distinct (cc.puntoscategoria, cc.puntosgeneral, cc.puestocategoria, cc.puestogeneral) )-- select A
from gr15_clasificacioncompetencia cc
where cc.nrodoc in(
select ed.nrodoc
from gr15_equipodeportista ed
where ed.id in(
--obtenemos el equipo del deportista al que se le agrega puntos
select gr15_equipodeportista.id
from gr15_clasificacioncompetencia cc
natural join gr15_equipodeportista
where nrodoc = 32383548
and tipodoc = 'dni'
ORDER BY fecha_inscripcion DESC 
LIMIT 1))) < 1)
THEN 
return new;
else 
RAISE EXCEPTION 'ERROR, LOS DEPORTISTAS DE UN MISMO EQUIPO NO POSEEN LOS MISMOS DATOS DE PUNTOS Y/O PUESTOS QUE SUS COMPAÑEROS DE EQUIPO';
end if;
return new;
end;$$
language 'plpgsql';
--TRIGGER

CREATE TRIGGER tr_gr15_controlarIgualdadPuntosDeportistasMismoEquipo
AFTER INSERT ON gr15_inscripcion 
FOR EACH ROW EXECUTE PROCEDURE trfn_gr15_controlarIgualdadPuntosDeportistasMismoEquipo();

--competencias grupales
select cc.idcompetencia
from gr15_clasificacioncompetencia cc
where cc.idcompetencia in(select c.idcompetencia from gr15_competencia c 
where c.individual = '0');

--CREACION DE VISTAS
--PUNTO D1
create view vw_gr15_ordenarCompenciasPorDisciplinas 
as select * 
from gr15_competencia
order by cdodisciplina;

--SERVICIOS
--c1
create or replace function fn_gr15_mostrarDatosDeportistasPorCompetencia(integer)
returns table(
tipodoc varchar,
nrodoc int,
nombre varchar,
apellido varchar,
direccion varchar,
nombrelocalidad varchar,
celular varchar,
sexo char(1),
mail varchar,
tipo char(1),
fechanacimiento timestamp
) as $$
declare 
nrocompetencia alias for $1;
begin
return query 
select *
from gr15_persona p
where p.nrodoc in (select i.nrodoc
from gr15_inscripcion i
where i.idcompetencia = nrocompetencia)
and p.tipodoc in (select i.tipodoc
from gr15_inscripcion i
where i.idcompetencia = nrocompetencia);
end;
$$ language 'plpgsql';
-- select fn_gr15_mostrarDatosDeportistasPorCompetencia(3) -- para llamar la funcion con el idcompetencia como parametro
-- http://www.postgresqltutorial.com/plpgsql-function-returns-a-table/

--c2
create or replace function fn_gr15_mostrarequipodeportista(varchar,int)
returns table(
nombre varchar
) as $$
declare 
tipo alias for $1;
nro alias for $2;
begin
return query 
select e.nombre
from gr15_equipo e
where e.id in(
select gr15_equipodeportista.id
from gr15_clasificacioncompetencia cc
natural join gr15_equipodeportista
where nrodoc = nro
and tipodoc = tipo);
end;
$$ language 'plpgsql'
;

--c3
create or replace function fn_gr15_mostrarclasificacioncompetencia(int)
returns table(
tipodoc varchar,
nrodoc int,
puestogeneral varchar,
puntosgeneral int,
puestocategoria varchar,
puntoscatecoria int
) as $$
declare 
id alias for $1;
begin
return query 
select cc.tipodoc, cc.nrodoc, cc.puestogeneral, cc.puntosgeneral, cc.puestocategoria, cc.puntoscategoria
from gr15_clasificacioncompetencia cc
where cc.idcompetencia = id;
end;
$$ language 'plpgsql'
;
--select fn_gr15_mostrarclasificacioncompetencia(1)

-- c4

create or replace function fn_gr15_mostrarinscripcionesjuez(varchar,int)
returns table(
idcomptencia int
) as $$
declare 
tipo alias for $1;
nro alias for $2;
begin
if( nro in (select jc.nrodoc from gr15_juezcompetencia jc))
then
return query 
select i.idcompetencia
from gr15_inscripcion i
where  i.tipodoc = tipo
and i.nrodoc = nro;
else 
raise exception 'EL DOCUMENTO INGRESADO NO CORRESPONDE A UN JUEZ';
end if;
end;
$$ language 'plpgsql';


--------------------------------------
--d2 
create view vw_gr15_mostrarCompetenciasConDeportistasSinclasificar
as select distinct i.idcompetencia
from gr15_inscripcion i
where not exists(
select cc.idcompetencia
from gr15_clasificacioncompetencia cc
where i.idcompetencia = cc.idcompetencia
and i.nrodoc = cc.nrodoc
and i.tipodoc = i.tipodoc)
;


--d3 anda joya, ver si se puede mejorar el tema de los nombres, trando de acortar, ej, gr15_deportista d, tira errores
create view vw_gr15_mostrarPuntosDeportistaAnioActual
as SELECT gr15_deportista.nrodoc ,sum( gr15_clasificacioncompetencia.puntoscategoria) as puntos_categoria, sum(gr15_clasificacioncompetencia.puntosgeneral) as puntos_general
FROM gr15_deportista 
INNER JOIN gr15_clasificacioncompetencia on ( gr15_deportista.nrodoc = gr15_clasificacioncompetencia.nrodoc)
where gr15_clasificacioncompetencia.idcompetencia in (SELECT distinct cc.idCompetencia
FROM gr15_clasificacioncompetencia cc, gr15_competencia c 
WHERE date_part('year', c.fecha) = date_part('year', CURRENT_DATE))
group by gr15_deportista.nrodoc;
;


