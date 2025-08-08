use master
go

create database Expotecnica
go

use Expotecnica
go

                                                                               -- Creaci�n de tablas

create table persona
(
cedula varchar (15) primary key not null,
nombre1 varchar (35) not null,
nombre2 varchar (35) not null,
ap1 varchar (35) not null,
ap2 varchar (30) not null,
sexo varchar (1) not null,
fechaNacimiento date not null
);

create table telefono
(
idTelefono int primary key identity (0, 1),
numero varchar not null,
descripcionTelefono text null,
estadoTelefono bit default 1,
cedula varchar (15) not null,
foreign key (cedula) references persona (cedula)
);

create table correo
(
idCorreo int primary key identity (0, 1),
correo varchar (100) not null,
descripcionCorreo text null,
estadoCorreo bit default 1,
cedula varchar (15) not null,
foreign key (cedula) references persona (cedula)
);

create table direccion
(
idDireccion int primary key identity (0, 1),
provincia varchar (60) not null,
canton varchar (60) not null,
distrito varchar (60) not null,
descripcionDireccion text null,
codigoPostal varchar (15) not null,
estadoDireccion bit default 1,
cedula varchar (15) not null,
foreign key (cedula) references persona (cedula)
);

create table rol
(
idRol int primary key identity (0, 1),
nombreRol varchar (35) not null,
descripcionRol varchar (35) null,
estadoRol bit default 1 not null,
);

create table usuario
(
idUsuario int primary key identity (0, 1),
username varchar (35) not null unique,
passwordHash varchar not null,   -- crear hashing en el c�digo
estadoUsuario bit default 1 not null,
idRol int not null,
cedula varchar (15) not null,
foreign key (idRol) references rol (idRol),
foreign key (cedula) references persona (cedula)
);

create table categoria
(
idCategoria int primary key identity (0, 1),
nombreCategoria varchar (35) not null,
descripcionCategoria text not null,
estadoCategoria bit default 1 not null
);

create table proyecto
(
idProyecto int primary key identity (0, 1),
nombreProyecto varchar (35) not null,
ejeTematico text not null,
centroEducativo text not null,
logoURL text not null,
estadoProyecto bit default 1 not null,
idCategoria int not null,
idUsuario int not null,
foreign key (idCategoria) references categoria (idCategoria),
foreign key (idUsuario) references usuario (idUsuario)
);

create table estudiante
(
idEstudiante int primary key identity (0, 1),
nombreCompletoEstudiante text not null,
estadoEstudiante bit default 1 not null,
idProyecto int not null,
foreign key (idProyecto) references proyecto (idProyecto)
);

create table tipoRubrica
(
idTipo int primary key identity (0, 1),
nombreTipo text not null,
estadoTipo bit default 1 not null,
idCategoria int not null,
foreign key (idCategoria) references categoria (idCategoria)
);

create table tiempo
(
idTiempo int primary key identity (0, 1),
inicio time not null,
final time not null,
idTipo int not null,
foreign key (idTipo) references tipoRubrica (idTipo)
);

create table aCalificar
(
idACalificar int primary key identity (0, 1),
nombreACalificar text not null,
puntajeTotal int not null,
porcentajeTotal int not null,
subTotal int not null,
idTipo int not null,
foreign key (idTipo) references tipoRubrica (idTipo)
);

create table rubrica
(
idRubrica int primary key identity (0, 1),
detalleRubrica text not null,
observacionRubrica text not null,
idTipo int not null,
foreign key (idTipo) references tipoRubrica (idTipo)
);

create table caliObtenida
(
idCaliObtenida int primary key identity (0, 1),
observacionObt text not null,
puntajeObt int not null,
porcentajeObt int not null,
subTotalObt int not null,
recomendaciones text not null,
idRubrica int not null,
foreign key (idRubrica) references rubrica (idRubrica)
);

                                                                               -- Storage procedure

-- persona con usuario y rol

create procedure SP_personarolusuario

@opc int,
-- parametros persona
@cedula varchar (15),
@nombre1 varchar (35),
@nombre2 varchar (35),
@ap1 varchar (35),
@ap2 varchar (30),
@sexo varchar (1),
@fechaNacimiento date,
-- parametros telefono
@numero varchar,
@descripcionTelefono text,
-- parametros direccion
@provincia varchar (60),
@canton varchar (60),
@distrito varchar (60),
@descripcionDireccion text,
@codigoPostal varchar (15),
-- parametros correo
@correo varchar (100),
@descripcionCorreo text,
-- parametros rol
@idRol int,
-- parametros usuario\
@username varchar (35),
@passwordHash varchar,
@estadoUsuario bit

as

if @opc = 1		-- agregar persona con direccion, telefono, correo, usuario y rol.
begin
	begin transaction;
	begin try
		-- insertar persona
		insert into persona (cedula, nombre1, nombre2, ap1, ap2, sexo, fechaNacimiento)
		values (@cedula, @nombre1, @nombre2, @ap1, @ap2, @sexo, @fechaNacimiento);
		-- insertar telefono
		insert into telefono (numero, descripcionTelefono)
		values (@numero, @descripcionTelefono);
		-- insertar correo
		insert into correo (correo, descripcionCorreo)
		values (@correo, @descripcionCorreo);
		-- insertar direccion
		insert into direccion (provincia, canton, distrito, descripcionDireccion, codigoPostal)
		values (@provincia, @canton, @distrito, @descripcionDireccion, @codigoPostal);
		-- insertar usuario
		insert into usuario(username, passwordHash, idRol, cedula)
		values (@username, @passwordHash, @idRol, @cedula);
		commit transaction
	end try
	begin catch
		rollback transaction;
		throw;
	end catch;
end;

if @opc = 2		-- leer persona persona con direccion, telefono, correo, usuario y rol.
begin
	select
		-- Datos tabla persona
		p.cedula, p.nombre1, p.nombre2, p.ap1, p.ap2, p.sexo, p.fechaNacimiento,
		-- Datos tabla telefono
		t.numero, t.descripcionTelefono,
		-- Datos tabla direccion
		d.provincia, d.canton, d.distrito, d.descripcionDireccion, d.codigoPostal,
		-- Datos tabla correo
		c.correo, c.descripcionCorreo
		-- Datos tabla usuario
		u.username,
		-- Datos tabla rol
		r.nombreRol
	from
		persona as p
	inner join
		telefono as t on p.cedula = t.cedula
	inner join
		direccion as d on p.cedula = d.cedula
	inner join
		correo as c on p.cedula = c.cedula
	inner join
		usuario as u on p.cedula = u.cedula
	inner join
		rol as r on u.idRol = r.idRol
	where
		p.cedula = @cedula;
end;

if @opc = 3		-- actualizar persona, direccion, telefono y correo.
	begin transaction;
	begin try 
		-- Actualiza persona
		update persona set nombre1 = @nombre1, nombre2 = @nombre2, ap1 = @ap1, ap2 = @ap2, sexo = @sexo, fechaNacimiento = @fechaNacimiento where cedula = @cedula;
		-- Actualiza telefono
		update telefono set numero = @numero, descripcionTelefono = @descripcionTelefono where cedula = @cedula;
		-- Actualiza correo
		update correo set correo = @correo, descripcionCorreo = @descripcionCorreo where cedula = @cedula;
		-- Actualiza direccion
		update direccion set provincia = @provincia, canton = @canton, distrito = @distrito, descripcionDireccion = @descripcionDireccion, codigoPostal = @codigoPostal where cedula = @cedula;
		commit transaction
	end try
	begin catch
		rollback transaction;
		throw;
	end catch;
end;
