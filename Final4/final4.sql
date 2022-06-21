--
-- Año: 2022 
-- Alumno: Fernando Nahuel Tuquina
-- Plataforma (SO + Versión): Windows 10 Pro
-- Motor y Versión: MySQL Server 8.0.28 (Community Edition) 
-- GitHub Usuarios: Tuquina
-- Parcial de Práctica Nº4

-- ------------------------------------------------------------------------------------------------------- --

-- -----------------------------------------------------
-- Apartado 1: Creación de la BD
-- -----------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema final4
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `final4` ;

-- -----------------------------------------------------
-- Schema final4
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `final4` ;
USE `final4` ;

-- -----------------------------------------------------
-- Table `final4`.`Trabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final4`.`Trabajos` ;

CREATE TABLE IF NOT EXISTS `final4`.`Trabajos` (
  `idTrabajo` INTEGER NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `duracion` INTEGER NOT NULL DEFAULT 6,
  `area` VARCHAR(10) NOT NULL,
  CHECK (`area` = 'Hardware' OR `area` = 'Redes' OR `area` = 'Software'),
  `fechaPresentacion` DATE NOT NULL,
  `fechaAprobacion` DATE NOT NULL,
  `fechaFinalizacion` DATE NULL,
  PRIMARY KEY (`idTrabajo`),
  UNIQUE INDEX `titulo_UNIQUE` (`titulo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final4`.`Personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final4`.`Personas` ;

CREATE TABLE IF NOT EXISTS `final4`.`Personas` (
  `dni` INTEGER NOT NULL,
  `apellidos` VARCHAR(40) NOT NULL,
  `nombres` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`dni`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final4`.`Cargos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final4`.`Cargos` ;

CREATE TABLE IF NOT EXISTS `final4`.`Cargos` (
  `idCargo` INTEGER NOT NULL,
  `cargo` VARCHAR(20) NULL,
  PRIMARY KEY (`idCargo`),
  UNIQUE INDEX `cargo_UNIQUE` (`cargo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final4`.`Profesores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final4`.`Profesores` ;

CREATE TABLE IF NOT EXISTS `final4`.`Profesores` (
  `dni` INTEGER NOT NULL,
  `idCargo` INTEGER NOT NULL,
  INDEX `fk_Profesores_Personas_idx` (`dni` ASC) VISIBLE,
  PRIMARY KEY (`dni`),
  INDEX `fk_Profesores_Cargos1_idx` (`idCargo` ASC) VISIBLE,
  CONSTRAINT `fk_Profesores_Personas`
    FOREIGN KEY (`dni`)
    REFERENCES `final4`.`Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Profesores_Cargos1`
    FOREIGN KEY (`idCargo`)
    REFERENCES `final4`.`Cargos` (`idCargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final4`.`Alumnos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final4`.`Alumnos` ;

CREATE TABLE IF NOT EXISTS `final4`.`Alumnos` (
  `dni` INTEGER NOT NULL,
  `cx` CHAR(7) NOT NULL,
  INDEX `fk_Alumnos_Personas1_idx` (`dni` ASC) VISIBLE,
  PRIMARY KEY (`dni`),
  UNIQUE INDEX `cx_UNIQUE` (`cx` ASC) VISIBLE,
  CONSTRAINT `fk_Alumnos_Personas1`
    FOREIGN KEY (`dni`)
    REFERENCES `final4`.`Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final4`.`RolesEnTrabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final4`.`RolesEnTrabajos` ;

CREATE TABLE IF NOT EXISTS `final4`.`RolesEnTrabajos` (
  `idTrabajo` INTEGER NOT NULL,
  `dni` INTEGER NOT NULL,
  `rol` VARCHAR(7) NOT NULL,
  CHECK (`rol` = 'Tutor' OR `rol` = 'Cotutor' OR `rol` = 'Jurado'),
  `desde` DATE NOT NULL,
  `hasta` DATE NULL,
  `razon` VARCHAR(100) NULL,
  INDEX `fk_RolesEnTrabajos_Trabajos1_idx` (`idTrabajo` ASC) VISIBLE,
  INDEX `fk_RolesEnTrabajos_Profesores1_idx` (`dni` ASC) VISIBLE,
  PRIMARY KEY (`idTrabajo`, `dni`),
  CONSTRAINT `fk_RolesEnTrabajos_Trabajos1`
    FOREIGN KEY (`idTrabajo`)
    REFERENCES `final4`.`Trabajos` (`idTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RolesEnTrabajos_Profesores1`
    FOREIGN KEY (`dni`)
    REFERENCES `final4`.`Profesores` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final4`.`AlumnosEnTrabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final4`.`AlumnosEnTrabajos` ;

CREATE TABLE IF NOT EXISTS `final4`.`AlumnosEnTrabajos` (
  `idTrabajo` INTEGER NOT NULL,
  `dni` INTEGER NOT NULL,
  `desde` DATE NOT NULL,
  `hasta` DATE NULL,
  `razon` VARCHAR(100) NULL,
  INDEX `fk_AlumnosEnTrabajos_Trabajos1_idx` (`idTrabajo` ASC) VISIBLE,
  INDEX `fk_AlumnosEnTrabajos_Alumnos1_idx` (`dni` ASC) VISIBLE,
  PRIMARY KEY (`idTrabajo`, `dni`),
  CONSTRAINT `fk_AlumnosEnTrabajos_Trabajos1`
    FOREIGN KEY (`idTrabajo`)
    REFERENCES `final4`.`Trabajos` (`idTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AlumnosEnTrabajos_Alumnos1`
    FOREIGN KEY (`dni`)
    REFERENCES `final4`.`Alumnos` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------------------------------
-- Apartado 2: Creación de procedimiento DetalleRoles
-- -----------------------------------------------------

DROP VIEW IF EXISTS VDetalleRoles;

CREATE VIEW VDetalleRoles (Año, DNI, Apellidos, Nombres, Tutor, Cotutor, Jurado) 
AS 
	SELECT YEAR(RolesEnTrabajos.desde), Profesores.dni, Personas.apellidos, Personas.nombres, count(if(RolesEnTrabajos.rol='Tutor',1,NULL)) AS Tutor, count(if(RolesEnTrabajos.rol='Cotutor',1,NULL)) AS Cotutor, count(if(RolesEnTrabajos.rol='Jurado',1,NULL)) AS Jurado
	FROM RolesEnTrabajos JOIN Profesores
    ON RolesEnTrabajos.dni = Profesores.dni
    JOIN Personas
    ON Personas.dni = Profesores.dni
    GROUP BY YEAR(RolesEnTrabajos.desde), Profesores.dni, Personas.apellidos, Personas.nombres
	ORDER BY YEAR(RolesEnTrabajos.desde) ASC, apellidos ASC, nombres ASC;

SELECT * FROM VDetalleRoles;


DROP PROCEDURE IF EXISTS DetalleRoles;

DELIMITER //
CREATE PROCEDURE DetalleRoles(pAnioInicio INT, pAnioFin INT, OUT mensaje VARCHAR(100))
SALIR: BEGIN  
	DECLARE AnioAux YEAR;
	IF (pAnioInicio IS NULL) AND (pAnioFin IS NULL) THEN
		SET mensaje = 'Se mostraron todos detalles guardados';
			SELECT * FROM VDetalleRoles;
        LEAVE SALIR;
	ELSEIF (pAnioFin IS NULL) THEN
		SET mensaje = 'Se mostraron todos los detalles desde el anio de inicio';
			SELECT * FROM VDetalleRoles
			WHERE VDetalleRoles.Año >= pAnioInicio;
        LEAVE SALIR;
	ELSEIF (pAnioInicio IS NULL) THEN
		SET mensaje = 'Se mostraron todos los detalles hasta el AnioFin';
			SELECT * FROM VDetalleRoles
			WHERE VDetalleRoles.Año <= pAnioFin;
        LEAVE SALIR;
	ELSE
		IF pAnioInicio > pAnioFin THEN -- se invierten los anios
			SET AnioAux = pAnioInicio;
			SET pAnioInicio = pAnioFin;
			SET pAnioFin = AnioAux;
		END IF;
		SELECT * FROM VDetalleRoles
		WHERE VDetalleRoles.Año BETWEEN pAnioInicio AND pAnioFin;
		SET mensaje = 'Se mostraron los detalles en el rango especificado';
    END IF;
END //
DELIMITER ;

CALL DetalleRoles(2016,2018,@resultado);
SELECT @resultado;
CALL DetalleRoles(NULL,NULL,@resultado);
CALL DetalleRoles(2015,NULL,@resultado);
CALL DetalleRoles(NULL,2017,@resultado);

-- -----------------------------------------------------
-- Apartado 3: 
-- -----------------------------------------------------


DROP PROCEDURE IF EXISTS NuevoTrabajo;

DELIMITER //
CREATE PROCEDURE NuevoTrabajo(pIdTrabajo INTEGER, pTitulo VARCHAR(100), pDuracion INTEGER,
pArea VARCHAR(10), pFechaPresentacion DATE, pFechaAprobacion DATE, pFechaFinalizacion DATE, OUT mensaje VARCHAR(100))
SALIR: BEGIN  
	IF (pIdTrabajo IS NULL) OR (pTitulo IS NULL) OR (pDuracion IS NULL) OR (pArea IS NULL) OR (pFechaPresentacion IS NULL) OR (pFechaAprobacion IS NULL) THEN
		SET mensaje = 'Los datos no pueden ser nulos';
        LEAVE SALIR;
	ELSEIF (pTitulo = '') OR (pArea = '') THEN
		SET mensaje = 'Los campos no pueden estar vacios';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT idTrabajo FROM Trabajos WHERE idTrabajo = pIdTrabajo) THEN
		SET mensaje = 'Ya existe un trabajo con ese identificador';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT idTrabajo FROM Trabajos WHERE titulo = pTitulo) THEN
		SET mensaje = 'Ya existe un trabajo con ese titulo';
        LEAVE SALIR;
	ELSEIF (pDuracion < 0) THEN
		SET mensaje = 'La duracion no puede ser menor que cero';
        LEAVE SALIR;
	ELSEIF (pFechaPresentacion < pFechaAprobacion) THEN
		SET mensaje = 'La fecha de presentacion no puede ser menor a la fecha de aprobacion';
        LEAVE SALIR;
	ELSE
		INSERT INTO Trabajos VALUES (pIdTrabajo, pTitulo, pDuracion, pArea, pFechaPresentacion, pFechaAprobacion, pFechaFinalizacion);
		SET mensaje = 'Trabajo dada de alta con exito';
    END IF;
END //
DELIMITER ;

-- -----------------------------------------------------
-- Apartado 4: Creación de Auditoría Trabajos
-- -----------------------------------------------------

DROP TABLE IF EXISTS `AuditoriaTrabajos` ;

CREATE TABLE IF NOT EXISTS `AuditoriaTrabajos` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `IDTrabajo` INTEGER NOT NULL,
  `Titulo` VARCHAR(150) NOT NULL,
  `Duracion` INTEGER NOT NULL,
  `FechaPresentacion` DATETIME NOT NULL,
  `FechaAprobacion` DATETIME NOT NULL,
  `FechaFinalizacion` DATETIME NULL,
  `Tipo` CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, M: Modificación)
  `Usuario` VARCHAR(45) NOT NULL,  
  `Maquina` VARCHAR(45) NOT NULL,  
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`ID`)
);

DROP TRIGGER IF EXISTS `Trig_Trabajos_Insercion` 

DELIMITER //
CREATE TRIGGER `Trig_Trabajos_Insercion` 
AFTER INSERT ON `Trabajos` FOR EACH ROW
BEGIN
	IF(NEW.Duracion < 3 OR NEW.Duracion > 12) THEN
		INSERT INTO AuditoriaTrabajos VALUES (
			DEFAULT, 
			NEW.IDTrabajo,
			NEW.Titulo, 
			NEW.Duracion,
			NEW.FechaPresentacion,
			NEW.FechaAprobacion,
			NEW.FechaFinalizacion,
			'I', 
			SUBSTRING_INDEX(USER(), '@', 1), 
			SUBSTRING_INDEX(USER(), '@', -1), 
			NOW()
	  );
      END IF;
END //
DELIMITER ;

DELETE FROM AuditoriaTrabajos;

SELECT * FROM AuditoriaTrabajos;

INSERT INTO Trabajos VALUES (80,'titulo11',6,'Redes','2020-09-15','2020-07-01',NULL);
INSERT INTO Trabajos VALUES (81,'titulo22',2,'Redes','2020-09-15','2020-07-01',NULL);
INSERT INTO Trabajos VALUES (82,'titulo33',15,'Redes','2020-09-15','2020-07-01',NULL);