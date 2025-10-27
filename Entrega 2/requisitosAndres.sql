# REQUISITOS PREGUNTADOS ANDRES
# RQF040 y RQF052

create database requisitosPreguntadosAndres;
use requisitosPreguntadosAndres;

create table usuario (
    idUsuario int primary key auto_increment,
    nombreUsuario varchar(50) not null,
    rolUsuario varchar(25) not null,
    nickname varchar(50) not null,
    claveUsuario varchar(100) not null,
    correoUsuario varchar(256) not null,
    telefonoUsuario varchar(20) not null,
    estadoUsuario varchar(25) not null,
    fechaRegistroUsuario timestamp default current_timestamp
);

create table producto (
	idProducto varchar(32) primary key not null,
    nombreProducto varchar(128) not null,
    unidadProducto varchar(16)
);

create table inventario (
    idInventario varchar(68) primary key not null,
    idProductoFK varchar(32) not null,
    bodega varchar(32) not null,
    cantidadInventario float not null,
    fechaActualizacion date not null,
    idUsuarioFK int,
    foreign key (idProductoFK) references producto(idProducto),
    foreign key (idUsuarioFK) references usuario(idUsuario)
);

create table movimiento (
    idMovimiento int primary key not null,
    idInventarioFK varchar(68) not null,
    cantidadNetaMovimiento float not null,
    tipoMovimiento varchar(16) not null,
    fechaMovimiento date not null,
    concepto varchar(128),
    foreign key (idInventarioFK) references inventario(idInventario)
);

create table proveedor (
	nitProveedor varchar(32) primary key not null,
    nombreProveedor varchar(64)
);

create table compra (
	idMovimientoFK int primary key not null,
    costoUnitarioCompra float not null,
    costoTotalCompra float not null,
    nitProveedorFK varchar(32) not null,
    foreign key (idMovimientoFK) references movimiento(idMovimiento),
    foreign key (nitProveedorFK) references proveedor(nitProveedor)
);

create table cliente (
	nitCliente varchar(32) primary key not null,
    nombreCliente varchar(64)
);

create table venta (
	idMovimientoFK int primary key not null,
    costoUnitarioVenta float not null,
    costoTotalVenta float not null,
    nitClienteFK varchar(32) not null,
    foreign key (idMovimientoFK) references movimiento(idMovimiento),
    foreign key (nitClienteFK) references cliente(nitCliente)
);

create table ensamble (
	idEnsamble varchar(73) primary key not null,
    idProductoPadreFK varchar(32) not null,
    idProductoHijoFK varchar(32) not null,
    razonHijosPorPadre float not null,
    foreign key (idProductoPadreFK) references producto(idProducto),
    foreign key (idProductoHijoFK) references producto(idProducto)
);

/*
RQF040
Obtener clave de usuario
*/

delimiter $$
create function GetClaveUsuario(i_idUsuario int)
returns varchar(100)
deterministic
begin
	declare r_claveUsuario varchar(100);
    select claveUsuario into r_claveUsuario from usuario
		where idUsuario = i_idUsuario;
    return r_claveUsuario;
end $$
delimiter ;

/*
RQF052
Obtener identificador de inventario de movimiento
*/

delimiter $$
create function GetIdInventario(i_idMovimiento int)
returns varchar(68)
deterministic
begin
	declare r_idInventarioFK varchar(68);
    select idInventarioFK into r_idInventarioFK from movimiento
		where idMovimiento = i_idMovimiento;
    return r_idInventarioFK;
end $$
delimiter ;
