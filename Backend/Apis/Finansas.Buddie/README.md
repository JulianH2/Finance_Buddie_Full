# Finansas.Buddie

## Descripción del Proyecto

**Finansas.Buddie** es una aplicación web diseñada para ayudar a los usuarios a gestionar sus finanzas personales de manera eficiente. El sistema permite realizar un seguimiento de los ingresos, gastos, metas de ahorro y mantener un historial de saldos. Además, proporciona herramientas para establecer metas financieras, controlar los gastos e ingresos, y registrar transacciones de manera fácil y ordenada.

El proyecto está estructurado en capas, siguiendo un modelo de arquitectura limpio (Clean Architecture), con una API backend que interactúa con una base de datos SQL Server. Se cuenta con funciones de autenticación, manejo de usuarios y gestión de recursos financieros como las metas de ahorro y los registros de transacciones.

## Funcionalidades

- **Gestión de usuarios**: Los usuarios pueden crear cuentas, iniciar sesión y actualizar su información personal.
- **Gestión de transacciones**: Los usuarios pueden registrar ingresos y gastos, y asociarlos con categorías y metas de ahorro.
- **Metas de ahorro**: Los usuarios pueden crear, actualizar, eliminar metas de ahorro y ver su progreso.
- **Historial de saldos**: Los usuarios pueden ver su saldo actual y su historial de saldos con el tiempo.
- **Mensajes y preguntas**: Los usuarios pueden enviar preguntas y recibir respuestas sobre sus finanzas.

## Estructura de la Base de Datos

La base de datos utilizada por la aplicación es SQL Server y está compuesta por varias tablas relacionadas, cada una destinada a almacenar diferentes tipos de información relevante para el seguimiento de las finanzas.

### Crear la Base de Datos

```sql
CREATE DATABASE FINANZAS_BUDDIE
GO

USE FINANZAS_BUDDIE
GO

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(255) NOT NULL UNIQUE,
    hashContraseña VARCHAR(512) NOT NULL,
    telefono VARCHAR(20),
    fechaCreacion DATETIME DEFAULT GETDATE(),
    estaActivo BIT DEFAULT 1
);
go
-- Tabla de Metas de Ahorro
CREATE TABLE MetasAhorro (
    idMeta INT IDENTITY(1,1) PRIMARY KEY ,
    idUsuario INT FOREIGN KEY REFERENCES Usuarios(idUsuario),
    nombreMeta VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    montoObjetivo DECIMAL(18,2) NOT NULL,
    montoActual DECIMAL(18,2) DEFAULT 0.00,
    fechaInicio DATETIME DEFAULT GETDATE(),
    fechaFin DATETIME NOT NULL,
    estaCompletada BIT DEFAULT 0,
    fechaCreacion DATETIME DEFAULT GETDATE()
);
go
-- Tabla de Transacciones
CREATE TABLE Transacciones (
    idTransaccion INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT FOREIGN KEY REFERENCES Usuarios(idUsuario),
    monto DECIMAL(18,2) NOT NULL,
    tipo VARCHAR(10) CHECK (tipo IN ('Ingreso', 'Gasto')),
    fechaOperacion DATETIME NOT NULL,
    categoria VARCHAR(50),
    descripcion VARCHAR(500),
    fechaCreacion DATETIME DEFAULT GETDATE(),
    idMeta INT NULL FOREIGN KEY REFERENCES MetasAhorro(idMeta) 
);
go
-- Tabla de Mensajes
CREATE TABLE Mensajes (
    idMensaje INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioRemitente INT FOREIGN KEY REFERENCES Usuarios(idUsuario),
    contenidoPregunta VARCHAR(MAX) NOT NULL,
    contenidoRespuesta VARCHAR(MAX) NULL,
    fechaEnvio DATETIME DEFAULT GETDATE()
);
go
-- Tabla de Aportaciones a Metas 
CREATE TABLE AportacionesMeta (
    idAportacion INT IDENTITY(1,1) PRIMARY KEY,
    idMeta INT FOREIGN KEY REFERENCES MetasAhorro(idMeta),
    monto DECIMAL(18,2) NOT NULL,
    fechaAportacion DATETIME DEFAULT GETDATE()
);
go
CREATE TABLE HistorialSaldo (
    idHistorial INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT FOREIGN KEY REFERENCES Usuarios(idUsuario),
    saldo DECIMAL(18,2) NOT NULL,
    fechaRegistro DATETIME DEFAULT GETDATE()
);
go



/*=================================simulacion con datos==============================*/
--crear usuario
INSERT INTO Usuarios (nombre, correo, hashContraseña, telefono)
VALUES ('Carlos Pérez', 'carlos@email.com', 'hash_seguro123', '1234567890');
go

--Registrar dos transacciones (un ingreso y un gasto)
-- Ingreso
INSERT INTO Transacciones (idUsuario, monto, tipo, fechaOperacion, categoria, descripcion)
VALUES (1, 5000.00, 'Ingreso', GETDATE(), 'Salario', 'Pago mensual');
go
-- Gasto
INSERT INTO Transacciones (idUsuario, monto, tipo, fechaOperacion, categoria, descripcion)
VALUES (1, 1500.00, 'Gasto', GETDATE(), 'Compras', 'Supermercado y hogar');
go

--Registrar el saldo actual del usuario en HistorialSaldo
--El saldo actual es: 5000 - 1500 = $3500
INSERT INTO HistorialSaldo (idUsuario, saldo)
VALUES (1, 3500.00);
go

--Crear una meta de ahorro
INSERT INTO MetasAhorro (idUsuario, nombreMeta, descripcion, montoObjetivo, fechaFin)
VALUES (1, 'Nuevo teléfono', 'Ahorro para comprar un nuevo teléfono', 2000.00, '2025-12-31');
go

--Aportar a la meta
-- Actualizar montoActual en la meta
UPDATE MetasAhorro
SET montoActual = montoActual + 1000
WHERE idMeta = 1;
go
-- Registrar la aportación
INSERT INTO AportacionesMeta (idMeta, monto)
VALUES (1, 1000.00);
go

--Mensajes
INSERT INTO Mensajes (idUsuarioRemitente, contenidoPregunta)
VALUES (
    1,
    '¿Cuál es la mejor forma de empezar a ahorrar si tengo ingresos variables?'
);
go
UPDATE Mensajes
SET contenidoRespuesta = 'Una buena estrategia es aplicar la regla del 50/30/20 adaptada: guarda al menos el 20% de tus ingresos mensuales, aunque sean variables. Usa una meta de ahorro con monto flexible para no dejar de avanzar.'
WHERE idMensaje = 1;
go
```
### Pruebas
Para probar la aplicación, se recomienda ejecutar las funciones de la API con herramientas como Postman o Insomnia. Asegúrate de que la base de datos esté configurada correctamente antes de comenzar con las pruebas de los siguientes servicios:

- **Registrar Usuario**: `POST /api/usuario/registro`
- **Login Usuario**: `POST /api/usuario/login`
- **Crear Meta de Ahorro**: `POST /api/metasahorro/crear`
- **Crear Transacción**: `POST /api/transacciones/crear`
- **Consultar Historial de Saldo**: `GET /api/historialsaldo/{idUsuario}`

### Tecnologías Utilizadas
- **Frontend**: HTML, CSS, JavaScript (React.js o Angular).
- **Backend**: .NET Core API.
- **Base de Datos**: SQL Server.
- **Autenticación**: JWT (JSON Web Tokens).
- **ORM**: Entity Framework.



