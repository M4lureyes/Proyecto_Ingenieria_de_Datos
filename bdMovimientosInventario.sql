create database bdMovimientosInventario;

use bdMovimientosInventario;

create table tercero(
	nitTercero varchar(32) primary key not null,
    nombreTercero varchar(64),
    esProveedor bool default false
);

create table productoCompra(
	codigoProdCompra varchar(32) primary key not null,
    nombreProdCompra varchar(128) not null,
    unidadProdCompra varchar(16),
    estadoProdCompra varchar(32) default 'Activo'
);

create table productoReal(
	codigoProdReal varchar(32) primary key not null,
    nombreProdReal varchar(128) not null,
    unidadProdReal varchar(16),
    esComprable bool default false,
    estadoProdReal varchar(32) default 'Activo'
);

create table productoCompraProductoReal(
	codigoEnsamble int primary key auto_increment,
    codigoProdCompra varchar(32) not null,
    codigoProdReal varchar(32) not null,
    foreign key (codigoProdCompra) references productoCompra(codigoProdCompra),
    foreign key (codigoProdReal) references productoReal(codigoProdReal)
);

create table movimientoInventario(
	codigoMov int primary key not null,
    codigoProdReal varchar(32) not null,
    bodega varchar(32) not null,
	cantidadPrevia float not null,
    cantidadEntrada float not null,
    cantidadSalida float not null,
    cantidadFinal float not null,
    tipoMovimiento varchar(16) not null,
    prefijo varchar(8) not null,
    numero varchar(16) not null,
    fecha date not null,
    concepto varchar(128),
    nitTercero varchar(32),
    costo float not null,
    foreign key (codigoProdReal) references productoReal(codigoProdReal),
    foreign key (nitTercero) references Tercero(nitTercero)
);

#drop database bdmovimientosinventario;
