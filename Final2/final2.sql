--
-- Año: 2022 
-- Alumno: Fernando Nahuel Tuquina
-- Plataforma (SO + Versión): Windows 10 Pro
-- Motor y Versión: MySQL Server 8.0.28 (Community Edition) 
-- GitHub Usuarios: Tuquina
-- Parcial de Práctica Nº2

-- ------------------------------------------------------------------------------------------------------- --

-- -----------------------------------------------------
-- Apartado 1: Creación de la BD
-- -----------------------------------------------------

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema final2
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `final2` ;

-- -----------------------------------------------------
-- Schema final2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `final2` DEFAULT CHARACTER SET utf8 ;
USE `final2` ;

-- -----------------------------------------------------
-- Table `final2`.`Direcciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final2`.`Direcciones` ;

CREATE TABLE IF NOT EXISTS `final2`.`Direcciones` (
  `idDireccion` INT NOT NULL,
  `calleYNumero` VARCHAR(60) NOT NULL,
  `codigoPostal` VARCHAR(10) NULL,
  `telefono` VARCHAR(25) NOT NULL,
  `municipio` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`idDireccion`),
  UNIQUE INDEX `calleYNumero_UNIQUE` (`calleYNumero` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final2`.`Personal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final2`.`Personal` ;

CREATE TABLE IF NOT EXISTS `final2`.`Personal` (
  `idPersonal` INT NOT NULL,
  `apellidos` VARCHAR(50) NOT NULL,
  `nombres` VARCHAR(50) NOT NULL,
  `correo` VARCHAR(50) NULL,
  `estado` CHAR(1) DEFAULT 'E' NOT NULL
  CHECK (estado = 'E' OR estado = 'D'),
  `idDireccion` INT NOT NULL,
  PRIMARY KEY (`idPersonal`),
  INDEX `fk_Personal_Direcciones_idx` (`idDireccion` ASC) VISIBLE,
  UNIQUE INDEX `correo_UNIQUE` (`correo` ASC) VISIBLE,
  CONSTRAINT `fk_Personal_Direcciones`
    FOREIGN KEY (`idDireccion`)
    REFERENCES `final2`.`Direcciones` (`idDireccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final2`.`Sucursales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final2`.`Sucursales` ;

CREATE TABLE IF NOT EXISTS `final2`.`Sucursales` (
  `idSucursal` CHAR(10) NOT NULL,
  `idDireccion` INT NOT NULL,
  `idGerente` INT NOT NULL,
  PRIMARY KEY (`idSucursal`, `idGerente`),
  INDEX `fk_Sucursales_Direcciones1_idx` (`idDireccion` ASC) VISIBLE,
  INDEX `fk_Sucursales_Personal1_idx` (`idGerente` ASC) VISIBLE,
  CONSTRAINT `fk_Sucursales_Direcciones1`
    FOREIGN KEY (`idDireccion`)
    REFERENCES `final2`.`Direcciones` (`idDireccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sucursales_Personal1`
    FOREIGN KEY (`idGerente`)
    REFERENCES `final2`.`Personal` (`idPersonal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final2`.`Generos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final2`.`Generos` ;

CREATE TABLE IF NOT EXISTS `final2`.`Generos` (
  `idGenero` CHAR(10) NOT NULL,
  `nombre` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`idGenero`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final2`.`Peliculas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final2`.`Peliculas` ;

CREATE TABLE IF NOT EXISTS `final2`.`Peliculas` (
  `idPelicula` INT NOT NULL,
  `titulo` VARCHAR(128) NOT NULL,
  `clasificacion` VARCHAR(5) DEFAULT 'G' NOT NULL
  CHECK	(clasificacion = 'G' OR clasificacion = 'PG' OR clasificacion = 'PG-13' OR clasificacion = 'R' OR clasificacion = 'NC-17'),
  `estreno` INT NULL,
  `duracion` INT NULL,
  PRIMARY KEY (`idPelicula`),
  UNIQUE INDEX `titulo_UNIQUE` (`titulo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final2`.`GenerosDePeliculas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final2`.`GenerosDePeliculas` ;

CREATE TABLE IF NOT EXISTS `final2`.`GenerosDePeliculas` (
  `idGenero` CHAR(10) NOT NULL,
  `idPelicula` INT NOT NULL,
  INDEX `fk_GenerosDePeliculas_Peliculas1_idx` (`idPelicula` ASC) VISIBLE,
  INDEX `fk_GenerosDePeliculas_Generos1_idx` (`idGenero` ASC) VISIBLE,
  CONSTRAINT `fk_GenerosDePeliculas_Peliculas1`
    FOREIGN KEY (`idPelicula`)
    REFERENCES `final2`.`Peliculas` (`idPelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GenerosDePeliculas_Generos1`
    FOREIGN KEY (`idGenero`)
    REFERENCES `final2`.`Generos` (`idGenero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final2`.`inventario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final2`.`inventario` ;

CREATE TABLE IF NOT EXISTS `final2`.`inventario` (
  `idInventario` INT NOT NULL,
  `idPelicula` INT NOT NULL,
  `idSucursal` CHAR(10) NOT NULL,
  PRIMARY KEY (`idInventario`),
  INDEX `fk_inventario_Peliculas1_idx` (`idPelicula` ASC) VISIBLE,
  INDEX `fk_inventario_Sucursales1_idx` (`idSucursal` ASC) VISIBLE,
  CONSTRAINT `fk_inventario_Peliculas1`
    FOREIGN KEY (`idPelicula`)
    REFERENCES `final2`.`Peliculas` (`idPelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventario_Sucursales1`
    FOREIGN KEY (`idSucursal`)
    REFERENCES `final2`.`Sucursales` (`idSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------------------------------
-- Apartado 4: Creación del SP TotalPeliculas
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS TotalPeliculas;

DELIMITER //
CREATE PROCEDURE TotalPeliculas()
-- Muestra un listado ordenado por Nombre del Genero del total de películas de ese género
BEGIN  
	SELECT Generos.idGenero, Generos.nombre AS Nombre, count(GenerosDePeliculas.idGenero) AS Cantidad
    FROM Generos JOIN GenerosDePeliculas
    ON Generos.idGenero = GenerosDePeliculas.idGenero
    GROUP BY Generos.idGenero, Generos.nombre
    ORDER BY Generos.nombre ASC;
END //
DELIMITER ;

CALL TotalPeliculas;

SELECT * FROM Generos;
SELECT * FROM GenerosDePeliculas;