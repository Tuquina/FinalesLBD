--
-- Año: 2022 
-- Alumno: Fernando Nahuel Tuquina
-- Plataforma (SO + Versión): Windows 10 Pro
-- Motor y Versión: MySQL Server 8.0.28 (Community Edition) 
-- GitHub Usuarios: Tuquina
-- Parcial de Práctica Nº3

-- ------------------------------------------------------------------------------------------------------- --

-- -----------------------------------------------------
-- Apartado 1: Creación de la BD
-- -----------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema final3
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `final3` ;

-- -----------------------------------------------------
-- Schema final3
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `final3` ;
USE `final3` ;

-- -----------------------------------------------------
-- Table `final3`.`Categorias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final3`.`Categorias` ;

CREATE TABLE IF NOT EXISTS `final3`.`Categorias` (
  `categoria` INT NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`categoria`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final3`.`Puestos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final3`.`Puestos` ;

CREATE TABLE IF NOT EXISTS `final3`.`Puestos` (
  `puesto` INT NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`puesto`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final3`.`Personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final3`.`Personas` ;

CREATE TABLE IF NOT EXISTS `final3`.`Personas` (
  `persona` INT NOT NULL,
  `nombres` VARCHAR(25) NOT NULL,
  `apellidos` VARCHAR(25) NOT NULL,
  `puesto` INT NOT NULL,
  `fechaIngreso` DATE NOT NULL,
  `fechaBaja` DATE,
  PRIMARY KEY (`persona`),
  INDEX `fk_Personas_Puestos_idx` (`puesto` ASC) VISIBLE,
  CONSTRAINT `fk_Personas_Puestos`
    FOREIGN KEY (`puesto`)
    REFERENCES `final3`.`Puestos` (`puesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final3`.`Niveles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final3`.`Niveles` ;

CREATE TABLE IF NOT EXISTS `final3`.`Niveles` (
  `nivel` INT NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`nivel`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final3`.`Conocimientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final3`.`Conocimientos` ;

CREATE TABLE IF NOT EXISTS `final3`.`Conocimientos` (
  `conocimiento` INT NOT NULL,
  `categoria` INT NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`conocimiento`),
  INDEX `fk_Conocimientos_Categorias1_idx` (`categoria` ASC) VISIBLE,
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE,
  CONSTRAINT `fk_Conocimientos_Categorias1`
    FOREIGN KEY (`categoria`)
    REFERENCES `final3`.`Categorias` (`categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final3`.`Habilidades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final3`.`Habilidades` ;

CREATE TABLE IF NOT EXISTS `final3`.`Habilidades` (
  `habilidad` INT NOT NULL,
  `persona` INT NOT NULL,
  `conocimiento` INT NOT NULL,
  `nivel` INT NOT NULL,
  `fechaUltimaModificacion` DATE NOT NULL,
  `observaciones` VARCHAR(200) NULL,
  PRIMARY KEY (`habilidad`),
  INDEX `fk_Habilidades_Niveles1_idx` (`nivel` ASC) VISIBLE,
  INDEX `fk_Habilidades_Personas1_idx` (`persona` ASC) VISIBLE,
  INDEX `fk_Habilidades_Conocimientos1_idx` (`conocimiento` ASC) VISIBLE,
  UNIQUE INDEX `persona_conocimiento_UNIQUE` (`persona` ASC, `conocimiento` ASC) VISIBLE,
  CONSTRAINT `fk_Habilidades_Niveles1`
    FOREIGN KEY (`nivel`)
    REFERENCES `final3`.`Niveles` (`nivel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Habilidades_Personas1`
    FOREIGN KEY (`persona`)
    REFERENCES `final3`.`Personas` (`persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Habilidades_Conocimientos1`
    FOREIGN KEY (`conocimiento`)
    REFERENCES `final3`.`Conocimientos` (`conocimiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Apartado 2: Creación de la vista VHabilidades
-- -----------------------------------------------------

DROP VIEW IF EXISTS VHabilidades;

CREATE VIEW VHabilidades (apellidos,nombres,puesto,conocimiento,nivel) 
AS 
	SELECT Personas.apellidos, Personas.nombres, Puestos.nombre, Conocimientos.nombre, Niveles.nombre
	FROM Personas JOIN Puestos
	ON Personas.puesto = Puestos.puesto
	JOIN Habilidades 
	ON Personas.persona = Habilidades.persona
    JOIN Niveles 
	ON Habilidades.nivel = Niveles.nivel
    JOIN Conocimientos 
	ON Habilidades.conocimiento = Conocimientos.conocimiento
	ORDER BY apellidos ASC, nombres ASC;

SELECT * FROM VHabilidades;

-- -----------------------------------------------------
-- Apartado 3: Creación del SP NuevaPersona
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS NuevaPersona;

DELIMITER //
CREATE PROCEDURE NuevaPersona(pPersona INT, pNombres VARCHAR(25), pApellidos VARCHAR(25), pPuesto INT, pFechaIngreso DATE, pFechaBaja DATE,  OUT mensaje VARCHAR(100))
SALIR: BEGIN  
	IF (pNombres IS NULL) OR (pApellidos IS NULL) OR (pPuesto IS NULL) OR (pFechaIngreso IS NULL) THEN
		SET mensaje = 'Los datos de la persona no pueden ser nulos';
        LEAVE SALIR;
	ELSEIF (pNombres = '') OR (pApellidos = '') THEN
		SET mensaje = 'Los campos no pueden estar vacios';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT persona FROM Personas WHERE persona = pPersona) THEN
		SET mensaje = 'Ya existe una persona con ese identificador';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT puesto FROM Puestos WHERE puesto = pPuesto)  THEN
		SET mensaje = 'No existe el puesto indicado';
        LEAVE SALIR;
	ELSE
		INSERT INTO Personas VALUES (pPersona , pNombres, pApellidos, pPuesto, pFechaIngreso, pFechaBaja);
		SET mensaje = 'Persona dada de alta con exito';
    END IF;
END //
DELIMITER ;

-- Vemos las Personas guardadas actualmente:
SELECT * FROM Personas; -- Son 20

-- Ingreso una persona correcta
CALL NuevaPersona(21, 'Fernando', 'Tuquina', 3, '2022/05/14', NULL, @resultado);
SELECT @resultado;
SELECT * FROM Personas; -- Se agrega a la tabla Personas

-- Ingreso un valor NULL no permitido
CALL NuevaPersona(22, NULL, 'Juarez', 3, '2022/05/14', NULL, @resultado);
SELECT @resultado;
SELECT * FROM Personas; -- NO se agrega a la tabla Direcciones

-- Ingreso un valor vacío no permitido
CALL NuevaPersona(22, '' , 'Juarez', 3, '2022/05/14', NULL, @resultado);
SELECT @resultado;
SELECT * FROM Personas; -- NO se agrega a la tabla Direcciones

-- Ingreso una clave repetida
CALL NuevaPersona(20, 'Emanuel' , 'Juarez', 2, '2022/05/14', NULL, @resultado);
SELECT @resultado;
SELECT * FROM Personas; -- NO se agrega a la tabla Direcciones

-- Ingreso una puesto inexistente
CALL NuevaPersona(22, 'Emanuel' , 'Juarez', 5, '2022/05/14', NULL, @resultado);
SELECT @resultado;
SELECT * FROM Personas; -- NO se agrega a la tabla Direcciones

-- -----------------------------------------------------
-- Apartado 4: Creación del SP PersonasConConocimiento
-- -----------------------------------------------------


DROP PROCEDURE IF EXISTS PersonasConConocimiento;

DELIMITER //
CREATE PROCEDURE PersonasConConocimiento(pCategoria INT, pConocimiento INT, OUT mensaje VARCHAR(100)) 
SALIR: BEGIN  
	IF (pCategoria IS NULL) OR (pConocimiento IS NULL) THEN
		SET mensaje = 'Los datos no pueden ser null';
        LEAVE SALIR;
	ELSEIF (pCategoria = '') OR (pConocimiento = '') THEN
		SET mensaje = 'Los datos no pueden estar vacios';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT categoria FROM Categorias WHERE categoria = pCategoria) THEN
		SET mensaje = 'No existe la categoria buscada';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT conocimiento FROM Conocimientos WHERE conocimiento = pConocimiento) THEN
		SET mensaje = 'No existe el conocimiento buscado';
        LEAVE SALIR;
	ELSE
		SELECT Categorias.nombre AS 'Categoría', Conocimientos.nombre AS 'Conocimiento', Niveles.nombre AS 'Nivel', COUNT(Personas.persona) AS 'Personas'
			FROM Categorias JOIN Conocimientos
            ON Categorias.categoria = Conocimientos.categoria
            JOIN Habilidades
            ON Habilidades.conocimiento = Conocimientos.Conocimiento
            JOIN Niveles
            ON Niveles.nivel = Habilidades.nivel
            JOIN Personas
            ON Personas.persona = Habilidades.habilidad
            WHERE Categorias.categoria = pCategoria AND Conocimientos.conocimiento = pConocimiento
            GROUP BY Categorias.nombre, Conocimientos.nombre, Niveles.nombre
            ORDER BY 'Personas' ASC;
		SET mensaje = 'Se mostraron correctamente los datos';
    END IF;
END //
DELIMITER ;

-- Veamos los conocimientos y categorías actuales:
SELECT * FROM Conocimientos;
SELECT * FROM Categorias;

-- Ingreso una categoria y conocimiento existente
CALL PersonasConConocimiento(1,2 , @resultado); -- Idioma, inglés medio
SELECT @resultado;

-- -----------------------------------------------------
-- Apartado 5: Creación del trigger para borrar un nivel
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS Trig_Nivel_Borrado;

DELIMITER //
CREATE TRIGGER Trig_Nivel_Borrado
BEFORE DELETE ON Niveles FOR EACH ROW
BEGIN
	DECLARE referencia_habilidad CONDITION FOR SQLSTATE '45001';

	IF EXISTS (SELECT habilidad FROM Habilidades WHERE Habilidades.nivel = OLD.nivel) THEN
		SIGNAL referencia_habilidad SET MESSAGE_TEXT = 'No se puede borrar este nivel porque tiene una habilidad asociada', MYSQL_ERRNO = 45001;
    END IF;
END //
DELIMITER ;

SELECT * FROM Niveles;

DELETE FROM Niveles Where nivel=2;

INSERT INTO Niveles VALUES (6,'Maestro');
SELECT * FROM Niveles;
DELETE FROM Niveles Where nivel=6;
SELECT * FROM Niveles;