#Creación Base de Datos
CREATE DATABASE bdProyecto;

#Uso de la base de datos
USE bdProyecto;

#Creación de las tablas
#Tabla Usuarios
CREATE TABLE Usuario(
	idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nombreUsuario VARCHAR(50) NOT NULL,
    rolUsuario VARCHAR(25) NOT NULL,
    estadoUsuario VARCHAR(25) NOT NULL
);

#Tabla Productos
CREATE TABLE Producto(
	idProducto INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(25) NOT NULL,
    precio FLOAT(10, 2) NOT NULL,
    tipoProducto VARCHAR(25) NOT NULL
);

#Tabla Tipo de Tranasacciones
CREATE TABLE TipoTransaccion(
	idTipoTransaccion INT AUTO_INCREMENT PRIMARY KEY,
    nombreTransaccion VARCHAR(50),
    entrada BOOLEAN,
    salida BOOLEAN
);

#Tabla Inventario
CREATE TABLE Inventario(
	idInventario INT AUTO_INCREMENT PRIMARY KEY,
    cantidadDisponible INT,
    cantidadMinima INT,
    ubicacion VARCHAR(25),
    idUsuario INT NOT NULL,
    idProducto INT NOT NULL,
    idTipoTransaccion INT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    FOREIGN KEY (idTipoTransaccion) REFERENCES TipoTransaccion(idTipoTransaccion)
);

#Tabla Ventas
CREATE TABLE Venta(
	idVenta INT AUTO_INCREMENT PRIMARY KEY,
    fechaVenta DATE NOT NULL,
    cantidadVenta INT NOT NULL,
    precioUnidad FLOAT(10, 2) NOT NULL,
    totalVenta FLOAT(10, 2) NOT NULL,
    idInventario INT NOT NULL,
    FOREIGN KEY (idInventario) REFERENCES Inventario(idInventario)
);

#Tabla Compras
CREATE TABLE Compra(
	idCompra INT AUTO_INCREMENT PRIMARY KEY,
    fechaCompra DATE NOT NULL,
    cantidadCompra INT NOT NULL,
    precioUnidad FLOAT(10, 2) NOT NULL,
    totalCompra FLOAT(10, 2) NOT NULL,
    proveedor VARCHAR(25) NOT NULL,
    idInventario INT NOT NULL,
    FOREIGN KEY (idInventario) REFERENCES Inventario(idInventario)
);

#Insersión de datos para cada tabla
#Insersión para la tabla Usuario
INSERT INTO Usuario (nombreUsuario, rolUsuario, estadoUsuario) VALUES
('Mariana Romero', 'Administrador', 'Activo'),
('Juan Pérez', 'Empleado', 'Activo'),
('Ana Torres', 'Empleado', 'Activo'),
('Carlos Díaz', 'Administrador', 'Activo'),
('Laura Gómez', 'Empleado', 'Activo'),
('Pedro Sánchez', 'Empleado', 'Inactivo'),
('Camila López', 'Empleado', 'Activo'),
('Andrés Mora', 'Administrador', 'Activo'),
('Valentina Ríos', 'Empleado', 'Activo'),
('Jorge Martínez', 'Empleado', 'Activo'),
('Sofía Castro', 'Empleado', 'Activo'),
('Mateo Suárez', 'Empleado', 'Activo'),
('Daniela Vega', 'Empleado', 'Activo'),
('Felipe Cárdenas', 'Empleado', 'Activo'),
('Isabela León', 'Administrador', 'Activo'),
('Gabriel Ruiz', 'Empleado', 'Activo'),
('Sara Herrera', 'Empleado', 'Activo'),
('Lucas Medina', 'Empleado', 'Activo'),
('Martina Ortiz', 'Empleado', 'Activo'),
('Juliana Reyes', 'Empleado', 'Activo'),
('Emilio Pardo', 'Empleado', 'Activo'),
('Nicolás Peña', 'Empleado', 'Activo'),
('Paula Serrano', 'Empleado', 'Activo'),
('David López', 'Empleado', 'Activo'),
('Alejandra Rojas', 'Empleado', 'Activo'),
('Diego Torres', 'Empleado', 'Activo'),
('Lucía Gil', 'Empleado', 'Activo'),
('Sebastián Cruz', 'Empleado', 'Activo'),
('Manuela Vargas', 'Empleado', 'Activo'),
('Tomás Mejía', 'Empleado', 'Activo'),
('Natalia Mora', 'Administrador', 'Activo'),
('Samuel Ramos', 'Empleado', 'Activo'),
('Carmen Acosta', 'Empleado', 'Activo'),
('Simón Pérez', 'Empleado', 'Activo'),
('Laura Sánchez', 'Empleado', 'Activo'),
('Andrés Vega', 'Empleado', 'Activo'),
('Felipe Díaz', 'Empleado', 'Activo'),
('Ana Rincón', 'Empleado', 'Activo'),
('Julián Castro', 'Empleado', 'Activo'),
('Paola Ruiz', 'Empleado', 'Activo'),
('Valeria Gómez', 'Empleado', 'Activo'),
('Cristian Mora', 'Empleado', 'Activo'),
('Camilo Duarte', 'Empleado', 'Activo'),
('María Pérez', 'Empleado', 'Activo'),
('Iván García', 'Empleado', 'Activo'),
('Andrea Díaz', 'Empleado', 'Activo'),
('Esteban León', 'Empleado', 'Activo'),
('Karen Ortiz', 'Empleado', 'Activo'),
('David Romero', 'Empleado', 'Activo'),
('Lucía Cárdenas', 'Empleado', 'Activo');

#Insersión para la tabla Producto
INSERT INTO Producto (marca, precio, tipoProducto) VALUES
('Nestlé', 2500.00, 'Alimento'),
('Pepsi', 1800.00, 'Bebida'),
('Coca-Cola', 1900.00, 'Bebida'),
('Colgate', 3500.00, 'Higiene'),
('Ariel', 4200.00, 'Limpieza'),
('Dove', 4800.00, 'Cuidado Personal'),
('Pantene', 5600.00, 'Cuidado Personal'),
('Ramo', 1500.00, 'Alimento'),
('Bimbo', 2200.00, 'Alimento'),
('Jet', 3000.00, 'Dulce'),
('Corona', 5000.00, 'Bebida'),
('Postobón', 2000.00, 'Bebida'),
('Noel', 2400.00, 'Alimento'),
('Familia', 3800.00, 'Higiene'),
('Colcafé', 4500.00, 'Bebida'),
('Zenú', 5200.00, 'Alimento'),
('Alpina', 2600.00, 'Lácteo'),
('La Fina', 3100.00, 'Aceite'),
('Rexona', 4700.00, 'Cuidado Personal'),
('Bavaria', 5500.00, 'Bebida'),
('BonYurt', 3200.00, 'Lácteo'),
('Milo', 4100.00, 'Bebida'),
('Nescafé', 4600.00, 'Bebida'),
('Scott', 3700.00, 'Higiene'),
('Detodito', 2900.00, 'Snack'),
('Jet', 3100.00, 'Dulce'),
('Frutiño', 2300.00, 'Bebida'),
('Ace', 4800.00, 'Limpieza'),
('BonBonBum', 1200.00, 'Dulce'),
('Vive100', 2500.00, 'Energizante'),
('Ranchera', 5200.00, 'Alimento'),
('CremHelado', 2800.00, 'Postre'),
('Colombina', 3500.00, 'Dulce'),
('Carulla', 3000.00, 'Alimento'),
('Pony Malta', 2600.00, 'Bebida'),
('Bavaria', 5500.00, 'Bebida'),
('Zenú', 5200.00, 'Alimento'),
('Jet', 2900.00, 'Dulce'),
('Noel', 2400.00, 'Alimento'),
('Postobón', 2000.00, 'Bebida'),
('Familia', 3800.00, 'Higiene'),
('Dove', 4800.00, 'Cuidado Personal'),
('Rexona', 4700.00, 'Cuidado Personal'),
('Pantene', 5600.00, 'Cuidado Personal'),
('Ariel', 4200.00, 'Limpieza'),
('Colgate', 3500.00, 'Higiene'),
('Ace', 4800.00, 'Limpieza'),
('Bimbo', 2200.00, 'Alimento'),
('Nestlé', 2500.00, 'Alimento'),
('Milo', 4100.00, 'Bebida');

#Insersión para la tabla Tipo de Transacciones
INSERT INTO TipoTransaccion (nombreTransaccion, entrada, salida) VALUES
('Compra de productos', TRUE, FALSE),
('Venta de productos', FALSE, TRUE),
('Devolución a proveedor', FALSE, TRUE),
('Entrada por ajuste', TRUE, FALSE),
('Salida por ajuste', FALSE, TRUE),
('Ingreso inicial', TRUE, FALSE),
('Retiro por pérdida', FALSE, TRUE),
('Transferencia interna', TRUE, FALSE),
('Devolución de cliente', TRUE, FALSE),
('Muestra gratuita', FALSE, TRUE),
('Entrada especial', TRUE, FALSE),
('Salida especial', FALSE, TRUE),
('Ajuste inventario', TRUE, FALSE),
('Consignación recibida', TRUE, FALSE),
('Consignación entregada', FALSE, TRUE),
('Donación recibida', TRUE, FALSE),
('Donación entregada', FALSE, TRUE),
('Reintegro inventario', TRUE, FALSE),
('Venta promocional', FALSE, TRUE),
('Reposición stock', TRUE, FALSE),
('Compra especial', TRUE, FALSE),
('Venta mayorista', FALSE, TRUE),
('Compra urgente', TRUE, FALSE),
('Salida temporal', FALSE, TRUE),
('Entrada temporal', TRUE, FALSE),
('Producción interna', TRUE, FALSE),
('Consumo interno', FALSE, TRUE),
('Reingreso de producto', TRUE, FALSE),
('Salida por vencimiento', FALSE, TRUE),
('Actualización stock', TRUE, FALSE),
('Prueba laboratorio', FALSE, TRUE),
('Mantenimiento', FALSE, TRUE),
('Corrección inventario', TRUE, FALSE),
('Reposición', TRUE, FALSE),
('Ajuste contable', TRUE, FALSE),
('Despacho urgente', FALSE, TRUE),
('Reabastecimiento', TRUE, FALSE),
('Baja inventario', FALSE, TRUE),
('Pedido pendiente', TRUE, FALSE),
('Carga inicial', TRUE, FALSE),
('Retiro temporal', FALSE, TRUE),
('Ingreso extraordinario', TRUE, FALSE),
('Salida extraordinaria', FALSE, TRUE),
('Revisión inventario', TRUE, FALSE),
('Venta online', FALSE, TRUE),
('Compra internacional', TRUE, FALSE),
('Devolución internacional', TRUE, FALSE),
('Salida internacional', FALSE, TRUE),
('Prueba calidad', FALSE, TRUE),
('Ingreso devolución', TRUE, FALSE);

#Insersión para la tabla Inventario
INSERT INTO Inventario (cantidadDisponible, cantidadMinima, ubicacion, idUsuario, idProducto, idTipoTransaccion) VALUES
(100, 10, 'Bodega A', 1, 1, 1),
(50, 5, 'Bodega A', 2, 2, 2),
(120, 10, 'Bodega B', 3, 3, 3),
(80, 8, 'Bodega C', 4, 4, 1),
(200, 20, 'Bodega B', 5, 5, 1),
(300, 25, 'Bodega A', 6, 6, 2),
(60, 6, 'Bodega C', 7, 7, 3),
(500, 50, 'Bodega B', 8, 8, 4),
(70, 10, 'Bodega A', 9, 9, 1),
(30, 5, 'Bodega B', 10, 10, 5),
(150, 15, 'Bodega C', 11, 11, 2),
(100, 10, 'Bodega A', 12, 12, 6),
(200, 20, 'Bodega B', 13, 13, 7),
(80, 8, 'Bodega C', 14, 14, 8),
(90, 9, 'Bodega A', 15, 15, 9),
(110, 10, 'Bodega B', 16, 16, 10),
(220, 20, 'Bodega A', 17, 17, 1),
(310, 25, 'Bodega C', 18, 18, 2),
(60, 6, 'Bodega B', 19, 19, 3),
(120, 10, 'Bodega C', 20, 20, 4),
(140, 14, 'Bodega A', 21, 21, 5),
(100, 10, 'Bodega B', 22, 22, 6),
(90, 9, 'Bodega C', 23, 23, 7),
(160, 16, 'Bodega A', 24, 24, 8),
(180, 18, 'Bodega B', 25, 25, 9),
(70, 7, 'Bodega C', 26, 26, 10),
(200, 20, 'Bodega A', 27, 27, 1),
(210, 21, 'Bodega B', 28, 28, 2),
(150, 15, 'Bodega C', 29, 29, 3),
(190, 19, 'Bodega A', 30, 30, 4),
(80, 8, 'Bodega B', 31, 31, 5),
(50, 5, 'Bodega A', 32, 32, 6),
(70, 7, 'Bodega B', 33, 33, 7),
(120, 12, 'Bodega C', 34, 34, 8),
(90, 9, 'Bodega A', 35, 35, 9),
(220, 22, 'Bodega B', 36, 36, 10),
(130, 13, 'Bodega C', 37, 37, 1),
(300, 30, 'Bodega A', 38, 38, 2),
(250, 25, 'Bodega B', 39, 39, 3),
(170, 17, 'Bodega C', 40, 40, 4),
(190, 19, 'Bodega A', 41, 41, 5),
(210, 21, 'Bodega B', 42, 42, 6),
(230, 23, 'Bodega C', 43, 43, 7),
(90, 9, 'Bodega A', 44, 44, 8),
(110, 11, 'Bodega B', 45, 45, 9),
(240, 24, 'Bodega C', 46, 46, 10),
(250, 25, 'Bodega A', 47, 47, 1),
(270, 27, 'Bodega B', 48, 48, 2),
(280, 28, 'Bodega C', 49, 49, 3),
(290, 29, 'Bodega A', 50, 50, 4);

#Insersión para la tabla Ventas
INSERT INTO Venta (fechaVenta, cantidadVenta, precioUnidad, totalVenta, idInventario) VALUES
('2025-01-10', 10, 2500.00, 25000.00, 1),
('2025-01-11', 5, 1800.00, 9000.00, 2),
('2025-01-12', 8, 1900.00, 15200.00, 3),
('2025-01-13', 12, 3500.00, 42000.00, 4),
('2025-01-14', 6, 4200.00, 25200.00, 5),
('2025-01-15', 15, 4800.00, 72000.00, 6),
('2025-01-16', 9, 5600.00, 50400.00, 7),
('2025-01-17', 7, 1500.00, 10500.00, 8),
('2025-01-18', 20, 2200.00, 44000.00, 9),
('2025-01-19', 25, 3000.00, 75000.00, 10),
('2025-01-20', 18, 5000.00, 90000.00, 11),
('2025-01-21', 10, 2000.00, 20000.00, 12),
('2025-01-22', 9, 2400.00, 21600.00, 13),
('2025-01-23', 15, 3800.00, 57000.00, 14),
('2025-01-24', 11, 4500.00, 49500.00, 15),
('2025-01-25', 7, 5200.00, 36400.00, 16),
('2025-01-26', 10, 2600.00, 26000.00, 17),
('2025-01-27', 8, 3100.00, 24800.00, 18),
('2025-01-28', 13, 4700.00, 61100.00, 19),
('2025-01-29', 6, 5500.00, 33000.00, 20),
('2025-01-30', 9, 3200.00, 28800.00, 21),
('2025-02-01', 14, 4100.00, 57400.00, 22),
('2025-02-02', 8, 4600.00, 36800.00, 23),
('2025-02-03', 10, 3700.00, 37000.00, 24),
('2025-02-04', 12, 2900.00, 34800.00, 25),
('2025-02-05', 6, 3100.00, 18600.00, 26),
('2025-02-06', 9, 4800.00, 43200.00, 27),
('2025-02-07', 15, 1200.00, 18000.00, 28),
('2025-02-08', 8, 2500.00, 20000.00, 29),
('2025-02-09', 10, 5200.00, 52000.00, 30),
('2025-02-10', 5, 2800.00, 14000.00, 31),
('2025-02-11', 6, 3500.00, 21000.00, 32),
('2025-02-12', 7, 3000.00, 21000.00, 33),
('2025-02-13', 9, 2600.00, 23400.00, 34),
('2025-02-14', 11, 5500.00, 60500.00, 35),
('2025-02-15', 15, 5200.00, 78000.00, 36),
('2025-02-16', 13, 2900.00, 37700.00, 37),
('2025-02-17', 10, 2400.00, 24000.00, 38),
('2025-02-18', 8, 2000.00, 16000.00, 39),
('2025-02-19', 6, 4800.00, 28800.00, 40),
('2025-02-20', 7, 4700.00, 32900.00, 41),
('2025-02-21', 9, 5600.00, 50400.00, 42),
('2025-02-22', 10, 4200.00, 42000.00, 43),
('2025-02-23', 8, 3500.00, 28000.00, 44),
('2025-02-24', 6, 4800.00, 28800.00, 45),
('2025-02-25', 12, 2200.00, 26400.00, 46),
('2025-02-26', 7, 2500.00, 17500.00, 47),
('2025-02-27', 10, 4100.00, 41000.00, 48),
('2025-02-28', 5, 4600.00, 23000.00, 49),
('2025-03-01', 9, 3700.00, 33300.00, 50);

#Insersión para la tabla Compras
INSERT INTO Compra (fechaCompra, cantidadCompra, precioUnidad, totalCompra, proveedor, idInventario) VALUES
('2025-01-02', 100, 2500.00, 250000.00, 'Nestlé', 1),
('2025-01-03', 80, 1800.00, 144000.00, 'PepsiCo', 2),
('2025-01-04', 90, 1900.00, 171000.00, 'Coca-Cola', 3),
('2025-01-05', 60, 3500.00, 210000.00, 'Colgate', 4),
('2025-01-06', 120, 4200.00, 504000.00, 'Ariel', 5),
('2025-01-07', 75, 4800.00, 360000.00, 'Unilever', 6),
('2025-01-08', 100, 5600.00, 560000.00, 'Procter&Gamble', 7),
('2025-01-09', 50, 1500.00, 75000.00, 'Ramo', 8),
('2025-01-10', 200, 2200.00, 440000.00, 'Bimbo', 9),
('2025-01-11', 150, 3000.00, 450000.00, 'Jet', 10),
('2025-01-12', 90, 5000.00, 450000.00, 'Corona', 11),
('2025-01-13', 100, 2000.00, 200000.00, 'Postobón', 12),
('2025-01-14', 110, 2400.00, 264000.00, 'Noel', 13),
('2025-01-15', 120, 3800.00, 456000.00, 'Familia', 14),
('2025-01-16', 130, 4500.00, 585000.00, 'Colcafé', 15),
('2025-01-17', 80, 5200.00, 416000.00, 'Zenú', 16),
('2025-01-18', 90, 2600.00, 234000.00, 'Alpina', 17),
('2025-01-19', 70, 3100.00, 217000.00, 'La Fina', 18),
('2025-01-20', 65, 4700.00, 305500.00, 'Rexona', 19),
('2025-01-21', 50, 5500.00, 275000.00, 'Bavaria', 20),
('2025-01-22', 110, 3200.00, 352000.00, 'Alpina', 21),
('2025-01-23', 100, 4100.00, 410000.00, 'Nestlé', 22),
('2025-01-24', 120, 4600.00, 552000.00, 'PepsiCo', 23),
('2025-01-25', 90, 3700.00, 333000.00, 'Coca-Cola', 24),
('2025-01-26', 95, 2900.00, 275500.00, 'Noel', 25),
('2025-01-27', 80, 3100.00, 248000.00, 'Ariel', 26),
('2025-01-28', 70, 4800.00, 336000.00, 'Ace', 27),
('2025-01-29', 60, 1200.00, 72000.00, 'Colombina', 28),
('2025-01-30', 150, 2500.00, 375000.00, 'Nestlé', 29),
('2025-01-31', 100, 5200.00, 520000.00, 'Zenú', 30),
('2025-02-01', 80, 2800.00, 224000.00, 'CremHelado', 31),
('2025-02-02', 90, 3500.00, 315000.00, 'Colgate', 32),
('2025-02-03', 120, 3000.00, 360000.00, 'Carulla', 33),
('2025-02-04', 150, 2600.00, 390000.00, 'Pony Malta', 34),
('2025-02-05', 50, 5500.00, 275000.00, 'Bavaria', 35),
('2025-02-06', 130, 5200.00, 676000.00, 'Zenú', 36),
('2025-02-07', 90, 2900.00, 261000.00, 'Jet', 37),
('2025-02-08', 80, 2400.00, 192000.00, 'Postobón', 38),
('2025-02-09', 70, 2000.00, 140000.00, 'Postobón', 39),
('2025-02-10', 60, 4800.00, 288000.00, 'Ace', 40),
('2025-02-11', 55, 4700.00, 258500.00, 'Rexona', 41),
('2025-02-12', 90, 5600.00, 504000.00, 'Pantene', 42),
('2025-02-13', 80, 4200.00, 336000.00, 'Ariel', 43),
('2025-02-14', 60, 3500.00, 210000.00, 'Colgate', 44),
('2025-02-15', 75, 4800.00, 360000.00, 'Ace', 45),
('2025-02-16', 100, 2200.00, 220000.00, 'Bimbo', 46),
('2025-02-17', 90, 2500.00, 225000.00, 'Nestlé', 47),
('2025-02-18', 80, 4100.00, 328000.00, 'Milo', 48),
('2025-02-19', 120, 4600.00, 552000.00, 'Nescafé', 49),
('2025-02-20', 50, 3700.00, 185000.00, 'Scott', 50);

#Consultas Básicas
SELECT * FROM Usuario;
SELECT * FROM Producto;
SELECT * FROM TipoTransaccion;
SELECT * FROM Inventario;
SELECT * FROM Venta;
SELECT * FROM Compra;

#Consultas Específicas por Tabla
#Tabla Usuario
	#1. Nombres y roles de usuarios activos
	SELECT nombreUsuario, rolUsuario 
	FROM Usuario 
	WHERE estadoUsuario = 'Activo';
    
    #2. Cantidad de usuarios administradores
    SELECT COUNT(*) AS TotalAdmins
    FROM Usuario
    WHERE rolUsuario = 'Administrador';
    
    #3. Nombres de empleados inactivos
    SELECT nombreUsuario
    FROM Usuario
    WHERE rolUsuario = 'Empleado' AND estadoUsuario = 'Inactivo';
    
    #4. Roles diferentes registrados
    SELECT DISTINCT rolUsuario
    FROM Usuario;
    
    #5. 5 primeros usuarios registrados
    SELECT nombreUsuario
    FROM Usuario
    ORDER BY idUsuario ASC
    LIMIT 5;
    
    #6. Cantidad de usuarios por rol
    SELECT rolUsuario, COUNT(*) AS CantidadUsarios
    FROM Usuario
    GROUP BY rolUsuario;
    
    #7. Usuarios cuyo nombre contenga la letra m
    SELECT nombreUsuario
    FROM Usuario
    WHERE nombreUsuario LIKE '%m%';
    
#Tabla Producto
	#1. Productos con precio mayor a 4000
    SELECT marca, precio
    FROM Producto
    WHERE precio > 4000;
    
    #2. Tipos de productos diferentes registrados
    SELECT DISTINCT tipoProducto
    FROM Producto;
    
    #3. Cantidad de productos por tipo
    SELECT tipoProducto, COUNT(*) AS TotalProductos
    FROM Producto
    GROUP BY tipoProducto;
    
    #4. Producto más costoso
    SELECT marca, precio
    FROM Producto
    ORDER BY precio DESC
    LIMIT 1;
    
    #5. Productos de la marca 'Nestlé'
    SELECT *
    FROM Producto
    WHERE marca = 'Nestlé';
    
    #6. Promedio del precio de los productos
    SELECT AVG(precio) AS PrecioPromedio
    FROM Producto;
    
    #7. Productos entre 2000 y 4000
    SELECT marca, precio 
    FROM Producto
    WHERE precio BETWEEN 2000 AND 4000;

#Tabla Tipos de Transacciones
	#1. Transacciones de entrada
    SELECT nombreTransaccion
    FROM TipoTransaccion
    WHERE entrada = TRUE;
    
    #2. Transacciones de salida
    SELECT nombreTransaccion
    FROM TipoTransaccion
    WHERE salida = TRUE;
    
    #3. Cantidad de tipos de transacciones
    SELECT COUNT(*) AS TotalTransacciones
    FROM TipoTransaccion;
    
    #4. Transacciones que no son ni de entrada ni de salida
    SELECT nombreTransaccion
    FROM TipoTransaccion
    WHERE entrada = FALSE AND salida = FALSE;
    
    #5. Transacciones que contengan la palabra 'venta'
    SELECT nombreTransaccion
    FROM TipoTransaccion
    WHERE nombreTransaccion LIKE '%venta%';
    
    #6. Cantidad de transacciones de entrada y salida
    SELECT 
	SUM(entrada = TRUE) AS TotalEntradas,
	SUM(salida = TRUE) AS TotalSalidas
	FROM TipoTransaccion;
	
    #7. 10 primeras transacciones ordenadas alfabeticamente
    SELECT *
    FROM TipoTransaccion
    ORDER BY nombreTransaccion ASC
    LIMIT 10;

#Tabla Inventario
	#1. Productos con cantidad disponible menor que la cantidad mínima
    SELECT idInventario, cantidadDisponible, cantidadMinima
    FROM Inventario
    WHERE cantidadDisponible < cantidadMinima;
    
    #2. Productos en la Bodega A
    SELECT idInventario, ubicacion
    FROM Inventario
    WHERE ubicacion = 'Bodega A';
    
    #3. Total unidades disponibles por bodega
    SELECT ubicacion, SUM(cantidadDisponible) AS TotalUnidades
    FROM Inventario
    GROUP BY ubicacion;
    
    #4. Promedio de cantidad mínima
    SELECT AVG(cantidadMinima) AS PromedioMinimo
    FROM Inventario;
    
    #5. 5 productos con más unidades disponibles
    SELECT idInventario, cantidadDisponible
    FROM Inventario
    ORDER BY cantidadDisponible DESC
    LIMIT 5;
    
    #6. Productos de inventario con su nombre de usuario asociado
    SELECT I.idInventario, U.nombreUsuario, I.cantidadDisponible
    FROM Inventario I
    INNER JOIN Usuario U ON I.idUsuario = U.idUsuario;
    
    #7. Cantidad de productos registrados por transacción
    SELECT idTipoTransaccion, COUNT(*) AS Total
    FROM Inventario
    GROUP BY idTipoTransaccion;

#Tabla Ventas
	#1. Ventas del mes de Febrero
    SELECT *
    FROM Venta
    WHERE MONTH(fechaVenta) = 2;
    
    #2. Total ventas
    SELECT SUM(totalVenta) AS TotalVentas
    FROM Venta;
    
    #3. Ventas con total mayor a 50000
    SELECT *
    FROM Venta
    WHERE totalVenta > 50000;
    
    #4. Venta con mayor total
    SELECT *
    FROM Venta
    ORDER BY totalVenta DESC
    LIMIT 1;
    
    #5. Total vendido por dia
    SELECT fechaVenta, SUM(totalVenta) AS TotalDia
    FROM Venta
    GROUP BY fechaVenta;
    
    #6. Promedio cantidad vendida
    SELECT AVG(cantidadVenta) AS PromedioCantidad
    FROM Venta;
    
    #7. Ventas y ubicacion de bodega
    SELECT V.idVenta, V.totalVenta, I.ubicacion
    FROM Venta V
    INNER JOIN Inventario I ON V.idInventario = I.idInventario;

#Tabla Compra
	#1. Compras hechas al proveedor 'Nestlé'
    SELECT *
    FROM Compra
    WHERE proveedor = 'Nestlé';
    
    #2. Total compras
    SELECT SUM(totalCompra) AS TotalCompras
    FROM Compra;
    
    #3. Compras realizadas en Enero
    SELECT *
    FROM Compra
    WHERE MONTH(fechaCompra) = 1;
    
    #4. Compra con mayor unidades
    SELECT *
    FROM Compra
    ORDER BY cantidadCompra DESC
    LIMIT 1;
    
    #5. Valor promedio compra
    SELECT AVG(totalCompra) AS PromedioCompra
    FROM Compra;
    
    #6. Proveedores únicos registrados
    SELECT DISTINCT proveedor
    FROM Compra;
    
    #7. Compras con su bodega correspondiente
    SELECT C.idCompra, C.totalCompra, I.ubicacion
    FROM Compra C
    INNER JOIN Inventario I ON C.idInventario = I.idInventario;
    
#Modificaciones
    #1. Actualizar estado usuario
    UPDATE Usuario
    SET estadoUsuario = 'Inactivo'
    WHERE nombreUsuario = 'Juan Pérez'
    LIMIT 1;
        #Verificación
        SELECT * FROM Usuario WHERE nombreUsuario = 'Juan Pérez';
    
    #2. Cambiar precio
    UPDATE Producto
    SET precio = 6000.00
    WHERE marca = 'Pantene'
    LIMIT 1;
        #Verificación
        SELECT * FROM Producto WHERE marca = 'Pantene';
    
    #3. Modificar cantidad disponible
    UPDATE Inventario
    SET cantidadDisponible = cantidadDisponible - 20
    WHERE idInventario = 1
    LIMIT 1;
        #Verificación
        SELECT * FROM Inventario WHERE idInventario = 1;
        
    #4. Actualizar proveedor de una compra específica
    UPDATE Compra
    SET proveedor = 'Nestlé Colombia S.A.'
    WHERE idCompra = 1;
        #Verifiación
        SELECT * FROM Compra WHERE idCompra = 1;
        
    #5. Agregar campo nuevo en Ventas
    ALTER TABLE Venta
    ADD COLUMN metodoPago VARCHAR(25);
        #Verificación
        DESCRIBE Venta;

#Eliminación
#Eliminar venta
DELETE FROM Venta
WHERE idVenta = 50
LIMIT 1;
    #Verificación
    SELECT * FROM Venta WHERE idVenta = 50;

#Consultas Multitabla
    #1. Ventas con información de producto, usuario y tipo de transacción
    SELECT 
        V.idVenta,
        V.fechaVenta,
        P.marca AS Producto,
        P.tipoProducto,
        U.nombreUsuario AS Responsable,
        TT.nombreTransaccion AS TipoTransaccion,
        V.totalVenta
    FROM Venta V
    INNER JOIN Inventario I ON V.idInventario = I.idInventario
    INNER JOIN Producto P ON I.idProducto = P.idProducto
    INNER JOIN Usuario U ON I.idUsuario = U.idUsuario
    INNER JOIN TipoTransaccion TT ON I.idTipoTransaccion = TT.idTipoTransaccion
    ORDER BY V.fechaVenta DESC;

    #2. Compras con información de producto, usuario y ubicación
    SELECT
        C.idCompra,
        C.fechaCompra,
        C.proveedor,
        P.marca AS Producto,
        U.nombreUsuario AS Encargado,
        I.ubicacion AS Bodega,
        C.totalCompra
    FROM Compra C
    INNER JOIN Inventario I ON C.idInventario = I.idInventario
    INNER JOIN Producto P ON I.idProducto = P.idProducto
    INNER JOIN Usuario U ON I.idUsuario = U.idUsuario
    ORDER BY fechaCompra DESC;

#Subconsultas
    #1. Productos cuyo precio esté por encima del promedio general
    SELECT marca, precio
    FROM Producto
    WHERE precio > (SELECT AVG(precio) FROM Producto);
    
    #2. Productos con cantidad disponible menor al promedio general
    SELECT 
        I.idInventario,
        P.marca AS Producto,
        I.cantidadDisponible,
    (SELECT AVG(cantidadDisponible) FROM Inventario) AS PromedioGeneral
    FROM Inventario I
    INNER JOIN Producto P ON I.idProducto = P.idProducto
    WHERE I.cantidadDisponible < (SELECT AVG(cantidadDisponible) FROM Inventario);

#Procedimientos almacenados
    #1. Registrar una venta nueva
    DELIMITER $$
    CREATE PROCEDURE RegistrarVenta(
        IN p_idInventario INT,
        IN p_cantidadVenta INT,
        IN p_precioUnidad FLOAT
    )
    BEGIN
        DECLARE v_totalVenta FLOAT;
        SET v_totalVenta = p_cantidadVenta * p_precioUnidad;
        INSERT INTO Venta (fechaVenta, cantidadVenta, precioUnidad, totalVenta, idInventario)
        VALUES (CURDATE(), p_cantidadVenta, p_precioUnidad, v_totalVenta, p_idInventario);
        UPDATE Inventario
        SET cantidadDisponible = cantidadDisponible - p_cantidadVenta
        WHERE idInventario = p_idInventario;
    END $$
    DELIMITER ;
        #Verificación
        CALL RegistrarVenta(1, 5, 2500.00);
        
    #2. Consultar resumen de compras por proveedor
    DELIMITER $$
    CREATE PROCEDURE ResumenComprasPorProveedor()
    BEGIN
        SELECT 
            proveedor,
            COUNT(*) AS NumeroCompras,
            SUM(totalCompra) AS TotalGastado
        FROM Compra
        GROUP BY proveedor
        ORDER BY TotalGastado DESC;
    END $$
    DELIMITER ;
        #Verificación
        CALL ResumenComprasPorProveedor();
    
#Vistas
    #1. Vista ventas
    CREATE VIEW VistaVentasDetalladas AS
    SELECT 
        V.idVenta,
        V.fechaVenta,
        P.marca AS Producto,
        P.tipoProducto,
        U.nombreUsuario AS Responsable,
        I.ubicacion AS Bodega,
        V.cantidadVenta,
        V.precioUnidad,
        V.totalVenta
    FROM Venta V
    INNER JOIN Inventario I ON V.idInventario = I.idInventario
    INNER JOIN Producto P ON I.idProducto = P.idProducto
    INNER JOIN Usuario U ON I.idUsuario = U.idUsuario;
        #Verificación
        SELECT * FROM VistaVentasDetalladas;
        
    #2. Vista inventario
    CREATE VIEW VistaInventario AS
    SELECT 
        I.idInventario,
        P.marca AS Producto,
        P.tipoProducto,
        I.cantidadDisponible,
        I.cantidadMinima,
        I.ubicacion,
        U.nombreUsuario AS Responsable,
        TT.nombreTransaccion AS TipoTransaccion
    FROM Inventario I
    INNER JOIN Producto P ON I.idProducto = P.idProducto
    INNER JOIN Usuario U ON I.idUsuario = U.idUsuario
    INNER JOIN TipoTransaccion TT ON I.idTipoTransaccion = TT.idTipoTransaccion;
        #Verificación
        SELECT * FROM VistaInventario;

#Triggers
    #1. Actualizar inventario después de una venta
    DELIMITER $$
    CREATE TRIGGER actualizarInventarioDespuesVenta
    AFTER INSERT ON Venta
    FOR EACH ROW
    BEGIN
        UPDATE Inventario
        SET cantidadDisponible = cantidadDisponible - NEW.cantidadVenta
        WHERE idInventario = NEW.idInventario;
    END $$
    DELIMITER ;

    #2. Actualizar inventario después de una compra
    DELIMITER $$
    CREATE TRIGGER actualizarInventarioDespuesCompra
    AFTER INSERT ON Compra
    FOR EACH ROW
    BEGIN
        UPDATE Inventario
        SET cantidadDisponible = cantidadDisponible + NEW.cantidadCompra
        WHERE idInventario = NEW.idInventario;
    END $$
    DELIMITER ;

    #Verificación
    #Registrar venta
    INSERT INTO Venta (fechaVenta, cantidadVenta, precioUnidad, totalVenta, idInventario)
    VALUES (CURDATE(), 3, 2500.00, 7500.00, 1);

    #Registrar compra
    INSERT INTO Compra (fechaCompra, cantidadCompra, precioUnidad, totalCompra, proveedor, idInventario)
    VALUES (CURDATE(), 10, 2500.00, 25000.00, 'Nestlé', 1);

    #Comprobar inventario actualizado
    SELECT idInventario, cantidadDisponible
    FROM Inventario
    WHERE idInventario = 1;

    #3. Evitar ventas con cantidad superior al inventario disponible
    DELIMITER $$
    CREATE TRIGGER verificarStockAntesVenta
    BEFORE INSERT ON Venta
    FOR EACH ROW
    BEGIN
        DECLARE stockDisponible INT;
        SELECT cantidadDisponible INTO stockDisponible
        FROM Inventario
        WHERE idInventario = NEW.idInventario;
        IF stockDisponible < NEW.cantidadVenta THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: No hay suficiente stock disponible para realizar la venta.';
        END IF;
    END $$
    DELIMITER ;
    
    #Verificación
    #Intentar vender más de lo disponible
    INSERT INTO Venta (fechaVenta, cantidadVenta, precioUnidad, totalVenta, idInventario)
    VALUES (CURDATE(), 9999, 2500.00, 24997500.00, 1);

    #Intentar vender una cantidad válida (debería permitirlo)
    INSERT INTO Venta (fechaVenta, cantidadVenta, precioUnidad, totalVenta, idInventario)
    VALUES (CURDATE(), 2, 2500.00, 5000.00, 1);
