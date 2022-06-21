--
-- Año: 2022 
-- Alumno: Fernando Nahuel Tuquina
-- Plataforma (SO + Versión): Windows 10 Pro
-- Motor y Versión: MySQL Server 8.0.28 (Community Edition) 
-- GitHub Usuarios: Tuquina
-- Parcial de Práctica Nº1

-- ------------------------------------------------------------------------------------------------------- --

-- -----------------------------------------------------
-- Apartado 1: Creación de la BD
-- -----------------------------------------------------

DROP DATABASE IF EXISTS final1;

-- Creación de BD en MySQL

CREATE DATABASE IF NOT EXISTS final1;

USE final1;

-- 
-- TABLE: Películas
--

DROP TABLE IF EXISTS Peliculas ;

CREATE TABLE IF NOT EXISTS Peliculas(
    idPelicula  	INTEGER         NOT NULL,
    titulo 			VARCHAR(128)	NOT NULL,
	estreno			INTEGER			NULL,
    duracion		INTEGER			NULL,
    clasificacion	VARCHAR(10)		DEFAULT 'G' NOT NULL
    CHECK 			(clasificacion = 'G' OR clasificacion = 'PG' OR clasificacion = 'PG-13' OR clasificacion = 'R' OR clasificacion = 'NC-17'),
    PRIMARY KEY (idPelicula),
    UNIQUE INDEX UI_Peliculas_titulo(titulo)
    )ENGINE=INNODB
;

-- INDEX: UI_Peliculas
-- CREATE UNIQUE INDEX UI_Peliculas ON Peliculas(titulo);

-- 
-- TABLE: Direcciones
--

DROP TABLE IF EXISTS Direcciones ;

CREATE TABLE IF NOT EXISTS Direcciones(
    idDireccion  	INTEGER         NOT NULL,
    calleYNumero	VARCHAR(50)		NOT NULL,
    municipio 		VARCHAR(20)		NOT NULL,
    codigoPostal	VARCHAR(10)		NULL,
    telefono 		VARCHAR(20)		NOT NULL,
    PRIMARY KEY (idDireccion)
)ENGINE=INNODB
;

-- INDEX: UI_Direccion
CREATE UNIQUE INDEX UI_Direccion ON Direcciones(calleYNumero)
;

-- 
-- TABLE: Personal
--

DROP TABLE IF EXISTS Personal ;

CREATE TABLE IF NOT EXISTS Personal(
    idPersonal  	INTEGER         NOT NULL,
    nombres 		VARCHAR(45)		NOT NULL,
    apellidos 		VARCHAR(45)		NOT NULL,
	idDireccion		INTEGER			NOT NULL,
    correo	 		VARCHAR(50)		NULL,
    estado		 	CHAR(1)			DEFAULT 'E' NOT NULL
    CHECK			(estado = 'E' OR estado = 'D'),
    PRIMARY KEY (idPersonal),
	INDEX `FK_idDireccionPersonal_idx` (idDireccion),
    CONSTRAINT `FK_idDireccionPersonal`
		FOREIGN KEY (idDireccion)
		REFERENCES Direcciones(idDireccion)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)ENGINE=INNODB
;

-- INDEX: UI_CorreoPersonal
CREATE UNIQUE INDEX UI_CorreoPersonal ON Personal(correo)
;

-- 
-- TABLE: Sucursales
--

DROP TABLE IF EXISTS Sucursales ;

CREATE TABLE IF NOT EXISTS Sucursales(
    idSucursal  	CHAR(10)       	NOT NULL,
    idGerente		INTEGER			NOT NULL,
    idDireccion		INTEGER			NOT NULL,
    PRIMARY KEY (idSucursal),
    CONSTRAINT `FK_idGerente`
		FOREIGN KEY (idGerente)
		REFERENCES Personal(idPersonal)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT `FK_idDireccionSucursal`
		FOREIGN KEY (idDireccion)
		REFERENCES Direcciones(idDireccion)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)ENGINE=INNODB
;

-- 
-- TABLE: Inventario
--

DROP TABLE IF EXISTS Inventario ;

CREATE TABLE IF NOT EXISTS Inventario(
    idInventario  	INTEGER       	NOT NULL,
    idPelicula		INTEGER 		NOT NULL,
    idSucursal		CHAR(10)		NOT NULL,
    PRIMARY KEY (idInventario),
    CONSTRAINT `FK_idPelicula`
		FOREIGN KEY (idPelicula)
		REFERENCES Peliculas(idPelicula)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT `FK_idSucursal`
		FOREIGN KEY (idSucursal)
		REFERENCES Sucursales(idSucursal)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)ENGINE=INNODB
;

-- 
-- TABLE: Generos
--

DROP TABLE IF EXISTS Generos ;

CREATE TABLE IF NOT EXISTS Generos(
    idGenero  		CHAR(10)        NOT NULL,
    nombre	 		VARCHAR(25)		NOT NULL,
    PRIMARY KEY (idGenero)
)ENGINE=INNODB
;

-- INDEX: UI_Genero 
CREATE UNIQUE INDEX UI_Genero ON Generos(nombre)
;

-- 
-- TABLE: GenerosDePeliculas
--

DROP TABLE IF EXISTS GenerosDePeliculas ;

CREATE TABLE IF NOT EXISTS GenerosDePeliculas(
    idPelicula		INTEGER 		NOT NULL,
    idGenero		CHAR(10)		NOT NULL,
    CONSTRAINT `FK_idPelicula2`
		FOREIGN KEY (idPelicula)
		REFERENCES Peliculas(idPelicula)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT `FK_idGenero`
		FOREIGN KEY (idGenero)
		REFERENCES Generos(idGenero)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	PRIMARY KEY (idPelicula,idGenero)
)ENGINE=INNODB
;

-- ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡PREGUNTAR SOBRE DE LOS INDICES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- -----------------------------------------------------
-- Apartado 2: Creación de la vista VCantidadPeliculas
-- -----------------------------------------------------

DROP VIEW IF EXISTS VCantidadPeliculas;

CREATE VIEW VCantidadPeliculas (idPelicula, Titulo, Cantidad) 
AS 
	SELECT Peliculas.idPelicula, Peliculas.titulo, COUNT(Peliculas.titulo)
	FROM Peliculas JOIN Inventario
	ON Peliculas.idPelicula = Inventario.idPelicula
	JOIN Sucursales 
	ON Inventario.idSucursal = Sucursales.idSucursal
    GROUP BY Peliculas.idPelicula, Peliculas.titulo
	ORDER BY idPelicula ASC;

SELECT * FROM VCantidadPeliculas;

-- -----------------------------------------------------
-- Apartado 3: Creación del SP NuevaDireccion
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS NuevaDireccion;

DELIMITER //
CREATE PROCEDURE NuevaDireccion(pidDireccion INTEGER, pcalleYNumero VARCHAR(50), pmunicipio VARCHAR(20), pcodigoPostal VARCHAR(10), ptelefono VARCHAR(20), OUT mensaje VARCHAR(100))
SALIR: BEGIN  
	IF (pidDireccion IS NULL) OR (pcalleYNumero IS NULL) OR (pmunicipio IS NULL) OR (ptelefono IS NULL) THEN
		SET mensaje = 'Los datos de la direccion no pueden ser nulos';
        LEAVE SALIR;
	ELSEIF (pidDireccion = '') OR (pcalleYNumero = '') OR (pmunicipio = '') OR (ptelefono = '') THEN
		SET mensaje = 'Los campos no pueden estar vacios';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT idDireccion FROM Direcciones WHERE idDireccion = pidDireccion) THEN
		SET mensaje = 'Ya existe una direccion con ese ID';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT idDireccion FROM Direcciones WHERE (calleYNumero = pcalleYNumero AND municipio = pmunicipio)) THEN
		SET mensaje = 'Ya existe una direccion con esa calle y numero en el municipio';
        LEAVE SALIR;
	ELSE
		START TRANSACTION;
			INSERT INTO Direcciones VALUES (pidDireccion, pcalleYNumero, pmunicipio, pcodigoPostal, ptelefono);
            SET mensaje = 'Direccion dada de alta con exito';
		COMMIT;		
    END IF;
END //
DELIMITER ;

-- Vemos las direcciones guardadas actualmente:
SELECT * FROM Direcciones; -- Son 605

-- Ingreso una direccion correcta
CALL NuevaDireccion(606, '3103 Jujuy', 'Capital', '4000', '3813569477', @resultado);
SELECT @resultado;
SELECT * FROM Direcciones; -- Se agrega a la tabla Direcciones

-- Ingreso un valor NULL que no sea el código postal
CALL NuevaDireccion(607, NULL, 'Capital', '4000', '3813569477', @resultado);
SELECT @resultado;
SELECT * FROM Direcciones; -- NO se agrega a la tabla Direcciones

-- Ingreso un valor VACÍO  que no sea el código postal
CALL NuevaDireccion(607, '3103 Jujuy', '', '4000', '3813569477', @resultado);
SELECT @resultado;
SELECT * FROM Direcciones; -- NO se agrega a la tabla Direcciones

-- Ingreso una direccion repetida en un mismo municipio
CALL NuevaDireccion(607, '152 Kitwe Parkway', 'Caraga', NULL, '42784954', @resultado);
SELECT @resultado;
SELECT * FROM Direcciones; -- NO se agrega a la tabla Direcciones

-- Ingreso un ID repetido
CALL NuevaDireccion(100, '3208 Salta', 'Lules', '75201', '3813569477', @resultado);
SELECT @resultado;
SELECT * FROM Direcciones; -- NO se agrega a la tabla Direcciones

-- -----------------------------------------------------
-- Apartado 4: Creación del SP BuscarPeliculasPorGenero
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS BuscarPeliculasPorGenero;

DELIMITER //
CREATE PROCEDURE BuscarPeliculasPorGenero(pidGenero CHAR(10), OUT mensaje VARCHAR(100))
SALIR: BEGIN  
	IF (pidGenero IS NULL)  THEN
		SET mensaje = 'El genero no puede ser NULL';
        LEAVE SALIR;
	ELSEIF (pidGenero = '') THEN
		SET mensaje = 'El genero no puede estar vacio';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT idGenero FROM Generos WHERE Generos.idGenero = pidGenero) THEN
		SET mensaje = 'No existe el genero buscado';
        LEAVE SALIR;
	ELSE
		SELECT Peliculas.idPelicula, Peliculas.titulo AS 'Titulo', Sucursales.idSucursal, COUNT(GenerosDePeliculas.idPelicula) AS 'Cantidad', Direcciones.calleYNumero AS 'Calle y numero'	
			FROM Peliculas JOIN Inventario
			ON Peliculas.idPelicula = inventario.idPelicula
			JOIN Sucursales
			ON Inventario.idSucursal = Sucursales.idSucursal
			JOIN Direcciones 
			ON Sucursales.idDireccion = Direcciones.idDireccion
			JOIN GenerosDePeliculas
			ON Peliculas.idPelicula = GenerosDePeliculas.IdPelicula
			JOIN Generos
			ON GenerosDePeliculas.idGenero = Generos.idGenero
            WHERE Generos.idGenero = pidGenero
            GROUP BY Peliculas.idPelicula, Peliculas.titulo, Sucursales.idSucursal,Direcciones.calleYNumero
            ORDER BY Peliculas.titulo ASC;
		SET mensaje = 'Se mostraron correctamente las peliculas';
    END IF;
END //
DELIMITER ;

-- Vemos los géneros guardados actualmente:
SELECT * FROM Generos;	-- Son 16

-- Ingreso un genero existente
CALL BuscarPeliculasPorGenero('6', @resultado);
SELECT @resultado;

-- Ingreso un genero NULL
CALL BuscarPeliculasPorGenero(NULL, @resultado);
SELECT @resultado;

-- Ingreso un genero vacío
CALL BuscarPeliculasPorGenero('', @resultado);
SELECT @resultado;

-- Ingreso un genero que no existe en la BD
CALL BuscarPeliculasPorGenero('19', @resultado);
SELECT @resultado;

-- -----------------------------------------------------
-- Apartado 5: Creación del trigger para borrar una dirección
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS `Trig_Direccion_Borrado`;

DELIMITER //
CREATE TRIGGER `Trig_Direccion_Borrado` 
BEFORE DELETE ON Direcciones FOR EACH ROW
BEGIN
	DECLARE referencia_sucursal CONDITION FOR SQLSTATE '45001';
    DECLARE referencia_personal CONDITION FOR SQLSTATE '45002';

	IF EXISTS (SELECT idSucursal FROM Sucursales WHERE Sucursales.idDireccion = OLD.idDireccion) THEN
		SIGNAL referencia_sucursal SET MESSAGE_TEXT = 'No se puede borrar esta direccion porque tiene Sucursales asociada', MYSQL_ERRNO = 45001;
	ELSEIF EXISTS (SELECT idPersonal FROM Personal WHERE Personal.idDireccion = OLD.idDireccion) THEN
		SIGNAL referencia_personal SET MESSAGE_TEXT = 'No se puede borrar esta direccion porque tiene Personal asociado', MYSQL_ERRNO = 45002;
    END IF;
END //
DELIMITER ;

SELECT * FROM Direcciones;

-- Averiguo qué direcciones tienen personal asociado para controlar
SELECT * FROM Direcciones LEFT JOIN Personal ON Direcciones.idDireccion = Personal.idDireccion WHERE Personal.idPersonal IS NULL;	-- ¿De dónde sale esto?
DELETE FROM Direcciones WHERE idDireccion = 1; -- No se puede borrar esta direccion porque tiene Personal asociado

-- Averiguo qué direcciones tienen Sucursales asociadas para controlar
SELECT * FROM Direcciones LEFT JOIN Sucursales ON Direcciones.idDireccion = Sucursales.idDireccion WHERE Sucursales.idSucursal IS NULL; -- ¿De dónde sale esto?
DELETE FROM Direcciones WHERE idDireccion = 3; -- No se puede borrar esta direccion porque tiene Sucursales asociada

DELETE FROM Direcciones WHERE idDireccion = 5; -- Se borra

SELECT * FROM Direcciones;