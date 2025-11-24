-- DEFINICION BD
create database bdInventarioTarajai;
use bdInventarioTarajai;

create table usuario(
    idUsuario int primary key IDENTITY(1,1),
    nombreUsuario varchar(50) not null,
    rolUsuario varchar(25) not null,
    nickname varchar(50) not null,
    claveUsuario varchar(100) not null,
    correoUsuario varchar(256) not null,
    telefonoUsuario varchar(20) not null,
    estadoUsuario varchar(25) not null,
    fechaRegistroUsuario DATETIME2 NOT NULL DEFAULT (GETDATE())
);

create table producto(
	idProducto varchar(32) primary key not null,
    nombreProducto varchar(128) not null,
    unidadProducto varchar(16)
);

create table inventario(
    idInventario varchar(68) primary key not null,
    idProductoFK varchar(32) not null,
    bodega varchar(32) not null,
    cantidadInventario float not null,
    fechaActualizacion date not null,
    idUsuarioFK int,
    foreign key (idProductoFK) references producto(idProducto),
    foreign key (idUsuarioFK) references usuario(idUsuario)
);

create table movimiento(
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
    foreign key (idProductoHijoFK) references producto(idProducto)
);

-- SEGUNDA SECCION: TABLA FANTASMA DE IMPORTACION

-- Esta tablita temporal es para obtener todos los datos del csv procesado
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

-- Esto carga los datos a esa tablita :)
BULK INSERT tablaImportacion
FROM 'C:\Users\use 10\Desktop\proyectoDatos\datosLimpios.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);


-- TERCERA SECCION: CRUD DE CADA TABLA

-- CRUD Usuario
-- 1. Registrar usuario
create procedure RegistrarUsuario
    @i_nombreUsuario varchar(50),
    @i_rolUsuario varchar(25),
    @i_nickname varchar(50),
    @i_claveUsuario varchar(100),
    @i_correoUsuario varchar(256),
    @i_telefonoUsuario varchar(20),
    @i_estadoUsuario varchar(25)
as
begin
	insert into usuario
			(nombreUsuario, rolUsuario, nickname, claveUsuario,
			correoUsuario, telefonoUsuario, estadoUsuario)
        values
			(@i_nombreUsuario, @i_rolUsuario, @i_nickname, @i_claveUsuario,
            @i_correoUsuario, @i_telefonoUsuario, @i_estadoUsuario);
end;
go

-- 2. Consultar usuarios
create procedure ConsultarUsuarios
as
begin
    select * from usuario;
end;
go

-- 3. Modificar usuario
create procedure ModificarUsuario
    @i_idUsuario int,
    @i_nombreUsuario varchar(50),
    @i_rolUsuario varchar(25),
    @i_nickname varchar(50),
    @i_claveUsuario varchar(100),
    @i_correoUsuario varchar(256),
    @i_telefonoUsuario varchar(20),
    @i_estadoUsuario varchar(25)
as
begin
	update usuario set 
		nombreUsuario = @i_nombreUsuario,
		rolUsuario = @i_rolUsuario,
		nickname = @i_nickname,
		claveUsuario = @i_claveUsuario,
		correoUsuario = @i_correoUsuario,
		telefonoUsuario = @i_telefonoUsuario,
		estadoUsuario = @i_estadoUsuario
        where idUsuario = @i_idUsuario;
end;
go

-- 4. Eliminar usuario
create procedure EliminarUsuario
    @i_idUsuario int
as
begin
    delete from usuario
    where idUsuario = @i_idUsuario;
end;
go

-- CRUD Producto
-- 5. Registrar producto
create procedure RegistrarProducto
	@i_idProducto varchar(32),
    @i_nombreProducto varchar(128),
    @i_unidadProducto varchar(16)
as
begin
    IF NOT EXISTS (
        SELECT 1
        FROM producto
        WHERE idProducto = @i_idProducto
    )
    BEGIN
        INSERT INTO producto (idProducto, nombreProducto, unidadProducto)
        VALUES (@i_idProducto, @i_nombreProducto, @i_unidadProducto);
    END
end;
go

-- 6. Consultar productos
create procedure ConsultarProductos
as
begin
	select * from producto;
end;
go

-- 7. Modificar producto
create procedure ModificarProducto
    @i_idProducto varchar(32),
    @i_nombreProducto varchar(128),
    @i_unidadProducto varchar(16)
as
begin
    update producto set 
        nombreProducto = @i_nombreProducto,
        unidadProducto = @i_unidadProducto
    where idProducto = @i_idProducto;
end;
go

-- 8. Eliminar producto
create procedure EliminarProducto
    @i_idProducto varchar(32)
as
begin
    delete from Producto
    where idProducto = @i_idProducto;
end;
go

-- CRUD Inventario
-- 9. Registrar inventario
create procedure RegistrarInventario
    @i_idInventario varchar(68),
    @i_idProductoFK varchar(32),
    @i_bodega varchar(32),
    @i_cantidadInventario float,
    @i_fechaActualizacion date,
    @i_idUsuarioFK int
as
begin
    IF NOT EXISTS (
        SELECT 1
        FROM inventario
        WHERE idInventario = @i_idInventario
    )
    BEGIN
        INSERT INTO inventario (
            idInventario, idProductoFK, bodega,
            cantidadInventario, fechaActualizacion, idUsuarioFK
        )
        VALUES (
            @i_idInventario, @i_idProductoFK, @i_bodega,
            @i_cantidadInventario, @i_fechaActualizacion, @i_idUsuarioFK
        );
    END
end;
go

-- 10. Consultar inventarios
create procedure ConsultarInventarios
as
begin
    select * from inventario;
end;
go

-- 11. Modificar inventario
create procedure ModificarInventario
    @i_idInventario varchar(68),
    @i_idProductoFK varchar(32),
    @i_bodega varchar(32),
    @i_cantidadInventario float,
    @i_fechaActualizacion date,
    @i_idUsuarioFK int
as
begin
    update inventario set
        idProductoFK = @i_idProductoFK,
        bodega = @i_bodega,
        cantidadInventario = @i_cantidadInventario,
        fechaActualizacion = @i_fechaActualizacion,
        idUsuarioFK = @i_idUsuarioFK
    where idInventario = @i_idInventario;
end;
go

-- 12. Eliminar inventario
create procedure EliminarInventario
    @i_idInventario varchar(68)
as
begin
    delete from inventario
    where idInventario = @i_idInventario;
end;
go

-- CRUD Movimiento
-- 13. Registrar movimiento
create procedure RegistrarMovimiento
    @i_idMovimiento int,
    @i_idInventarioFK varchar(68),
    @i_cantidadNetaMovimiento float,
    @i_tipoMovimiento varchar(16),
    @i_fechaMovimiento date,
    @i_concepto varchar(128)
as
begin
    IF NOT EXISTS (
        SELECT 1
        FROM movimiento
        WHERE idMovimiento = @i_idMovimiento
    )
    BEGIN
        INSERT INTO movimiento (
            idMovimiento, idInventarioFK, cantidadNetaMovimiento,
            tipoMovimiento, fechaMovimiento, concepto
        )
        VALUES (
            @i_idMovimiento, @i_idInventarioFK, @i_cantidadNetaMovimiento,
            @i_tipoMovimiento, @i_fechaMovimiento, @i_concepto
        );
    END
end;
go

-- 14. Consultar movimientos
create procedure ConsultarMovimientos
as
begin
    select * from movimiento;
end;
go

-- 15. Modificar movimientos
create procedure ModificarMovimiento
    @i_idMovimiento int,
    @i_idInventarioFK varchar(68),
    @i_cantidadNetaMovimiento float,
    @i_tipoMovimiento varchar(16),
    @i_fechaMovimiento date,
    @i_concepto varchar(128)
as
begin
    update movimiento set 
        idInventarioFK = @i_idInventarioFK,
        cantidadNetaMovimiento = @i_cantidadNetaMovimiento,
        tipoMovimiento = @i_tipoMovimiento,
        fechaMovimiento = @i_fechaMovimiento,
        concepto = @i_concepto
    where idMovimiento = @i_idMovimiento;
end;
go

-- 16. Eliminar movimiento
create procedure EliminarMovimiento
    @i_idMovimiento int
as
begin
    delete from movimiento
    where idMovimiento = @i_idMovimiento;
end;
go

-- CRUD Proveedor
-- 17. Registrar proveedor
create procedure RegistrarProveedor
    @i_nitProveedor varchar(32),
    @i_nombreProveedor varchar(64)
as
begin
    IF NOT EXISTS (
        SELECT 1
        FROM proveedor
        WHERE nitProveedor = @i_nitProveedor
    )
    BEGIN
        INSERT INTO proveedor (nitProveedor, nombreProveedor)
        VALUES (@i_nitProveedor, @i_nombreProveedor);
    END
end;
go

-- 18. Consultar proveedores
create procedure ConsultarProveedores
as
begin
    select * from proveedor;
end;
go

-- 19. Modificar proveedor
create procedure ModificarProveedor
    @i_nitProveedor varchar(32),
    @i_nombreProveedor varchar(64)
as
begin
    update proveedor
    set nombreProveedor = @i_nombreProveedor
    where nitProveedor = @i_nitProveedor;
end;
go

-- 20. Eliminar proveedor
create procedure EliminarProveedor
    @i_nitProveedor varchar(32)
as
begin
    delete from proveedor
    where nitProveedor = @i_nitProveedor;
end;
go

-- CRUD Compra
-- 21. Registrar compra
create procedure RegistrarCompra
    @i_idMovimientoFK int,
    @i_costoUnitarioCompra float,
    @i_costoTotalCompra float,
    @i_nitProveedorFK varchar(32)
as
begin
    IF NOT EXISTS (
        SELECT 1
        FROM compra
        WHERE idMovimientoFK = @i_idMovimientoFK
    )
    BEGIN
        INSERT INTO compra
        (
            idMovimientoFK,
            costoUnitarioCompra,
            costoTotalCompra,
            nitProveedorFK
        )
        VALUES
        (
            @i_idMovimientoFK,
            @i_costoUnitarioCompra,
            @i_costoTotalCompra,
            @i_nitProveedorFK
        );
    END
end;
go

-- 22. Consultar compras
create procedure ConsultarCompras
as
begin
    select * from compra;
end;
go

-- 23. Modificar compra
create procedure ModificarCompra
    @i_idMovimientoFK int,
    @i_costoUnitarioCompra float,
    @i_costoTotalCompra float,
    @i_nitProveedorFK varchar(32)
as
begin
    update compra set
		costoUnitarioCompra = @i_costoUnitarioCompra,
        costoTotalCompra = @i_costoTotalCompra,
        nitProveedorFK = @i_nitProveedorFK
    where idMovimientoFK = @i_idMovimientoFK;
end;
go

-- 24. Eliminar compra
create procedure EliminarCompra
    @i_idMovimientoFK int
as
begin
    delete from compra
    where idMovimientoFK = @i_idMovimientoFK;
end;
go

-- CRUD Cliente
-- 25. Registrar cliente
create procedure RegistrarCliente
    @i_nitCliente varchar(32),
    @i_nombreCliente varchar(64)
as
begin
    IF NOT EXISTS (
        SELECT 1
        FROM cliente
        WHERE nitCliente = @i_nitCliente
    )
    BEGIN
        INSERT INTO cliente (nitCliente, nombreCliente)
        VALUES (@i_nitCliente, @i_nombreCliente);
    END
end;
go

-- 26. Consultar clientes
create procedure ConsultarClientes
as
begin
    select * from cliente;
end;
go

-- 27. Modificar cliente
create procedure ModificarCliente
    @i_nitCliente varchar(32),
    @i_nombreCliente varchar(64)
as
begin
    update cliente set nombreCliente = @i_nombreCliente
    where nitCliente = @i_nitCliente;
end;
go

-- 28. Eliminar cliente
create procedure EliminarCliente
    @i_nitCliente varchar(32)
as
begin
    delete from cliente
    where nitCliente = @i_nitCliente;
end;
go

-- CRUD Venta
-- 29. Registrar venta
create procedure RegistrarVenta
    @i_idMovimientoFK int,
    @i_costoUnitarioVenta float,
    @i_costoTotalVenta float,
    @i_nitClienteFK varchar(32)
as
begin
    IF NOT EXISTS (
        SELECT 1
        FROM venta
        WHERE idMovimientoFK = @i_idMovimientoFK
    )
    BEGIN
        INSERT INTO venta
        (
            idMovimientoFK,
            costoUnitarioVenta,
            costoTotalVenta,
            nitClienteFK
        )
        VALUES
        (
            @i_idMovimientoFK,
            @i_costoUnitarioVenta,
            @i_costoTotalVenta,
            @i_nitClienteFK
        );
    END
end;
go

-- 30. Consultar ventas
create procedure ConsultarVentas
as
begin
    select * from venta;
end;
go

-- 31. Modificar venta
create procedure ModificarVenta
    @i_idMovimientoFK int,
    @i_costoUnitarioVenta float,
    @i_costoTotalVenta float,
    @i_nitClienteFK varchar(32)
as
begin
    update venta set 
        costoUnitarioVenta = @i_costoUnitarioVenta,
        costoTotalVenta = @i_costoTotalVenta,
        nitClienteFK = @i_nitClienteFK
    where idMovimientoFK = @i_idMovimientoFK;
end;
go

-- 32. Eliminar venta
create procedure EliminarVenta
    @i_idMovimientoFK int
as
begin
    delete from venta
    where idMovimientoFK = @i_idMovimientoFK;
end;
go

-- CRUD Ensamble
-- 33. Registrar ensamble
create procedure RegistrarEnsamble
    @i_idEnsamble varchar(73),
    @i_idProductoPadreFK varchar(32),
    @i_idProductoHijoFK varchar(32),
    @i_razonHijosPorPadre float
as
begin
    IF NOT EXISTS (
        SELECT 1
        FROM ensamble
        WHERE idEnsamble = @i_idEnsamble
    )
    BEGIN
        INSERT INTO ensamble
        (
            idEnsamble,
            idProductoPadreFK,
            idProductoHijoFK,
            razonHijosPorPadre
        )
        VALUES
        (
            @i_idEnsamble,
            @i_idProductoPadreFK,
            @i_idProductoHijoFK,
            @i_razonHijosPorPadre
        );
    END
end;
go

-- 34. Consultar ensambles
create procedure ConsultarEnsambles
as
begin
    select * from ensamble;
end;
go

-- 35. Modificar ensamble
create procedure ModificarEnsamble
    @i_idEnsamble varchar(73),
    @i_idProductoPadreFK varchar(32),
    @i_idProductoHijoFK varchar(32),
    @i_razonHijosPorPadre float
as
begin
    update ensamble set
        idProductoPadreFK = @i_idProductoPadreFK,
        idProductoHijoFK = @i_idProductoHijoFK,
        razonHijosPorPadre = @i_razonHijosPorPadre
    where idEnsamble = @i_idEnsamble;
end;
go

-- 36. Eliminar ensamble
create procedure EliminarEnsamble
    @i_idEnsamble varchar(73)
as
begin
    delete from ensamble
    where idEnsamble = @i_idEnsamble;
end;
go

-- CUARTA SECCION: GETS DE CADA TABLA

-- Gets de Usuario
-- 37. Obtener nombre de usuario
create function GetNombreUsuario(@i_idUsuario int) 
returns varchar(50)
as
begin
    declare @r_nombreUsuario varchar(50);
    select @r_nombreUsuario = nombreUsuario from usuario where idUsuario = @i_idUsuario;
    return @r_nombreUsuario;
end;
go

-- 38. Obtener rol de usuario
create function GetRolUsuario(@i_idUsuario int) 
returns varchar(25)
as
begin
    declare @r_rolUsuario varchar(25);
    select @r_rolUsuario = rolUsuario from usuario where idUsuario = @i_idUsuario;
    return @r_rolUsuario;
end;
go

-- 39. Obtener nickname de usuario
create function GetNickname(@i_idUsuario int) 
returns varchar(50)
as
begin
    declare @r_nickname varchar(50);
    select @r_nickname = nickname from usuario where idUsuario = @i_idUsuario;
    return @r_nickname;
end;
go

-- 40. Obtener clave de usuario
create function GetClaveUsuario(@i_idUsuario int) 
returns varchar(100)
as
begin
    declare @r_claveUsuario varchar(100);
    select @r_claveUsuario = claveUsuario from usuario where idUsuario = @i_idUsuario;
    return @r_claveUsuario;
end;
go

-- 41. Obtener correo de usuario
create function GetCorreoUsuario(@i_idUsuario int) 
returns varchar(256)
as
begin
    declare @r_correoUsuario varchar(256);
    select @r_correoUsuario = correoUsuario from usuario where idUsuario = @i_idUsuario;
    return @r_correoUsuario;
end;
go

-- 42. Obtener telefono de usuario

create function GetTelefonoUsuario(@i_idUsuario int) 
returns varchar(20)
as
begin
    declare @r_telefonoUsuario varchar(20);
    select @r_telefonoUsuario = telefonoUsuario from usuario where idUsuario = @i_idUsuario;
    return @r_telefonoUsuario;
end;
go

-- 43. Obtener estado de usuario
create function GetEstadoUsuario(@i_idUsuario int) 
returns varchar(25)
as
begin
    declare @r_estadoUsuario varchar(25);
    select @r_estadoUsuario = estadoUsuario from usuario where idUsuario = @i_idUsuario;
    return @r_estadoUsuario;
end;
go

-- 44. Obtener fecha de registro de usuario
create function GetFechaRegistroUsuario(@i_idUsuario int) 
returns DATETIME2
as
begin
    declare @r_fechaRegistroUsuario DATETIME2;
    select @r_fechaRegistroUsuario = fechaRegistroUsuario from usuario where idUsuario = @i_idUsuario;
    return @r_fechaRegistroUsuario;
end;
go

-- Gets de Producto
-- 45. Obtener nombre de producto
create function GetNombreProducto(@i_idProducto varchar(32)) 
returns varchar(128)
as
begin
    declare @r_nombreProducto varchar(128);
    select @r_nombreProducto = nombreProducto from producto where idProducto = @i_idProducto;
    return @r_nombreProducto;
end;
go

-- 46. Obtener unidad de producto
create function GetUnidadProducto(@i_idProducto varchar(32)) 
returns varchar(16)
as
begin
    declare @r_unidadProducto varchar(16);
    select @r_unidadProducto = unidadProducto from producto where idProducto = @i_idProducto;
    return @r_unidadProducto;
end;
go

-- Gets de Inventario
-- 47. Obtener identificador de producto de inventario
create function GetIdProducto(@i_idInventario varchar(68)) 
returns varchar(32)
as
begin
    declare @r_idProductoFK varchar(32);
    select @r_idProductoFK = idProductoFK from inventario where idInventario = @i_idInventario;
    return @r_idProductoFK;
end;
go

-- 48. Obtener bodega de inventario
create function GetBodega(@i_idInventario varchar(68)) 
returns varchar(32)
as
begin
    declare @r_bodega varchar(32);
    select @r_bodega = bodega from inventario where idInventario = @i_idInventario;
    return @r_bodega;
end;
go

-- 49. Obtener cantidad de inventario
create function GetCantidadInventario(@i_idInventario varchar(68)) 
returns float
as
begin
    declare @r_cantidadInventario float;
    select @r_cantidadInventario = cantidadInventario from inventario where idInventario = @i_idInventario;
    return @r_cantidadInventario;
end;
go

-- 50. Obtener fecha de actualización de inventario
create function GetFechaActualizacion(@i_idInventario varchar(68)) 
returns date
as
begin
    declare @r_fechaActualizacion date;
    select @r_fechaActualizacion = fechaActualizacion from inventario where idInventario = @i_idInventario;
    return @r_fechaActualizacion;
end;
go

-- 51. Obtener usuario de inventario
create function GetIdUsuario(@i_idInventario varchar(68)) 
returns int
as
begin
    declare @r_idUsuarioFK int;
    select @r_idUsuarioFK = idUsuarioFK from inventario where idInventario = @i_idInventario;
    return @r_idUsuarioFK;
end;
go

-- Gets de Movimiento
-- 52. Obtener identificador de inventario de movimiento
create function GetIdInventario(@i_idMovimiento int) 
returns varchar(68)
as
begin
    declare @r_idInventarioFK varchar(68);
    select @r_idInventarioFK = idInventarioFK from movimiento where idMovimiento = @i_idMovimiento;
    return @r_idInventarioFK;
end;
go

-- 53. Obtener cantidad neta de movimiento

create function GetCantidadNetaMovimiento(@i_idMovimiento int) 
returns float
as
begin
    declare @r_cantidadNetaMovimiento float;
    select @r_cantidadNetaMovimiento = cantidadNetaMovimiento from movimiento where idMovimiento = @i_idMovimiento;
    return @r_cantidadNetaMovimiento;
end;
go

-- 54. Obtener tipo de movimiento
create function GetTipoMovimiento(@i_idMovimiento int) 
returns varchar(16)
as
begin
    declare @r_tipoMovimiento varchar(16);
    select @r_tipoMovimiento = tipoMovimiento from movimiento where idMovimiento = @i_idMovimiento;
    return @r_tipoMovimiento;
end;
go

-- 55. Obtener fecha de movimiento
create function GetFechaMovimiento(@i_idMovimiento int) 
returns date
as
begin
    declare @r_fechaMovimiento date;
    select @r_fechaMovimiento = fechaMovimiento from movimiento where idMovimiento = @i_idMovimiento;
    return @r_fechaMovimiento;
end;
go

-- 56. Obtener concepto de movimiento
create function GetConcepto(@i_idMovimiento int) 
returns varchar(128)
as
begin
    declare @r_concepto varchar(128);
    select @r_concepto = concepto from movimiento where idMovimiento = @i_idMovimiento;
    return @r_concepto;
end;
go

-- Gets de Proveedor
-- 57. Obtener nombre de proveedor
create function GetNombreProveedor(@i_nitProveedor varchar(32)) 
returns varchar(64)
as
begin
    declare @r_nombreProveedor varchar(64);
    select @r_nombreProveedor = nombreProveedor from proveedor where nitProveedor = @i_nitProveedor;
    return @r_nombreProveedor;
end;
go

-- Gets de Compra
-- 58. Obtener costo unitario de compra
create function GetCostoUnitarioCompra(@i_idMovimientoFK int) 
returns float
as
begin
    declare @r_costoUnitarioCompra float;
    select @r_costoUnitarioCompra = costoUnitarioCompra from compra where idMovimientoFK = @i_idMovimientoFK;
    return @r_costoUnitarioCompra;
end;
go

-- 59. Obtener costo total de compra
create function GetCostoTotalCompra(@i_idMovimientoFK int) 
returns float
as
begin
    declare @r_costoTotalCompra float;
    select @r_costoTotalCompra = costoTotalCompra from compra where idMovimientoFK = @i_idMovimientoFK;
    return @r_costoTotalCompra;
end;
go

-- 60. Obtener nit de proveedor de compra
create function GetNitProveedor(@i_idMovimientoFK int) 
returns varchar(32)
as
begin
    declare @r_nitProveedorFK varchar(32);
    select @r_nitProveedorFK = nitProveedorFK from compra where idMovimientoFK = @i_idMovimientoFK;
    return @r_nitProveedorFK;
end;
go

-- Gets de Cliente
-- 61. Obtener nombre de cliente
create function GetNombreCliente(@i_nitCliente varchar(32)) 
returns varchar(64)
as
begin
    declare @r_nombreCliente varchar(64);
    select @r_nombreCliente = nombreCliente from cliente where nitCliente = @i_nitCliente;
    return @r_nombreCliente;
end;
go

-- Gets de Venta
-- 62. Obtener costo unitario de venta
create function GetCostoUnitarioVenta(@i_idMovimientoFK int) 
returns float
as
begin
    declare @r_costoUnitarioVenta float;
    select @r_costoUnitarioVenta = costoUnitarioVenta from venta where idMovimientoFK = @i_idMovimientoFK;
    return @r_costoUnitarioVenta;
end;
go

-- 63. Obtener costo total de venta
create function GetCostoTotalVenta(@i_idMovimientoFK int) 
returns float
as
begin
    declare @r_costoTotalVenta float;
    select @r_costoTotalVenta = costoTotalVenta from venta where idMovimientoFK = @i_idMovimientoFK;
    return @r_costoTotalVenta;
end;
go

-- 64. Obtener nit de cliente de venta
create function GetNitCliente(@i_idMovimientoFK int) 
returns varchar(32)
as
begin
    declare @r_nitClienteFK varchar(32);
    select @r_nitClienteFK = nitClienteFK from venta where idMovimientoFK = @i_idMovimientoFK;
    return @r_nitClienteFK;
end;
go

-- Gets de Ensamble
-- 65. Obtener identificador del producto padre de ensamble
create function GetIdProductoPadre(@i_idEnsamble varchar(73)) 
returns varchar(32)
as
begin
    declare @r_idProductoPadreFK varchar(32);
    select @r_idProductoPadreFK = idProductoPadreFK from ensamble where idEnsamble = @i_idEnsamble;
    return @r_idProductoPadreFK;
end;
go

-- 66. Obtener identificador del producto hijo de ensamble
create function GetIdProductoHijo(@i_idEnsamble varchar(73)) 
returns varchar(32)
as
begin
    declare @r_idProductoHijoFK varchar(32);
    select @r_idProductoHijoFK = idProductoHijoFK from ensamble where idEnsamble = @i_idEnsamble;
    return @r_idProductoHijoFK;
end;
go

-- 67. Obtener razón entre hijo y padre de ensamble

create function GetRazon(@i_idEnsamble varchar(73)) 
returns float
as
begin
    declare @r_razonHijosPorPadre float;
    select @r_razonHijosPorPadre = razonHijosPorPadre from ensamble where idEnsamble = @i_idEnsamble;
    return @r_razonHijosPorPadre;
end;
go

------ QUINTA SECCION: ESTRUCTURA DE IMPORTACION

-- 68. Generar identificador de inventario
create function GenerarIdInventario(
    @i_idProducto varchar(32),
    @i_bodega varchar(32))
returns varchar(68)
as
begin
    return concat(@i_idProducto, '_in_', @i_bodega);
end;
go

-- 69. Generar identificador de ensamble
create function GenerarIdEnsamble(
    @i_idProductoPadre varchar(32),
    @i_idProductoHijo varchar(32))
returns varchar(73)
as
begin
    return concat(@i_idProductoPadre, '_padreDe_', @i_idProductoHijo);
end;
go

-- 70. Registrar productos de importacion
create procedure RegistrarProductosDeImportacion
as
begin
    INSERT INTO producto (idProducto, nombreProducto, unidadProducto)
    SELECT DISTINCT t.idProducto, t.nombreProducto, t.unidadProducto
    FROM tablaImportacion t
    WHERE NOT EXISTS (
        SELECT 1
        FROM producto p
        WHERE p.idProducto = t.idProducto
    );
end;
go

-- 71. Registrar inventarios de importacion
create procedure RegistrarInventariosDeImportacion
AS
BEGIN
    ;WITH Dedup AS (
        SELECT *
        FROM (
            SELECT
                dbo.GenerarIdInventario(idProducto, bodega) AS idInventario,
                idProducto,
                bodega,
                cantidadInventario,
                fecha,
                ROW_NUMBER() OVER (
                    PARTITION BY dbo.GenerarIdInventario(idProducto, bodega)
                    ORDER BY fecha DESC
                ) AS rn
            FROM tablaImportacion
        ) t
        WHERE rn = 1  -- keep only one row per generated idInventario
    )
    INSERT INTO inventario (
        idInventario, idProductoFK, bodega,
        cantidadInventario, fechaActualizacion, idUsuarioFK
    )
    SELECT
        idInventario, idProducto, bodega, cantidadInventario, fecha, NULL
    FROM Dedup
    WHERE NOT EXISTS (
        SELECT 1
        FROM inventario i
        WHERE i.idInventario = Dedup.idInventario
    );
END;
GO

-- 72. Actualizar inventario con cada movimiento
CREATE TRIGGER autoActualizarInventario
ON movimiento
AFTER INSERT
AS
BEGIN
    -- Aggregate net movement per inventario in case multiple rows were inserted at once
    ;WITH NetMovements AS (
        SELECT
            idInventarioFK,
            SUM(cantidadNetaMovimiento) AS totalMovimiento,
            MAX(fechaMovimiento) AS lastFecha
        FROM inserted
        WHERE idInventarioFK IS NOT NULL
        GROUP BY idInventarioFK
    )
    UPDATE inv
    SET
        inv.cantidadInventario = inv.cantidadInventario + nm.totalMovimiento,
        inv.fechaActualizacion = nm.lastFecha
    FROM inventario inv
    INNER JOIN NetMovements nm
        ON inv.idInventario = nm.idInventarioFK;
END;
GO

-- 73. Registrar movimientos de importación
create procedure RegistrarMovimientosDeImportacion
as
begin
    INSERT INTO movimiento(
        idMovimiento,
        idInventarioFK,
        cantidadNetaMovimiento,
        tipoMovimiento,
        fechaMovimiento,
        concepto
    )
    SELECT 
        t.idMovimiento,
        dbo.GenerarIdInventario(t.idProducto, t.bodega),
        t.cantidadNetaMovimiento,
        t.tipoMovimiento,
        t.fecha,
        t.concepto
    FROM tablaImportacion t
    WHERE NOT EXISTS (
        SELECT 1
        FROM movimiento m
        WHERE m.idMovimiento = t.idMovimiento
    );
end;
go

-- 74. Registrar proveedores de importación
create procedure RegistrarProveedoresDeImportacion
as
begin
    INSERT INTO proveedor(
        nitProveedor,
        nombreProveedor
    )
    SELECT DISTINCT
        t.nitTercero,
        t.nombreTercero
    FROM tablaImportacion t
    WHERE t.tipoMovimiento = 'FACTCOMP'
      AND NOT EXISTS (
          SELECT 1
          FROM proveedor p
          WHERE p.nitProveedor = t.nitTercero
      );
end;
go

-- 75. Registrar compras de importación
create procedure RegistrarComprasDeImportacion
as
begin
    INSERT INTO compra(
        idMovimientoFK,
        costoUnitarioCompra,
        costoTotalCompra,
        nitProveedorFK
    )
    SELECT DISTINCT
        t.idMovimiento,
        t.valorUnitario,
        ISNULL(t.valorUnitario * t.cantidadNetaMovimiento, 0),
        t.nitTercero
    FROM tablaImportacion t
    WHERE t.tipoMovimiento = 'FACTCOMP'
      AND NOT EXISTS (
          SELECT 1
          FROM compra c
          WHERE c.idMovimientoFK = t.idMovimiento
            AND c.nitProveedorFK = t.nitTercero
      );
end;
go

-- 76. Registrar clientes de importación
create procedure RegistrarClientesDeImportacion
as
begin
    INSERT INTO cliente(
        nitCliente,
        nombreCliente
    )
    SELECT DISTINCT
        t.nitTercero,
        t.nombreTercero
    FROM tablaImportacion t
    WHERE t.tipoMovimiento = 'FACTVENT'
      AND NOT EXISTS (
          SELECT 1
          FROM cliente c
          WHERE c.nitCliente = t.nitTercero
      );
end;
go

-- 77. Registrar ventas de importación
create procedure RegistrarVentasDeImportacion
as
begin
    INSERT INTO venta(
        idMovimientoFK, 
        costoUnitarioVenta,
        costoTotalVenta, 
        nitClienteFK
    )
    SELECT DISTINCT
        t.idMovimiento,
        t.valorUnitario,
        ISNULL(t.valorUnitario * t.cantidadNetaMovimiento, 0),
        t.nitTercero
    FROM tablaImportacion t
    WHERE t.tipoMovimiento = 'FACTVENT'
      AND NOT EXISTS (
          SELECT 1
          FROM venta v
          WHERE v.idMovimientoFK = t.idMovimiento
      );
end;
go

-- 78. Registrar ensambles a partir de movimientos
create procedure RegistrarEnsamblesPorMovimientos
AS
BEGIN
    ;WITH CandidatePairs AS (
        SELECT
            dbo.GenerarIdEnsamble(i1.idProductoFK, i2.idProductoFK) AS idEnsamble,
            i1.idProductoFK AS idProductoPadreFK,
            i2.idProductoFK AS idProductoHijoFK,
            ABS(CAST(m2.cantidadNetaMovimiento AS FLOAT) / NULLIF(m1.cantidadNetaMovimiento, 0)) AS razonHijosPorPadre,
            ROW_NUMBER() OVER (
                PARTITION BY dbo.GenerarIdEnsamble(i1.idProductoFK, i2.idProductoFK)
                ORDER BY m1.idMovimiento
            ) AS rn
        FROM movimiento m1
        INNER JOIN inventario i1 ON m1.idInventarioFK = i1.idInventario
        INNER JOIN movimiento m2 ON 
            m1.concepto = m2.concepto AND
            m1.tipoMovimiento = 'ENSAMBLE' AND
            m2.tipoMovimiento = 'ENSAMBLE' AND
            m1.cantidadNetaMovimiento < 0 AND
            m2.cantidadNetaMovimiento > 0 AND
            m1.idMovimiento = m2.idMovimiento + 1 AND
            m1.fechaMovimiento = m2.fechaMovimiento
        INNER JOIN inventario i2 ON m2.idInventarioFK = i2.idInventario
        WHERE i1.idProductoFK != i2.idProductoFK
          AND i1.bodega = i2.bodega
    )
    INSERT INTO ensamble (idEnsamble, idProductoPadreFK, idProductoHijoFK, razonHijosPorPadre)
    SELECT c.idEnsamble, c.idProductoPadreFK, c.idProductoHijoFK, c.razonHijosPorPadre
    FROM CandidatePairs c
    WHERE c.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM ensamble e
          WHERE e.idEnsamble = c.idEnsamble
      );
END;
GO

-- 79. Importar datos
create procedure ImportarDatos
as
begin
    exec RegistrarProductosDeImportacion;
    exec RegistrarInventariosDeImportacion;
    exec RegistrarMovimientosDeImportacion;
    exec RegistrarProveedoresDeImportacion;
    exec RegistrarComprasDeImportacion;
    exec RegistrarClientesDeImportacion;
    exec RegistrarVentasDeImportacion;
    exec RegistrarEnsamblesPorMovimientos;
end;
go

------ SEXTA SECCION: OTROS RQF
-- 80. Consultar ensamblados de padre
create or alter procedure ConsultarEnsambladosDePadre
    @p_idProductoPadre varchar(32)
as
begin
    select  idEnsamble,
            @p_idProductoPadre as 'idProductoPadre',
            dbo.GetNombreProducto(@p_idProductoPadre) as 'nombreProductoPadre',
            idProductoHijoFK,
            dbo.GetNombreProducto(idProductoHijoFK) as 'nombreProductoHijo',
            razonHijosPorPadre
    from ensamble
    where idProductoPadreFK = @p_idProductoPadre;
end;
go

-- 81. Consultar existencias en cada bodega de un producto
create procedure ConsultarExistencias
    @p_idProducto varchar(32)
as
begin
    select 
        dbo.GetBodega(i.idInventario) as bodega,
        dbo.GetCantidadInventario(i.idInventario) as cantidad,
        dbo.GetFechaActualizacion(i.idInventario) as fechaActualizacion
    from inventario i
    where dbo.GetIdProducto(i.idInventario) = @p_idProducto
    order by dbo.GetBodega(i.idInventario);
end;
go

-- 82. Consultar productos de proveedor
create procedure ConsultarProductosDeProveedor
    @p_nitProveedor varchar(32)
as
begin
    select distinct
        c.nitProveedorFK as "NIT Proveedor",
        dbo.GetNombreProveedor(c.nitProveedorFK) as "Nombre Proveedor",
        dbo.GetIdProducto(dbo.GetIdInventario(c.idMovimientoFK)) as "Código Producto",
        dbo.GetNombreProducto(dbo.GetIdProducto(dbo.GetIdInventario(c.idMovimientoFK))) as "Nombre Producto",
        dbo.GetUnidadProducto(dbo.GetIdProducto(dbo.GetIdInventario(c.idMovimientoFK))) as "Unidad Producto"
    from compra c
    where c.nitProveedorFK = @p_nitProveedor;
end;
go

-- 83. Consultar movimientos de producto por mes
create procedure ConsultarMovimientosDeProductoMes
    @p_idProducto varchar(32),
    @p_anio int,
    @p_mes int
as
begin
    select 
        p.idProducto,
        dbo.GetNombreProducto(p.idProducto) as nombreProducto,
        dbo.GetUnidadProducto(p.idProducto) as unidadProducto,
        @p_anio as anio,
        @p_mes as mes,
        -- sumatoria de movimientos positivos = entradas
        sum(case when m.cantidadNetaMovimiento > 0 then m.cantidadNetaMovimiento else 0 end) as cantidadEntrada,
        -- sumatoria de movimientos negativos = salidas
        sum(case when m.cantidadNetaMovimiento < 0 then m.cantidadNetaMovimiento else 0 end) as cantidadSalida,
        -- total de compras asociadas al producto en el mes
        sum(coalesce(c.costoTotalCompra, 0)) as totalCompras
    from producto p
    left join inventario i 
        on i.idProductoFK = p.idProducto
    left join movimiento m 
        on m.idInventarioFK = i.idInventario
        and year(m.fechaMovimiento) = @p_anio
        and month(m.fechaMovimiento) = @p_mes
    left join compra c 
        on c.idMovimientoFK = m.idMovimiento
    where p.idProducto = @p_idProducto
    group by p.idProducto, p.nombreProducto, p.unidadProducto
    order by p.idProducto;
end;
go

-- 84. Consultar movimientos de ensamblados por mes
create procedure ConsultarMovimientosDeEnsambladosPorMes
    @p_idProductoPadre varchar(32),
    @p_anio int,
    @p_mes int
as
begin
    select 
        e.idProductoPadreFK as idProductoPadre,
        e.idProductoHijoFK as idProductoHijo,
        dbo.GetNombreProducto(e.idProductoHijoFK) as nombreProductoHijo,
        dbo.GetUnidadProducto(e.idProductoHijoFK) as unidadProducto,
        @p_anio as anio,
        @p_mes as mes,
        -- las entradas son movimientos positivos
        sum(case when m.cantidadNetaMovimiento > 0 then m.cantidadNetaMovimiento else 0 end) as cantidadEntrada,
        -- las salidas son movimientos negativos
        sum(case when m.cantidadNetaMovimiento < 0 then m.cantidadNetaMovimiento else 0 end) as cantidadSalida
    from ensamble e
    left join inventario i 
        on i.idProductoFK = e.idProductoHijoFK
    left join movimiento m 
        on m.idInventarioFK = i.idInventario
        and year(m.fechaMovimiento) = @p_anio
        and month(m.fechaMovimiento) = @p_mes
    where e.idProductoPadreFK = @p_idProductoPadre
    group by 
        e.idProductoPadreFK, 
        e.idProductoHijoFK
    order by e.idProductoHijoFK;
end;
go

-- 85. Consultar movimientos de proveedor por mes
create procedure ConsultarMovimientosDeProveedorMes
    @p_nitProveedor varchar(32),
    @p_anio int,
    @p_mes int
as
begin
    select 
        p.idProducto, 
        p.nombreProducto,
        p.unidadProducto,
        @p_anio as anio,
        @p_mes as mes,
        -- entradas: movimientos positivos
        sum(case when m.cantidadNetaMovimiento > 0 then m.cantidadNetaMovimiento else 0 end) as cantidadEntrada,
        -- salidas: movimientos negativos
        sum(case when m.cantidadNetaMovimiento < 0 then m.cantidadNetaMovimiento else 0 end) as cantidadSalida,
        sum(coalesce(c.costoTotalCompra, 0)) as totalCompras
    from producto p
    left join inventario i 
        on p.idProducto = i.idProductoFK
    left join movimiento m 
        on i.idInventario = m.idInventarioFK
        and year(m.fechaMovimiento) = @p_anio
        and month(m.fechaMovimiento) = @p_mes
    left join compra c 
        on m.idMovimiento = c.idMovimientoFK
    where exists
		(select 1
        from compra c2
        join movimiento m2 on m2.idMovimiento = c2.idMovimientoFK
        join inventario i2 on m2.idInventarioFK = i2.idInventario
        where c2.nitProveedorFK = @p_nitProveedor
          and i2.idProductoFK = p.idProducto)
    group by p.idProducto, p.nombreProducto, p.unidadProducto
    order by p.idProducto;
end;
go


-- 86. Consultar movimientos de producto por mes y bodega
create procedure ConsultarMovimientosDeProductoMesPorBodega
    @p_idProducto varchar(32),
    @p_anio int,
    @p_mes int
as
begin
    select 
        p.idProducto, 
        p.nombreProducto,
        p.unidadProducto,
        @p_anio as anio,
        @p_mes as mes,
        i.bodega,
        -- Entradas (movimientos positivos)
        sum(case when m.cantidadNetaMovimiento > 0 then m.cantidadNetaMovimiento else 0 end) as cantidadEntrada,
        -- Salidas (movimientos negativos)
        sum(case when m.cantidadNetaMovimiento < 0 then m.cantidadNetaMovimiento else 0 end) as cantidadSalida,
        -- Total de compras (si aplica)
        sum(coalesce(c.costoTotalCompra, 0)) as totalCompras
    from producto p
    left join inventario i 
        on p.idProducto = i.idProductoFK
    left join movimiento m 
        on i.idInventario = m.idInventarioFK
        and year(m.fechaMovimiento) = @p_anio
        and month(m.fechaMovimiento) = @p_mes
    left join compra c 
        on m.idMovimiento = c.idMovimientoFK
    where p.idProducto = @p_idProducto
    group by p.idProducto, p.nombreProducto, p.unidadProducto, i.bodega
    order by i.bodega;
end;
go

-- 87. Consultar datos padre e hijos
create procedure ResumenDatosPadreEHijos
    @i_idProductoPadre varchar(32),
    @i_anio int,
    @i_mes int
as
begin
    select 
        p.idProducto as "Código Producto",
        p.nombreProducto as "Nombre Producto",
        p.unidadProducto as "Unidad Producto",
        'Padre' as "Tipo de Producto",
        coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP', 'DEVOLPRV') then m.cantidadNetaMovimiento else 0 end), 0) as "Unidades Compradas",
        coalesce(sum(case when m.tipoMovimiento in ('FACTVENT', 'DEVOLCLI') then -1 * m.cantidadNetaMovimiento else 0 end), 0) as "Unidades Vendidas",
        coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP', 'DEVOLPRV') then dbo.GetCostoTotalCompra(m.idMovimiento) else 0 end), 0) as "Costo Invertido",
        coalesce(sum(case when m.tipoMovimiento in ('FACTVENT', 'DEVOLCLI') then -1 * dbo.GetCostoTotalVenta(m.idMovimiento) else 0 end), 0) as "Costo Recuperado",
        @i_anio as "Año",
        @i_mes as "Mes"
    from producto p
    left join inventario i on i.idProductoFK = p.idProducto
    left join movimiento m on m.idInventarioFK = i.idInventario
    where p.idProducto = @i_idProductoPadre
		and year(m.fechaMovimiento) = @i_anio
        and month(m.fechaMovimiento) = @i_mes
    group by p.idProducto, p.nombreProducto, p.unidadProducto

    union all

    select 
        p.idProducto as "Código Producto",
        p.nombreProducto as "Nombre Producto",
        p.unidadProducto as "Unidad Producto",
        'Hijo' as "Tipo de Producto",
        coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP', 'DEVOLPRV') then m.cantidadNetaMovimiento else 0 end), 0) as "Unidades Compradas",
        coalesce(sum(case when m.tipoMovimiento in ('FACTVENT', 'DEVOLCLI') then -1 * m.cantidadNetaMovimiento else 0 end), 0) as "Unidades Vendidas",
        coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP', 'DEVOLPRV') then dbo.GetCostoTotalCompra(m.idMovimiento) else 0 end), 0) as "Costo Invertido",
        coalesce(sum(case when m.tipoMovimiento in ('FACTVENT', 'DEVOLCLI') then -1 * dbo.GetCostoTotalVenta(m.idMovimiento) else 0 end), 0) as "Costo Recuperado",
        @i_anio as "Año",
        @i_mes as "Mes"
    from producto p
    inner join ensamble e on p.idProducto = e.idProductoHijoFK
    left join inventario i on i.idProductoFK = p.idProducto
    left join movimiento m on m.idInventarioFK = i.idInventario
    where e.idProductoPadreFK = @i_idProductoPadre
		and year(m.fechaMovimiento) = @i_anio
        and month(m.fechaMovimiento) = @i_mes
    group by p.idProducto, p.nombreProducto, p.unidadProducto;
end;
go

-- 88. Consultar consolidado de padre con hijos
create procedure ConsolidarDatosPadreEHijos
    @i_idProductoPadre varchar(32),
    @i_anio int,
    @i_mes int
as
begin
    -- Variables para acumular los totales de losh ijos
    declare @v_unidadesCompradasHijos float = 0;
    declare @v_unidadesVendidasHijos float = 0;
    declare @v_costoInvertidoHijos float = 0;
    declare @v_costoRecuperadoHijos float = 0;

    -- Calcular los totales de los hijos
    select 
        @v_unidadesCompradasHijos = 
        coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP', 'DEVOLPRV') 
							then (m.cantidadNetaMovimiento / e.razonHijosPorPadre) 
							else 0 end), 0),
        @v_unidadesVendidasHijos = 
        coalesce(sum(case when m.tipoMovimiento in ('FACTVENT', 'DEVOLCLI') 
							then -1 * (m.cantidadNetaMovimiento / e.razonHijosPorPadre) 
							else 0 end), 0),
        @v_costoInvertidoHijos = 
        coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP', 'DEVOLPRV') 
							then dbo.GetCostoTotalCompra(m.idMovimiento) 
							else 0 end), 0),
        @v_costoRecuperadoHijos =
        coalesce(sum(case when m.tipoMovimiento in ('FACTVENT', 'DEVOLCLI') 
							then -1 * dbo.GetCostoTotalVenta(m.idMovimiento) 
							else 0 end), 0)
    from producto p
    inner join ensamble e on p.idProducto = e.idProductoHijoFK
    left join inventario i on i.idProductoFK = p.idProducto
    left join movimiento m on m.idInventarioFK = i.idInventario
    where e.idProductoPadreFK = @i_idProductoPadre
		and year(m.fechaMovimiento) = @i_anio
		and month(m.fechaMovimiento) = @i_mes;

    -- Sumarselos a los datos del padre
    select 
        p.idProducto as "Código Producto",
        p.nombreProducto as "Nombre Producto",
        p.unidadProducto as "Unidad Producto",
        coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP', 'DEVOLPRV') 
							then m.cantidadNetaMovimiento else 0 end), 0) + @v_unidadesCompradasHijos as "Unidades Compradas",
        coalesce(sum(case when m.tipoMovimiento in ('FACTVENT', 'DEVOLCLI') 
							then -1 * m.cantidadNetaMovimiento else 0 end), 0) + @v_unidadesVendidasHijos as "Unidades Vendidas",
        coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP', 'DEVOLPRV') 
							then dbo.GetCostoTotalCompra(m.idMovimiento) else 0 end), 0) + @v_costoInvertidoHijos as "Costo Invertido",
        coalesce(sum(case when m.tipoMovimiento in ('FACTVENT', 'DEVOLCLI') 
							then -1 * dbo.GetCostoTotalVenta(m.idMovimiento) else 0 end), 0) + @v_costoRecuperadoHijos as "Costo Recuperado",
        @i_anio as "Año",
        @i_mes as "Mes"
    from producto p
    left join inventario i on i.idProductoFK = p.idProducto
    left join movimiento m on m.idInventarioFK = i.idInventario
    where p.idProducto = @i_idProductoPadre
		and year(m.fechaMovimiento) = @i_anio
		and month(m.fechaMovimiento) = @i_mes
    group by p.idProducto, p.nombreProducto, p.unidadProducto;
end;
go

-- 89. Consultar consolidado de productos de proveedor
create procedure ConsolidarProductosDeProveedor
    @i_nitProveedor varchar(32),
    @i_anio int,
    @i_mes int
as
begin
    select 
        dbo.GetNombreProveedor(@i_nitProveedor) as 'Nombre Proveedor',
        @i_nitProveedor as 'NIT Proveedor',
        p.idProducto as 'Código Producto',
        p.nombreProducto as 'Nombre Producto',
        p.unidadProducto as 'Unidad Producto',

        -- Calcular las cantidades compradasc on hijos
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP','DEVOLPRV') 
                              then m.cantidadNetaMovimiento else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTCOMP','DEVOLPRV')
                                then mm.cantidadNetaMovimiento / e.razonHijosPorPadre
                                else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and year(mm.fechaMovimiento) = @i_anio
					and month(mm.fechaMovimiento) = @i_mes
            ),0)
        ) as 'Unidades Compradas',

        -- Calcular las cantidades vendidas con hijos
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTVENT','DEVOLCLI') 
                              then -1 * m.cantidadNetaMovimiento else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTVENT','DEVOLCLI')
                                then -1 * (mm.cantidadNetaMovimiento / e.razonHijosPorPadre)
                                else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and year(mm.fechaMovimiento) = @i_anio
					and month(mm.fechaMovimiento) = @i_mes
            ),0)
        ) as 'Unidades Vendidas',

        -- Calcular el costo de las compras
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP','DEVOLPRV') 
                              then dbo.GetCostoTotalCompra(m.idMovimiento) else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTCOMP','DEVOLPRV')
                                then dbo.GetCostoTotalCompra(mm.idMovimiento) else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and year(mm.fechaMovimiento) = @i_anio
					and month(mm.fechaMovimiento) = @i_mes
            ),0)
        ) as 'Costo Invertido',

        -- Calcular el costo recuperado de las ventas
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTVENT','DEVOLCLI') 
                              then -1 * dbo.GetCostoTotalVenta(m.idMovimiento) else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTVENT','DEVOLCLI')
                                then -1 * dbo.GetCostoTotalVenta(mm.idMovimiento) else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and year(mm.fechaMovimiento) = @i_anio
					and month(mm.fechaMovimiento) = @i_mes
            ),0)
        ) as 'Costo Recuperado',
        @i_anio as "Año",
        @i_mes as "Mes"

    from producto p
    left join inventario i on i.idProductoFK = p.idProducto
    left join movimiento m on m.idInventarioFK = i.idInventario

    -- Restringido a los productos que vende el proveedor
    where exists (
        select 1
        from compra c
        where c.nitProveedorFK = @i_nitProveedor
          and dbo.GetIdProducto(dbo.GetIdInventario(c.idMovimientoFK)) = p.idProducto
    )	and year(m.fechaMovimiento) = @i_anio
		and month(m.fechaMovimiento) = @i_mes

    group by p.idProducto, p.nombreProducto, p.unidadProducto
    order by p.idProducto;
end;
go

-- 90. Consultar consolidado de productos de proveedor por bodega
create procedure ConsolidarProductosDeProveedorPorBodega
    @i_nitProveedor varchar(32),
    @i_anio int,
    @i_mes int
as
begin
    select 
        dbo.GetNombreProveedor(@i_nitProveedor) as 'Nombre Proveedor',
        @i_nitProveedor as 'NIT Proveedor',
        i.bodega as 'Bodega',
        p.idProducto as 'Código Producto',
        p.nombreProducto as 'Nombre Producto',
        p.unidadProducto as 'Unidad Producto',

        -- Unidades Compradas (agrupadas por bodega ahora tambien ayuda)
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP','DEVOLPRV') 
                              then m.cantidadNetaMovimiento else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTCOMP','DEVOLPRV')
                                then mm.cantidadNetaMovimiento / e.razonHijosPorPadre
                                else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and ii.bodega = i.bodega
                    and year(mm.fechaMovimiento) = @i_anio
					and month(mm.fechaMovimiento) = @i_mes
            ),0)
        ) as 'Unidades Compradas',

        -- Unidades Vendidas (agrupadas por bodega)
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTVENT','DEVOLCLI') 
                              then -1 * m.cantidadNetaMovimiento else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTVENT','DEVOLCLI')
                                then -1 * (mm.cantidadNetaMovimiento / e.razonHijosPorPadre)
                                else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and ii.bodega = i.bodega
                    and year(mm.fechaMovimiento) = @i_anio
					and month(mm.fechaMovimiento) = @i_mes
            ),0)
        ) as 'Unidades Vendidas',

        -- costo Invertido (agrupado por bodega)
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP','DEVOLPRV') 
                              then dbo.GetCostoTotalCompra(m.idMovimiento) else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTCOMP','DEVOLPRV')
                                then dbo.GetCostoTotalCompra(mm.idMovimiento) else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and ii.bodega = i.bodega
                    and year(mm.fechaMovimiento) = @i_anio
					and month(mm.fechaMovimiento) = @i_mes
            ),0)
        ) as 'Costo Invertido',

        -- Costo Recuperado (agrupado por bodega)
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTVENT','DEVOLCLI') 
                              then -1 * dbo.GetCostoTotalVenta(m.idMovimiento) else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTVENT','DEVOLCLI')
                                then -1 * dbo.GetCostoTotalVenta(mm.idMovimiento) else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and ii.bodega = i.bodega
                    and year(mm.fechaMovimiento) = @i_anio
					and month(mm.fechaMovimiento) = @i_mes
            ),0)
        ) as 'Costo Recuperado',
        @i_anio as "Año",
        @i_mes as "Mes"

    from producto p
    left join inventario i on i.idProductoFK = p.idProducto
    left join movimiento m on m.idInventarioFK = i.idInventario

    where exists (
        select 1
        from compra c
        where c.nitProveedorFK = @i_nitProveedor
          and dbo.GetIdProducto(dbo.GetIdInventario(c.idMovimientoFK)) = p.idProducto
    )	and year(m.fechaMovimiento) = @i_anio
		and month(m.fechaMovimiento) = @i_mes

    group by i.bodega, p.idProducto, p.nombreProducto, p.unidadProducto
    order by p.idProducto, i.bodega;
end;
go

-- 91. Consultar consolidado de productos de proveedor por bodega parametrizado por fecha
create or alter procedure ConsolidarProductosDeProveedorPorBodegaEntreFecha
    @i_nitProveedor varchar(32),
    @i_anio_in int,
    @i_mes_in int,
    @i_dia_in int,
    @i_anio_end int,
    @i_mes_end int,
    @i_dia_end int
as
begin

    DECLARE @f_in  DATETIME = DATEFROMPARTS(@i_anio_in,  @i_mes_in,  @i_dia_in);
    DECLARE @f_end DATETIME = DATEFROMPARTS(@i_anio_end, @i_mes_end, @i_dia_end);

    select 
        dbo.GetNombreProveedor(@i_nitProveedor) as 'Nombre Proveedor',
        @i_nitProveedor as 'NIT Proveedor',
        i.bodega as 'Bodega',
        p.idProducto as 'Código Producto',
        p.nombreProducto as 'Nombre Producto',
        p.unidadProducto as 'Unidad Producto',

        -- Unidades Compradas (agrupadas por bodega ahora tambien ayuda)
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP','DEVOLPRV') 
                              then m.cantidadNetaMovimiento else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTCOMP','DEVOLPRV')
                                then mm.cantidadNetaMovimiento / e.razonHijosPorPadre
                                else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and ii.bodega = i.bodega
                    and mm.fechaMovimiento BETWEEN @f_in AND @f_end
            ),0)
        ) as 'Unidades Compradas',

        -- Unidades Vendidas (agrupadas por bodega)
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTVENT','DEVOLCLI') 
                              then -1 * m.cantidadNetaMovimiento else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTVENT','DEVOLCLI')
                                then -1 * (mm.cantidadNetaMovimiento / e.razonHijosPorPadre)
                                else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and ii.bodega = i.bodega
                    and mm.fechaMovimiento BETWEEN @f_in AND @f_end
            ),0)
        ) as 'Unidades Vendidas',

        -- costo Invertido (agrupado por bodega)
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTCOMP','DEVOLPRV') 
                              then dbo.GetCostoTotalCompra(m.idMovimiento) else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTCOMP','DEVOLPRV')
                                then dbo.GetCostoTotalCompra(mm.idMovimiento) else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and ii.bodega = i.bodega
                    and mm.fechaMovimiento BETWEEN @f_in AND @f_end
            ),0)
        ) as 'Costo Invertido',

        -- Costo Recuperado (agrupado por bodega)
        (
            coalesce(sum(case when m.tipoMovimiento in ('FACTVENT','DEVOLCLI') 
                              then -1 * dbo.GetCostoTotalVenta(m.idMovimiento) else 0 end),0)
            +
            coalesce((
                select sum(case when mm.tipoMovimiento in ('FACTVENT','DEVOLCLI')
                                then -1 * dbo.GetCostoTotalVenta(mm.idMovimiento) else 0 end)
                from ensamble e
                join producto h on h.idProducto = e.idProductoHijoFK
                left join inventario ii on ii.idProductoFK = h.idProducto
                left join movimiento mm on mm.idInventarioFK = ii.idInventario
                where e.idProductoPadreFK = p.idProducto
					and ii.bodega = i.bodega
                    and mm.fechaMovimiento BETWEEN @f_in AND @f_end
            ),0)
        ) as 'Costo Recuperado'

    from producto p
    left join inventario i on i.idProductoFK = p.idProducto
    left join movimiento m on m.idInventarioFK = i.idInventario

    where exists (
        select 1
        from compra c
        where c.nitProveedorFK = @i_nitProveedor
          and dbo.GetIdProducto(dbo.GetIdInventario(c.idMovimientoFK)) = p.idProducto
    )	and m.fechaMovimiento BETWEEN @f_in AND @f_end

    group by i.bodega, p.idProducto, p.nombreProducto, p.unidadProducto
    order by p.idProducto, i.bodega;
end;
go

-- SEPTIMA SECCION: CORRER EL CODIGO
exec ImportarDatos;
