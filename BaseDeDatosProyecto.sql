CREATE DATABASE quickcarryDB CHARSET utf8mb4;
USE quickcarryDB;

CREATE TABLE trabajador(
	id INT UNSIGNED AUTO_INCREMENT,
	username VARCHAR(16) UNIQUE NOT NULL,
	pass VARCHAR(50) NOT NULL,
    nom VARCHAR(30),
	ape VARCHAR(30),
	tel VARCHAR(12),
	bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_trabajador PRIMARY KEY (id) 
);
CREATE TABLE almacen(
	id_alma TINYINT UNSIGNED AUTO_INCREMENT NOT NULL,
	calle VARCHAR(30) NOT NULL,
    num VARCHAR(10) NOT NULL,
    esq VARCHAR(30),
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_almacen PRIMARY KEY (id_alma)
);
CREATE TABLE camion(
	id_camion INT UNSIGNED AUTO_INCREMENT NOT NULL,
	peso_camion SMALLINT,
    volumen_camion TINYINT,
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT check_volCamion CHECK (volumen_camion <= 90),
    CONSTRAINT check_pesoCamion CHECK (peso_camion <= 26000),
    CONSTRAINT pk_camion PRIMARY KEY (id_camion)
);
CREATE TABLE producto(
	id_prod INT UNSIGNED AUTO_INCREMENT NOT NULL,
	peso_producto SMALLINT UNSIGNED,
    volumen_producto TINYINT UNSIGNED,
    calle VARCHAR(30) NOT NULL,
    num VARCHAR(10) NOT NULL,
    esq VARCHAR(30),
    cliente VARCHAR(20) NOT NULL,
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT check_volProducto CHECK (volumen_producto <= 90),
    CONSTRAINT check_pesoProducto CHECK (peso_producto <= 26000),
    CONSTRAINT pk_producto PRIMARY KEY (id_prod)
);
CREATE TABLE destino(
	id_des INT UNSIGNED AUTO_INCREMENT NOT NULL,
	calle VARCHAR(30) NOT NULL,
    num VARCHAR(10) NOT NULL,
    esq VARCHAR(30),
    fech_esti DATE,
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_destino PRIMARY KEY (id_des)
);
CREATE TABLE lote(
	id_lote INT UNSIGNED AUTO_INCREMENT NOT NULL,
	fech_crea DATE NOT NULL,
    fech_entre DATE,
    id_des INT UNSIGNED,
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT check_fechas CHECK (fech_entre > fech_crea),
	CONSTRAINT fk_IdDes_lote FOREIGN KEY (id_des) REFERENCES destino(id_des),
    CONSTRAINT pk_lote PRIMARY KEY (id_lote, id_des, fech_Crea)
);
CREATE TABLE camionero(
	id_camionero INT UNSIGNED NOT NULL,
	bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT fk_id_camionero FOREIGN KEY (id_camionero) REFERENCES trabajador(id),
    CONSTRAINT pk_camionero PRIMARY KEY (id_camionero)
);
CREATE TABLE operario(
	id_operario INT UNSIGNED NOT NULL,
	bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT fk_id_operario FOREIGN KEY (id_operario) REFERENCES trabajador(id),
    CONSTRAINT pk_operario PRIMARY KEY (id_operario)
);
CREATE TABLE conduce(
	id_camionero INT UNSIGNED NOT NULL,
    id_camion INT UNSIGNED NOT NULL,
    CONSTRAINT fk_camionero_conduce FOREIGN KEY (id_camionero) REFERENCES camionero(id_camionero),
    CONSTRAINT fk_camion_conduce FOREIGN KEY (id_camion) REFERENCES camion(id_camion),
    CONSTRAINT pk_conduce PRIMARY KEY (id_camionero, id_camion)
);
CREATE TABLE gestiona(
	id_operario INT UNSIGNED NOT NULL,
    id_alma TINYINT UNSIGNED NOT NULL,
    CONSTRAINT fk_operario_gestiona FOREIGN KEY (id_operario) REFERENCES operario(id_operario),
    CONSTRAINT fk_almacen_gestiona FOREIGN KEY (id_alma) REFERENCES almacen(id_alma),
    CONSTRAINT pk_gestiona PRIMARY KEY (id_operario, id_Alma)
);
CREATE TABLE almacena(
	id_prod INT UNSIGNED NOT NULL,
    id_alma TINYINT UNSIGNED NOT NULL,
    fecha_ingre DATE,
    CONSTRAINT fk_id_prod_almacena FOREIGN KEY (id_prod) REFERENCES producto(id_prod),
    CONSTRAINT fk_idalma_almacena FOREIGN KEY (id_alma) REFERENCES almacen(id_alma),
    CONSTRAINT pk_almacena PRIMARY KEY (id_prod, id_alma)
);
CREATE TABLE integra(
	id_prod INT UNSIGNED NOT NULL,
    id_lote INT UNSIGNED NOT NULL,
    CONSTRAINT fk_idprod_integra FOREIGN KEY (id_prod) REFERENCES producto(id_prod),
    CONSTRAINT fk_idlote_integra FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    CONSTRAINT pk_pertence PRIMARY KEY (id_prod, id_lote)
);
CREATE TABLE llevan(
	id_camion INT UNSIGNED NOT NULL,
    id_lote INT UNSIGNED NOT NULL,
    fech_sal DATE NOT NULL,
    CONSTRAINT fk_idcamion_llevan FOREIGN KEY (id_camion) REFERENCES camion(id_camion),
    CONSTRAINT fk_idlote_llevan FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    CONSTRAINT pk_llevan PRIMARY KEY (id_camion, id_lote)
);
CREATE TABLE transporta(
	id_camion INT UNSIGNED NOT NULL,
    id_lote INT UNSIGNED NOT NULL,
    id_des INT UNSIGNED NOT NULL,
	estatus ENUM ("Entregado", "En camino", "Retrasado", "No enviado"),
    CONSTRAINT fk_idcamion_camion FOREIGN KEY (id_camion) REFERENCES camion(id_camion),
    CONSTRAINT fk_idlote_transporta FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    CONSTRAINT fk_iddes_transporta FOREIGN KEY (id_des) REFERENCES destino(id_des),
    CONSTRAINT pk_transporta PRIMARY KEY (id_camion, id_lote, id_des)
);
CREATE TABLE recorrido(
	id_des INT UNSIGNED NOT NULL,
    id_alma TINYINT UNSIGNED NOT NULL,
    tipo_trayecto ENUM ("Inicio", "Parada", "Fin"),
	fech_trayecto DATETIME,
	CONSTRAINT fk_id_des_contiene FOREIGN KEY (id_des) REFERENCES destino(id_des),
    CONSTRAINT fk_id_alma_contiene FOREIGN KEY (id_alma) REFERENCES almacen(id_alma),
	CONSTRAINT pk_contiene PRIMARY KEY(id_des, id_alma)
);

#PERMISOS_ROOT
GRANT ALL PRIVILEGES ON proyecto_Base_de_Datos.all TO 'root'@'localhost';

#PERMISOS_ADMIN_BD
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.trabajador TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.almacen TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.camion TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.producto TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.destino TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.lote TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.camionero TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.operario TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.conduce TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.gestiona TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.almacena TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.integra TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.llevan TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.transporta TO 'admin_bd'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON quickcarryDB.recorrido TO 'admin_bd'@'localhost';

#PERMISOS_CAMIONERO
GRANT SELECT, UPDATE ON quickcarryDB.transporta TO 'camionero'@'localhost';
GRANT SELECT, UPDATE ON quickcarryDB.recorrido TO 'camionero'@'localhost';
GRANT SELECT ON quickcarryDB.destino TO 'camionero'@'localhost';
GRANT SELECT ON quickcarryDB.conduce TO 'camionero'@'localhost';
GRANT SELECT ON quickcarryDB.llevan TO 'camionero'@'localhost';

#PERMISOS_OPERARIO
GRANT SELECT, UPDATE ON quickcarryDB.almacena TO 'operario'@'localhost';
GRANT SELECT, UPDATE ON quickcarryDB.integra TO 'operario'@'localhost';
GRANT SELECT, UPDATE ON quickcarryDB.llevan TO 'operario'@'localhost';
GRANT SELECT, UPDATE ON quickcarryDB.lote TO 'operario'@'localhost';
GRANT SELECT ON quickcarryDB.almacen TO 'operario'@'localhost';
GRANT SELECT ON quickcarryDB.producto TO 'operario'@'localhost';
GRANT SELECT ON quickcarryDB.lote TO 'operario'@'localhost';
GRANT SELECT ON quickcarryDB.camion TO 'operario'@'localhost';
GRANT SELECT ON quickcarryDB.destino TO 'operario'@'localhost';