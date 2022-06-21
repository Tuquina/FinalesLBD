-- Año: 2022
-- Grupo: 14
-- Integrantes: Santana Juan Alfredo, Tuquina Fernando Nahuel
-- Tema: Gestion de clientes y turnos para un ISP
-- Nombre del Esquema: LBD2022G14
-- Plataforma: Windows 10 Pro
-- Motor y Versión: MySQL Workbench 8.0 (Community Edition)
-- GitHub Repositorio: LBD2022G14
-- GitHub Usuarios: alfredosantana94, Tuquina
-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema LBD2022G14
-- -----------------------------------------------------

USE `LBD2022G14` ;

-- ----------------------------------------------------------------------------------------------------------
-- ---------------------------------------------- TRIGGERS --------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------
-- Tabla de auditoría
-- -----------------------------------------------------

DROP TABLE IF EXISTS `AuditoriaEquipos` ;

CREATE TABLE IF NOT EXISTS `AuditoriaEquipos` (
  `ID` INT NOT NULL AUTO_INCREMENT,	-- ID de Auditoría para equipos
  `MAC` VARCHAR(30) NOT NULL,
  `Marca` VARCHAR(45) NULL,
  `Modelo` VARCHAR(45) NULL,
  `SerialNumber` VARCHAR(45) NULL,
  `Estado` VARCHAR(45) NULL,
  `IP` VARCHAR(45) NULL,
  `idTipoEquipo` INT NOT NULL,
  `Tipo` CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, M: Modificación)
  `Usuario` VARCHAR(45) NOT NULL,  
  `Maquina` VARCHAR(45) NOT NULL,  
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`ID`)
);

-- -----------------------------------------------------
-- Trigger de Inserción
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS `Trig_Equipos_Insercion`;

DELIMITER //
CREATE TRIGGER `Trig_Equipos_Insercion` 
AFTER INSERT ON `Equipos` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaEquipos VALUES (
		DEFAULT, 
		NEW.MAC,
		NEW.Marca, 
        NEW.Modelo,
        NEW.SerialNumber,
        NEW.Estado,
        NEW.IP,
        NEW.idTipoEquipo,
		'I', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
  );
END //
DELIMITER ;
-- USER(): devuelve el usuario actual y la máquina como una cadena. Por ejemplo: 'juan@localhost'
-- SUBSTRING_INDEX(): devuelve una subcadena de la cadena especificada. 
-- En el primer caso, devuelve todo a la izquierda del delimitador '@' ('juan')
-- En el segundo caso devuelve todo a la derecha del delimitador '@' ('localhost')

SELECT * FROM Equipos;
SELECT * FROM AuditoriaEquipos;

INSERT INTO Equipos (MAC, Marca, Modelo, SerialNumber, Estado, IP, idTipoEquipo) VALUES ('FF-FF-FF-FF-FF-FF', 'Mikrotik', '2', '9999999999', 'Activo', '192.168.100.100', 2);

SELECT * FROM Equipos;
SELECT * FROM AuditoriaEquipos;

-- -----------------------------------------------------
-- Trigger de Modificación
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS `Trig_Equipos_Modificacion`;

DELIMITER //
CREATE TRIGGER `Trig_Equipos_Modificacion` 
AFTER UPDATE ON `Equipos` FOR EACH ROW
BEGIN
	-- valores viejos
	INSERT INTO AuditoriaEquipos VALUES (
        DEFAULT, 
		OLD.MAC,
		OLD.Marca, 
        OLD.Modelo,
        OLD.SerialNumber,
        OLD.Estado,
        OLD.IP,
        OLD.idTipoEquipo,
		'M', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
    -- valores nuevos
	INSERT INTO AuditoriaEquipos VALUES (
		DEFAULT, 
		NEW.MAC,
		NEW.Marca, 
        NEW.Modelo,
        NEW.SerialNumber,
        NEW.Estado,
        NEW.IP,
        NEW.idTipoEquipo,
		'M', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);    
END //
DELIMITER ;

SELECT * FROM Equipos;
SELECT * FROM AuditoriaEquipos;

UPDATE Equipos 
	SET SerialNumber = '2222222222', Estado = 'Baja', IP = '192.168.111.111'
    WHERE MAC = 'FF-FF-FF-FF-FF-FF';

SELECT * FROM Equipos;
SELECT * FROM AuditoriaEquipos;

-- -----------------------------------------------------
-- Trigger de Borrado
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS `Trig_Equipos_Borrado`;

DELIMITER //
CREATE TRIGGER `Trig_Equipos_Borrado` 
AFTER DELETE ON `Equipos` FOR EACH ROW
BEGIN
	-- valores borrados
	INSERT INTO AuditoriaEquipos VALUES (
        DEFAULT, 
		OLD.MAC,
		OLD.Marca, 
        OLD.Modelo,
        OLD.SerialNumber,
        OLD.Estado,
        OLD.IP,
        OLD.idTipoEquipo,
		'B', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);   
END //
DELIMITER ;

SELECT * FROM Equipos;
SELECT * FROM AuditoriaEquipos;

DELETE FROM Equipos 
	WHERE  MAC = 'FF-FF-FF-FF-FF-FF';

SELECT * FROM Equipos;
SELECT * FROM AuditoriaEquipos;

-- ----------------------------------------------------------------------------------------------------------
-- ---------------------------------- PROCEDIMIENTOS ALMACENADOS --------------------------------------------
-- ----------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------
-- Creación de un equipo
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS AltaEquipo;

DELIMITER //
CREATE PROCEDURE AltaEquipo(pMAC VARCHAR(30), pMarca VARCHAR(45), pModelo VARCHAR(45), pSerialNumber VARCHAR(45), 
pEstado VARCHAR(45), pIP VARCHAR(45),pidTipoEquipo INT, OUT mensaje VARCHAR(100))
-- Crea un equipo siempre y cuando no haya otro con la misma MAC, y sea un tipo de equipo válido.
-- La cláusula LEAVE permite salir del flujo de control que tiene la etiqueta dada
-- Si la etiqueta es para el bloque más externo, se puede salir de todo el procedimiento.
SALIR: BEGIN  
	IF (pMAC IS NULL) OR (pidTipoEquipo IS NULL) THEN
		SET mensaje = 'Error en los datos del equipo';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT MAC FROM Equipos WHERE MAC = pMAC) THEN
		SET mensaje = 'Ya existe un equipo con esa MAC';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT Tipo FROM TipoEquipo WHERE TipoEquipo.idTipoEquipo = pidTipoEquipo) THEN
		SET mensaje = 'No existe el tipo de equipo elegido';
        LEAVE SALIR;
	ELSE
		START TRANSACTION;
			INSERT INTO Equipos VALUES (pMAC, pMarca, pModelo, pSerialNumber, pEstado, pIP,pidTipoEquipo);
            SET mensaje = 'Equipo creado con éxito';
		COMMIT;		
    END IF;
END //
DELIMITER ;

-- Los otros datos no se considera si son NULL ya que, por definición de la DB (TP1), pueden ser NULL

CALL AltaEquipo('BB-55-67-BC-78-15', 'TPLink', '9', '8561442228', 'Activo', '218.196.151.30', 2, @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- Se agrega a la tabla Equipos

-- Ingreso NULL como valor de MAC
CALL AltaEquipo(NULL, 'TPLink', '9', '8561442228', 'Activo', '218.196.151.30', 2, @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se agrega a la tabla Equipos

-- Ingreso un valor de MAC repetido
CALL AltaEquipo('26-2D-75-59-61-ED', 'Mikrotik', '6', '1577765229', 'Activo', '115.200.141.31', 3, @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se agrega a la tabla Equipos

-- Ingreso un idTipoEquipo inexistente (No se encuentra en la tabla TipoEquipo)
CALL AltaEquipo('DD-EE-AA-00-77-55', 'TPLink', '4', NULL, 'Activo', NULL, 4, @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se agrega a la tabla Equipos

-- -----------------------------------------------------
-- Modificación de un equipo
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS ModificarEquipo;

DELIMITER //
CREATE PROCEDURE ModificarEquipo(pMAC VARCHAR(30), pMarca VARCHAR(45), pModelo VARCHAR(45), pSerialNumber VARCHAR(45), 
pEstado VARCHAR(45), pIP VARCHAR(45),pidTipoEquipo INT, OUT mensaje VARCHAR(100))
-- Modifica un equipo siempre y cuando sea un tipo de equipo válido.
-- La cláusula LEAVE permite salir del flujo de control que tiene la etiqueta dada
-- Si la etiqueta es para el bloque más externo, se puede salir de todo el procedimiento.
SALIR: BEGIN  
	IF (pMAC IS NULL) OR (pidTipoEquipo IS NULL) THEN
		SET mensaje = 'Error en los datos del equipo';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT MAC FROM Equipos WHERE MAC = pMAC) THEN
		SET mensaje = 'No existe un equipo con esa MAC';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT Tipo FROM TipoEquipo WHERE TipoEquipo.idTipoEquipo = pidTipoEquipo) THEN
		SET mensaje = 'No existe el tipo de equipo elegido';
        LEAVE SALIR;
	ELSE
		START TRANSACTION;
			UPDATE Equipos
				SET Marca = pMarca,  Modelo = pModelo, SerialNumber = pSerialNumber, Estado = pEstado, IP = pIP, idTipoEquipo = pidTipoEquipo
                WHERE MAC = pMAC;
            SET mensaje = 'Equipo modificado con éxito';
		COMMIT;		
    END IF;
END //
DELIMITER ;

-- Lo doy de Baja y cambio el tipo de equipo
CALL ModificarEquipo('BB-55-67-BC-78-15', 'TPLink', '9', '8561442228', 'Baja', '218.196.151.30', 3, @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- Se agrega a la tabla Equipos

-- Ingreso un valor de MAC que no existe
CALL ModificarEquipo('DD-EE-AA-00-77-55', 'TPLink', '4', NULL, 'Activo', NULL, 2, @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se agrega a la tabla Equipos

-- Ingreso NULL como valor de MAC
CALL ModificarEquipo(NULL, 'TPLink', '9', '8561442228', 'Activo', '218.196.151.30', 2, @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se modifica nada en la tabla Equipos

-- Ingreso un idTipoEquipo inexistente (No se encuentra en la tabla TipoEquipo)
CALL ModificarEquipo('26-2D-75-59-61-ED', 'Mikrotik', '6', '1577765229', 'Activo', '115.200.141.31', 5, @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se agrega a la tabla Equipos

-- -----------------------------------------------------
-- Borrado de un equipo
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS BajaEquipo;

DELIMITER //
CREATE PROCEDURE BajaEquipo(pMAC VARCHAR(30), OUT mensaje VARCHAR(100))
-- Borra un equipo siempre y cuando este exista, la MAC elegida no sea NULL y no esté asociado a un cliente/servicio.
-- La cláusula LEAVE permite salir del flujo de control que tiene la etiqueta dada
-- Si la etiqueta es para el bloque más externo, se puede salir de todo el procedimiento.
SALIR: BEGIN  
	IF (pMAC IS NULL) THEN
		SET mensaje = 'Error, MAC elegida NULL';
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT MAC FROM Equipos WHERE MAC = pMAC) THEN -- ¿CÓMO PUEDO HACER EL CONTROL SIN EL NOT?
		SET mensaje = 'No existe un equipo con esa MAC';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT MAC FROM Servicio WHERE Servicio.MAC = pMAC) OR
		   EXISTS (SELECT MAC FROM EquiposCliente WHERE EquiposCliente.MAC = pMAC) THEN
		SET mensaje = 'No se puede borrar un equipo asociado a un servicio o cliente';
        LEAVE SALIR;
	ELSE
		START TRANSACTION;
			DELETE FROM Equipos WHERE MAC = pMAC;
            SET mensaje = 'Equipo borrado con éxito';
		COMMIT;		
    END IF;
END //
DELIMITER ;

-- Pruebo con el valor ingresado anteriormente NO asociado a ningún servicio
CALL BajaEquipo('BB-55-67-BC-78-15', @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- Se borra de la tabla Equipos

-- Ingreso una MAC NULL
CALL BajaEquipo(NULL, @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se borra de la tabla Equipos

-- La MAC ingresada no existe en la BD
CALL BajaEquipo('B8-65-77-AC-78-1A', @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se borra de la tabla Equipos

-- El equipo está asociado a un CLIENTE, por lo que no se puede borrar
CALL BajaEquipo('C2-AF-04-6F-11-31', @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se borra de la tabla Equipos

-- El equipo está asociado a un SERVICIO, por lo que no se puede borrar
CALL BajaEquipo('26-2D-75-59-61-ED', @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Equipos; -- No se borra de la tabla Equipos

-- -----------------------------------------------------
-- Búsqueda de un equipo
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS BuscarEquipo;

DELIMITER //
CREATE PROCEDURE BuscarEquipo(pMAC VARCHAR(30), OUT mensaje VARCHAR(100))
-- Busca un equipo siempre y cuando este exista. Si la MAC es NULL muestra todos los equipos.
-- La cláusula LEAVE permite salir del flujo de control que tiene la etiqueta dada
-- Si la etiqueta es para el bloque más externo, se puede salir de todo el procedimiento.
SALIR: BEGIN  
	IF (pMAC IS NULL OR pMAC = '') THEN
		SET mensaje = 'Se mostraron todos los equipos';
			SELECT * FROM Equipos
			ORDER BY Marca, Modelo;
        LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT MAC FROM Equipos WHERE MAC = pMAC) THEN -- ¿CÓMO PUEDO HACER EL CONTROL SIN EL NOT?
		SET mensaje = 'No existe un equipo con esa MAC';
        LEAVE SALIR;
	ELSE
		SELECT * FROM Equipos
        WHERE MAC = pMAC
		ORDER BY Marca, Modelo;
		SET mensaje = 'Equipo encontrado con éxito';
    END IF;
END //
DELIMITER ;

-- Pruebo una MAC existente
CALL BuscarEquipo('13-CE-4E-A0-8E-81', @resultado); -- funciona
SELECT @resultado;

-- Pruebo la MAC borrada de la consulta anterior (No está en la BD)
CALL BuscarEquipo('BB-55-67-BC-78-15', @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida

-- Ingreso una MAC NULL
CALL BuscarEquipo(NULL, @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida

-- Ingreso una MAC Vacía
CALL BuscarEquipo('', @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida

-- -----------------------------------------------------
-- Listado de equipos ordenado por Marca y Modelo
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS ListarEquipos;

DELIMITER //
CREATE PROCEDURE ListarEquipos()
-- Muestra un listado ordenado por Marca y Modelo de los Equipos registrados.
BEGIN  
	SELECT Marca, Modelo, MAC, SerialNumber AS 'Numero de serie', IP, TipoEquipo.Tipo, Estado
    FROM Equipos JOIN TipoEquipo
    ON Equipos.idTipoEquipo = TipoEquipo.idTipoEquipo
    ORDER BY Marca DESC, Modelo ASC;
END //
DELIMITER ;

CALL ListarEquipos;

-- -----------------------------------------------------
-- Dado un rango de fechas, mostrar día a día el total
-- de servicios realizados. El formato deberá ser: 
-- fecha, total de servicios
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS MostrarTotalServicios;

DELIMITER //
CREATE PROCEDURE MostrarTotalServicios(pFechaInicio DATE, pFechaFin DATE, OUT mensaje VARCHAR(100))
-- Muestra el total de servicios realizados en el rango de fechas
-- Si la FechaFin es NULL muestra todos los servicios desde la FechaInicio
-- Si la FechaInicio es NULL muestra todos los servicios HASTA la FechaFin
-- Si ambas son NULL muestra TODOS los servicios registrados
-- Si la FechaFin es mayor que fecha de inicio las intercambia
-- La cláusula LEAVE permite salir del flujo de control que tiene la etiqueta dada
-- Si la etiqueta es para el bloque más externo, se puede salir de todo el procedimiento.
SALIR: BEGIN  
	DECLARE fechaAux DATE;
	IF (pFechaInicio IS NULL) AND (pFechaFin IS NULL) THEN
		SET mensaje = 'Se mostraron todos los servicios registrados';
			SELECT FechaInicio as 'Fecha', count(idServicios) as 'Total de Servicios'
			FROM Servicio
			GROUP BY FechaInicio
			ORDER BY FechaInicio DESC;
        LEAVE SALIR;
	ELSEIF (pFechaFin IS NULL) THEN
		SET mensaje = 'Se mostraron todos los servicios desde la FechaInicio';
			SELECT FechaInicio as 'Fecha', count(idServicios) as 'Total de Servicios'
			FROM Servicio
			WHERE FechaInicio >= pFechaInicio
			GROUP BY FechaInicio
			ORDER BY FechaInicio DESC;
        LEAVE SALIR;
	ELSEIF (pFechaInicio IS NULL) THEN
		SET mensaje = 'Se mostraron todos los servicios hasta la FechaFin';
			SELECT FechaInicio as 'Fecha', count(idServicios) as 'Total de Servicios'
			FROM Servicio
			WHERE FechaInicio <= pFechaFin
			GROUP BY FechaInicio
			ORDER BY FechaInicio DESC;
        LEAVE SALIR;
	ELSE
		IF pFechaInicio > pFechaFin THEN -- se invierten las fechas
			SET fechaAux = pFechaInicio;
			SET pFechaInicio = pFechaFin;
			SET pFechaFin = fechaAux;
		END IF;
		SELECT FechaInicio as 'Fecha', count(idServicios) as 'Total de Servicios'
		FROM Servicio
		WHERE FechaInicio BETWEEN pFechaInicio AND pFechaFin
		GROUP BY FechaInicio
		ORDER BY FechaInicio DESC;
		SET mensaje = 'Se mostraron las fechas en el rango especificado';
    END IF;
END //
DELIMITER ;

-- Ingreso un intervalo normal de fechas
CALL MostrarTotalServicios('2022-01-10','2022-04-05', @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida

-- Ingreso el mismo intervalo invertido
CALL MostrarTotalServicios('2022-04-05','2022-01-10', @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida

-- Ingreso sólo una fecha de Inicio
CALL MostrarTotalServicios('2022-03-02',NULL, @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida

-- Ingreso sólo una fecha de Fin
CALL MostrarTotalServicios(NULL,'2022-03-02', @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida

-- Ingreso ambas fechas NULL
CALL MostrarTotalServicios(NULL,NULL, @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida

-- -----------------------------------------------------
-- Funcionalidad de interés
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS MostrarClientesColor;

DELIMITER //
CREATE PROCEDURE MostrarClientesColor(color VARCHAR(50), OUT mensaje VARCHAR(100))
-- Mostrar tdoos los clientes que estén en un mismo color de pelo de fibra
-- Se muestra DNI, nombre y apellido del cliente, y tambien el color de pelo de fibra al que pertenecen
-- Si el color no existe, devuelve el mensaje de error
SALIR: BEGIN
	DECLARE Resultset VARCHAR(100);
	IF (color IS NULL OR color = "") THEN
		SET mensaje = "El color no puede estar vacío";
		LEAVE SALIR;
	ELSEIF NOT EXISTS (SELECT ColorFibra FROM EquiposCliente WHERE EquiposCliente.ColorFibra = color) THEN
		SET mensaje = "No existe el color de pelo solicitado";
        LEAVE SALIR;
	ELSE
		SELECT EquiposCliente.Dni_C AS Dni, Persona.Apellido, Persona.Nombre, EquiposCliente.ColorFibra AS 'Color de Fibra' FROM 
		Persona INNER JOIN Clientes ON Persona.Dni = Clientes.Dni
				INNER JOIN EquiposCliente ON EquiposCliente.Dni_C = Clientes.Dni 
				WHERE EquiposCliente.ColorFibra = color
                GROUP BY EquiposCliente.Dni_C, Persona.Apellido, Persona.Nombre, EquiposCliente.ColorFibra;
		SET mensaje = "Se mostraron todos los clientes del color de fibra seleccionado";
	END IF;
END //
DELIMITER ;

-- Ingreso un color que si existe
CALL MostrarClientesColor("Naranja",@resultado);
SELECT @resultado; -- funciona y muestra el mensaje

-- Ingreso un color que no existe
CALL MostrarClientesColor("Blanco",@resultado);
SELECT @resultado; -- muestra el mensaje de color inexistente

-- Ingreso en el campo color el valor NULL
CALL MostrarClientesColor(NULL,@resultado);
SELECT @resultado; -- muestra que el campo no puede estar vacio o ser null

-- Dejo vacio el campo color
CALL MostrarClientesColor("",@resultado);
SELECT @resultado; -- muestra que el campo no puede estar vacio o ser null

-- -----------------------------------------------------
-- Corroboramos el funcionamiento del Trigger
-- con los Stored Procedures
-- -----------------------------------------------------

SELECT * FROM AuditoriaEquipos;