CREATE DATABASE bdMovimientosInventario;

USE bdMovimientosInventario;

CREATE TABLE Grupo(
    codigoGrupo int PRIMARY KEY,
    descripcionGrupo varchar(32) NOT NULL UNIQUE
);

CREATE TABLE Subgrupo(
    codigoSubgrupo int PRIMARY KEY,
    descripcionSubGrupo varchar(32) UNIQUE
);

CREATE TABLE Marca(
    codigoMarca int PRIMARY KEY,
    descripcionMarca varchar(32) NOT NULL UNIQUE
);

CREATE TABLE Fabricante(
    codigoFabricante int PRIMARY KEY,
    descripcionFabricante varchar(32) NOT NULL UNIQUE
);

CREATE TABLE Producto(
    codigoProducto varchar(32) PRIMARY KEY,
    nombreProducto varchar(64) NOT NULL,
    unidad varchar(32) NOT NULL,
    codigoGrupo int NOT NULL,
    codigoSubgrupo int,
    codigoMarca int,
    codigoFabricante int,
    esComprable BOOL DEFAULT FALSE,
    FOREIGN KEY (codigoGrupo) REFERENCES Grupo(codigoGrupo),
    FOREIGN KEY (codigoSubgrupo) REFERENCES Subgrupo(codigoSubgrupo),
    FOREIGN KEY (codigoMarca) REFERENCES Marca(codigoMarca),
    FOREIGN KEY (codigoFabricante) REFERENCES Fabricante(codigoFabricante)
);

CREATE TABLE Tercero(
	nitTercero varchar(32) PRIMARY KEY,
    nombreTercero varchar(64),
    esProovedor bool default false
);

CREATE TABLE Bodega(
	codigoBodega int PRIMARY KEY NOT NULL,
    nombreBodega varchar(32) NOT NULL
);

CREATE TABLE Movimiento(
	tipoMovimiento int PRIMARY KEY NOT NULL,
    nombreMovimiento varchar(32) NOT NULL
);

CREATE TABLE MovimientoInventario(
	codigoMovimiento int PRIMARY KEY NOT NULL,
    codigoProducto varchar(32),
    tipoMovimiento int,
    codigoBodega int,
    cantidadPrevia double NOT NULL,
    cantidadEntrada double NOT NULL,
    cantidadSalida double NOT NULL,
    cantidadFinal double NOT NULL,
    concepto varchar(128),
    nitTercero varchar(32),
    FOREIGN KEY (codigoProducto) REFERENCES Producto(codigoProducto),
    FOREIGN KEY (tipoMovimiento) REFERENCES Movimiento(tipoMovimiento),
    FOREIGN KEY (codigoBodega) REFERENCES Bodega(codigoBodega),
    FOREIGN KEY (nitTercero) REFERENCES Tercero(nitTercero)
);

DESCRIBE MovimientoInventario;