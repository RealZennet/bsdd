DROP DATABASE IF EXISTS proyecto_Base_de_Datos;
CREATE DATABASE proyecto_Base_de_Datos CHARSET utf8mb4;
USE proyecto_Base_de_Datos;

CREATE TABLE trabajador(
	id INT UNSIGNED AUTO_INCREMENT,
	username VARCHAR(16) UNIQUE NOT NULL,
	pass VARCHAR(50) NOT NULL,
    nom VARCHAR(30),
	ape VARCHAR(30),
	tel TINYINT(11) UNSIGNED,
	bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_trabajador PRIMARY KEY(id) 
);
CREATE TABLE almacen(
	id_alma TINYINT UNSIGNED AUTO_INCREMENT NOT NULL,
	calle VARCHAR(30) NOT NULL,
    num VARCHAR(10) NOT NULL,
    esq VARCHAR(30),
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_almacen PRIMARY KEY(id_alma)
);
CREATE TABLE paquete(
	id_paq INT UNSIGNED AUTO_INCREMENT NOT NULL,
    calle VARCHAR(30) NOT NULL,
    num VARCHAR(10) NOT NULL,
    esq VARCHAR(30),
    cliente VARCHAR(20) NOT NULL,
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_paquete PRIMARY KEY(id_paq)
);
CREATE TABLE producto(
	id_prod INT UNSIGNED AUTO_INCREMENT NOT NULL,
	nom_Prod VARCHAR(30),
	peso SMALLINT(100) UNSIGNED,
    volumen SMALLINT(100) UNSIGNED,
    desc_Prod VARCHAR(100),
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY(id_prod)
);
CREATE TABLE camion(
	id_camion INT UNSIGNED AUTO_INCREMENT NOT NULL,
	peso SMALLINT(100),
    volumen SMALLINT(100),
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_camion PRIMARY KEY(id_camion)
);
CREATE TABLE destino(
	id_des INT UNSIGNED AUTO_INCREMENT NOT NULL,
	fech_Esti DATE NOT NULL,
	calle VARCHAR(30) NOT NULL,
    num VARCHAR(10) NOT NULL,
    esq VARCHAR(30),
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT pk_destino PRIMARY KEY(id_des)
);
CREATE TABLE lote(
	id_lote INT UNSIGNED AUTO_INCREMENT NOT NULL,
	fech_Crea DATE NOT NULL,
    fech_Entre DATE,
    id_des INT UNSIGNED,
    bajalogica BOOLEAN DEFAULT 0 NOT NULL,
	CONSTRAINT fk_IdDes_lote FOREIGN KEY(id_des) REFERENCES destino(id_des),
    CONSTRAINT pk_lote PRIMARY KEY(id_lote, id_des, fech_Crea)
);
CREATE TABLE camionero(
	id_camionero INT UNSIGNED NOT NULL,
	bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT fk_id_camionero FOREIGN KEY(id_camionero) REFERENCES trabajador(id),
    CONSTRAINT pk_camionero PRIMARY KEY(id_camionero)
);
CREATE TABLE operario(
	id_operario INT UNSIGNED NOT NULL,
	bajalogica BOOLEAN DEFAULT 0 NOT NULL,
    CONSTRAINT fk_id_operario FOREIGN KEY (id_operario) REFERENCES trabajador(id),
    CONSTRAINT pk_operario PRIMARY KEY(id_operario)
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
	id_paq INT UNSIGNED NOT NULL,
    id_alma TINYINT UNSIGNED NOT NULL,
    fecha_ingre DATE,
    CONSTRAINT fk_id_paq_almacena FOREIGN KEY (id_paq) REFERENCES paquete(id_paq),
    CONSTRAINT fk_idalma_almacena FOREIGN KEY (id_alma) REFERENCES almacen(id_alma),
    CONSTRAINT pk_almacena PRIMARY KEY (id_paq, id_alma)
);
CREATE TABLE integra(
	id_paq INT UNSIGNED NOT NULL,
    id_lote INT UNSIGNED NOT NULL,
    CONSTRAINT fk_idprod_integra FOREIGN KEY (id_paq) REFERENCES paquete(id_paq),
    CONSTRAINT fk_idlote_integra FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    CONSTRAINT pk_pertence PRIMARY KEY (id_paq, id_lote)
);
CREATE TABLE llevan(
	id_camion INT UNSIGNED NOT NULL,
    id_lote INT UNSIGNED NOT NULL,
    id_des INT UNSIGNED NOT NULL,
    fech_sal DATE NOT NULL,
    CONSTRAINT fk_idcamion_llevan FOREIGN KEY (id_camion) REFERENCES camion(id_camion),
    CONSTRAINT fk_idlote_llevan FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    CONSTRAINT fk_iddes_llevan FOREIGN KEY (id_des) REFERENCES destino(id_des),
    PRIMARY KEY (id_camion, id_lote, id_des)
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
CREATE TABLE contiene(
	id_prod INT UNSIGNED NOT NULL,
    id_paq INT UNSIGNED NOT NULL,
	CONSTRAINT fk_idprod_contiene FOREIGN KEY (id_prod) REFERENCES producto(id_prod),
	CONSTRAINT fk_id_paq_contiene FOREIGN KEY (id_paq) REFERENCES paquete(id_paq),
	CONSTRAINT pk_contiene PRIMARY KEY(id_paq, id_prod)
);

#CREACION USUARIOS
DROP USER 'root';
DROP USER 'admin_bd'; 
DROP USER 'chofer'; 
DROP USER 'almacenero';
  
SELECT user FROM mysql.user;
CREATE USER 'root' identified by 'root1234';
CREATE USER 'admin_bd' identified by 'admin123';
CREATE USER 'chofer' identified by '1234';
CREATE USER 'almacenero' identified by '4321';

#PERMISOS_ROOT
GRANT ALL PRIVILEGES ON proyecto_Base_de_Datos.all TO 'root'@'localhost';
#PERMISOS_admin_bd
GRANT SELECT, INSERT, DELETE, UPDATE ON proyecto_Base_de_Datos.add TO 'admin_bd'@'localhost';
#PERMISOS_chofer
GRANT SELECT, UPDATE ON proyecto_Base_de_Datos.entregan TO 'chofer'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.destino TO 'chofer'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.conduce TO 'chofer'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.llevan TO 'chofer'@'localhost';
#PERMISOS_almacenero
GRANT SELECT, UPDATE ON proyecto_Base_de_Datos.almacena TO 'almacenero'@'localhost';
GRANT SELECT, UPDATE ON proyecto_Base_de_Datos.pertenece TO 'almacenero'@'localhost';
GRANT SELECT, UPDATE ON proyecto_Base_de_Datos.llevan TO 'almacenero'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.trabaja TO 'almacenero'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.almacen TO 'almacenero'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.producto TO 'almacenero'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.lote TO 'almacenero'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.camion TO 'almacenero'@'localhost';
GRANT SELECT ON proyecto_Base_de_Datos.destino TO 'almacenero'@'localhost';