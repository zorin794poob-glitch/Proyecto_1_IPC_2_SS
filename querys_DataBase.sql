CREATE DATABASE IF NOT EXISTS transporte_CodeBugs_guatemala;

--AGREGADO
CREATE TABLE sucursal (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    ubicacion_sucursal VARCHAR(200) NOT NULL,
    telefono VARCHAR(20),
    estado BOOLEAN NOT NULL DEFAULT TRUE
);

--AGREGADO

CREATE TABLE usuario (

    dpi VARCHAR(20) NOT NULL UNIQUE PRIMARY KEY, 
    nombre_completo VARCHAR(150) NOT NULL,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(120) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    nit VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    rol ENUM(
        'ADMIN_SISTEMA',
        'ADMIN_SUCURSAL',
        'CLIENTE'
    ) NOT NULL DEFAULT 'CLIENTE',
    id_sucursal INT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_usuario_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES sucursal(id_sucursal)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE bus (
    id_bus INT AUTO_INCREMENT PRIMARY KEY,
    foto VARCHAR(255),
    placa VARCHAR(20) NOT NULL UNIQUE,
    marca VARCHAR(60) NOT NULL,
    modelo VARCHAR(60) NOT NULL,
    anio_fabricacion YEAR NOT NULL,
    capacidad INT NOT NULL,
    estado_operativo ENUM('ACTIVO','INACTIVO','MANTENIMIENTO') NOT NULL DEFAULT 'ACTIVO',
    kilometraje_actual DECIMAL(12,2) NOT NULL DEFAULT 0,
    id_sucursal INT NOT NULL,
    CONSTRAINT chk_bus_capacidad CHECK (capacidad > 0),
    CONSTRAINT chk_bus_km CHECK (kilometraje_actual >= 0),
    CONSTRAINT fk_bus_sucursal
        FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE chofer (
    id_chofer INT AUTO_INCREMENT PRIMARY KEY,
    foto VARCHAR(255),
    nombre_completo VARCHAR(150) NOT NULL,
    numero_licencia VARCHAR(30) NOT NULL UNIQUE,
    tipo_licencia VARCHAR(30) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    salario_base DECIMAL(10,2) NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    id_sucursal INT NOT NULL,
    CONSTRAINT chk_chofer_salario CHECK (salario_base >= 0),
    CONSTRAINT fk_chofer_sucursal
        FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ruta (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    id_sucursal_origen INT NOT NULL,
    id_sucursal_destino INT NOT NULL,
    distancia_km DECIMAL(10,2) NOT NULL,
    precio_boleto DECIMAL(10,2) NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_ruta_distancia CHECK (distancia_km > 0),
    CONSTRAINT chk_ruta_precio CHECK (precio_boleto >= 0),
    CONSTRAINT chk_ruta_origen_destino CHECK (id_sucursal_origen <> id_sucursal_destino),
    CONSTRAINT fk_ruta_origen
        FOREIGN KEY (id_sucursal_origen) REFERENCES sucursal(id_sucursal)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ruta_destino
        FOREIGN KEY (id_sucursal_destino) REFERENCES sucursal(id_sucursal)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE viaje (
    id_viaje INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('REGULAR','PRIVADO') NOT NULL,
    id_bus INT NULL,
    id_chofer INT NULL,
    id_ruta INT NULL,
    fecha_hora_salida DATETIME NOT NULL,
    fecha_hora_llegada_estimada DATETIME NOT NULL,
    origen_privado VARCHAR(200),
    destino_privado VARCHAR(200),
    fecha_retorno DATETIME NULL,
    numero_pasajeros INT NULL,
    precio_total DECIMAL(12,2) NULL,
    estado ENUM('PROGRAMADO','EN_TRANSITO','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'PROGRAMADO',
    CONSTRAINT fk_viaje_bus FOREIGN KEY (id_bus) REFERENCES bus(id_bus)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_viaje_chofer FOREIGN KEY (id_chofer) REFERENCES chofer(id_chofer)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_viaje_ruta FOREIGN KEY (id_ruta) REFERENCES ruta(id_ruta)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_viaje_fechas CHECK (fecha_hora_llegada_estimada >= fecha_hora_salida),
    CONSTRAINT chk_viaje_pasajeros CHECK (numero_pasajeros IS NULL OR numero_pasajeros > 0)
);

CREATE TABLE salida_viaje (
    id_salida INT AUTO_INCREMENT PRIMARY KEY,
    id_viaje INT NOT NULL UNIQUE,
    id_bus INT NOT NULL,
    id_chofer INT NOT NULL,
    fecha_hora_real DATETIME NOT NULL,
    kilometraje_salida DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_salida_viaje FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_salida_bus FOREIGN KEY (id_bus) REFERENCES bus(id_bus)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_salida_chofer FOREIGN KEY (id_chofer) REFERENCES chofer(id_chofer)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_salida_km CHECK (kilometraje_salida >= 0)
);

CREATE TABLE llegada_viaje (
    id_llegada INT AUTO_INCREMENT PRIMARY KEY,
    id_viaje INT NOT NULL UNIQUE,
    fecha_hora_real DATETIME NOT NULL,
    kilometraje_final DECIMAL(12,2) NOT NULL,
    gasto_combustible DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_llegada_viaje FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_llegada_km CHECK (kilometraje_final >= 0),
    CONSTRAINT chk_llegada_combustible CHECK (gasto_combustible >= 0)
);

CREATE TABLE asiento (
    id_asiento INT AUTO_INCREMENT PRIMARY KEY,
    id_bus INT NOT NULL,
    numero INT NOT NULL,
    CONSTRAINT uq_asiento_bus_numero UNIQUE (id_bus, numero),
    CONSTRAINT fk_asiento_bus FOREIGN KEY (id_bus) REFERENCES bus(id_bus)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE cartera (
    id_cartera INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    saldo DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT chk_cartera_saldo CHECK (saldo >= 0),
    CONSTRAINT fk_cartera_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE movimiento_cartera (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_cartera INT NOT NULL,
    tipo ENUM('RECARGA','PAGO','AJUSTE') NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    fecha DATETIME NOT NULL,
    descripcion VARCHAR(255),
    CONSTRAINT chk_movimiento_monto CHECK (monto > 0),
    CONSTRAINT fk_movimiento_cartera FOREIGN KEY (id_cartera) REFERENCES cartera(id_cartera)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE boleto (
    id_boleto INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_viaje INT NOT NULL,
    id_asiento INT NOT NULL,
    fecha_pago DATETIME NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    estado ENUM('PAGADO','CANCELADO') NOT NULL DEFAULT 'PAGADO',
    CONSTRAINT uq_boleto_viaje_asiento UNIQUE (id_viaje, id_asiento),
    CONSTRAINT fk_boleto_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_boleto_viaje FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_boleto_asiento FOREIGN KEY (id_asiento) REFERENCES asiento(id_asiento)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_boleto_precio CHECK (precio >= 0)
);

CREATE TABLE alquiler (
    id_alquiler INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_viaje INT NOT NULL UNIQUE,
    precio_estimado DECIMAL(12,2) NOT NULL,
    precio_confirmado DECIMAL(12,2),
    estado ENUM('SOLICITADO','CONFIRMADO','PAGADO','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'SOLICITADO',
    CONSTRAINT fk_alquiler_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_alquiler_viaje FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_alquiler_estimado CHECK (precio_estimado >= 0),
    CONSTRAINT chk_alquiler_confirmado CHECK (precio_confirmado IS NULL OR precio_confirmado >= 0)
);

CREATE TABLE mantenimiento (
    id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_bus INT NOT NULL,
    fecha_mantenimiento DATE NOT NULL,
    monto_mano_obra DECIMAL(12,2) NOT NULL DEFAULT 0,
    monto_repuestos DECIMAL(12,2) NOT NULL DEFAULT 0,
    descripcion VARCHAR(255),
    CONSTRAINT fk_mantenimiento_bus FOREIGN KEY (id_bus) REFERENCES bus(id_bus)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_mantenimiento_mano CHECK (monto_mano_obra >= 0),
    CONSTRAINT chk_mantenimiento_repuestos CHECK (monto_repuestos >= 0)
);

CREATE TABLE repuesto (
    id_repuesto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio_unitario DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_repuesto_precio CHECK (precio_unitario >= 0),
    CONSTRAINT chk_repuesto_stock CHECK (stock >= 0)
);

CREATE TABLE mantenimiento_repuesto (
    id_mantenimiento INT NOT NULL,
    id_repuesto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_aplicado DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_mantenimiento, id_repuesto),
    CONSTRAINT fk_mr_mantenimiento FOREIGN KEY (id_mantenimiento) REFERENCES mantenimiento(id_mantenimiento)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_mr_repuesto FOREIGN KEY (id_repuesto) REFERENCES repuesto(id_repuesto)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_mr_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_mr_precio CHECK (precio_aplicado >= 0)
);

CREATE TABLE configuracion (
    id_configuracion INT PRIMARY KEY,
    depreciacion_km DECIMAL(10,4) NOT NULL,
    CONSTRAINT chk_config_depreciacion CHECK (depreciacion_km >= 0)
);

CREATE TABLE depreciacion_viaje (
    id_viaje INT PRIMARY KEY,
    kilometros_recorridos DECIMAL(12,2) NOT NULL,
    monto_por_km DECIMAL(10,4) NOT NULL,
    monto_depreciacion DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_depreciacion_viaje FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_dep_km CHECK (kilometros_recorridos >= 0),
    CONSTRAINT chk_dep_monto CHECK (monto_por_km >= 0 AND monto_depreciacion >= 0)
);

-- Consultas base para reportes
SELECT v.id_viaje, r.id_ruta, r.precio_boleto,
       COUNT(b.id_boleto) AS boletos_vendidos,
       SUM(b.precio) AS ingreso_total
FROM viaje v
JOIN ruta r ON r.id_ruta = v.id_ruta
LEFT JOIN boleto b ON b.id_viaje = v.id_viaje AND b.estado = 'PAGADO'
GROUP BY v.id_viaje, r.id_ruta, r.precio_boleto;

SELECT r.id_ruta, s1.nombre AS origen, s2.nombre AS destino,
       COUNT(b.id_boleto) AS boletos_vendidos
FROM ruta r
JOIN sucursal s1 ON s1.id_sucursal = r.id_sucursal_origen
JOIN sucursal s2 ON s2.id_sucursal = r.id_sucursal_destino
JOIN viaje v ON v.id_ruta = r.id_ruta
JOIN boleto b ON b.id_viaje = v.id_viaje AND b.estado = 'PAGADO'
GROUP BY r.id_ruta, s1.nombre, s2.nombre
ORDER BY boletos_vendidos DESC;
