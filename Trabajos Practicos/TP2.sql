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

-- Correr primero el Script corregido del TPNº1

-- -----------------------------------------------------
-- Consulta Nº1
-- -----------------------------------------------------

-- Listar equipos de un cliente

SELECT Persona.Apellido, Persona.Nombre, Persona.Dni, Equipos.MAC, Equipos.Marca, Equipos.Modelo
FROM Persona JOIN Clientes
ON Persona.Dni = Clientes.Dni
JOIN EquiposCliente
ON Clientes.Dni = EquiposCliente.Dni_C
JOIN Equipos
ON EquiposCliente.MAC = Equipos.MAC
WHERE (Persona.Apellido = 'Rhubottom') AND (Persona.Nombre = 'Olag')
ORDER BY Equipos.MAC;

-- Supongo el cliente Olag Rhubottom

-- -----------------------------------------------------
-- Consulta Nº2
-- -----------------------------------------------------

-- Listado de Equipos agrupados por tipo
SELECT TipoEquipo.Tipo, Equipos.Marca, Equipos.Modelo
FROM Equipos JOIN TipoEquipo
ON Equipos.idTipoEquipo = TipoEquipo.idTipoEquipo
GROUP BY TipoEquipo.Tipo, Equipos.Marca, Equipos.Modelo
ORDER BY TipoEquipo.Tipo ASC, Equipos.Marca ASC, Equipos.Modelo ASC;

-- -----------------------------------------------------
-- Consulta Nº3
-- -----------------------------------------------------

-- Listado de servicios
SELECT Servicio.idServicios as 'ID de Servicio' , Servicio.FechaInicio as 'Fecha de Inicio',
Servicio.FechaFin as 'Fecha de Fin', Persona.Apellido as 'Apellido', Persona.Nombre as 'Nombre',
Persona.Dni as 'DNI Cliente', Equipos.MAC as 'MAC del equipo', Equipos.Marca, Equipos.Modelo, 
TipoEquipo.Tipo as 'Tipo de Equipo', EquiposCliente.ColorFibra as 'Color de Fibra', EquiposCliente.NumPON as 'Numero PON',
TipoServicios.Tipo as 'Tipo de Servicio'
FROM Servicio JOIN Clientes
ON Servicio.Dni = Clientes.Dni
JOIN TipoServicios
ON Servicio.idTipoServicios = TipoServicios.idTipoServicios
JOIN Persona
ON Clientes.Dni = Persona.Dni
JOIN Equipos
ON Servicio.MAC = Equipos.MAC
JOIN TipoEquipo
ON Equipos.idTipoEquipo = TipoEquipo.idTipoEquipo
JOIN EquiposCliente
ON EquiposCliente.MAC = Equipos.MAC
ORDER BY FechaInicio DESC, Servicio.idServicios ASC;

-- Cambio de Enunciado: también debe mostrar color de fibra y numPON para usar en el punto 9), modifica el punto 8) también
-- Se agregó el Tipo de Servicio para mostrar que a un mismo cliente, con una misma MAC se le pueden realizar más de
-- un servicio diferente.

-- -----------------------------------------------------
-- Consulta Nº4
-- -----------------------------------------------------

-- Mostrar total de servicios por día
SELECT FechaInicio as 'Fecha', count(idServicios) as 'Total de Servicios'
FROM Servicio
WHERE FechaInicio BETWEEN '2020-12-08' AND '2022-05-15'
GROUP BY FechaInicio
ORDER BY FechaInicio DESC;

-- Considero las fechas entre el '2020-12-08' y '2022-05-15'
-- No se muestran los días que tienen 0 servicios realizados ya que no
-- hay persistencia en la BD de esos días

-- -----------------------------------------------------
-- Consulta Nº5
-- -----------------------------------------------------

-- Ranking de personas que realizaron más servicios
SELECT Persona.Apellido, Persona.Nombre, count(Servicio.idServicios) as 'Total de Servicios'
FROM Persona JOIN Personal
ON Persona.Dni = Personal.DNI
JOIN PersonalServicio
ON Personal.Dni = PersonalServicio.Dni_P
JOIN Servicio
ON PersonalServicio.idServicios = Servicio.idServicios
GROUP BY Persona.Apellido, Persona.Nombre
ORDER BY count(Servicio.idServicios) DESC
LIMIT 10;

-- Nota: varias personas pueden trabajar en el mismo servicio.

-- -----------------------------------------------------
-- Consulta Nº6
-- -----------------------------------------------------

-- Equipos a los que se le realizaron más servicios
SELECT Equipos.MAC, Equipos.Marca, Equipos.Modelo, count(Servicio.idServicios) AS 'Total de servicios' 
FROM Equipos JOIN Servicio 
ON Equipos.MAC = Servicio.MAC
GROUP BY Equipos.MAC, Equipos.Marca, Equipos.Modelo
ORDER BY count(Servicio.idServicios) DESC
LIMIT 10;

-- -----------------------------------------------------
-- Consulta Nº7
-- -----------------------------------------------------

-- Ranking de tipos de servicios más realizados
SELECT TipoServicios.Tipo, count(Servicio.idServicios) as 'Total de Servicios'
FROM Servicio JOIN TipoServicios
ON Servicio.idTipoServicios = TipoServicios.idTipoServicios
GROUP BY TipoServicios.Tipo
ORDER BY count(Servicio.idServicios) DESC, TipoServicios.Tipo ASC
LIMIT 10;

-- -----------------------------------------------------
-- Consulta Nº8
-- -----------------------------------------------------

-- Vista que lista los servicios de usuarios
DROP VIEW IF EXISTS V_ServiciosUsuarios;

CREATE VIEW V_ServiciosUsuarios (ID, FechaInicio, FechaFin, Apellido, Nombre, DNI, MAC, Marca, Modelo, Tipo, ColorFibra, NumPON, TipoServicio) 
AS 
	SELECT Servicio.idServicios as 'ID de Servicio' , Servicio.FechaInicio as 'Fecha de Inicio',
	Servicio.FechaFin as 'Fecha de Fin', Persona.Apellido as 'Apellido', Persona.Nombre as 'Nombre',
	Persona.Dni as 'DNI Cliente', Equipos.MAC as 'MAC del equipo', Equipos.Marca, Equipos.Modelo, 
	TipoEquipo.Tipo as 'Tipo de Equipo', EquiposCliente.ColorFibra as 'Color de Fibra', EquiposCliente.NumPON as 'Numero PON',
	TipoServicios.Tipo as 'Tipo de Servicio'
	FROM Servicio JOIN Clientes
	ON Servicio.Dni = Clientes.Dni
	JOIN TipoServicios
	ON Servicio.idTipoServicios = TipoServicios.idTipoServicios
	JOIN Persona
	ON Clientes.Dni = Persona.Dni
	JOIN Equipos
	ON Servicio.MAC = Equipos.MAC
	JOIN TipoEquipo
	ON Equipos.idTipoEquipo = TipoEquipo.idTipoEquipo
	JOIN EquiposCliente
	ON EquiposCliente.MAC = Equipos.MAC
	ORDER BY FechaInicio DESC, Servicio.idServicios ASC;

SELECT * FROM V_ServiciosUsuarios;

-- -----------------------------------------------------
-- Consulta Nº9
-- Crear una copia de la tabla Equipos, llamada EquiposJSON, que tenga una columna del
-- tipo JSON para guardar los equipos del cliente. Llenar esta tabla con los mismos datos del
-- TP1 y resolver la consulta del apartado 3.
-- Consulta Nº3
-- Realizar un listado de servicios: id, fechas de inicio y fin, apellido, nombre y dni del
-- cliente, MAC, marca, modelo, color de fibra, num de pon y nombre del tipo de equipo. Ordenar por la fecha de inicio del
-- servicio en forma descendente.

-- -----------------------------------------------------

-- Table `LBD2022`.`EquiposJSON`
DROP TABLE IF EXISTS `LBD2022G14`.`EquiposJSON`; 

CREATE TABLE IF NOT EXISTS `LBD2022G14`.`EquiposJSON` (
  `MAC` VARCHAR(30) NOT NULL,
  `Marca` VARCHAR(45) NULL,
  `Modelo` VARCHAR(45) NULL,
  `SerialNumber` VARCHAR(45) NULL,
  `Estado` VARCHAR(45) NULL,
  `IP` VARCHAR(45) NULL,
  `idTipoEquipo` INT NOT NULL,
  `EquiposCliente` JSON NOT NULL,
  PRIMARY KEY (`MAC`),
  INDEX `fk_Equipos_TipoEquipo_idx` (`idTipoEquipo` ASC) VISIBLE,
  CONSTRAINT `fk_Equipos_TipoEquipo`
    FOREIGN KEY (`idTipoEquipo`)
    REFERENCES `LBD2022G14`.`TipoEquipo` (`idTipoEquipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Agrego los datos a la tabla:

insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('CB-44-57-CB-38-10', 'TPLink', '1', '5130440005', 'Activo', '200.197.155.18', 1
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958090'),
		JSON_OBJECT('ColorFibra', 'Azul'),
        JSON_OBJECT('NombreTroncal', 'T1'),
        JSON_OBJECT('NumONU', '2'),
        JSON_OBJECT('NumPON', '3')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('CA-32-C7-9E-EE-EF', 'TPLink', '2', '7193331795', 'Activo', '24.27.253.189', 2
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958090'),
		JSON_OBJECT('ColorFibra', 'Azul'),
        JSON_OBJECT('NombreTroncal', 'T1'),
        JSON_OBJECT('NumONU', '3'),
        JSON_OBJECT('NumPON', '3')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('40-36-15-BF-FE-CB', 'TPLink', '3', '2801336254', 'Activo', '202.210.198.105', 2
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958091'),
		JSON_OBJECT('ColorFibra', 'Verde'),
        JSON_OBJECT('NombreTroncal', 'T2'),
        JSON_OBJECT('NumONU', '1'),
        JSON_OBJECT('NumPON', '2')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('A4-BD-39-47-A2-5F', 'TPLink', '4', '2709899140', 'Activo', '80.167.42.217', 2
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958090'),
		JSON_OBJECT('ColorFibra', 'Azul'),
        JSON_OBJECT('NombreTroncal', 'T1'),
        JSON_OBJECT('NumONU', '4'),
        JSON_OBJECT('NumPON', '3')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('16-47-54-35-A7-AD', 'TPLink', '5', '2527276083', 'Activo', '173.216.1.64', 1
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', ''),
		JSON_OBJECT('ColorFibra', ''),
        JSON_OBJECT('NombreTroncal', ''),
        JSON_OBJECT('NumONU', ''),
        JSON_OBJECT('NumPON', '')
	)
);
-- Está registrado en el sistema pero no está asociado a ningún cliente, por eso el JSON está vacío.
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('49-F8-30-80-90-E6', 'TPLink', '6', '4984036346', 'Activo', '194.224.107.30', 2
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958095'),
		JSON_OBJECT('ColorFibra', 'Naranja'),
        JSON_OBJECT('NombreTroncal', 'T4'),
        JSON_OBJECT('NumONU', '6'),
        JSON_OBJECT('NumPON', '8')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('57-E2-E2-39-C9-1E', 'TPLink', '6', '1683756169', 'Activo', '102.232.68.146', 2
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958091'),
		JSON_OBJECT('ColorFibra', 'Verde'),
        JSON_OBJECT('NombreTroncal', 'T2'),
        JSON_OBJECT('NumONU', '2'),
        JSON_OBJECT('NumPON', '2')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('C2-AF-04-6F-11-31', 'TPLink', '7', '7978228150', 'Activo', '83.116.33.80', 1
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958090'),
		JSON_OBJECT('ColorFibra', 'Azul'),
        JSON_OBJECT('NombreTroncal', 'T1'),
        JSON_OBJECT('NumONU', '5'),
        JSON_OBJECT('NumPON', '3')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('26-2D-75-59-61-ED', 'TPLink', '8', '3840166837', 'Activo', '30.90.86.112', 1
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958092'),
		JSON_OBJECT('ColorFibra', 'Amarillo'),
        JSON_OBJECT('NombreTroncal', 'T3'),
        JSON_OBJECT('NumONU', '4'),
        JSON_OBJECT('NumPON', '9')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('66-86-BC-4E-D4-DF', 'GLC', '1', '8787043416', 'Activo', '115.112.139.41', 3
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958093'),
		JSON_OBJECT('ColorFibra', 'Amarillo'),
        JSON_OBJECT('NombreTroncal', 'T3'),
        JSON_OBJECT('NumONU', '6'),
        JSON_OBJECT('NumPON', '9')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('13-CE-4E-A0-8E-81', 'GLC', '2', '2933515016', 'Activo', '62.182.107.154', 3
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958099'),
		JSON_OBJECT('ColorFibra', 'Rojo'),
        JSON_OBJECT('NombreTroncal', 'T6'),
        JSON_OBJECT('NumONU', '11'),
        JSON_OBJECT('NumPON', '11')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('ED-89-8A-4C-6A-52', 'GLC', '3', '3913688080', 'Activo', '75.175.101.198', 2
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958094'),
		JSON_OBJECT('ColorFibra', 'Gris'),
        JSON_OBJECT('NombreTroncal', 'T3'),
        JSON_OBJECT('NumONU', '6'),
        JSON_OBJECT('NumPON', '4')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('DE-0D-8A-AD-FF-CA', 'GLC', '4', '5552492609', 'Activo', '14.43.189.126', 3
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958097'),
		JSON_OBJECT('ColorFibra', 'Rosa'),
        JSON_OBJECT('NombreTroncal', 'T6'),
        JSON_OBJECT('NumONU', '10'),
        JSON_OBJECT('NumPON', '11')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('36-F2-18-EE-AE-EB', 'GLC', '5', '4046307404', 'Activo', '76.102.110.2', 2
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958096'),
		JSON_OBJECT('ColorFibra', 'Naranja'),
        JSON_OBJECT('NombreTroncal', 'T5'),
        JSON_OBJECT('NumONU', '9'),
        JSON_OBJECT('NumPON', '10')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('0B-24-D7-31-08-E7', 'GLC', '6', '1548986402', 'Activo', '96.133.216.162', 1
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958095'),
		JSON_OBJECT('ColorFibra', 'Naranja'),
        JSON_OBJECT('NombreTroncal', 'T4'),
        JSON_OBJECT('NumONU', '7'),
        JSON_OBJECT('NumPON', '8')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('0A-CA-45-B8-C6-D1', 'Mikrotik', '1', '1695141377', 'Activo', '147.216.97.137', 3
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958094'),
		JSON_OBJECT('ColorFibra', 'Gris'),
        JSON_OBJECT('NombreTroncal', 'T3'),
        JSON_OBJECT('NumONU', '7'),
        JSON_OBJECT('NumPON', '4')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('8A-3A-CE-FE-15-B2', 'Mikrotik', '2', '8137204520', 'Activo', '133.25.152.219', 3
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958096'),
		JSON_OBJECT('ColorFibra', 'Naranja'),
        JSON_OBJECT('NombreTroncal', 'T5'),
        JSON_OBJECT('NumONU', '8'),
        JSON_OBJECT('NumPON', '10')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('7E-CF-DA-52-D5-E2', 'Mikrotik', '3', '3069666361', 'Activo', '106.114.211.244', 3
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958094'),
		JSON_OBJECT('ColorFibra', 'Gris'),
        JSON_OBJECT('NombreTroncal', 'T3'),
        JSON_OBJECT('NumONU', '5'),
        JSON_OBJECT('NumPON', '4')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('41-41-A2-B0-62-00', 'Mikrotik', '4', '5702738195', 'Activo', '163.206.111.249', 3
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958096'),
		JSON_OBJECT('ColorFibra', 'Naranja'),
        JSON_OBJECT('NombreTroncal', 'T5'),
        JSON_OBJECT('NumONU', '7'),
        JSON_OBJECT('NumPON', '10')
	)
);
insert into EquiposJSON (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo, EquiposCliente) values ('76-53-DA-C9-21-AA', 'Mikrotik', '5', '3731716062', 'Activo', '152.94.138.205', 2
,JSON_MERGE_PRESERVE(
		JSON_OBJECT('Dni_C', '37958093'),
		JSON_OBJECT('ColorFibra', 'Amarillo'),
        JSON_OBJECT('NombreTroncal', 'T3'),
        JSON_OBJECT('NumONU', '5'),
        JSON_OBJECT('NumPON', '9')
	)
);

-- Listado de servicios con operador ->>
SELECT Servicio.idServicios as 'ID de Servicio' , Servicio.FechaInicio as 'Fecha de Inicio',
Servicio.FechaFin as 'Fecha de Fin', Persona.Apellido as 'Apellido', Persona.Nombre as 'Nombre',
Persona.Dni as 'DNI Cliente', EquiposJSON.MAC as 'MAC del equipo', EquiposJSON.Marca, EquiposJSON.Modelo, 
TipoEquipo.Tipo as 'Tipo de Equipo', 
EquiposJSON.EquiposCliente->>'$.ColorFibra' as 'Color de Fibra', EquiposJSON.EquiposCliente->>'$.NumPON' as 'Numero PON',
TipoServicios.Tipo as 'Tipo de Servicio'
FROM Servicio JOIN Clientes
ON Servicio.Dni = Clientes.Dni
JOIN TipoServicios
ON Servicio.idTipoServicios = TipoServicios.idTipoServicios
JOIN Persona
ON Clientes.Dni = Persona.Dni
JOIN EquiposJSON
ON Servicio.MAC = EquiposJSON.MAC
JOIN TipoEquipo
ON EquiposJSON.idTipoEquipo = TipoEquipo.idTipoEquipo
ORDER BY FechaInicio DESC, Servicio.idServicios ASC;

-- -----------------------------------------------------
-- Consulta Nº10
-- -----------------------------------------------------

-- Muestre una vista que contenga los datos de todos los clientes que tenga registrado en su sistema
-- Así como el total de servicios recibidos por cada persona en su domicilio

-- Vista Usuarios
DROP VIEW IF EXISTS V_Usuarios;

CREATE VIEW V_Usuarios (Dni, Apellido, Nombre, Mail, Telefono, Provincia, Localidad, Calle, Numero, TotalServicios) 
AS 
	SELECT Persona.Dni, Persona.Apellido, Persona.Nombre, Persona.Email, Persona.Telefono,
    Domicilio.Provincia, Domicilio.Localidad, Domicilio.Calle,Domicilio.Numero, count(idServicios)
	FROM Persona JOIN Domicilio
    ON Persona.Dni = Domicilio.Dni
    JOIN Clientes
    ON Persona.Dni = Clientes.Dni
    JOIN Servicio
    ON Clientes.Dni = Servicio.Dni
    GROUP BY Persona.Dni, Persona.Apellido, Persona.Nombre, Persona.Email, Persona.Telefono,
    Domicilio.Provincia, Domicilio.Localidad, Domicilio.Calle,Domicilio.Numero
	ORDER BY Apellido ASC, Nombre ASC;

SELECT * FROM V_Usuarios;

-- 