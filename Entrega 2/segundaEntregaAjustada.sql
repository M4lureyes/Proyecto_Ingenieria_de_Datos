# PRIMERA SECCION: ESTRUCTURA DE LA BASE DE DATOS
create database bdInventarioTarajai;
use bdInventarioTarajai;

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

create table producto(
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
    foreign key (idUsuarioFK) references usuario(idUsuario),
    unique (idProductoFK, bodega)
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

create table proveedor(
	nitProveedor varchar(32) primary key not null,
    nombreProveedor varchar(64)
);

create table compra(
	idMovimientoFK int primary key not null,
    costoUnitarioCompra float not null,
    costoTotalCompra float not null,
    nitProveedorFK varchar(32) not null,
    foreign key (idMovimientoFK) references movimiento(idMovimiento),
    foreign key (nitProveedorFK) references proveedor(nitProveedor)
);

create table cliente(
	nitCliente varchar(32) primary key not null,
    nombreCliente varchar(64)
);

create table venta(
	idMovimientoFK int primary key not null,
    costoUnitarioVenta float not null,
    costoTotalVenta float not null,
    nitClienteFK varchar(32) not null,
    foreign key (idMovimientoFK) references movimiento(idMovimiento),
    foreign key (nitClienteFK) references cliente(nitCliente)
);

create table ensamble(
	idEnsamble varchar(73) primary key not null,
    idProductoPadreFK varchar(32) not null,
    idProductoHijoFK varchar(32) not null,
    razonHijosPorPadre float not null,
    foreign key (idProductoPadreFK) references producto(idProducto),
    foreign key (idProductoHijoFK) references producto(idProducto),
    unique (idProductoPadreFK, idProductoHijoFK)
);

# SEGUNDA SECCION: TABLA FANTASMA DE IMPORTACION

# Esta tablita temporal es para obtener todos los datos del csv procesado
create table tablaImportacion(
    idMovimiento int,
    idProducto varchar(32),
    nombreProducto varchar(128),
    unidadProducto varchar(16),
    bodega varchar(32),
    cantidadInventario float,
    cantidadFinal float,
    cantidadNetaMovimiento float,
    tipoMovimiento varchar(16),
    fecha date,
    concepto varchar(128),
    nitTercero varchar(32),
    nombreTercero varchar(64),
    valorUnitario float
);

# Esto carga los datos a esa tablita :)
load data infile 'C:/Users/use 10/Desktop/proyectoDatos/datosLimpios.csv'
into table tablaImportacion
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows (
    idMovimiento,
    idProducto,
    nombreProducto,
    unidadProducto,
    bodega,
    cantidadInventario,
    cantidadFinal,
    cantidadNetaMovimiento,
    tipoMovimiento,
    fecha,
    concepto,
    nitTercero,
    nombreTercero,
    valorUnitario
);

# TERCERA SECCION: CRUD DE CADA TABLA

# CRUD Usuario
# 1. Registrar usuario
delimiter $$
create procedure RegistrarUsuario(
    in i_nombreUsuario varchar(50),
    in i_rolUsuario varchar(25),
    in i_nickname varchar(50),
    in i_claveUsuario varchar(100),
    in i_correoUsuario varchar(256),
    in i_telefonoUsuario varchar(20),
    in i_estadoUsuario varchar(25))
begin
	insert into usuario
			(nombreUsuario, rolUsuario, nickname, claveUsuario,
			correoUsuario, telefonoUsuario, estadoUsuario)
        values
			(i_nombreUsuario, i_rolUsuario, i_nickname, i_claveUsuario,
            i_correoUsuario, i_telefonoUsuario, i_estadoUsuario);
end $$
delimiter ;

# 2. Consultar usuarios
delimiter $$
create procedure ConsultarUsuarios()
begin
    select * from usuario;
end $$
delimiter ;

# 3. Consultar usuario
delimiter $$
create procedure ModificarUsuario(
    in i_idUsuario int,
    in i_nombreUsuario varchar(50),
    in i_rolUsuario varchar(25),
    in i_nickname varchar(50),
    in i_claveUsuario varchar(100),
    in i_correoUsuario varchar(256),
    in i_telefonoUsuario varchar(20),
    in i_estadoUsuario varchar(25))
begin
	update usuario set 
		nombreUsuario = i_nombreUsuario,
		rolUsuario = i_rolUsuario,
		nickname = i_nickname,
		claveUsuario = i_claveUsuario,
		correoUsuario = i_correoUsuario,
		telefonoUsuario = i_telefonoUsuario,
		estadoUsuario = i_estadoUsuario
        where idUsuario = i_idUsuario;
end $$
delimiter ;

# 4. Eliminar usuario
delimiter $$
create procedure EliminarUsuario(in i_idUsuario int)
begin
    delete from usuario
    where idUsuario = i_idUsuario;
end $$
delimiter ;

# CRUD Producto
# 5. Registrar producto
delimiter $$
create procedure RegistrarProducto(
	in i_idProducto varchar(32),
    in i_nombreProducto varchar(128),
    in i_unidadProducto varchar(16))
begin
    insert ignore into producto(idProducto, nombreProducto, unidadProducto)
    values (i_idProducto, i_nombreProducto, i_unidadProducto);
end $$
delimiter ;

# 6. Consultar productos
delimiter $$
create procedure ConsultarProductos()
begin
	select * from producto;
end $$
delimiter ;

# 7. Modificar producto
delimiter $$
create procedure ModificarProducto(
    in i_idProducto varchar(32),
    in i_nombreProducto varchar(128),
    in i_unidadProducto varchar(16))
begin
    update producto set 
        nombreProducto = i_nombreProducto,
        unidadProducto = i_unidadProducto
    where idProducto = i_idProducto;
end $$
delimiter ;

# 8. Eliminar producto
delimiter $$
create procedure EliminarProducto(in i_idProducto varchar(32))
begin
    delete from Producto
    where idProducto = i_idProducto;
end $$
delimiter ;

# CRUD Inventario
# 9. Registrar inventario
delimiter $$
create procedure RegistrarInventario(
    in i_idInventario varchar(68),
    in i_idProductoFK varchar(32),
    in i_bodega varchar(32),
    in i_cantidadInventario float,
    in i_fechaActualizacion date,
    in i_idUsuarioFK int
)
begin
    insert ignore into inventario
			(idInventario, idProductoFK, bodega,
			cantidadInventario, fechaActualizacion, idUsuarioFK)
        values
			(i_idInventario, i_idProductoFK, i_bodega,
			i_cantidadInventario, i_fechaActualizacion, i_idUsuarioFK);
end $$
delimiter ;

# 10. Consultar inventarios
delimiter $$
create procedure ConsultarInventarios()
begin
    select * from inventario;
end $$
delimiter ;

# 11. Modificar inventario
delimiter $$
create procedure ModificarInventario(
    in i_idInventario varchar(68),
    in i_idProductoFK varchar(32),
    in i_bodega varchar(32),
    in i_cantidadInventario float,
    in i_fechaActualizacion date,
    in i_idUsuarioFK int)
begin
    update inventario set
        idProductoFK = i_idProductoFK,
        bodega = i_bodega,
        cantidadInventario = i_cantidadInventario,
        fechaActualizacion = i_fechaActualizacion,
        idUsuarioFK = i_idUsuarioFK
    where idInventario = i_idInventario;
end $$
delimiter ;

# 12. Eliminar inventario
delimiter $$
create procedure EliminarInventario(in i_idInventario varchar(68))
begin
    delete from inventario
    where idInventario = i_idInventario;
end $$
delimiter ;

# CRUD Movimiento
# 13. Registrar movimiento
delimiter $$
create procedure RegistrarMovimiento(
    in i_idMovimiento int,
    in i_idInventarioFK varchar(68),
    in i_cantidadNetaMovimiento float,
    in i_tipoMovimiento varchar(16),
    in i_fechaMovimiento date,
    in i_concepto varchar(128))
begin
    insert ignore into movimiento
			(idMovimiento, idInventarioFK, cantidadNetaMovimiento,
			tipoMovimiento, fechaMovimiento, concepto)
        values
			(i_idMovimiento, i_idInventarioFK, i_cantidadNetaMovimiento,
			i_tipoMovimiento, i_fechaMovimiento, i_concepto);
end $$
delimiter ;

# 14. Consultar movimientos
delimiter $$
create procedure ConsultarMovimientos()
begin
    select * from movimiento;
end $$
delimiter ;

# 15. Modificar movimientos
delimiter $$
create procedure ModificarMovimiento(
    in i_idMovimiento int,
    in i_idInventarioFK varchar(68),
    in i_cantidadNetaMovimiento float,
    in i_tipoMovimiento varchar(16),
    in i_fechaMovimiento date,
    in i_concepto varchar(128))
begin
    update movimiento set 
        idInventarioFK = i_idInventarioFK,
        cantidadNetaMovimiento = i_cantidadNetaMovimiento,
        tipoMovimiento = i_tipoMovimiento,
        fechaMovimiento = i_fechaMovimiento,
        concepto = i_concepto
    where idMovimiento = i_idMovimiento;
end $$
delimiter ;

# 16. Eliminar movimiento
delimiter $$
create procedure EliminarMovimiento(in i_idMovimiento int)
begin
    delete from movimiento
    where idMovimiento = i_idMovimiento;
end $$
delimiter ;

# CRUD Proveedor
# 17. Registrar proveedor
delimiter $$
create procedure RegistrarProveedor(
    in i_nitProveedor varchar(32),
    in i_nombreProveedor varchar(64))
begin
    insert ignore into proveedor(nitProveedor, nombreProveedor)
		values (i_nitProveedor, i_nombreProveedor);
end $$
delimiter ;

# 18. Consultar proveedores
delimiter $$
create procedure ConsultarProveedores()
begin
    select * from proveedor;
end $$
delimiter ;

# 19. Modificar proveedor
delimiter $$
create procedure ModificarProveedor(
    in i_nitProveedor varchar(32),
    in i_nombreProveedor varchar(64))
begin
    update proveedor
    set nombreProveedor = i_nombreProveedor
    where nitProveedor = i_nitProveedor;
end $$
delimiter ;

# 20. Eliminar proveedor
delimiter $$
create procedure EliminarProveedor(in i_nitProveedor varchar(32))
begin
    delete from proveedor
    where nitProveedor = i_nitProveedor;
end $$
delimiter ;

# CRUD Compra
# 21. Registrar compra
delimiter $$
create procedure RegistrarCompra(
    in i_idMovimientoFK int,
    in i_costoUnitarioCompra float,
    in i_costoTotalCompra float,
    in i_nitProveedorFK varchar(32))
begin
    insert ignore into compra
			(idMovimientoFK, costoUnitarioCompra, costoTotalCompra, nitProveedorFK)
        values
			(i_idMovimientoFK, i_costoUnitarioCompra, i_costoTotalCompra, i_nitProveedorFK);
end $$
delimiter ;

# 22. Consultar compras
delimiter $$
create procedure ConsultarCompras()
begin
    select * from compra;
end $$
delimiter ;

# 23. Modificar compra
delimiter $$
create procedure ModificarCompra(
    in i_idMovimientoFK int,
    in i_costoUnitarioCompra float,
    in i_costoTotalCompra float,
    in i_nitProveedorFK varchar(32))
begin
    update compra set
		costoUnitarioCompra = i_costoUnitarioCompra,
        costoTotalCompra = i_costoTotalCompra,
        nitProveedorFK = i_nitProveedorFK
    where idMovimientoFK = i_idMovimientoFK;
end $$
delimiter ;

# 24. Eliminar compra
delimiter $$
create procedure EliminarCompra(in i_idMovimientoFK int)
begin
    delete from compra
    where idMovimientoFK = i_idMovimientoFK;
end $$
delimiter ;

# CRUD Cliente
# 25. Registrar cliente
delimiter $$
create procedure RegistrarCliente(
    in i_nitCliente varchar(32),
    in i_nombreCliente varchar(64))
begin
    insert ignore into cliente(nitCliente, nombreCliente)
		values (i_nitCliente, i_nombreCliente);
end $$
delimiter ;

# 26. Consultar clientes
delimiter $$
create procedure ConsultarClientes()
begin
    select * from cliente;
end $$
delimiter ;

# 27. Modificar cliente
delimiter $$
create procedure ModificarCliente(
    in i_nitCliente varchar(32),
    in i_nombreCliente varchar(64))
begin
    update cliente set nombreCliente = i_nombreCliente
    where nitCliente = i_nitCliente;
end $$
delimiter ;

# 28. Eliminar cliente
delimiter $$
create procedure EliminarCliente(in i_nitCliente varchar(32))
begin
    delete from cliente
    where nitCliente = i_nitCliente;
end $$
delimiter ;

# CRUD Venta
# 29. Registrar venta
delimiter $$
create procedure RegistrarVenta(
    in i_idMovimientoFK int,
    in i_costoUnitarioVenta float,
    in i_costoTotalVenta float,
    in i_nitClienteFK varchar(32))
begin
    insert ignore into venta
			(idMovimientoFK, costoUnitarioVenta, costoTotalVenta, nitClienteFK)
        values
			(i_idMovimientoFK, i_costoUnitarioVenta, i_costoTotalVenta, i_nitClienteFK);
end $$

delimiter ;

# 30. Consultar ventas
delimiter $$
create procedure ConsultarVentas()
begin
    select * from venta;
end $$
delimiter ;

# 31. Modificar venta
delimiter $$
create procedure ModificarVenta(
    in i_idMovimientoFK int,
    in i_costoUnitarioVenta float,
    in i_costoTotalVenta float,
    in i_nitClienteFK varchar(32))
begin
    update venta set 
        costoUnitarioVenta = i_costoUnitarioVenta,
        costoTotalVenta = i_costoTotalVenta,
        nitClienteFK = i_nitClienteFK
    where idMovimientoFK = i_idMovimientoFK;
end $$
delimiter ;

# 32. Eliminar venta
delimiter $$
create procedure EliminarVenta(in i_idMovimientoFK int)
begin
    delete from venta
    where idMovimientoFK = i_idMovimientoFK;
end $$
delimiter ;

# CRUD Ensamble
# 33. Registrar ensamble
delimiter $$
create procedure RegistrarEnsamble(
    in i_idEnsamble varchar(73),
    in i_idProductoPadreFK varchar(32),
    in i_idProductoHijoFK varchar(32),
    in i_razonHijosPorPadre float)
begin
    insert ignore into ensamble
			(idEnsamble, idProductoPadreFK, idProductoHijoFK, razonHijosPorPadre)
		values
			(i_idEnsamble, i_idProductoPadreFK, i_idProductoHijoFK, i_razonHijosPorPadre);
end $$
delimiter ;

# 34. Consultar ensambles
delimiter $$
create procedure ConsultarEnsambles()
begin
    select * from ensamble;
end $$
delimiter ;

# 35. Modificar ensamble
delimiter $$
create procedure ModificarEnsamble(
    in i_idEnsamble varchar(73),
    in i_idProductoPadreFK varchar(32),
    in i_idProductoHijoFK varchar(32),
    in i_razonHijosPorPadre float)
begin
    update ensamble set
        idProductoPadreFK = i_idProductoPadreFK,
        idProductoHijoFK = i_idProductoHijoFK,
        razonHijosPorPadre = i_razonHijosPorPadre
    where idEnsamble = i_idEnsamble;
end $$
delimiter ;

# 36. Eliminar ensamble
delimiter $$
create procedure EliminarEnsamble(in i_idEnsamble varchar(73))
begin
    delete from ensamble
    where idEnsamble = i_idEnsamble;
end $$
delimiter ;

# CUARTA SECCION: GETS DE CADA TABLA

# Gets de Usuario
# 37. Obtener nombre de usuario
delimiter $$
create function GetNombreUsuario(i_idUsuario int) 
returns varchar(50)
deterministic
begin
    declare r_nombreUsuario varchar(50);
    select nombreUsuario into r_nombreUsuario from usuario where idUsuario = i_idUsuario;
    return r_nombreUsuario;
end $$
delimiter ;

# 38. Obtener rol de usuario
delimiter $$
create function GetRolUsuario(i_idUsuario int) 
returns varchar(25)
deterministic
begin
    declare r_rolUsuario varchar(25);
    select rolUsuario into r_rolUsuario from usuario where idUsuario = i_idUsuario;
    return r_rolUsuario;
end $$
delimiter ;

# 39. Obtener nickname de usuario
delimiter $$
create function GetNickname(i_idUsuario int) 
returns varchar(50)
deterministic
begin
    declare r_nickname varchar(50);
    select nickname into r_nickname from usuario where idUsuario = i_idUsuario;
    return r_nickname;
end $$
delimiter ;

# 40. Obtener clave de usuario
delimiter $$
create function GetClaveUsuario(i_idUsuario int) 
returns varchar(100)
deterministic
begin
    declare r_claveUsuario varchar(100);
    select claveUsuario into r_claveUsuario from usuario where idUsuario = i_idUsuario;
    return r_claveUsuario;
end $$
delimiter ;

# 41. Obtener correo de usuario
delimiter $$
create function GetCorreoUsuario(i_idUsuario int) 
returns varchar(256)
deterministic
reads sql data
begin
    declare r_correoUsuario varchar(256);
    select correoUsuario into r_correoUsuario from usuario where idUsuario = i_idUsuario;
    return r_correoUsuario;
end $$
delimiter ;

# 42. Obtener telefono de usuario
delimiter $$
create function GetTelefonoUsuario(i_idUsuario int) 
returns varchar(20)
deterministic
begin
    declare r_telefonoUsuario varchar(20);
    select telefonoUsuario into r_telefonoUsuario from usuario where idUsuario = i_idUsuario;
    return r_telefonoUsuario;
end $$
delimiter ;

# 43. Obtener estado de usuario
delimiter $$
create function GetEstadoUsuario(i_idUsuario int) 
returns varchar(25)
deterministic
begin
    declare r_estadoUsuario varchar(25);
    select estadoUsuario into r_estadoUsuario from usuario where idUsuario = i_idUsuario;
    return r_estadoUsuario;
end $$
delimiter ;

# 44. Obtener fecha de registro de usuario
delimiter $$
create function GetFechaRegistroUsuario(i_idUsuario int) 
returns timestamp
deterministic
begin
    declare r_fechaRegistroUsuario timestamp;
    select fechaRegistroUsuario into r_fechaRegistroUsuario from usuario where idUsuario = i_idUsuario;
    return r_fechaRegistroUsuario;
end $$
delimiter ;

# Gets de Producto
# 45. Obtener nombre de producto
delimiter $$
create function GetNombreProducto(i_idProducto varchar(32)) 
returns varchar(128)
deterministic
begin
    declare r_nombreProducto varchar(128);
    select nombreProducto into r_nombreProducto from producto where idProducto = i_idProducto;
    return r_nombreProducto;
end $$
delimiter ;

# 46. Obtener unidad de producto
delimiter $$
create function GetUnidadProducto(i_idProducto varchar(32)) 
returns varchar(16)
deterministic
begin
    declare r_unidadProducto varchar(16);
    select unidadProducto into r_unidadProducto from producto where idProducto = i_idProducto;
    return r_unidadProducto;
end $$
delimiter ;

# Gets de Inventario
# 47. Obtener identificador de producto de inventario
delimiter $$
create function GetIdProducto(i_idInventario varchar(68)) 
returns varchar(32)
deterministic
begin
    declare r_idProductoFK varchar(32);
    select idProductoFK into r_idProductoFK from inventario where idInventario = i_idInventario;
    return r_idProductoFK;
end $$
delimiter ;

# 48. Obtener bodega de inventario
delimiter $$
create function GetBodega(i_idInventario varchar(68)) 
returns varchar(32)
deterministic
begin
    declare r_bodega varchar(32);
    select bodega into r_bodega from inventario where idInventario = i_idInventario;
    return r_bodega;
end $$
delimiter ;

# 49. Obtener cantidad de inventario
delimiter $$
create function GetCantidadInventario(i_idInventario varchar(68)) 
returns float
deterministic
begin
    declare r_cantidadInventario float;
    select cantidadInventario into r_cantidadInventario from inventario where idInventario = i_idInventario;
    return r_cantidadInventario;
end $$
delimiter ;

# 50. Obtener fecha de actualización de inventario
delimiter $$
create function GetFechaActualizacion(i_idInventario varchar(68)) 
returns date
deterministic
begin
    declare r_fechaActualizacion date;
    select fechaActualizacion into r_fechaActualizacion from inventario where idInventario = i_idInventario;
    return r_fechaActualizacion;
end $$
delimiter ;

# 51. Obtener usuario de inventario
delimiter $$
create function GetIdUsuario(i_idInventario varchar(68)) 
returns int
deterministic
begin
    declare r_idUsuarioFK int;
    select idUsuarioFK into r_idUsuarioFK from inventario where idInventario = i_idInventario;
    return r_idUsuarioFK;
end $$
delimiter ;

# Gets de Movimiento
# 52. Obtener identificador de inventario de movimiento
delimiter $$
create function GetIdInventario(i_idMovimiento int) 
returns varchar(68)
deterministic
begin
    declare r_idInventarioFK varchar(68);
    select idInventarioFK into r_idInventarioFK from movimiento where idMovimiento = i_idMovimiento;
    return r_idInventarioFK;
end $$
delimiter ;

# 53. Obtener cantidad neta de movimiento
delimiter $$
create function GetCantidadNetaMovimiento(i_idMovimiento int) 
returns float
deterministic
begin
    declare r_cantidadNetaMovimiento float;
    select cantidadNetaMovimiento into r_cantidadNetaMovimiento from movimiento where idMovimiento = i_idMovimiento;
    return r_cantidadNetaMovimiento;
end $$
delimiter ;

# 54. Obtener tipo de movimiento
delimiter $$
create function GetTipoMovimiento(i_idMovimiento int) 
returns varchar(16)
deterministic
begin
    declare r_tipoMovimiento varchar(16);
    select tipoMovimiento into r_tipoMovimiento from movimiento where idMovimiento = i_idMovimiento;
    return r_tipoMovimiento;
end $$
delimiter ;

# 55. Obtener fecha de movimiento
delimiter $$
create function GetFechaMovimiento(i_idMovimiento int) 
returns date
deterministic
begin
    declare r_fechaMovimiento date;
    select fechaMovimiento into r_fechaMovimiento from movimiento where idMovimiento = i_idMovimiento;
    return r_fechaMovimiento;
end $$
delimiter ;

# 56. Obtener concepto de movimiento
delimiter $$
create function GetConcepto(i_idMovimiento int) 
returns varchar(128)
deterministic
begin
    declare r_concepto varchar(128);
    select concepto into r_concepto from movimiento where idMovimiento = i_idMovimiento;
    return r_concepto;
end $$
delimiter ;

# Gets de Proveedor
# 57. Obtener nombre de proveedor
delimiter $$
create function GetNombreProveedor(i_nitProveedor varchar(32)) 
returns varchar(64)
deterministic
begin
    declare r_nombreProveedor varchar(64);
    select nombreProveedor into r_nombreProveedor from proveedor where nitProveedor = i_nitProveedor;
    return r_nombreProveedor;
end $$
delimiter ;

# Gets de Compra
# 58. Obtener costo unitario de compra
delimiter $$
create function GetCostoUnitarioCompra(i_idMovimientoFK int) 
returns float
deterministic
begin
    declare r_costoUnitarioCompra float;
    select costoUnitarioCompra into r_costoUnitarioCompra from compra where idMovimientoFK = i_idMovimientoFK;
    return r_costoUnitarioCompra;
end $$
delimiter ;

# 59. Obtener costo total de compra
delimiter $$
create function GetCostoTotalCompra(i_idMovimientoFK int) 
returns float
deterministic
begin
    declare r_costoTotalCompra float;
    select costoTotalCompra into r_costoTotalCompra from compra where idMovimientoFK = i_idMovimientoFK;
    return r_costoTotalCompra;
end $$
delimiter ;

# 60. Obtener nit de proveedor de compra
delimiter $$
create function GetNitProveedor(i_idMovimientoFK int) 
returns varchar(32)
deterministic
begin
    declare r_nitProveedorFK varchar(32);
    select nitProveedorFK into r_nitProveedorFK from compra where idMovimientoFK = i_idMovimientoFK;
    return r_nitProveedorFK;
end $$
delimiter ;

# Gets de Cliente
# 61. Obtener nombre de cliente
delimiter $$
create function GetNombreCliente(i_nitCliente varchar(32)) 
returns varchar(64)
deterministic
begin
    declare r_nombreCliente varchar(64);
    select nombreCliente into r_nombreCliente from cliente where nitCliente = i_nitCliente;
    return r_nombreCliente;
end $$
delimiter ;

# Gets de Venta
# 62. Obtener costo unitario de venta
delimiter $$
create function GetCostoUnitarioVenta(i_idMovimientoFK int) 
returns float
deterministic
begin
    declare r_costoUnitarioVenta float;
    select costoUnitarioVenta into r_costoUnitarioVenta from venta where idMovimientoFK = i_idMovimientoFK;
    return r_costoUnitarioVenta;
end $$
delimiter ;

# 63. Obtener costo total de venta
delimiter $$
create function GetCostoTotalVenta(i_idMovimientoFK int) 
returns float
deterministic
begin
    declare r_costoTotalVenta float;
    select costoTotalVenta into r_costoTotalVenta from venta where idMovimientoFK = i_idMovimientoFK;
    return r_costoTotalVenta;
end $$
delimiter ;

# 64. Obtener nit de cliente de venta
delimiter $$
create function GetNitCliente(i_idMovimientoFK int) 
returns varchar(32)
deterministic
begin
    declare r_nitClienteFK varchar(32);
    select nitClienteFK into r_nitClienteFK from venta where idMovimientoFK = i_idMovimientoFK;
    return r_nitClienteFK;
end $$
delimiter ;

# Gets de Ensamble
# 65. Obtener identificador del producto padre de ensamble
delimiter $$
create function GetIdProductoPadre(i_idEnsamble varchar(73)) 
returns varchar(32)
deterministic
begin
    declare r_idProductoPadreFK varchar(32);
    select idProductoPadreFK into r_idProductoPadreFK from ensamble where idEnsamble = i_idEnsamble;
    return r_idProductoPadreFK;
end $$
delimiter ;

# 66. Obtener identificador del producto hijo de ensamble
delimiter $$
create function GetIdProductoHijo(i_idEnsamble varchar(73)) 
returns varchar(32)
deterministic
begin
    declare r_idProductoHijoFK varchar(32);
    select idProductoHijoFK into r_idProductoHijoFK from ensamble where idEnsamble = i_idEnsamble;
    return r_idProductoHijoFK;
end $$
delimiter ;

# 67. Obtener razón entre hijo y padre de ensamble
delimiter $$
create function GetRazon(i_idEnsamble varchar(73)) 
returns float
deterministic
begin
    declare r_razonHijosPorPadre float;
    select razonHijosPorPadre into r_razonHijosPorPadre from ensamble where idEnsamble = i_idEnsamble;
    return r_razonHijosPorPadre;
end $$
delimiter ;

### QUINTA SECCION: ESTRUCTURA DE IMPORTACION

# 68. Generar identificador de inventario
delimiter $$
create function GenerarIdInventario(
    i_idProducto varchar(32),
    i_bodega varchar(32))
returns varchar(68)
deterministic
begin
    return concat(i_idProducto, '_in_', i_bodega);
end $$
delimiter ;

# 69. Generar identificador de ensamble
delimiter $$
create function GenerarIdEnsamble(
    i_idProductoPadre varchar(32),
    i_idProductoHijo varchar(32))
returns varchar(73)
deterministic
begin
    return concat(i_idProductoPadre, '_padreDe_', i_idProductoHijo);
end $$
delimiter ;

# 70. Registrar productos de importacion
delimiter $$
create procedure RegistrarProductosDeImportacion()
begin
    insert ignore into producto(idProducto, nombreProducto, unidadProducto)
    select distinct idProducto, nombreProducto, unidadProducto
    from tablaImportacion;
end $$
delimiter ;

# 71. Registrar inventarios de importacion
delimiter $$
create procedure RegistrarInventariosDeImportacion()
begin
    insert ignore into inventario(
        idInventario, idProductoFK, bodega,
        cantidadInventario, fechaActualizacion, idUsuarioFK)
    select
        GenerarIdInventario(idProducto, bodega), idProducto, bodega,
        cantidadInventario, fecha, NULL
    from tablaImportacion;
end $$
delimiter ;

# 72. Actualizar inventario con cada movimiento
delimiter $$
create trigger autoActualizarInventario
after insert on movimiento
for each row
begin
    update inventario
    set cantidadInventario = cantidadInventario + new.cantidadNetaMovimiento,
        fechaActualizacion = new.fechaMovimiento
    where idInventario = new.idInventarioFK;
end $$
delimiter ;

# 73. Registrar movimientos de importación
delimiter $$
create procedure RegistrarMovimientosDeImportacion()
begin
    insert ignore into movimiento(
        idMovimiento, idInventarioFK, cantidadNetaMovimiento,
        tipoMovimiento, fechaMovimiento, concepto)
    select distinct
        idMovimiento, GenerarIdInventario(idProducto, bodega), cantidadNetaMovimiento,
        tipoMovimiento, fecha, concepto
    from tablaImportacion;
end $$
delimiter ;

# 74. Registrar proveedores de importación
delimiter $$
create procedure RegistrarProveedoresDeImportacion()
begin
    insert ignore into proveedor(
        nitProveedor,
        nombreProveedor)
    select distinct
        nitTercero,
        nombreTercero
    from tablaImportacion
    where tipoMovimiento = 'FACTCOMP';
end $$
delimiter ;

# 75. Registrar compras de importación
delimiter $$
create procedure RegistrarComprasDeImportacion()
begin
    insert ignore into compra(
        idMovimientoFK, costoUnitarioCompra,
        costoTotalCompra, nitProveedorFK)
    select distinct
        idMovimiento, valorUnitario,
        ifnull(valorUnitario * cantidadNetaMovimiento, 0), nitTercero
    from tablaImportacion
    where tipoMovimiento = 'FACTCOMP';
end $$
delimiter ;

# 76. Registrar clientes de importación
delimiter $$
create procedure RegistrarClientesDeImportacion()
begin
    insert ignore into cliente(
        nitCliente,
        nombreCliente)
    select distinct
        nitTercero,
        nombreTercero
    from tablaImportacion
    where tipoMovimiento = 'FACTVENT';
end $$
delimiter ;

# 77. Registrar ventas de importación
delimiter $$
create procedure RegistrarVentasDeImportacion()
begin
    insert ignore into venta(
        idMovimientoFK, costoUnitarioVenta,
        costoTotalVenta, nitClienteFK)
    select distinct
        idMovimiento, valorUnitario,
        ifnull(valorUnitario * cantidadNetaMovimiento, 0), nitTercero
    from tablaImportacion
    where tipoMovimiento = 'FACTVENT';
end $$
delimiter ;

# 78. Registrar ensambles a partir de movimientos
delimiter $$
create procedure RegistrarEnsamblesPorMovimientos()
begin
    insert ignore into ensamble(
        idEnsamble,
        idProductoPadreFK,
        idProductoHijoFK,
        razonHijosPorPadre)
    select
        GenerarIdEnsamble(i1.idProductoFK, i2.idProductoFK),
        i1.idProductoFK as idProductoPadre,
        i2.idProductoFK as idProductoHijo,
        abs(m2.cantidadNetaMovimiento / m1.cantidadNetaMovimiento) as razonHijosPorPadre
    from movimiento m1
    join inventario i1 on m1.idInventarioFK = i1.idInventario
    join movimiento m2 on
        m1.concepto = m2.concepto and
        m1.tipoMovimiento = 'ENSAMBLE' and
        m2.tipoMovimiento = 'ENSAMBLE' and
        m1.cantidadNetaMovimiento < 0 and
        m2.cantidadNetaMovimiento > 0 and
        m1.idMovimiento = m2.idMovimiento + 1
    join inventario i2 on m2.idInventarioFK = i2.idInventario
    where
        i1.idProductoFK != i2.idProductoFK and
        i1.bodega = i2.bodega and
        m1.fechaMovimiento = m2.fechaMovimiento and
        not exists (
            select 1
            from ensamble e
            where e.idProductoPadreFK = i1.idProductoFK
              and e.idProductoHijoFK = i2.idProductoFK
        );
end$$
delimiter ;

# 79. Importar datos
delimiter $$
create procedure ImportarDatos()
begin
    call RegistrarProductosDeImportacion();
    call RegistrarInventariosDeImportacion();
    call RegistrarMovimientosDeImportacion();
    call RegistrarProveedoresDeImportacion();
    call RegistrarComprasDeImportacion();
    call RegistrarClientesDeImportacion();
    call RegistrarVentasDeImportacion();
    call RegistrarEnsamblesPorMovimientos();
end$$
delimiter ;

### SEXTA SECCION: OTROS RQF

# 80. Consultar ensamblados de padre
delimiter $$
create procedure ConsultarEnsambladosDePadre(in p_idProductoPadre varchar(32))
begin
    select idEnsamble, idProductoHijoFK, razonHijosPorPadre
    from ensamble
    where idProductoPadreFK = p_idProductoPadre;
end $$
delimiter ;
#call ConsultarEnsambladosDePadre('000020B'); # 1HARINA 50K ELITE REPOSTERA

# 81. Consultar existencias en cada bodega de un producto
delimiter $$
create procedure ConsultarExistencias(in p_idProducto varchar(32))
begin
    select 
        GetBodega(i.idInventario) as bodega,
        GetCantidadInventario(i.idInventario) as cantidad,
        GetFechaActualizacion(i.idInventario) as fechaActualizacion
    from inventario i
    where GetIdProducto(i.idInventario) = p_idProducto
    order by GetBodega(i.idInventario);
end $$
delimiter ;
#call ConsultarExistencias('000020B'); # Retorna todo el stock de 1HARINA 50K ELITE REPOSTERA

# 82. Consultar productos de proveedor
delimiter $$
create procedure ConsultarProductosDeProveedor(in p_nitProveedor varchar(32))
begin
    select distinct
        GetIdProducto(GetIdInventario(c.idMovimientoFK)) as idProducto,
        GetNombreProducto(GetIdProducto(GetIdInventario(c.idMovimientoFK))) as nombreProducto,
        GetUnidadProducto(GetIdProducto(GetIdInventario(c.idMovimientoFK))) as unidadProducto
    from compra c
    where GetNitProveedor(c.idMovimientoFK) = p_nitProveedor;
end $$
delimiter ;
#call ConsultarProductosDeProveedor('890400372'); # Retorna todos los productos de Tres Castillos

# 83. Consultar movimientos de producto por mes
delimiter $$
create procedure ConsultarMovimientosDeProductoMes(
    in p_idProducto varchar(32),
    in p_anio int,
    in p_mes int)
begin
    select 
        p.idProducto,
        GetNombreProducto(p.idProducto) as nombreProducto,
        GetUnidadProducto(p.idProducto) as unidadProducto,
        p_anio as anio,
        p_mes as mes,
        # sumatoria de movimientos positivos = entradas
        sum(case when m.cantidadNetaMovimiento > 0 then m.cantidadNetaMovimiento else 0 end) as cantidadEntrada,
        # sumatoria de movimientos negativos = salidas
        sum(case when m.cantidadNetaMovimiento < 0 then m.cantidadNetaMovimiento else 0 end) as cantidadSalida,
        # total de compras asociadas al producto en el mes
        sum(coalesce(c.costoTotalCompra, 0)) as totalCompras
    from producto p
    left join inventario i 
        on i.idProductoFK = p.idProducto
    left join movimiento m 
        on m.idInventarioFK = i.idInventario
        and year(m.fechaMovimiento) = p_anio
        and month(m.fechaMovimiento) = p_mes
    left join compra c 
        on c.idMovimientoFK = m.idMovimiento
    where p.idProducto = p_idProducto
    group by p.idProducto, p.nombreProducto, p.unidadProducto, p_anio, p_mes
    order by p.idProducto;
end $$
delimiter ;
#call ConsultarMovimientosDeProductoMes('000020B', 2025, 9); # HARINA 50K ELITE REPOSTERA

# 84. Consultar movimientos de ensamblados por mes
delimiter $$
create procedure ConsultarMovimientosDeEnsambladosPorMes(
    in p_idProductoPadre varchar(32),
    in p_anio int,
    in p_mes int)
begin
    select 
        e.idProductoPadreFK as idProductoPadre,
        e.idProductoHijoFK as idProductoHijo,
        GetNombreProducto(e.idProductoHijoFK) as nombreProductoHijo,
        GetUnidadProducto(e.idProductoHijoFK) as unidadProducto,
        p_anio as anio,
        p_mes as mes,
        # las entradas son movimientos positivos
        sum(case when m.cantidadNetaMovimiento > 0 then m.cantidadNetaMovimiento else 0 end) as cantidadEntrada,
        # las salidas son movimientos negativos
        sum(case when m.cantidadNetaMovimiento < 0 then m.cantidadNetaMovimiento else 0 end) as cantidadSalida
    from ensamble e
    left join inventario i 
        on i.idProductoFK = e.idProductoHijoFK
    left join movimiento m 
        on m.idInventarioFK = i.idInventario
        and year(m.fechaMovimiento) = p_anio
        and month(m.fechaMovimiento) = p_mes
    where e.idProductoPadreFK = p_idProductoPadre
    group by 
        e.idProductoPadreFK, 
        e.idProductoHijoFK, 
        p_anio, 
        p_mes
    order by e.idProductoHijoFK;
end $$
delimiter ;
#call ConsultarMovimientosDeEnsambladosPorMes('000020B', 2025, 9); # 1HARINA 50K ELITE REPOSTERA

# 85. Consultar movimientos de proveedor por mes
delimiter $$
create procedure ConsultarMovimientosDeProveedorMes(
    in p_nitProveedor varchar(32),
    in p_anio int,
    in p_mes int)
begin
    select 
        p.idProducto, 
        p.nombreProducto,
        p.unidadProducto,
        p_anio as anio,
        p_mes as mes,
        # entradas: movimientos positivos
        sum(case when m.cantidadNetaMovimiento > 0 then m.cantidadNetaMovimiento else 0 end) as cantidadEntrada,
        # salidas: movimientos negativos
        sum(case when m.cantidadNetaMovimiento < 0 then m.cantidadNetaMovimiento else 0 end) as cantidadSalida,
        sum(coalesce(c.costoTotalCompra, 0)) as totalCompras
    from producto p
    left join inventario i 
        on p.idProducto = i.idProductoFK
    left join movimiento m 
        on i.idInventario = m.idInventarioFK
        and year(m.fechaMovimiento) = p_anio
        and month(m.fechaMovimiento) = p_mes
    left join compra c 
        on m.idMovimiento = c.idMovimientoFK
    where exists
		(select 1
        from compra c2
        join movimiento m2 on m2.idMovimiento = c2.idMovimientoFK
        join inventario i2 on m2.idInventarioFK = i2.idInventario
        where c2.nitProveedorFK = p_nitProveedor
          and i2.idProductoFK = p.idProducto)
    group by p.idProducto, p.nombreProducto, p.unidadProducto, p_anio, p_mes
    order by p.idProducto;
end $$
delimiter ;
#call ConsultarMovimientosDeProveedorMes('890400372', 2025, 9); # RAFAEL DEL CASTILLO & CIA

# 86. Consultar movimientos de producto por mes por bodega
delimiter $$
create procedure ConsultarMovimientosDeProductoMesPorBodega(
    in p_idProducto varchar(32),
    in p_anio int,
    in p_mes int)
begin
    select 
        p.idProducto, 
        p.nombreProducto,
        p.unidadProducto,
        p_anio as anio,
        p_mes as mes,
        i.bodega,
        # Entradas (movimientos positivos)
        sum(case when m.cantidadNetaMovimiento > 0 then m.cantidadNetaMovimiento else 0 end) as cantidadEntrada,
        # Salidas (movimientos negativos)
        sum(case when m.cantidadNetaMovimiento < 0 then m.cantidadNetaMovimiento else 0 end) as cantidadSalida,
        # Total de compras (si aplica)
        sum(coalesce(c.costoTotalCompra, 0)) as totalCompras
    from producto p
    left join inventario i 
        on p.idProducto = i.idProductoFK
    left join movimiento m 
        on i.idInventario = m.idInventarioFK
        and year(m.fechaMovimiento) = p_anio
        and month(m.fechaMovimiento) = p_mes
    left join compra c 
        on m.idMovimiento = c.idMovimientoFK
    where p.idProducto = p_idProducto
    group by p.idProducto, p.nombreProducto, p.unidadProducto, p_anio, p_mes, i.bodega
    order by i.bodega;
end $$
delimiter ;
#call ConsultarMovimientosDeProductoMesPorBodega('000020B', 2025, 9); # HARINA 50K ELITE REPOSTERA

# TRIGGERS DE INTEGRIDAD PARA EVITAR ERRORES AL ELIMINAR Y OTRAS COSAS
# Producto (referenciado por inventario y ensamble)
delimiter $$
create trigger verificarBorrarProducto
before delete on producto
for each row
begin
    if exists (select 1 from inventario where idProductoFK = old.idProducto)
       or exists (select 1 from ensamble where idProductoPadreFK = old.idProducto or idProductoHijoFK = old.idProducto) then
        signal sqlstate '45000'
        set message_text = 'No se puede eliminar el producto: existen dependencias en inventario o ensamble.';
    end if;
end $$
delimiter ;

# Usuario (referenciado por inventario)
delimiter $$
create trigger verificarBorrarUsuario
before delete on usuario
for each row
begin
    if exists (select 1 from inventario where idUsuarioFK = old.idUsuario) then
        signal sqlstate '45000'
        set message_text = 'No se puede eliminar el usuario: existen registros dependientes en inventario.';
    end if;
end $$
delimiter ;

# Inventario (referenciado por movimiento)
delimiter $$
create trigger verificarBorrarInventario
before delete on inventario
for each row
begin
    if exists (select 1 from movimiento where idInventarioFK = old.idInventario) then
        signal sqlstate '45000'
        set message_text = 'No se puede eliminar el inventario: existen movimientos asociados.';
    end if;
end $$
delimiter ;

# Movimiento (referenciado por compra y venta)
delimiter $$
create trigger verificarBorrarMovimiento
before delete on movimiento
for each row
begin
    if exists (select 1 from compra where idMovimientoFK = old.idMovimiento)
       or exists (select 1 from venta where idMovimientoFK = old.idMovimiento) then
        signal sqlstate '45000'
        set message_text = 'No se puede eliminar el movimiento: existen compras o ventas asociadas.';
    end if;
end $$
delimiter ;

# Proveedor (referenciado por compra)
delimiter $$
create trigger verificarBorrarProveedor
before delete on proveedor
for each row
begin
    if exists (select 1 from compra where nitProveedorFK = old.nitProveedor) then
        signal sqlstate '45000'
        set message_text = 'No se puede eliminar el proveedor: existen compras registradas.';
    end if;
end $$
delimiter ;

# Cliente (referenciado por venta)
delimiter $$
create trigger verificarBorrarCliente
before delete on cliente
for each row
begin
    if exists (select 1 from venta where nitClienteFK = old.nitCliente) then
        signal sqlstate '45000'
        set message_text = 'No se puede eliminar el cliente: existen ventas registradas.';
    end if;
end $$
delimiter ;

# Verificar que idInventario cumple la función GenerarIdInventario
delimiter $$
create trigger verificarInsertarInventario
before insert on inventario
for each row
begin
    declare v_idEsperado varchar(68);

    set v_idEsperado = GenerarIdInventario(new.idProductoFK, new.bodega);

    if new.idInventario != v_idEsperado then
        signal sqlstate '45000'
        set message_text = 'idInventario inválido: debe ser igual a GenerarIdInventario(idProductoFK, bodega).';
    end if;
end $$
delimiter ;
delimiter $$
create trigger verificarActualizarInventario
before update on inventario
for each row
begin
    declare v_idEsperado varchar(68);

    set v_idEsperado = GenerarIdInventario(new.idProductoFK, new.bodega);

    if new.idInventario != v_idEsperado then
        signal sqlstate '45000'
        set message_text = 'idInventario inválido en actualización: debe ser igual a GenerarIdInventario(idProductoFK, bodega).';
    end if;
end $$
delimiter ;

# Verificar que idEnsamble cumple la función GenerarIdEnsamble
delimiter $$
create trigger verificarInsertarEnsamble
before insert on ensamble
for each row
begin
    declare v_idEsperado varchar(73);

    set v_idEsperado = GenerarIdEnsamble(new.idProductoPadreFK, new.idProductoHijoFK);

    if new.idEnsamble != v_idEsperado then
        signal sqlstate '45000'
        set message_text = 'idEnsamble inválido: debe ser igual a GenerarIdEnsamble(idProductoPadreFK, idProductoHijoFK).';
    end if;
end $$
delimiter ;
delimiter $$
create trigger verificarActualizarEnsamble
before update on ensamble
for each row
begin
    declare v_idEsperado varchar(73);

    set v_idEsperado = GenerarIdEnsamble(new.idProductoPadreFK, new.idProductoHijoFK);

    if new.idEnsamble != v_idEsperado then
        signal sqlstate '45000'
        set message_text = 'idEnsamble inválido en actualización: debe ser igual a GenerarIdEnsamble(idProductoPadreFK, idProductoHijoFK).';
    end if;
end $$
delimiter ;

/* CORRER EL CODIGO */
call ImportarDatos();
#drop table tablaImportacion;

# Vistas para todas las tablas
create view vistaUsuarios as select * from usuario;
create view vistaProductos as select * from producto;
create view vistaInventarios as select * from inventario;
create view vistaMovimientos as select * from movimiento;
create view vistaProveedores as select * from proveedor;
create view vistaCompras as select * from compra;
create view vistaClientes as select * from cliente;
create view vistaVentas as select * from venta;
create view vistaEnsambles as select * from ensamble;

select * from vistaUsuarios;
select * from vistaProductos;
select * from vistaInventarios;
select * from vistaMovimientos;
select * from vistaProveedores;
select * from vistaCompras;
select * from vistaClientes;
select * from vistaVentas;
select * from vistaEnsambles;
