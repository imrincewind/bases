
-- tables
-- Table: GR15_Categoria
CREATE TABLE GR15_Categoria (
    cdoCategoria varchar(20)  NOT NULL,
    cdoDisciplina varchar(10)  NOT NULL,
    descripcion varchar(200)  NOT NULL,
    edadMinima int  NOT NULL,
    edadMaxima int  NOT NULL,
    CONSTRAINT pk_GR15_categoria PRIMARY KEY (cdoCategoria,cdoDisciplina)
);

-- Table: GR15_ClasificacionCompetencia
CREATE TABLE GR15_ClasificacionCompetencia (
    idCompetencia int  NOT NULL,
    tipoDoc varchar(3)  NOT NULL,
    nroDoc int  NOT NULL,
    puestoGeneral varchar(50)  NOT NULL,
    puntosGeneral int  NOT NULL,
    puestoCategoria varchar(50)  NOT NULL,
    puntosCategoria int  NOT NULL,
    CONSTRAINT pk_GR15_ClasificacionCompetencia PRIMARY KEY (idCompetencia,tipoDoc,nroDoc)
);

-- Table: GR15_Competencia
CREATE TABLE GR15_Competencia (
    idCompetencia int  NOT NULL,
    cdoDisciplina varchar(10)  NOT NULL,
    nombre varchar(500)  NOT NULL,
    fecha timestamp  NULL,
    nombreLugar varchar(500)  NOT NULL,
    nombreLocalidad varchar(500)  NOT NULL,
    organizador varchar(500)  NOT NULL,
    individual bit(1)  NOT NULL,
    fechaLimiteInscripcion timestamp  NULL,
    cantJueces int  NOT NULL,
    coberturaTV bit(1)  NOT NULL,
    mapa text  NULL,
    web varchar(4000)  NULL,
    CONSTRAINT pk_GR15_competencia PRIMARY KEY (idCompetencia)
);

-- Table: GR15_Deportista
CREATE TABLE GR15_Deportista (
    tipoDoc varchar(3)  NOT NULL,
    nroDoc int  NOT NULL,
    federado bit(1)  NOT NULL,
    fechaUltimaFederacion timestamp  NULL,
    nroLicencia varchar(20)  NULL,
    cdoCategoria varchar(20)  NOT NULL,
    cdoDisciplina varchar(10)  NOT NULL,
    cdoFederacion varchar(50)  NULL,
    cdoDisciplinaFederacion varchar(10)  NULL,
    CONSTRAINT pk_GR15_Deportista PRIMARY KEY (tipoDoc,nroDoc)
);

-- Table: GR15_Disciplina
CREATE TABLE GR15_Disciplina (
    cdoDisciplina varchar(10)  NOT NULL,
    nombre varchar(100)  NOT NULL,
    descripcion text  NOT NULL,
    CONSTRAINT pk_GR15_Disciplina PRIMARY KEY (cdoDisciplina)
);

-- Table: GR15_Equipo
CREATE TABLE GR15_Equipo (
    id int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    fechaAlta timestamp  NOT NULL,
    CONSTRAINT pk_GR15_Equipo PRIMARY KEY (id)
);

-- Table: GR15_EquipoDeportista
CREATE TABLE GR15_EquipoDeportista (
    id int  NOT NULL,
    tipoDoc varchar(3)  NOT NULL,
    nroDoc int  NOT NULL,
    CONSTRAINT pk_GR15_EquipoDeportista PRIMARY KEY (id,tipoDoc,nroDoc)
);

-- Table: GR15_Federacion
CREATE TABLE GR15_Federacion (
    cdoFederacion varchar(50)  NOT NULL,
    cdoDisciplina varchar(10)  NOT NULL,
    nombre varchar(100)  NOT NULL,
    anioCreacion int  NULL,
    cantAfiliados int  NULL,
    CONSTRAINT pk_GR15_Federacion PRIMARY KEY (cdoFederacion,cdoDisciplina)
);

-- Table: GR15_Inscripcion
CREATE TABLE GR15_Inscripcion (
    id int  NOT NULL,
    tipoDoc varchar(3)  NULL,
    nroDoc int  NULL,
    Equipo_id int  NULL,
    idCompetencia int  NOT NULL,
    fecha timestamp  NULL,
    CONSTRAINT pk_GR15_Inscripcion PRIMARY KEY (id)
);

-- Table: GR15_Juez
CREATE TABLE GR15_Juez (
    tipoDoc varchar(3)  NOT NULL,
    nroDoc int  NOT NULL,
    oficial bit(1)  NOT NULL,
    nroLicencia varchar(20)  NULL,
    CONSTRAINT pk_GR15_Juez PRIMARY KEY (tipoDoc,nroDoc)
);

-- Table: GR15_JuezCompetencia
CREATE TABLE GR15_JuezCompetencia (
    idCompetencia int  NOT NULL,
    tipoDoc varchar(3)  NOT NULL,
    nroDoc int  NOT NULL,
    CONSTRAINT pk_GR15_JuezCompetencia PRIMARY KEY (idCompetencia,tipoDoc,nroDoc)
);

-- Table: GR15_Persona
CREATE TABLE GR15_Persona (
    tipoDoc varchar(3)  NOT NULL,
    nroDoc int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    apellido varchar(100)  NOT NULL,
    direccion varchar(250)  NOT NULL,
    nombreLocalidad varchar(250)  NOT NULL,
    celular varchar(20)  NOT NULL,
    sexo char(1)  NOT NULL,
    mail varchar(100)  NULL,
    tipo char(1)  NOT NULL,
    fechaNacimiento timestamp  NOT NULL,
    CONSTRAINT pk_GR15_Persona PRIMARY KEY (tipoDoc,nroDoc)
);

-- foreign keys
-- Reference: fk_ClasificacionCompetencia_Competencia (table: GR15_ClasificacionCompetencia)
ALTER TABLE GR15_ClasificacionCompetencia ADD CONSTRAINT fk_ClasificacionCompetencia_Competencia
    FOREIGN KEY (idCompetencia)
    REFERENCES GR15_Competencia (idCompetencia)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_ClasificacionCompetencia_Deportista (table: GR15_ClasificacionCompetencia)
ALTER TABLE GR15_ClasificacionCompetencia ADD CONSTRAINT fk_ClasificacionCompetencia_Deportista
    FOREIGN KEY (tipoDoc, nroDoc)
    REFERENCES GR15_Deportista (tipoDoc, nroDoc)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Competencia_Disciplina (table: GR15_Competencia)
ALTER TABLE GR15_Competencia ADD CONSTRAINT fk_Competencia_Disciplina
    FOREIGN KEY (cdoDisciplina)
    REFERENCES GR15_Disciplina (cdoDisciplina)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Deportista_Categoria (table: GR15_Deportista)
ALTER TABLE GR15_Deportista ADD CONSTRAINT fk_Deportista_Categoria
    FOREIGN KEY (cdoCategoria, cdoDisciplina)
    REFERENCES GR15_Categoria (cdoCategoria, cdoDisciplina)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Deportista_Federacion (table: GR15_Deportista)
ALTER TABLE GR15_Deportista ADD CONSTRAINT fk_Deportista_Federacion
    FOREIGN KEY (cdoFederacion, cdoDisciplinaFederacion)
    REFERENCES GR15_Federacion (cdoFederacion, cdoDisciplina)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Deportista_Persona (table: GR15_Deportista)
ALTER TABLE GR15_Deportista ADD CONSTRAINT fk_Deportista_Persona
    FOREIGN KEY (tipoDoc, nroDoc)
    REFERENCES GR15_Persona (tipoDoc, nroDoc)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_EquipoDeportista_Deportista (table: GR15_EquipoDeportista)
ALTER TABLE GR15_EquipoDeportista ADD CONSTRAINT fk_EquipoDeportista_Deportista
    FOREIGN KEY (tipoDoc, nroDoc)
    REFERENCES GR15_Deportista (tipoDoc, nroDoc)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_EquipoDeportista_Equipo (table: GR15_EquipoDeportista)
ALTER TABLE GR15_EquipoDeportista ADD CONSTRAINT fk_EquipoDeportista_Equipo
    FOREIGN KEY (id)
    REFERENCES GR15_Equipo (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Federacion_Disciplina (table: GR15_Federacion)
ALTER TABLE GR15_Federacion ADD CONSTRAINT fk_Federacion_Disciplina
    FOREIGN KEY (cdoDisciplina)
    REFERENCES GR15_Disciplina (cdoDisciplina)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Inscripcion_Competencia (table: GR15_Inscripcion)
ALTER TABLE GR15_Inscripcion ADD CONSTRAINT fk_Inscripcion_Competencia
    FOREIGN KEY (idCompetencia)
    REFERENCES GR15_Competencia (idCompetencia)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Inscripcion_Deportista (table: GR15_Inscripcion)
ALTER TABLE GR15_Inscripcion ADD CONSTRAINT fk_Inscripcion_Deportista
    FOREIGN KEY (tipoDoc, nroDoc)
    REFERENCES GR15_Deportista (tipoDoc, nroDoc)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Inscripcion_Equipo (table: GR15_Inscripcion)
ALTER TABLE GR15_Inscripcion ADD CONSTRAINT fk_Inscripcion_Equipo
    FOREIGN KEY (Equipo_id)
    REFERENCES GR15_Equipo (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_JuezCompetencia_Competencia (table: GR15_JuezCompetencia)
ALTER TABLE GR15_JuezCompetencia ADD CONSTRAINT fk_JuezCompetencia_Competencia
    FOREIGN KEY (idCompetencia)
    REFERENCES GR15_Competencia (idCompetencia)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_JuezCompetencia_Juez (table: GR15_JuezCompetencia)
ALTER TABLE GR15_JuezCompetencia ADD CONSTRAINT fk_JuezCompetencia_Juez
    FOREIGN KEY (tipoDoc, nroDoc)
    REFERENCES GR15_Juez (tipoDoc, nroDoc)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_Juez_Persona (table: GR15_Juez)
ALTER TABLE GR15_Juez ADD CONSTRAINT fk_Juez_Persona
    FOREIGN KEY (tipoDoc, nroDoc)
    REFERENCES GR15_Persona (tipoDoc, nroDoc)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: fk_categoria_disciplina (table: GR15_Categoria)
ALTER TABLE GR15_Categoria ADD CONSTRAINT fk_categoria_disciplina
    FOREIGN KEY (cdoDisciplina)
    REFERENCES GR15_Disciplina (cdoDisciplina)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.



--PUNTO A
--insert tabla persona

INSERT INTO gr15_persona (tipoDoc,nroDoc,nombre,apellido,direccion,nombreLocalidad,celular,sexo,mail,tipo,fechaNacimiento) 
    VALUES ('dni',31342131, 'Juan Armando','Perez','Juarez 1202','TANDIL','154-442332','m','el_locoq@gmail.com','I','1990/01/31');
INSERT INTO gr15_persona (tipoDoc,nroDoc,nombre,apellido,direccion,nombreLocalidad,celular,sexo,mail,tipo,fechaNacimiento) 
    VALUES ('lc',1055587, 'Luisa Francisca','Loperfido','Paz 570','TANDIL','155-313128','f','la_loquita@gmail.com','I','1956/09/27');
INSERT INTO gr15_persona (tipoDoc,nroDoc,nombre,apellido,direccion,nombreLocalidad,celular,sexo,mail,tipo,fechaNacimiento) 
    VALUES ('dni',33242190, 'Gabriel Francisco','Bermudez','Machado 1378','TANDIL','156-949932','m','el_loquillo@gmail.com','I','1987/06/04');
INSERT INTO gr15_persona (tipoDoc,nroDoc,nombre,apellido,direccion,nombreLocalidad,celular,sexo,mail,tipo,fechaNacimiento) 
    VALUES ('dni',32383548, 'Esteban Ramiro','Firmat','Montiel 1357','TANDIL','154-000545','m','el_lastloco@gmail.com','I','1986/07/01');
INSERT INTO gr15_persona (tipoDoc,nroDoc,nombre,apellido,direccion,nombreLocalidad,celular,sexo,mail,tipo,fechaNacimiento) 
    VALUES ('dni',33342131, 'Sabrina','Noble Funes','Santamarina 1628','TANDIL','155-991209','f','amea@gmail.com','I','1986/03/05');
INSERT INTO gr15_persona (tipoDoc,nroDoc,nombre,apellido,direccion,nombreLocalidad,celular,sexo,mail,tipo,fechaNacimiento) 
    VALUES ('dni',40212589, 'Lorena','Volaz','San Martin 332','RAUCH','0249-155-991209','f','seca_goeldvd@gmail.com','I','1999/04/19');

--insert tabla disciplina

INSERT INTO gr15_disciplina (cdoDisciplina,nombre,descripcion) 
    VALUES ('AT0001','100m','Carrera de velocidad sobre 100m');
INSERT INTO gr15_disciplina (cdoDisciplina,nombre,descripcion) 
    VALUES ('AT0002','200m','Carrera de velocidad sobre 200m');
INSERT INTO gr15_disciplina (cdoDisciplina,nombre,descripcion) 
    VALUES ('AT0003','400m','Carrera de velocidad sobre 400m');
INSERT INTO gr15_disciplina (cdoDisciplina,nombre,descripcion) 
    VALUES ('AT0004','800m','Carrera de velocidad sobre 800m');
INSERT INTO gr15_disciplina (cdoDisciplina,nombre,descripcion)
    VALUES ('AT0005','1500m','Carrera de velocidad sobre 1500m');
INSERT INTO gr15_disciplina (cdoDisciplina,nombre,descripcion) 
    VALUES ('AT0006','5000m','Carrera de velocidad sobre 5000m');

--insert tabla categoria --- preguntar "por lo menos 10 anios"-------hacer hasta 10 años y justificar que lo que está dicho en el enunciado es incongruente

INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('inf0001','AT0001','infantiles de entre 0 y 8 anios de edad en Carrera de velocidad sobre 100m',0,8);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('inf0002','AT0002','infantiles de entre 0 y 8 anios de edad en Carrera de velocidad sobre 200m',0,8);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('men0001','AT0001','menores de entre 9 y 14 anios de edad en Carrera de velocidad sobre 100m',9,14);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('men0002','AT0002','menores de entre 9 y 14 anios de edad en Carrera de velocidad sobre 200m',9,14);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('juv0001','AT0001','juveniles de entre 15 y 18 anios de edad en Carrera de velocidad sobre 100m',15,18);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('juv0002','AT0002','juveniles de entre 15 y 18 anios de edad en Carrera de velocidad sobre 200m',15,18);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('maya0001','AT0001','mayores de entre 19 y 28 anios de edad en Carrera de velocidad sobre 100m',19,28);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('maya0002','AT0002','mayores de entre 19 y 28 anios de edad en Carrera de velocidad sobre 200m',19,28);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('mayb0001','AT0001','mayores de entre 29 y 38 anios de edad en Carrera de velocidad sobre 100m',29,38);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('mayb0002','AT0002','mayores de entre 29 y 38 anios de edad en Carrera de velocidad sobre 200m',29,38);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('mayc0001','AT0001','mayores de entre 39 y 48 anios de edad en Carrera de velocidad sobre 100m',39,48);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('mayc0002','AT0002','mayores de entre 39 y 48 anios de edad en Carrera de velocidad sobre 200m',39,48);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('mayd0001','AT0001','mayores de entre 49 y 58 anios de edad en Carrera de velocidad sobre 100m',49,58);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('mayd0002','AT0002','mayores de entre 49 y 58 anios de edad en Carrera de velocidad sobre 200m',49,58);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('maye0001','AT0001','mayores de entre 59 y 68 anios de edad en Carrera de velocidad sobre 100m',59,68);
INSERT INTO gr15_categoria (cdoCategoria,cdoDisciplina,descripcion,edadMinima,edadMaxima)
    VALUES ('maye0002','AT0002','mayores de entre 59 y 68 anios de edad en Carrera de velocidad sobre 200m',59,68);

--insert tabla federacion ----preguntar diferencia disciplina deporte

INSERT INTO gr15_federacion (cdoFederacion,cdoDisciplina,nombre,anioCreacion,cantAfiliados) 
    VALUES ('fed001','AT0001','Federacion Atletica 100m',1956,2);
INSERT INTO gr15_federacion (cdoFederacion,cdoDisciplina,nombre,anioCreacion,cantAfiliados) 
    VALUES ('fed002','AT0002','Federacion Atletica 200m',1957,3);
INSERT INTO gr15_federacion (cdoFederacion,cdoDisciplina,nombre,anioCreacion,cantAfiliados) 
    VALUES ('fed003','AT0003','Federacion Atletica 400m',1958,0);
INSERT INTO gr15_federacion (cdoFederacion,cdoDisciplina,nombre,anioCreacion,cantAfiliados) 
    VALUES ('fed004','AT0004','Federacion Atletica 800m',1956,0);
INSERT INTO gr15_federacion (cdoFederacion,cdoDisciplina,nombre,anioCreacion,cantAfiliados) 
    VALUES ('fed005','AT0005','Federacion Atletica 1500m',1960,0);
INSERT INTO gr15_federacion (cdoFederacion,cdoDisciplina,nombre,anioCreacion,cantAfiliados) 
    VALUES ('fed006','AT0006','Federacion Atletica 5000m',1960,0);

--insert tabla competencia

INSERT INTO gr15_competencia (idCompetencia,cdoDisciplina,nombre,fecha,nombreLugar,nombreLocalidad,organizador,individual,fechaLimiteInscripcion,cantJueces,coberturaTV,mapa,web)
    VALUES ('1','AT0001','Gran competencia 100m Llanos','2017/12/14','dique','TANDIL','Nostros','1','2017/12/11',2,'1','van por aca y llegan ahi','http://www.grancompetencia100m.com.ar');
INSERT INTO gr15_competencia (idCompetencia,cdoDisciplina,nombre,fecha,nombreLugar,nombreLocalidad,organizador,individual,fechaLimiteInscripcion,cantJueces,coberturaTV,mapa,web)
     VALUES ('2','AT0002','Gran competencia 200m Llanos','2017/12/14','dique','TANDIL','Nostros','1','2017/12/11',2,'0','van por aca y llegan ahi','http://www.grancompetencia200m.com.ar');
INSERT INTO gr15_competencia (idCompetencia,cdoDisciplina,nombre,fecha,nombreLugar,nombreLocalidad,organizador,individual,fechaLimiteInscripcion,cantJueces,coberturaTV,mapa,web)
     VALUES ('3','AT0003','Gran competencia 400m Llanos','2017/12/15','dique','TANDIL','Nostros','1','2017/12/12',2,'0','van por aca y llegan ahi','http://www.grancompetencia400m.com.ar');
INSERT INTO gr15_competencia (idCompetencia,cdoDisciplina,nombre,fecha,nombreLugar,nombreLocalidad,organizador,individual,fechaLimiteInscripcion,cantJueces,coberturaTV,mapa,web)
    VALUES ('4','AT0004','Gran competencia 800m Llanos','2017/12/15','dique','TANDIL','Nostros','1','2017/12/12',2,'0','van por aca y llegan ahi','http://www.grancompetencia800m.com.ar');
INSERT INTO gr15_competencia (idCompetencia,cdoDisciplina,nombre,fecha,nombreLugar,nombreLocalidad,organizador,individual,fechaLimiteInscripcion,cantJueces,coberturaTV,mapa,web)
    VALUES ('5','AT0005','Gran competencia 1500m Llanos','2017/12/16','dique','TANDIL','Nostros','0','2017/12/13',2,'1','van por aca y llegan ahi','http://www.grancompetencia1500m.com.ar');
INSERT INTO gr15_competencia (idCompetencia,cdoDisciplina,nombre,fecha,nombreLugar,nombreLocalidad,organizador,individual,fechaLimiteInscripcion,cantJueces,coberturaTV,mapa,web)
    VALUES ('6','AT0006','Gran competencia 5000m Llanos','2017/12/16','dique','TANDIL','Nostros','0','2017/12/13',2,'1','van por aca y llegan ahi','http://www.grancompetencia5000m.com.ar');

--insert tabla equipo
INSERT INTO gr15_equipo (id,nombre,fechaAlta)
    VALUES (1,'Asesinos Cereales AC','2017/06/30');
INSERT INTO gr15_equipo (id,nombre,fechaAlta)
    VALUES (2,'Comino y pimienta AC','2017/02/10');
INSERT INTO gr15_equipo (id,nombre,fechaAlta)
    VALUES (3,'Los mandraque CA','2016/05/31');
INSERT INTO gr15_equipo (id,nombre,fechaAlta)
    VALUES (4,'No hay equipo AC','2015/12/03');
INSERT INTO gr15_equipo (id,nombre,fechaAlta)
    VALUES (5,'Portico CA','2017/01/22');

--insert tabla juez

INSERT INTO gr15_juez (tipoDoc,nroDoc,oficial,nroLicencia)
    VALUES ('dni',31342131, '1','123');
INSERT INTO gr15_juez (tipoDoc,nroDoc,oficial,nroLicencia)
    VALUES ('lc',1055587, '1','124');
INSERT INTO gr15_juez (tipoDoc,nroDoc,oficial,nroLicencia)
    VALUES ('dni',33242190, '0','125');
INSERT INTO gr15_juez (tipoDoc,nroDoc,oficial,nroLicencia)
    VALUES ('dni',32383548, '1','126');
INSERT INTO gr15_juez (tipoDoc,nroDoc,oficial,nroLicencia)
    VALUES ('dni',33342131, '0','127');

--insert tabla juezCompetencia

INSERT INTO gr15_juezcompetencia (idCompetencia,tipoDoc,nroDoc)
    VALUES (1,'dni',31342131);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (1,'lc',1055587);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (2,'dni',33242190);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (2,'dni',32383548);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (3,'dni',33342131);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (3,'dni',31342131);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (4,'lc',1055587);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (4,'dni',33242190);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (5,'dni',32383548);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (5,'dni',33342131);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (6,'dni',32383548);
INSERT INTO gr15_juezcompetencia  (idCompetencia,tipoDoc,nroDoc)
    VALUES (6,'dni',33342131);

--insert tabla deportista  

INSERT INTO gr15_deportista  (tipoDoc,nroDoc,federado,fechaUltimaFederacion,nroLicencia,cdoCategoria,cdoDisciplina,cdoFederacion,cdoDisciplinaFederacion)
    VALUES ('dni',31342131,'1','2017/05/05','123','maya0001','AT0001','fed001','AT0001');
INSERT INTO gr15_deportista  (tipoDoc,nroDoc,federado,fechaUltimaFederacion,nroLicencia,cdoCategoria,cdoDisciplina,cdoFederacion,cdoDisciplinaFederacion)
    VALUES ('lc',1055587,'1','2017/05/03','124','maye0002','AT0002','fed002','AT0002');
INSERT INTO gr15_deportista  (tipoDoc,nroDoc,federado,fechaUltimaFederacion,nroLicencia,cdoCategoria,cdoDisciplina,cdoFederacion,cdoDisciplinaFederacion)
    VALUES ('dni',33242190,'1','2017/05/04','125','mayb0002','AT0002','fed002','AT0002');
INSERT INTO gr15_deportista  (tipoDoc,nroDoc,federado,fechaUltimaFederacion,nroLicencia,cdoCategoria,cdoDisciplina,cdoFederacion,cdoDisciplinaFederacion)
    VALUES ('dni',32383548,'1','2017/05/08','126','mayb0002','AT0002','fed002','AT0002');
INSERT INTO gr15_deportista  (tipoDoc,nroDoc,federado,fechaUltimaFederacion,nroLicencia,cdoCategoria,cdoDisciplina,cdoFederacion,cdoDisciplinaFederacion)
    VALUES ('dni',33342131,'1','2017/05/10','127','mayb0001','AT0001','fed001','AT0001');
INSERT INTO gr15_deportista  (tipoDoc,nroDoc,federado,fechaUltimaFederacion,nroLicencia,cdoCategoria,cdoDisciplina,cdoFederacion,cdoDisciplinaFederacion)
    VALUES ('dni',40212589,'0','2017/05/01',null,'juv0002','AT0002',null,null);


--insert tabla inscripcion

INSERT INTO gr15_inscripcion (id,tipoDoc,nroDoc,Equipo_id,idCompetencia,fecha)
    VALUES (100,'dni',31342131,null ,'1','2017/05/07');
INSERT INTO gr15_inscripcion (id,tipoDoc,nroDoc,Equipo_id,idCompetencia,fecha)
    VALUES (101,'lc',1055587,null ,'2','2017/05/08');
INSERT INTO gr15_inscripcion (id,tipoDoc,nroDoc,Equipo_id,idCompetencia,fecha)
    VALUES (102,null,null,'1' ,'2','2017/05/09');
INSERT INTO gr15_inscripcion (id,tipoDoc,nroDoc,Equipo_id,idCompetencia,fecha)
    VALUES (103,null,null,'2' ,'2','2017/05/09');
INSERT INTO gr15_inscripcion (id,tipoDoc,nroDoc,Equipo_id,idCompetencia,fecha)
    VALUES (104,'dni',33342131,null ,'1','2017/05/07');
INSERT INTO gr15_inscripcion (id,tipoDoc,nroDoc,Equipo_id,idCompetencia,fecha)
    VALUES (105,'dni',40212589,null,'2','2017/05/07');


--insert tabla EquipoDeportista 

INSERT INTO gr15_equipodeportista  (id,tipoDoc,nroDoc)
    VALUES (1,'dni',33242190);
INSERT INTO gr15_equipodeportista  (id,tipoDoc,nroDoc)
    VALUES (1,'dni',32383548);
INSERT INTO gr15_equipodeportista  (id,tipoDoc,nroDoc)
    VALUES (2,'lc',1055587);
INSERT INTO gr15_equipodeportista  (id,tipoDoc,nroDoc)
    VALUES (3,'dni',31342131);
INSERT INTO gr15_equipodeportista  (id,tipoDoc,nroDoc)
    VALUES (4,'dni',33342131);
INSERT INTO gr15_equipodeportista  (id,tipoDoc,nroDoc)
    VALUES (5,'dni',40212589);

--insert tabla ClasificacionCompetencia

INSERT INTO gr15_clasificacioncompetencia (idCompetencia,tipoDoc,nroDoc,puestoGeneral,puntosGeneral,puestoCategoria,puntosCategoria)
    VALUES (1,'dni',31342131,'131',12,'50',25);
INSERT INTO gr15_clasificacioncompetencia (idCompetencia,tipoDoc,nroDoc,puestoGeneral,puntosGeneral,puestoCategoria,puntosCategoria)
     VALUES (2,'lc',1055587,'12',150,'1',275);
INSERT INTO gr15_clasificacioncompetencia (idCompetencia,tipoDoc,nroDoc,puestoGeneral,puntosGeneral,puestoCategoria,puntosCategoria)
     VALUES (2,'dni',33242190,'1',351,'1',402);
INSERT INTO gr15_clasificacioncompetencia (idCompetencia,tipoDoc,nroDoc,puestoGeneral,puntosGeneral,puestoCategoria,puntosCategoria)
     VALUES (2,'dni',32383548,'1',351,'1',402);
INSERT INTO gr15_clasificacioncompetencia (idCompetencia,tipoDoc,nroDoc,puestoGeneral,puntosGeneral,puestoCategoria,puntosCategoria)
     VALUES (1,'dni',33342131,'22',54,'14',204);
INSERT INTO gr15_clasificacioncompetencia (idCompetencia,tipoDoc,nroDoc,puestoGeneral,puntosGeneral,puestoCategoria,puntosCategoria)
     VALUES (2,'dni',40212589,'17',71,'10',140);
