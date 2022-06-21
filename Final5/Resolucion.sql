-- Creamos la DB.
DROP DATABASE IF EXISTS Choua;
CREATE DATABASE Choua;
USE Choua;

-- 
-- TABLE: Auditoria 
--

CREATE TABLE Auditoria(
    IDAuditoria       INT            AUTO_INCREMENT,
    Fecha             DATETIME       NOT NULL,
    Usuario           VARCHAR(45)    NOT NULL,
    IP                VARCHAR(45)    NOT NULL,
    Tipo              CHAR(1)        NOT NULL
                      CHECK (Tipo IN ('B')),
    IDMateriaPrima    INT            NOT NULL,
    Nombre            VARCHAR(35)    NOT NULL,
    PrecioUnitario    FLOAT    NOT NULL,
    Unidad            VARCHAR(10)    NOT NULL,
    PRIMARY KEY (IDAuditoria)
)ENGINE=INNODB
;



-- 
-- TABLE: Categorias 
--

CREATE TABLE Categorias(
    Nombre    VARCHAR(15)    NOT NULL,
    PRIMARY KEY (Nombre)
)ENGINE=INNODB
;



-- 
-- TABLE: Unidades 
--

CREATE TABLE Unidades(
    Nombre    VARCHAR(10)    NOT NULL,
    PRIMARY KEY (Nombre)
)ENGINE=INNODB
;



-- 
-- TABLE: MateriaPrima 
--

CREATE TABLE MateriaPrima(
    IDMateriaPrima    INT            NOT NULL,
    Nombre            VARCHAR(35)    NOT NULL,
    PrecioUnitario    FLOAT    NOT NULL
                      CHECK (PrecioUnitario > 0),
    Unidad            VARCHAR(10)    NOT NULL,
    PRIMARY KEY (IDMateriaPrima), 
    UNIQUE INDEX UI_Nombre(Nombre),
    INDEX Ref29(Unidad), 
    CONSTRAINT RefUnidades9 FOREIGN KEY (Unidad)
    REFERENCES Unidades(Nombre)
)ENGINE=INNODB
;



-- 
-- TABLE: Recetas 
--

CREATE TABLE Recetas(
    IDReceta         INT              NOT NULL,
    Rendimiento      FLOAT      NOT NULL
                     CHECK (Rendimiento > 0),
    Procedimiento    VARCHAR(1000)    NOT NULL,
    Nombre           VARCHAR(35)      NOT NULL,
    Unidad           VARCHAR(10)      NOT NULL,
    Categoria        VARCHAR(15)      NOT NULL,
    PRIMARY KEY (IDReceta), 
    UNIQUE INDEX UI_Nombre(Nombre),
    INDEX Ref22(Unidad),
    INDEX Ref33(Categoria), 
    CONSTRAINT RefUnidades2 FOREIGN KEY (Unidad)
    REFERENCES Unidades(Nombre),
    CONSTRAINT RefCategorias3 FOREIGN KEY (Categoria)
    REFERENCES Categorias(Nombre)
)ENGINE=INNODB
;



-- 
-- TABLE: Composicion 
--

CREATE TABLE Composicion(
    IDReceta          INT            NOT NULL,
    IDMateriaPrima    INT            NOT NULL,
    Cantidad          FLOAT    NOT NULL
                      CHECK (Cantidad > 0),
    PRIMARY KEY (IDReceta, IDMateriaPrima), 
    INDEX Ref66(IDMateriaPrima),
    INDEX Ref57(IDReceta), 
    CONSTRAINT RefMateriaPrima6 FOREIGN KEY (IDMateriaPrima)
    REFERENCES MateriaPrima(IDMateriaPrima),
    CONSTRAINT RefRecetas7 FOREIGN KEY (IDReceta)
    REFERENCES Recetas(IDReceta)
)ENGINE=INNODB
;



-- 
-- TABLE: RecetasRecetas 
--

CREATE TABLE RecetasRecetas(
    IDReceta        INT            NOT NULL,
    IDComponente    INT            NOT NULL,
    Cantidad        FLOAT    NOT NULL
                    CHECK (Cantidad > 0),
    PRIMARY KEY (IDReceta, IDComponente), 
    INDEX Ref54(IDReceta),
    INDEX Ref58(IDComponente), 
    CONSTRAINT RefRecetas4 FOREIGN KEY (IDReceta)
    REFERENCES Recetas(IDReceta),
    CONSTRAINT RefRecetas8 FOREIGN KEY (IDComponente)
    REFERENCES Recetas(IDReceta)
)ENGINE=INNODB
;

-- Creamos Trigger
DROP TRIGGER IF EXISTS `Choua`.`MateriaPrima_AFTER_DELETE`;

DELIMITER $$
USE `Choua`$$
CREATE TRIGGER `Choua`.`MateriaPrima_AFTER_DELETE` AFTER DELETE ON `MateriaPrima` FOR EACH ROW
BEGIN
/*
          Trigger que se ejecuta al momento de eliminar una MateriaPrima.
        Almacena toda la informacion de la materia prima antes de ser borrada.
        Ademas alamcenad la Operacion (B: Borrado en este caso), Usuario que ejecuto la accion, 
        Maquina desde donde se ejecuto y la Fecha y Hora.
*/
	INSERT INTO Auditoria VALUES(0, NOW(), SUBSTRING_INDEX(USER(),'@',1), SUBSTRING_INDEX(USER(),'@',-1), 
    'B',OLD.IDMateriaPrima, OLD.Nombre, OLD.PrecioUnitario, OLD.Unidad);
END$$
DELIMITER ;

-- Inserciones

INSERT INTO `Categorias` (`Nombre`) VALUES ('Tartas');
INSERT INTO `Categorias` (`Nombre`) VALUES ('Cremas Frías');
INSERT INTO `Categorias` (`Nombre`) VALUES ('Masas bases');
INSERT INTO `Categorias` (`Nombre`) VALUES ('Postres');
INSERT INTO `Categorias` (`Nombre`) VALUES ('Coberturas');
INSERT INTO `Categorias` (`Nombre`) VALUES ('Rellenos');
INSERT INTO `Categorias` (`Nombre`) VALUES ('Decoraciones');

INSERT INTO `Unidades` (`Nombre`) VALUES ('g');
INSERT INTO `Unidades` (`Nombre`) VALUES ('cc');
INSERT INTO `Unidades` (`Nombre`) VALUES ('u');
INSERT INTO `Unidades` (`Nombre`) VALUES ('porciones');

INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (1, 'Manteca', 5.06, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (2, 'Azúcar', 4.0065, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (3, 'Huevos', 13.34, 'u');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (4, 'Leche', 11.0, 'cc');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (5, 'Chocolate para taza', 10.1, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (6, 'Harina', 10.0055, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (7, 'Polvo para hornear', 20.06, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (8, 'Bicarbonato de sodio', 10.06, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (9, 'Coñac', 82.0, 'cc');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (10, 'Escencia de vainilla', 15.0, 'cc');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (11, 'Yemas', 28.0, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (12, 'Almidón de maíz', 15.0, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (13, 'Jugo de limón', 10.04, 'cc');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (14, 'Claras', 28.0, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (15, 'Chocolate cobertura', 125, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (16, 'Nueces', 10.2, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (17, 'Dulce de leche', 18, 'g');
INSERT INTO `MateriaPrima` (`IDMateriaPrima`, `Nombre`, `PrecioUnitario`, `Unidad`) VALUES (18, 'Agua', 10.5, 'cc');

INSERT INTO `Recetas` (`IDReceta`, `Rendimiento`, `Procedimiento`, `Nombre`, `Unidad`, `Categoria`) VALUES(1, 500.0, 'Batir ...', 'Merengue', 'g', 'Coberturas');
INSERT INTO `Recetas` (`IDReceta`, `Rendimiento`, `Procedimiento`, `Nombre`, `Unidad`, `Categoria`) VALUES(2, 10.0, 'Mezclar ...', 'Masa frola', 'porciones', 'Masas bases');
INSERT INTO `Recetas` (`IDReceta`, `Rendimiento`, `Procedimiento`, `Nombre`, `Unidad`, `Categoria`) VALUES(3, 3.0, 'Armar ...', 'Lemon Pie', 'porciones', 'Tartas');
INSERT INTO `Recetas` (`IDReceta`, `Rendimiento`, `Procedimiento`, `Nombre`, `Unidad`, `Categoria`) VALUES(4, 6.0, 'Mezclar ...', 'Bizcochuelo', 'porciones', 'Masas bases');

INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('4', '3', 2);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('4', '2', 60);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('4', '6', 60);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('4', '10', 10);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('1', '2', 340);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('1', '14', 150);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('2', '1', 150);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('2', '2', 150);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('2', '11', 80);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('2', '6', 300);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('2', '7', 5);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('2', '10', 10);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('3', '11', 80);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('3', '2', 100);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('3', '12', 40);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('3', '14', 200);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('3', '13', 60);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('3', '10', 10);
INSERT INTO `Composicion` (`IDReceta`, `IDMateriaPrima`, `Cantidad`) VALUES ('4', '14', 250);

INSERT INTO `RecetasRecetas` (`IDReceta`, `IDComponente`, `Cantidad`) VALUES ('3', '1', '650');
INSERT INTO `RecetasRecetas` (`IDReceta`, `IDComponente`, `Cantidad`) VALUES ('3', '2', '10');
INSERT INTO `RecetasRecetas` (`IDReceta`, `IDComponente`, `Cantidad`) VALUES ('3', '3', '12');
INSERT INTO `RecetasRecetas` (`IDReceta`, `IDComponente`, `Cantidad`) VALUES ('4', '3', '6');
INSERT INTO `RecetasRecetas` (`IDReceta`, `IDComponente`, `Cantidad`) VALUES ('4', '1', '750');

-- Creamos SP BorrarMateriaPrima
USE `Choua`;
DROP procedure IF EXISTS `BorrarMateriaPrima`;

DELIMITER $$
USE `Choua`$$
CREATE PROCEDURE `BorrarMateriaPrima` (pIDMateriaPrima INTEGER)
SALIR:BEGIN
	/*
    Permite borrar una Materia Prima. Controla parametro de entrada. 
    Controla que exista. Controla que no este en uso.
    Devuelve OK o el mensaje de error en Mensaje.
	*/
    
    -- Controla parametro de entrada pLegajo
	IF pIDMateriaPrima IS NULL OR pIDMateriaPrima = 0 THEN
		SELECT 'El ID de materia prima es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;

   -- Controlar si existe materia prima.
    IF NOT EXISTS(SELECT IDMateriaPrima FROM MateriaPrima WHERE IDMateriaPrima = pIDMateriaPrima) 
    THEN SELECT 'La materia prima que quiere borrar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Controla que no este en uso la materia prima
    IF EXISTS(SELECT IDMateriaPrima FROM Composicion WHERE IDMateriaPrima = pIDMateriaPrima) 
    THEN SELECT 'La materia prima que quiere borrar esta en uso.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Borramos.
    DELETE FROM MateriaPrima WHERE IDMateriaPrima = pIDMateriaPrima;
    SELECT 'OK.' AS Mensaje;
END$$

DELIMITER ;

-- Probamos SP BorrarMateriaPrima
CALL BorrarMateriaPrima(NULL); -- El ID de materia prima es obligatorio.
CALL BorrarMateriaPrima(999); -- La materia prima que quiere borrar no existe.
CALL BorrarMateriaPrima(2);  -- La materia prima que quiere borrar esta en uso.
CALL BorrarMateriaPrima(18); -- OK.


-- Probamos Auditoria
SELECT * FROM Auditoria;

-- Creamos vista RankingMateriasPrimas
CREATE VIEW RankingMateriasPrimas AS
SELECT ROW_NUMBER() OVER (ORDER BY SUM(com.Cantidad) DESC) AS Ranking,
mat.Nombre AS 'Materia Prima', SUM(com.cantidad) AS Cantidad, uni.Nombre AS Unidad
FROM MateriaPrima mat
INNER JOIN Composicion com ON mat.IDMateriaPrima = com.IDMateriaPrima
INNER JOIN Unidades uni ON mat.Unidad = uni.Nombre
GROUP BY mat.Nombre, uni.Nombre
ORDER BY Cantidad DESC;

-- Probamos RankingMateriasPrimas
SELECT * FROM RankingMateriasPrimas;


-- Creamos procedimiento almacenado VerRecetas
USE `Choua`;
DROP procedure IF EXISTS `VerRecetas`;

DELIMITER $$
USE `Choua`$$
CREATE PROCEDURE `VerRecetas`()
BEGIN
/*
	muestre una receta dada. Se deberá mostrar el nombre, rendimiento, unidades, categoría,
	composición y cantidad (tanto de materia prima como de otra receta que forme parte
	de la misma) y procedimiento. Al mostrar la composición (tanto de una materia prima
	como de otra receta) mostrar el nombre de la materia prima o de la receta
*/
	SELECT rec1.Nombre AS Receta, rec1.Rendimiento, cat.Nombre AS Categoria, 
    mat.Nombre AS 'Materia Prima', com.Cantidad AS Cantidad, 
    uni.Nombre AS Unidad, rec1.Procedimiento
    FROM Recetas rec1
    INNER JOIN Categorias cat ON rec1.Categoria = cat.Nombre
    INNER JOIN Composicion com ON rec1.IDReceta = com.IDReceta 
    INNER JOIN MateriaPrima mat ON com.IDMateriaPrima = mat.IDMateriaPrima
    INNER JOIN Unidades uni ON mat.Unidad = uni.Nombre
	
    UNION
    
	SELECT rec1.Nombre AS Receta, rec1.Rendimiento, cat.Nombre AS Categoria, 
    rec2.Nombre AS 'Materia Prima', rr.Cantidad, uni.Nombre, rec1.Procedimiento
    FROM Recetas rec1
    INNER JOIN Categorias cat ON rec1.Categoria = cat.Nombre
    INNER JOIN Unidades uni ON rec1.Unidad = uni.Nombre
    INNER JOIN RecetasRecetas rr ON rec1.IDReceta = rr.IDReceta
    INNER JOIN Recetas rec2 ON rec2.IDReceta = rr.IDComponente
    ORDER BY Receta, Cantidad DESC;

END$$

DELIMITER ;
;

-- Probamos VerReceta
CALL VerRecetas();

-- Creamos procedimiento almacenado VerReceta dada una receta
USE `Choua`;
DROP procedure IF EXISTS `VerReceta`;

DELIMITER $$
USE `Choua`$$
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