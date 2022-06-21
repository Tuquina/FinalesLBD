-- -----------------------------------------------------
-- Apartado 1: Creación de la BD
-- -----------------------------------------------------

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema final5
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `final5` ;

-- -----------------------------------------------------
-- Schema final5
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `final5` ;
USE `final5` ;

-- -----------------------------------------------------
-- Table `final5`.`Unidades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final5`.`Unidades` ;

CREATE TABLE IF NOT EXISTS `final5`.`Unidades` (
  `Nombre` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final5`.`table1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final5`.`Categorias` ;

CREATE TABLE IF NOT EXISTS `final5`.`Categorias` (
  `Nombre` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final5`.`Recetas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final5`.`Recetas` ;

CREATE TABLE IF NOT EXISTS `final5`.`Recetas` (
  `IDReceta` INT NOT NULL,
  `Rendimiento` FLOAT NOT NULL
		CHECK (`Rendimiento` > 0),
  `Procedimiento` VARCHAR(1000) NOT NULL,
  `Nombre` VARCHAR(35) NOT NULL,
  `Unidad` VARCHAR(10) NOT NULL,
  `Categoria` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`IDReceta`),
  INDEX `fk_Recetas_Unidades1_idx` (`Unidad` ASC) VISIBLE,
  INDEX `fk_Recetas_table11_idx` (`Categoria` ASC) VISIBLE,
  UNIQUE INDEX `Nombre_UNIQUE` (`Nombre` ASC) VISIBLE,
  CONSTRAINT `fk_Recetas_Unidades1`
    FOREIGN KEY (`Unidad`)
    REFERENCES `final5`.`Unidades` (`Nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recetas_Categorias1`
    FOREIGN KEY (`Categoria`)
    REFERENCES `final5`.`Categorias` (`Nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final5`.`MateriaPrima`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final5`.`MateriaPrima` ;

CREATE TABLE IF NOT EXISTS `final5`.`MateriaPrima` (
  `IDMateriaPrima` INT NOT NULL,
  `Nombre` VARCHAR(35) NOT NULL,
  `PrecioUnitario` FLOAT NOT NULL
  CHECK (`PrecioUnitario` > 0),
  `Unidad` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`IDMateriaPrima`),
  INDEX `fk_MateriaPrima_Unidades_idx` (`Unidad` ASC) VISIBLE,
  UNIQUE INDEX `Nombre_UNIQUE` (`Nombre` ASC) VISIBLE,
  CONSTRAINT `fk_MateriaPrima_Unidades`
    FOREIGN KEY (`Unidad`)
    REFERENCES `final5`.`Unidades` (`Nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final5`.`Composicion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final5`.`Composicion` ;

CREATE TABLE IF NOT EXISTS `final5`.`Composicion` (
  `IDReceta` INT NOT NULL,
  `IDMateriaPrima` INT NOT NULL,
  `Cantidad` FLOAT NOT NULL
  CHECK (`Cantidad` > 0),
  INDEX `fk_Composicion_MateriaPrima1_idx` (`IDMateriaPrima` ASC) VISIBLE,
  INDEX `fk_Composicion_Recetas1_idx` (`IDReceta` ASC) VISIBLE,
  PRIMARY KEY (`IDReceta`, `IDMateriaPrima`),
  CONSTRAINT `fk_Composicion_MateriaPrima1`
    FOREIGN KEY (`IDMateriaPrima`)
    REFERENCES `final5`.`MateriaPrima` (`IDMateriaPrima`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Composicion_Recetas1`
    FOREIGN KEY (`IDReceta`)
    REFERENCES `final5`.`Recetas` (`IDReceta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `final5`.`RecetasRecetas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `final5`.`RecetasRecetas` ;

CREATE TABLE IF NOT EXISTS `final5`.`RecetasRecetas` (
  `IDReceta` INT NOT NULL,
  `IDComponente` INT NOT NULL,
  `Cantidad` FLOAT NOT NULL
  CHECK (`Cantidad` > 0),
  INDEX `fk_RecetasRecetas_Recetas1_idx` (`IDReceta` ASC) VISIBLE,
  INDEX `fk_RecetasRecetas_Recetas2_idx` (`IDComponente` ASC) VISIBLE,
  PRIMARY KEY (`IDReceta`, `IDComponente`),
  CONSTRAINT `fk_RecetasRecetas_Recetas1`
    FOREIGN KEY (`IDReceta`)
    REFERENCES `final5`.`Recetas` (`IDReceta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RecetasRecetas_Recetas2`
    FOREIGN KEY (`IDComponente`)
    REFERENCES `final5`.`Recetas` (`IDReceta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Apartado 3: Creado de SP VerReceta
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS VerReceta;

DELIMITER //
CREATE PROCEDURE VerReceta(pIDReceta INT, OUT mensaje VARCHAR(100)) 
SALIR: BEGIN  
	IF (pIDReceta IS NULL) THEN
		SET mensaje = 'Los datos no pueden ser null';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT IDReceta FROM Recetas WHERE IDReceta = pIDReceta) THEN
		SET mensaje = 'No existe la receta buscada';
        LEAVE SALIR;
	ELSE
		SELECT Recetas.Nombre, Recetas.rendimiento, Unidades.nombre, Categorias.nombre, 
			FROM Categorias JOIN Conocimientos

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


CREATE PROCEDURE `VerReceta`(pIDReceta INTEGER)
SALIR: BEGIN
/*
	muestre una receta dada. Se deberá mostrar el nombre, rendimiento, unidades, categoría,
	composición y cantidad (tanto de materia prima como de otra receta que forme parte
	de la misma) y procedimiento. Al mostrar la composición (tanto de una materia prima
	como de otra receta) mostrar el nombre de la materia prima o de la receta.
	
    Controla que la receta del parametro de entrada exista y sea correcta.
*/

	-- Controla parametro de entrada pLegajo
	IF pIDReceta IS NULL OR pIDReceta = 0 THEN
		SELECT 'El ID de receta es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    -- Controlar si existe la receta.
    IF NOT EXISTS(SELECT IDReceta FROM Recetas WHERE IDReceta = pIDReceta) 
    THEN SELECT 'La receta que quiere visualizar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
	SELECT rec1.Nombre AS Receta, rec1.Rendimiento, cat.Nombre AS Categoria, 
    mat.Nombre AS 'Materia Prima', com.Cantidad AS Cantidad, 
    uni.Nombre AS Unidad, rec1.Procedimiento
    FROM Recetas rec1
    INNER JOIN Categorias cat ON rec1.Categoria = cat.Nombre
    INNER JOIN Composicion com ON rec1.IDReceta = com.IDReceta 
    INNER JOIN MateriaPrima mat ON com.IDMateriaPrima = mat.IDMateriaPrima
    INNER JOIN Unidades uni ON mat.Unidad = uni.Nombre
    WHERE pIDReceta = rec1.IDReceta
	
    UNION
    
	SELECT rec1.Nombre AS Receta, rec1.Rendimiento, cat.Nombre AS Categoria, 
    rec2.Nombre AS 'Materia Prima', rr.Cantidad, uni.Nombre, rec1.Procedimiento
    FROM Recetas rec1
    INNER JOIN Categorias cat ON rec1.Categoria = cat.Nombre
    INNER JOIN Unidades uni ON rec1.Unidad = uni.Nombre
    INNER JOIN RecetasRecetas rr ON rec1.IDReceta = rr.IDReceta
    INNER JOIN Recetas rec2 ON rec2.IDReceta = rr.IDComponente
    WHERE pIDReceta = rec1.IDReceta
    ORDER BY Receta, Cantidad DESC;

END$$

DELIMITER ;
;

-- Probamos el SP
CALL VerReceta(NULL); -- ID de receta obligatorio.
CALL VerReceta(99); -- Receta no existe.
CALL VerReceta(1); -- OK.