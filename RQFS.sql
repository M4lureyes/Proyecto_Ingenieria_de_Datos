#Requerimientos solicitados
CREATE DATABASE RQFS;
USE RQFS;

CREATE TABLE Usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nombreUsuario VARCHAR(50) NOT NULL,
    rolUsuario VARCHAR(25) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    claveUsuario VARCHAR(100) NOT NULL,
    correoUsuario VARCHAR(100) NOT NULL,
    telefonoUsuario VARCHAR(20) NOT NULL,
    estadoUsuario VARCHAR(25) NOT NULL,
    fechaRegistroUsuario TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE producto(
	idProducto VARCHAR(32) PRIMARY KEY NOT NULL,
    nombreProducto VARCHAR(128) NOT NULL,
    unidadProducto VARCHAR(16)
);

CREATE TABLE inventario (
    idInventario VARCHAR(68) PRIMARY KEY not null,
    idProductoFK VARCHAR(32) NOT NULL,
    bodega VARCHAR(32) NOT NULL,
    cantidadInventario FLOAT NOT NULL,
    fechaActualizacion DATE NOT NULL,
    idUsuarioFK INT,
    FOREIGN KEY (idProductoFK) REFERENCES producto(idProducto),
    FOREIGN KEY (idUsuarioFK) REFERENCES usuario(idUsuario)
);

CREATE TABLE movimiento (
    idMovimiento INT PRIMARY KEY NOT NULL,
    idInventarioFK VARCHAR(68) NOT NULL,
    cantidadNetaMovimiento FLOAT NOT NULL,
    tipoMovimiento VARCHAR(16) NOT NULL,
    fechaMovimiento DATE NOT NULL,
    concepto VARCHAR(128),
    FOREIGN KEY (idInventarioFK) REFERENCES inventario(idInventario)
);

CREATE TABLE proveedor(
	nitProveedor VARCHAR(32) PRIMARY KEY NOT NULL,
    nombreProveedor VARCHAR(64)
);

CREATE TABLE compra(
	idMovimientoFK INT PRIMARY KEY NOT NULL,
    costoUnitarioCompra FLOAT NOT NULL,
    costoTotalCompra FLOAT NOT NULL,
    nitProveedorFK VARCHAR(32) NOT NULL,
    FOREIGN KEY (idMovimientoFK) REFERENCES movimiento(idMovimiento),
    FOREIGN KEY (nitProveedorFK) REFERENCES proveedor(nitProveedor)
);

CREATE TABLE cliente(
	nitCliente VARCHAR(32) PRIMARY KEY NOT NULL,
    nombreCliente VARCHAR(64)
);

CREATE TABLE venta(
	idMovimientoFK INT PRIMARY KEY NOT NULL,
    costoUnitarioVenta FLOAT NOT NULL,
    costoTotalVenta FLOAT NOT NULL,
    nitClienteFK VARCHAR(32) NOT NULL,
    FOREIGN KEY (idMovimientoFK) REFERENCES movimiento(idMovimiento),
    FOREIGN KEY (nitClienteFK) REFERENCES cliente(nitCliente)
);

CREATE TABLE ensamble(
	idEnsamble VARCHAR(73) PRIMARY KEY NOT NULL,
    idProductoPadreFK VARCHAR(32) NOT NULL,
    idProductoHijoFK VARCHAR(32) NOT NULL,
    razonHijosPorPadre FLOAT NOT NULL,
    FOREIGN KEY (idProductoPadreFK) REFERENCES producto(idProducto),
    FOREIGN KEY (idProductoHijoFK) REFERENCES producto(idProducto)
);

#3. Modificar usuario (Como procedimiento)
DELIMITER $$
CREATE PROCEDURE ModificarUsuario(
    IN i_idUsuario INT,
    IN i_nombreUsuario VARCHAR(50),
    IN i_rolUsuario VARCHAR(25),
    IN i_nickname VARCHAR(50),
    IN i_claveUsuario VARCHAR(100),
    IN i_correoUsuario VARCHAR(100),
    IN i_telefonoUsuario VARCHAR(20),
    IN i_estadoUsuario VARCHAR(25))
BEGIN
	UPDATE usuario SET 
		nombreUsuario = i_nombreUsuario,
		rolUsuario = i_rolUsuario,
		nickname = i_nickname,
		claveUsuario = i_claveUsuario,
		correoUsuario = i_correoUsuario,
		telefonoUsuario = i_telefonoUsuario,
		estadoUsuario = i_estadoUsuario
        WHERE idUsuario = i_idUsuario;
END $$
DELIMITER ;

#26. Consultar clientes (Como vista)
CREATE VIEW ConsultarClientes AS
SELECT *
FROM Cliente;
SELECT * FROM ConsultarClientes;

#67. Obtener razón entre hijo y padre de ensamble (Como procedimiento)
DELIMITER $$
CREATE PROCEDURE GetRazon(
	IN idEnsamble VARCHAR(70),
    IN idProductoPadreFK VARCHAR(30),
    IN idProductoHijoFK VARCHAR(32),
    IN razonHijosPorPadre FLOAT,
    IN idProducto VARCHAR(32),
    IN nombreProducto VARCHAR(128),
    IN unidadProducto VARCHAR(16))
BEGIN
	UPDATE Ensamble, Producto SET 
		idEmsable = i_idEnsamble,
		idProductoPadreFK = i_idProductoPadreFK,
		idProductoHijoFK = idProductoHijoFK,
		razonHijosPorPadre = razonHijosPorPadre,
		idProducto = i_idProducto,
		nombreProducto = i_nombreProducto,
		unidadProducto = i_unidadProducto
        WHERE idEnsamble = i_idEnsamble;
END $$
DELIMITER ;