USE `final5` ;

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