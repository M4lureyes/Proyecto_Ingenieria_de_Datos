# PRIMERA SECCION:ESTRUCTURA DE LA BASE DE DATOS
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

# SEGUNDA SECCION: REGISTROS E IMPORTACION DE DATOS

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

#### LOS RQF LLEGAN HASTA ACA, EN ADELANTE ES ENREDO QUE NO VA EN LOS RQF PARA LOS COMPAÑEROS

# XX. Generar identificador de inventario
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

# XX. Generar identificador de ensamble
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

# XX. Registrar productos de importacion
delimiter $$
create procedure RegistrarProductosDeImportacion()
begin
    insert ignore into producto(idProducto, nombreProducto, unidadProducto)
    select distinct idProducto, nombreProducto, unidadProducto
    from tablaImportacion;
end $$
delimiter ;

# XX. Registrar inventarios de importacion
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

# XX. Actualizar inventario con cada movimiento
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

# XX. Registrar movimientos de importación
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

# XX. Registrar proveedores de importación
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

# XX. Registrar compras de importación
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

# XX. Registrar clientes de importación
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

# XX. Registrar ventas de importación
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

# XX. Registrar ensambles a partir de movimientos
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

# XX. Importar datos
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

/* CORRER EL CODIGO */
call ImportarDatos();
drop table tablaImportacion;

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
