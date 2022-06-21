-- ------------------------------------------------------------------------------------------------------- --

							-- Año: 2022 
							-- Alumno: Fernando Nahuel Tuquina
							-- Plataforma (SO + Versión): Linux Ubuntu 20.4
							-- Motor y Versión: MySQL Server 8.0.28 (Community Edition) 
							-- GitHub Usuarios: Tuquina
							-- Examen Final Laboratorio de Bases de Datos 2022

-- ------------------------------------------------------------------------------------------------------- --

-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------
--  Apartado 1: Creación de la Base de datos y sus Constraints
-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema 39975251
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `39975251` ;
CREATE SCHEMA IF NOT EXISTS `39975251` ;
USE `39975251` ;



-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------
-- Apartado 2: Creación de la vista 
-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS ;

CREATE VIEW  () 
AS 
	SELECT 
	FROM  JOIN 
	ON
	ORDER BY ;

SELECT * FROM ;

-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------
-- Apartado 3: Creación del Stored Procedure
-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Nueva

DELIMITER //
CREATE PROCEDURE Nueva(,  OUT mensaje VARCHAR(100))
SALIR: BEGIN  
	IF ( IS NULL) OR ( IS NULL) OR ( IS NULL) OR ( IS NULL) THEN
		SET mensaje = 'Los datos de XX no pueden ser nulos';
        LEAVE SALIR;
	ELSEIF ( = '') OR ( = '') THEN
		SET mensaje = 'Los campos no pueden estar vacios';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT  FROM  WHERE  = ) THEN
		SET mensaje = 'Ya existe XX con ese identificador';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT  FROM  WHERE  = )  THEN
		SET mensaje = 'No existe el XX indicado';
        LEAVE SALIR;
	ELSE
		INSERT INTO  VALUES ();
		SET mensaje = 'XX dada de alta con exito';
    END IF;
END //
DELIMITER ;

-- Vemos las elementos guardados actualmente:
SELECT * FROM ; -- Son XX

-- Ingreso XX correcta
CALL Nueva
SELECT @resultado;
SELECT * FROM ; -- Se agrega a la tabla Personas

-- Ingreso un valor NULL no permitido
CALL Nueva
SELECT @resultado;
SELECT * FROM ; -- NO se agrega a la tabla 

-- Ingreso un valor vacío no permitido
CALL Nueva
SELECT @resultado;
SELECT * FROM ; -- NO se agrega a la tabla 

-- Ingreso una clave repetida
CALL Nueva
SELECT @resultado;
SELECT * FROM ; -- NO se agrega a la tabla 

-- Ingreso XX inexistente
CALL Nueva
SELECT @resultado;
SELECT * FROM ; -- NO se agrega a la tabla 

-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------
-- Apartado 4: Creación del Stored Procedure
-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------


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

-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------
-- Apartado 5: Creación del trigger 
-- ----------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------

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