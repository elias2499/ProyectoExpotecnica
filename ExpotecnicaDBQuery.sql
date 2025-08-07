use master
go

create database Expotecnica
	on primary
		(name = Expotecnica_data,
		filename ='D:\Documentos\Expotecnica\DB\Expotecnica.mdf',
		size = 20, maxsize = unlimited, filegrowth = 10%)
	log on
		(name = Expotecnica_log,
		filename ='D:\Documentos\Expotecnica\DB\Expotecnica.ldf',
		size = 50)
go

use Expotecnica
go

                                                                               -- Creación de tablas

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
username varchar (35) not null,
passwordHash varchar not null,   -- crear hashing en el código
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

