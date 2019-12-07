-- 		Laboratorio de Sistema de Bases de Datos I 
--      Proyecto 1
--      Sept - Dic 2019
--
--		Integrantes:
--			Manuel Gil                  14-10397
--			Maria Fernanda Machado      13-10780
--
-------------------------------------------------------------------------
-- psql sistema_subasta < /home/manuelguillegil/Development/auction-system/tabla.sql
DROP TABLE IF EXISTS Categoria_Producto;
DROP TABLE IF EXISTS Bid;
DROP TABLE IF EXISTS Subasta;
DROP TABLE IF EXISTS Metodo_Pago_Usuario;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Metodo_Pago;
DROP TABLE IF EXISTS Producto;
DROP TABLE IF EXISTS Categoria;

-- Tabla Usuario
CREATE TABLE Usuario (
    id                      Integer NOT NULL PRIMARY KEY,
    usuario                 VARCHAR(64),
    email                   VARCHAR(64),
    clave                   VARCHAR(64)
);

-- TODO: Preguntar si se quiere guardar los bid no exitosos
-- Tabla Bid
CREATE TABLE Bid (
    id                      Integer NOT NULL PRIMARY KEY,
    usuario                 Integer,
    fecha                   Timestamp,
    monto                   Integer,
    subasta                 Integer
);

-- Tabla del Método de Pago
CREATE TABLE Metodo_Pago (
    id                      Integer NOT NULL PRIMARY KEY,
    nombre                  VARCHAR(64),
    descripcion             VARCHAR(64)
);

-- Tabla la lista de métodos de pago
CREATE TABLE Metodo_Pago_Usuario(
    id                      Integer NOT NULL PRIMARY KEY,
    usuario                 Integer,
    metodo_pago             Integer
);

-- Tabla de los Productos a subastar
CREATE TABLE Producto (
    id                      Integer NOT NULL PRIMARY KEY,
    nombre                  VARCHAR(64),
    descripcion             VARCHAR(128),
    caracteristicas         VARCHAR(128)
);

CREATE TABLE Categoria (
    id                  Integer NOT NULL PRIMARY KEY,
    tipo                VARCHAR(64),
    padre               Integer,
    es_hoja             Boolean
);

CREATE TABLE Categoria_Producto (
    id              INTEGER NOT NULL PRIMARY KEY,
    categoria       Integer,
    producto        Integer
);

CREATE TABLE Subasta (
    id                  Integer NOT NULL PRIMARY KEY,
    usuario             Integer,
    fecha_ini           Timestamp,
    fecha_fin           Timestamp,
    precio_base         Integer,
    precio_reserva      Integer, 
    precio_actual       Integer,
    producto            Integer,
    monto_minimo        Integer, -- Atributo que define el monto minimo que debe tener un bid para aumentar un precio
    fecha_limite        Timestamp -- Atributo que define el límite a considerar para actualizar la fecha de finalizacion de la subasta
);

/* -- Importamos el archivo cvs a la tabla creada
\COPY Censo FROM 'Censo Estudiantes Litoral.csv' WITH DELIMITER ',' CSV HEADER; */


-- Alteramos las tablas para crear claves foranéas
-- Estudiantes
ALTER TABLE Bid
    ADD CONSTRAINT usuario_fk
    FOREIGN KEY (usuario)
    REFERENCES Usuario(id)
    ON DELETE SET NULL;

 ALTER TABLE Bid
    ADD CONSTRAINT subasta_fk
    FOREIGN KEY (subasta)
    REFERENCES Subasta(id)
    ON DELETE SET NULL;

 ALTER TABLE Metodo_Pago_Usuario
    ADD CONSTRAINT usuario_fk
    FOREIGN KEY (usuario)
    REFERENCES Usuario(id)
    ON DELETE SET NULL;

 ALTER TABLE Metodo_Pago_Usuario
    ADD CONSTRAINT metodo_pago_fk
    FOREIGN KEY (metodo_pago)
    REFERENCES Metodo_Pago(id)
    ON DELETE SET NULL;

 ALTER TABLE Categoria
    ADD CONSTRAINT padre_categoria_fk
    FOREIGN KEY (padre)
    REFERENCES Categoria(id)
    ON DELETE SET NULL;

 ALTER TABLE Categoria_Producto
    ADD CONSTRAINT producto_fk
    FOREIGN KEY (producto)
    REFERENCES Producto(id)
    ON DELETE SET NULL;

 ALTER TABLE Categoria_Producto
    ADD CONSTRAINT categoria_fk
    FOREIGN KEY (categoria)
    REFERENCES Categoria(id)
    ON DELETE SET NULL;

 ALTER TABLE Subasta
    ADD CONSTRAINT producto_fk
    FOREIGN KEY (producto)
    REFERENCES Producto(id)
    ON DELETE SET NULL;

 ALTER TABLE Subasta
    ADD CONSTRAINT usuario_fk
    FOREIGN KEY (usuario)
    REFERENCES Usuario(id)
    ON DELETE SET NULL; 

\i '/home/manuelguillegil/Development/auction-system/triggersAddBid.sql'
\i '/home/manuelguillegil/Development/auction-system/triggersCheckHoja.sql'
\i '/home/manuelguillegil/Development/auction-system/triggersUpdateHojaPadre.sql'
\i '/home/manuelguillegil/Development/auction-system/triggerUpdateFinishDate.sql'

\COPY Usuario FROM '/home/manuelguillegil/Development/auction-system/usuarios.csv' WITH DELIMITER ',' CSV HEADER;
\COPY Categoria FROM '/home/manuelguillegil/Development/auction-system/categoria.csv' WITH DELIMITER ',' CSV HEADER;
\COPY Metodo_Pago FROM '/home/manuelguillegil/Development/auction-system/metodo_pago.csv' WITH DELIMITER ',' CSV HEADER;
\COPY Metodo_Pago_Usuario FROM '/home/manuelguillegil/Development/auction-system/metodo_pago_usuario.csv' WITH DELIMITER ',' CSV HEADER;
\COPY Producto FROM '/home/manuelguillegil/Development/auction-system/producto.csv' WITH DELIMITER ',' CSV HEADER;
\COPY Categoria_Producto FROM '/home/manuelguillegil/Development/auction-system/categoria_producto.csv' WITH DELIMITER ',' CSV HEADER;
\COPY Subasta FROM '/home/manuelguillegil/Development/auction-system/subasta.csv' WITH DELIMITER ',' CSV HEADER;
\COPY Bid FROM '/home/manuelguillegil/Development/auction-system/bid.csv' WITH DELIMITER ',' CSV HEADER;

-- TODO: TRIGGERS
-- 
-- 1. Actualizar la fecha de finalización de subasta si entra un nuevo bid en un tiempo N fijado por el administrador de subasta [LISTO]
-- 2. Cuando se inserta categoría se debe actualizar el atributo del papa para indiicar que ya no es hoja [LISTO]
-- 3. Cuando se inserta categoria de producto, verificar que esa categoria es hoja [LISTO]
-- 4. Verificar cuando se agrega un bid que se aummenta el precio base de la subasta en al menos X% el precio base del producto. El X se define como atributo en la subasta. Ademas se actualiza el precio actual de la subasta [LISTO]
-- 5. Si un bid no es exitoso y no se quiere guardar esos bids, entonces trigger que rebote la insercion de bids no exitosos [LISTO]