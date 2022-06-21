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

-- -------------------------------------------------------------------------------------------------
-- Se agregó como corrección del TP1 el agregado de un UNIQUE INDEX para la tabla EquiposClientes
-- que utiliza NumONU y NumPON
-- Además, se agregaron varios datos necesarios para poder correr y mostrar de forma correcta
-- las consultas del TPNº2
-- -------------------------------------------------------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LBD2022G14
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LBD2022G14`;
CREATE SCHEMA IF NOT EXISTS `LBD2022G14` DEFAULT CHARACTER SET utf8 ;
USE `LBD2022G14` ;

-- -----------------------------------------------------
-- Table `LBD2022`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`Persona` (
  `Dni` INT NOT NULL,
  `Nombre` VARCHAR(100) NULL,
  `Apellido` VARCHAR(60) NULL,
  `Estado` TINYINT NULL DEFAULT 1,
  `Email` VARCHAR(45) NULL,
  `Telefono` VARCHAR(45) NULL,
  PRIMARY KEY (`Dni`),
  INDEX `PersonaIndex` (`Dni` ASC, `Nombre` ASC, `Apellido` ASC) INVISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`Domicilio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`Domicilio` (
  `Dni` INT NOT NULL,
  `Provincia` VARCHAR(50) NULL,
  `Departamento` VARCHAR(50) NULL,
  `Localidad` VARCHAR(50) NULL,
  `Barrio` VARCHAR(50) NULL,
  `Calle` VARCHAR(50) NULL,
  `Numero` INT NULL,
  PRIMARY KEY (`Dni`),
  CONSTRAINT `fk_Domicilio_Personal`
    FOREIGN KEY (`Dni`)
    REFERENCES `LBD2022G14`.`Persona` (`Dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


ALTER TABLE `LBD2022G14`.`Domicilio`
ADD CHECK (Numero>0);
-- -----------------------------------------------------
-- Table `LBD2022`.`TipoPersonal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`TipoPersonal` (
  `idTipoPersonal` INT NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTipoPersonal`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`Personal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`Personal` (
  `Dni` INT NOT NULL,
  `idTipoPersonal` INT NOT NULL,
  PRIMARY KEY (`Dni`),
  INDEX `fk_Personal_TipoPersonal1_idx` (`idTipoPersonal` ASC) VISIBLE,
  CONSTRAINT `fk_Personal_Personal1`
    FOREIGN KEY (`Dni`)
    REFERENCES `LBD2022G14`.`Persona` (`Dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personal_TipoPersonal1`
    FOREIGN KEY (`idTipoPersonal`)
    REFERENCES `LBD2022G14`.`TipoPersonal` (`idTipoPersonal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`Clientes` (
  `Dni` INT NOT NULL,
  PRIMARY KEY (`Dni`),
  CONSTRAINT `fk_Clientes_Personal1`
    FOREIGN KEY (`Dni`)
    REFERENCES `LBD2022G14`.`Persona` (`Dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`TipoServicios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`TipoServicios` (
  `idTipoServicios` INT NOT NULL,
  `Tipo` VARCHAR(45) NULL,
  `Estado` VARCHAR(45) NULL DEFAULT 'Activo',
  PRIMARY KEY (`idTipoServicios`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`TipoEquipo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`TipoEquipo` (
  `idTipoEquipo` INT NOT NULL,
  `Tipo` VARCHAR(45) NULL,
  PRIMARY KEY (`idTipoEquipo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`Equipos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`Equipos` (
  `MAC` VARCHAR(30) NOT NULL,
  `Marca` VARCHAR(45) NULL,
  `Modelo` VARCHAR(45) NULL,
  `SerialNumber` VARCHAR(45) NULL,
  `Estado` VARCHAR(45) NULL,
  `IP` VARCHAR(45) NULL,
  `idTipoEquipo` INT NOT NULL,
  PRIMARY KEY (`MAC`),
  INDEX `fk_Equipos_TipoEquipo1_idx` (`idTipoEquipo` ASC) VISIBLE,
  CONSTRAINT `fk_Equipos_TipoEquipo1`
    FOREIGN KEY (`idTipoEquipo`)
    REFERENCES `LBD2022G14`.`TipoEquipo` (`idTipoEquipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`Servicio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`Servicio` (
  `idServicios` INT NOT NULL,
  `Dni` INT NOT NULL,
  `idTipoServicios` INT NOT NULL,
  `MAC` VARCHAR(30) NOT NULL,
  `Estado` VARCHAR(30) NULL,
  `FechaInicio` DATE NULL,
  `FechaFin` DATE NULL,
  INDEX `fk_Servicio_Clientes1_idx` (`Dni` ASC) VISIBLE,
  INDEX `fk_Servicio_TipoServicios1_idx` (`idTipoServicios` ASC) VISIBLE,
  PRIMARY KEY (`idServicios`),
  INDEX `fk_Servicio_Equipos1_idx` (`MAC` ASC) VISIBLE,
  CONSTRAINT `fk_Servicio_Clientes1`
    FOREIGN KEY (`Dni`)
    REFERENCES `LBD2022G14`.`Clientes` (`Dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servicio_TipoServicios1`
    FOREIGN KEY (`idTipoServicios`)
    REFERENCES `LBD2022G14`.`TipoServicios` (`idTipoServicios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servicio_Equipos1`
    FOREIGN KEY (`MAC`)
    REFERENCES `LBD2022G14`.`Equipos` (`MAC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`PersonalServicio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`PersonalServicio` (
  `Dni_P` INT NOT NULL,
  `Dni_C` INT NOT NULL,
  `idServicios` INT NOT NULL,
  PRIMARY KEY (`Dni_P`, `Dni_C`, `idServicios`),
  INDEX `fk_Personal_has_Clientes_Clientes1_idx` (`Dni_C` ASC) VISIBLE,
  INDEX `fk_Personal_has_Clientes_Personal1_idx` (`Dni_P` ASC) VISIBLE,
  INDEX `fk_PersonalServicio_Servicio1_idx` (`idServicios` ASC) VISIBLE,
  CONSTRAINT `fk_Personal_has_Clientes_Personal1`
    FOREIGN KEY (`Dni_P`)
    REFERENCES `LBD2022G14`.`Personal` (`Dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personal_has_Clientes_Clientes1`
    FOREIGN KEY (`Dni_C`)
    REFERENCES `LBD2022G14`.`Clientes` (`Dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PersonalServicio_Servicio1`
    FOREIGN KEY (`idServicios`)
    REFERENCES `LBD2022G14`.`Servicio` (`idServicios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2022`.`EquiposCliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2022G14`.`EquiposCliente` (
  `Dni_C` INT NOT NULL,
  `MAC` VARCHAR(30) NOT NULL,
  `ColorFibra` VARCHAR(45) NULL,
  `NombreTroncal` VARCHAR(45) NULL,
  `NumONU` INT NULL,
  `NumPON` INT NULL,
  PRIMARY KEY (`Dni_C`, `MAC`),
  INDEX `fk_Clientes_has_Equipos_Equipos1_idx` (`MAC` ASC) VISIBLE,
  INDEX `fk_Clientes_has_Equipos_Clientes1_idx` (`Dni_C` ASC) VISIBLE,
  UNIQUE INDEX `NumONU_PON` (`NumONU`,`NumPON` ASC) VISIBLE,
  CONSTRAINT `fk_Clientes_has_Equipos_Clientes1`
    FOREIGN KEY (`Dni_C`)
    REFERENCES `LBD2022G14`.`Clientes` (`Dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Clientes_has_Equipos_Equipos1`
    FOREIGN KEY (`MAC`)
    REFERENCES `LBD2022G14`.`Equipos` (`MAC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

##Crear Personas
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958090', 'Olag', 'Rhubottom', 1, 'orhubottom0@google.co.uk', '(904) 5162908');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958091', 'Wilburt', 'Oddie', 1, 'woddie1@businesswire.com', '(952) 2309061');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958092', 'Linn', 'Cassidy', 1, 'lcassidy2@surveymonkey.com', '(852) 8176695');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958093', 'Robb', 'Osmant', 1, 'rosmant3@businessweek.com', '(560) 9204098');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958094', 'Dal', 'MacRinn', 0, 'dmacrinn4@usatoday.com', '(419) 3682522');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958095', 'Tye', 'Viscovi', 0, 'tviscovi5@networksolutions.com', '(593) 9072116');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958096', 'Ronny', 'Wasling', 0, 'rwasling6@oaic.gov.au', '(729) 4955119');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958097', 'Rickie', 'Dunbavin', 0, 'rdunbavin7@webmd.com', '(891) 4575897');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958098', 'Marty', 'Shirtliff', 0, 'mshirtliff8@addtoany.com', '(404) 5700607');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958099', 'Kylynn', 'Swinglehurst', 0, 'kswinglehurst9@fda.gov', '(152) 6374934');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958070', 'Becki', 'Leyden', 1, 'bleydena@purevolume.com', '(434) 4430450');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958071', 'Rodi', 'Claussen', 1, 'rclaussenb@cdbaby.com', '(443) 7601948');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958072', 'Connie', 'Wayne', 0, 'cwaynec@lulu.com', '(853) 8623148');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958073', 'Carla', 'Phalip', 0, 'cphalipd@ca.gov', '(488) 9120569');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958074', 'Neile', 'Pavlovic', 0, 'npavlovice@technorati.com', '(584) 1302319');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958075', 'Winnah', 'Drain', 1, 'wdrainf@plala.or.jp', '(979) 4141852');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958076', 'Beaufort', 'Smetoun', 1, 'bsmetoung@noaa.gov', '(215) 9256345');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958077', 'Honey', 'Mullenger', 0, 'hmullengerh@oaic.gov.au', '(587) 5754027');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958078', 'Marty', 'Scarf', 0, 'mscarfi@mediafire.com', '(113) 9530745');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958079', 'Ricardo', 'Feron', 1, 'rferonj@comcast.net', '(317) 5259963');

insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958080', 'Martin', 'Fierro', 1, 'mfierro@gmail.com', '(317) 5259963');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958081', 'Matias', 'Mendez', 1, 'mmendez@live.com.ar', '(917) 1234567');
insert into Persona (Dni, Nombre, Apellido, Estado, Email, Telefono) values ('37958082', 'Facundo', 'Ramirez', 1, 'framirez@hotmail.com', '(322) 8883716');

#select * from persona;

##Agrego domicilios
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958090','Tucuman', 'Burruyacu', 'Garmendia', 'Barrio1', 'Esch', 62);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958091','Tucuman', 'Chicligasta', 'Arcadia', 'Barrio2', 'Bluestem', 718);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958092','Tucuman', 'Burruyacu', 'Garmendia', 'Barrio3', 'Warner', 83);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958093','Tucuman', 'Burruyacu', 'Garmendia', 'Barrio4', 'Pennsylvania', 355);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958094','Tucuman', 'Cruz Alta', 'Alderetes', 'Barrio5', 'Rowland', 577);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958095','Tucuman', 'Famailla', 'Famailla', 'Barrio6', 'Scott', 158);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958096','Tucuman', 'Monteros', 'Acheral', 'Barrio7', 'Hauk', 767);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958097','Tucuman', 'Chicligasta', 'Arcadia', 'Barrio1', 'Warner', 690);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958098','Tucuman', 'Chicligasta', 'Arcadia', 'Barrio2', 'Maryland', 438);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958099','Tucuman', 'Graneros', 'Lamadrid', 'Barrio3', 'Brentwood', 174);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958070','Tucuman', 'Graneros', 'Lamadrid', 'Barrio4', 'Glendale', 30);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958071','Tucuman', 'Graneros', 'Lamadrid', 'Barrio5', 'Huxley', 20);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958072','Tucuman', 'Graneros', 'Lamadrid', 'Barrio6', 'Cordelia', 642);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958073','Tucuman', 'Famailla', 'Famailla', 'Barrio7', 'Bartelt', 561);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958074','Tucuman', 'La Cocha', 'La Cocha', 'Barrio1', 'Hauk', 618);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958075','Tucuman', 'La Cocha', 'La Cocha', 'Barrio2', 'Loftsgordon', 706);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958076','Tucuman', 'Leales', 'Bella Vista', 'Barrio3', 'Shasta', 372);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958077','Tucuman', 'Lules', 'El Manantial', 'Barrio4', 'Spohn', 128);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958078','Tucuman', 'Monteros', 'Acheral', 'Barrio5', 'Bluejay', 768);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958079','Tucuman', 'Monteros', 'Acheral', 'Barrio6', 'Nelson', 5);

insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958080','Tucuman', 'Monteros', 'Acheral', 'Barrio7', 'Primera', 566);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958081','Tucuman', 'Chicligasta', 'Arcadia', 'Barrio3', 'Principal',123);
insert into Domicilio (Dni,Provincia, Departamento, Localidad, Barrio, Calle, Numero) values ('37958082','Tucuman', 'Lules', 'El Manantial', 'Barrio5', 'S/C', 1);

#select * from domicilio;

##Creo los tipos de equipo
insert into TipoEquipo (idTipoEquipo, Tipo) values (1, 'ONU');
insert into TipoEquipo (idTipoEquipo, Tipo) values (2, 'Switch');
insert into TipoEquipo (idTipoEquipo, Tipo) values (3, 'Router');

#select * from tipoequipo;

##Creo los equipos
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('CB-44-57-CB-38-10', 'TPLink', '1', '5130440005', 'Activo', '200.197.155.18', 1);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('CA-32-C7-9E-EE-EF', 'TPLink', '2', '7193331795', 'Activo', '24.27.253.189', 2);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('40-36-15-BF-FE-CB', 'TPLink', '3', '2801336254', 'Activo', '202.210.198.105', 2);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('A4-BD-39-47-A2-5F', 'TPLink', '4', '2709899140', 'Activo', '80.167.42.217', 2);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('16-47-54-35-A7-AD', 'TPLink', '5', '2527276083', 'Activo', '173.216.1.64', 1);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('49-F8-30-80-90-E6', 'TPLink', '6', '4984036346', 'Activo', '194.224.107.30', 2);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('57-E2-E2-39-C9-1E', 'TPLink', '6', '1683756169', 'Activo', '102.232.68.146', 2);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('C2-AF-04-6F-11-31', 'TPLink', '7', '7978228150', 'Activo', '83.116.33.80', 1);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('26-2D-75-59-61-ED', 'TPLink', '8', '3840166837', 'Activo', '30.90.86.112', 1);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('66-86-BC-4E-D4-DF', 'GLC', '1', '8787043416', 'Activo', '115.112.139.41', 3);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('13-CE-4E-A0-8E-81', 'GLC', '2', '2933515016', 'Activo', '62.182.107.154', 3);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('ED-89-8A-4C-6A-52', 'GLC', '3', '3913688080', 'Activo', '75.175.101.198', 2);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('DE-0D-8A-AD-FF-CA', 'GLC', '4', '5552492609', 'Activo', '14.43.189.126', 3);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('36-F2-18-EE-AE-EB', 'GLC', '5', '4046307404', 'Activo', '76.102.110.2', 2);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('0B-24-D7-31-08-E7', 'GLC', '6', '1548986402', 'Activo', '96.133.216.162', 1);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('0A-CA-45-B8-C6-D1', 'Mikrotik', '1', '1695141377', 'Activo', '147.216.97.137', 3);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('8A-3A-CE-FE-15-B2', 'Mikrotik', '2', '8137204520', 'Activo', '133.25.152.219', 3);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('7E-CF-DA-52-D5-E2', 'Mikrotik', '3', '3069666361', 'Activo', '106.114.211.244', 3);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('41-41-A2-B0-62-00', 'Mikrotik', '4', '5702738195', 'Activo', '163.206.111.249', 3);
insert into Equipos (MAC, Marca, Modelo, SerialNumber, Estado, ip, idTipoEquipo) values ('76-53-DA-C9-21-AA', 'Mikrotik', '5', '3731716062', 'Activo', '152.94.138.205', 2);

#select * from equipos;

##Creo los clientes
insert into Clientes (Dni) values ('37958090');
insert into Clientes (Dni) values ('37958091');
insert into Clientes (Dni) values ('37958092');
insert into Clientes (Dni) values ('37958093');
insert into Clientes (Dni) values ('37958094');
insert into Clientes (Dni) values ('37958095');
insert into Clientes (Dni) values ('37958096');
insert into Clientes (Dni) values ('37958097');
insert into Clientes (Dni) values ('37958098');
insert into Clientes (Dni) values ('37958099');

#select * from clientes;

##Creo el tipo de personal
insert into TipoPersonal (idTipoPersonal, Tipo) values (5, 'Torrista');
insert into TipoPersonal (idTipoPersonal, Tipo) values (4, 'Personal de Limpieza');
insert into TipoPersonal (idTipoPersonal, Tipo) values (2, 'Administrador de Redes');
insert into TipoPersonal (idTipoPersonal, Tipo) values (1, 'Tecnico');
insert into TipoPersonal (idTipoPersonal, Tipo) values (0, 'Recepcionita');

#select * from TipoPersonal;

##Creo el personal
insert into Personal (Dni,idTipoPersonal) values ('37958070',1);
insert into Personal (Dni,idTipoPersonal) values ('37958071',1);
insert into Personal (Dni,idTipoPersonal) values ('37958072',0);
insert into Personal (Dni,idTipoPersonal) values ('37958073',0);
insert into Personal (Dni,idTipoPersonal) values ('37958074',1);
insert into Personal (Dni,idTipoPersonal) values ('37958075',1);
insert into Personal (Dni,idTipoPersonal) values ('37958076',1);
insert into Personal (Dni,idTipoPersonal) values ('37958077',0);
insert into Personal (Dni,idTipoPersonal) values ('37958078',1);
insert into Personal (Dni,idTipoPersonal) values ('37958079',1);
insert into Personal (Dni,idTipoPersonal) values ('37958080',1);
insert into Personal (Dni,idTipoPersonal) values ('37958081',1);
insert into Personal (Dni,idTipoPersonal) values ('37958082',1);

#select * from personal;

##tipo servicios
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (0, 'Cambio de Contraseña', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (1, 'Chequeo General', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (2, 'Cambio de Ficha', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (3, 'Cambio de Fibra', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (4, 'Sustitucion', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (6, 'Cambio de puertos de Ethernet', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (7, 'Verificacion de Potencia', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (8, 'Cambios de Antena', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (9, 'Cambio de Procesador', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (10, 'Cambio de leds', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (11, 'Reparacion de fuentes', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (12, 'Resoldar Pistas', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (13, 'Prueba de Puertos', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (14, 'Prueba de Antenas', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (15, 'Cambio de memoria', 'Activo');
insert into TipoServicios (idTipoServicios, Tipo, Estado) values (16, 'Cambio de disipador', 'Baja');
insert into TipoServicios (idTipoServicios, Tipo) values (17, 'Desmantelamiento');
insert into TipoServicios (idTipoServicios, Tipo) values (18, 'Cambio de puertos sfp');
insert into TipoServicios (idTipoServicios, Tipo) values (19, 'Actualizacion de Firmware');

#select * from tiposervicios;

insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (1, '37958090', 0, 'CB-44-57-CB-38-10', 'concluido', '2022-03-04', '2022-03-04');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (2, '37958091', 1, '40-36-15-BF-FE-CB', 'en espera', '2022-04-07', '2022-04-07');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (3, '37958092', 2, '26-2D-75-59-61-ED', 'concluido', '2021-09-11', '2021-09-11');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (4, '37958093', 3, '76-53-DA-C9-21-AA', 'concluido', '2022-02-27', '2022-02-27');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (5, '37958094', 4, '0B-24-D7-31-08-E7', 'en espera', '2020-12-08', '2020-12-08');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (6, '37958095', 0, '41-41-A2-B0-62-00', 'suspendido', '2022-05-15', '2022-05-15');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (7, '37958096', 1, '7E-CF-DA-52-D5-E2', 'en espera', '2022-03-04', '2022-03-04');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (8, '37958097', 2, 'DE-0D-8A-AD-FF-CA', 'en espera', '2022-02-27', '2022-02-27');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (9, '37958098', 3, '49-F8-30-80-90-E6', 'suspendido', '2021-11-14', '2021-11-14');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (10, '37958099', 4, '13-CE-4E-A0-8E-81', 'suspendido', '2022-03-04', '2022-03-04');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (11, '37958090', 0, 'CB-44-57-CB-38-10', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (12, '37958090', 0, 'CB-44-57-CB-38-10', 'concluido', '2022-04-04', '2022-04-04');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (13, '37958090', 6, 'CA-32-C7-9E-EE-EF', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (14, '37958091', 7, '40-36-15-BF-FE-CB', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (15, '37958091', 8, 'CA-32-C7-9E-EE-EF', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (16, '37958091', 9, 'CA-32-C7-9E-EE-EF', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (17, '37958091', 3, '40-36-15-BF-FE-CB', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (18, '37958091', 13, '40-36-15-BF-FE-CB', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (19, '37958092', 9, '26-2D-75-59-61-ED', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (20, '37958092', 10, '26-2D-75-59-61-ED', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (21, '37958092', 12, '26-2D-75-59-61-ED', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (22, '37958092', 11, '26-2D-75-59-61-ED', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (23, '37958092', 14, '26-2D-75-59-61-ED', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (24, '37958093', 13, '76-53-DA-C9-21-AA', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (25, '37958093', 0, '76-53-DA-C9-21-AA', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (26, '37958093', 12, '76-53-DA-C9-21-AA', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (27, '37958093', 11, '66-86-BC-4E-D4-DF', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (28, '37958093', 15, '66-86-BC-4E-D4-DF', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (29, '37958094', 11, '7E-CF-DA-52-D5-E2', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (30, '37958094', 14, 'ED-89-8A-4C-6A-52', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (31, '37958094', 12, 'ED-89-8A-4C-6A-52', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (32, '37958094', 0, '0A-CA-45-B8-C6-D1', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (33, '37958095', 0, '49-F8-30-80-90-E6', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (34, '37958095', 3, '49-F8-30-80-90-E6', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (35, '37958095', 14, '0B-24-D7-31-08-E7', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (36, '37958095', 19, '0B-24-D7-31-08-E7', 'concluido', '2022-03-01', '2022-03-01');
insert into Servicio (idServicios, Dni, idTipoServicios, MAC, Estado, FechaInicio, FechaFin) values (37, '37958095', 17, '0B-24-D7-31-08-E7', 'concluido', '2022-03-01', '2022-03-01');

##Relacion personal servicio
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958070', '37958090', 1);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958070', '37958090', 11);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958071', '37958090', 12);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958071', '37958090', 13);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958082', '37958091', 2);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958079', '37958091', 14);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958079', '37958091', 15);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958079', '37958091', 16);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958071', '37958091', 17);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958071', '37958091', 18);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958071', '37958092', 3);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958071', '37958092', 19);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958071', '37958092', 20);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958074', '37958092', 21);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958074', '37958092', 22);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958074', '37958092', 23);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958075', '37958094', 29);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958075', '37958094', 30);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958075', '37958093', 4);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958072', '37958093', 24);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958072', '37958093', 25);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958073', '37958093', 26);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958075', '37958093', 27);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958075', '37958093', 28);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958081', '37958094', 5);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958075', '37958094', 31);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958075', '37958094', 32);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958078', '37958095', 6);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958074', '37958095', 33);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958078', '37958095', 34);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958078', '37958095', 35);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958076', '37958095', 36);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958077', '37958095', 37);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958079', '37958096', 7);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958080', '37958097', 8);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958079', '37958098', 9);
insert into PersonalServicio (Dni_P, Dni_C, idServicios) values ('37958079', '37958099', 10);


#select * from personalservicio;

##Equipos cliente
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958090','CB-44-57-CB-38-10','Azul', 'T1', 2, 3);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958090','CA-32-C7-9E-EE-EF','Azul', 'T1', 3, 3);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958090','A4-BD-39-47-A2-5F','Azul', 'T1', 4, 3);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958090','C2-AF-04-6F-11-31','Azul', 'T1', 5, 3);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958091','40-36-15-BF-FE-CB','Verde', 'T2', 1, 2);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958091','57-E2-E2-39-C9-1E','Verde', 'T2', 2, 2);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958092','26-2D-75-59-61-ED','Amarillo', 'T3', 4, 9);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958093','76-53-DA-C9-21-AA','Amarillo', 'T3', 5, 9);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958093','66-86-BC-4E-D4-DF','Amarillo', 'T3', 6, 9);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958094','7E-CF-DA-52-D5-E2','Gris', 'T3', 5, 4);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958094','ED-89-8A-4C-6A-52','Gris', 'T3', 6, 4);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958094','0A-CA-45-B8-C6-D1','Gris', 'T3', 7, 4);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958095','49-F8-30-80-90-E6','Naranja', 'T4', 6,8);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958095','0B-24-D7-31-08-E7','Naranja', 'T4', 7,8);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958096','41-41-A2-B0-62-00','Naranja', 'T5', 7, 10);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958096','8A-3A-CE-FE-15-B2','Naranja', 'T5', 8, 10);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958096','36-F2-18-EE-AE-EB','Naranja', 'T5', 9, 10);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958097','DE-0D-8A-AD-FF-CA','Rosa', 'T6', 10, 11);
insert into EquiposCliente (Dni_C,MAC,ColorFibra, NombreTroncal, NumONU, NumPON) values ('37958099','13-CE-4E-A0-8E-81','Rojo', 'T6', 11, 11);

#select * from equiposcliente;