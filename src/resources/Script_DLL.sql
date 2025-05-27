-- 0. Crear y usar la base de datos
CREATE DATABASE IF NOT EXISTS konrad_ecommerce
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE konrad_ecommerce;

-- 1. Usuarios
CREATE TABLE Usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  identificacion VARCHAR(20) NOT NULL UNIQUE,
  nombres VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL,
  direccion VARCHAR(200),
  ciudad VARCHAR(100),
  pais VARCHAR(100),
  telefono VARCHAR(30),
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Solicitudes
CREATE TABLE Solicitud (
  id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('PENDIENTE','APROBADA','DEVUELTA','RECHAZADA') NOT NULL,
  fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. Categorías y subcategorías
CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Subcategoria (
  id_subcategoria INT AUTO_INCREMENT PRIMARY KEY,
  categoria_id INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  FOREIGN KEY (categoria_id) REFERENCES Categoria(id_categoria)
    ON DELETE CASCADE,
  UNIQUE(categoria_id, nombre)
) ENGINE=InnoDB;

-- 4. Productos
CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  vendedor_id INT NOT NULL,
  subcategoria_id INT NOT NULL,
  marca VARCHAR(100),
  original BOOLEAN NOT NULL DEFAULT TRUE,
  color VARCHAR(50),
  tamano VARCHAR(50),
  peso DECIMAL(10,2),
  talla VARCHAR(50),
  estado VARCHAR(50),
  cantidad INT NOT NULL DEFAULT 0,
  precio DECIMAL(12,2) NOT NULL,
  descripcion TEXT,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (vendedor_id) REFERENCES Usuario(id_usuario)
    ON DELETE CASCADE,
  FOREIGN KEY (subcategoria_id) REFERENCES Subcategoria(id_subcategoria)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. Carrito y sus items
CREATE TABLE Carrito (
  id_carrito INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE CarritoItem (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  carrito_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  FOREIGN KEY (carrito_id) REFERENCES Carrito(id_carrito)
    ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES Producto(id_producto)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 6. Pedidos y sus items
CREATE TABLE Pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(12,2) NOT NULL,
  estado VARCHAR(50) NOT NULL,
  direccion_envio VARCHAR(200),
  tipo_envio VARCHAR(50),
  FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PedidoItem (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (pedido_id) REFERENCES Pedido(id_pedido)
    ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES Producto(id_producto)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 7. Pagos
CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL,
  metodo_pago VARCHAR(50),
  estado_pago VARCHAR(50),
  fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
  numero_aprobacion VARCHAR(100),
  FOREIGN KEY (pedido_id) REFERENCES Pedido(id_pedido)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. Suscripciones
CREATE TABLE Suscripcion (
  id_suscripcion INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME NOT NULL,
  tipo_periodo ENUM('MENSUAL','SEMESTRAL','ANUAL') NOT NULL,
  estado VARCHAR(50) NOT NULL,
  FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. Notificaciones
CREATE TABLE Notificacion (
  id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  tipo VARCHAR(50),
  mensaje TEXT,
  leido BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- Datos de prueba

USE konrad_ecommerce;

-- 1. Usuarios de prueba
INSERT INTO Usuario (identificacion, nombres, apellidos, email, password_hash, role, direccion, ciudad, pais, telefono) VALUES
('1234567890','Director','Comercial','director@konrad.com','hashed_pw1','DIRECTOR','Av. Siempre Viva 123','Bogotá','Colombia','3200000000'),
('0987654321','Vendedor','Prueba','vendedor@konrad.com','hashed_pw2','VENDEDOR','Calle 2','Medellín','Colombia','3100000000'),
('1122334455','Comprador','Prueba','comprador@konrad.com','hashed_pw3','COMPRADOR','Calle 3','Cali','Colombia','3200000001');

-- 2. Solicitudes pendientes (punto 2)
INSERT INTO Solicitud (usuario_id, fecha_solicitud, estado) VALUES
(2,'2025-05-20 10:00:00','PENDIENTE'),
(2,'2025-05-21 11:30:00','PENDIENTE');

-- 3. Categorías y subcategorías
INSERT INTO Categoria (nombre) VALUES
('Electrónica'),
('Hogar');

INSERT INTO Subcategoria (categoria_id, nombre) VALUES
(1,'Smartphones'),
(1,'Laptops'),
(2,'Muebles');

-- 4. Productos de ejemplo
INSERT INTO Producto (vendedor_id, subcategoria_id, marca, original, color, tamano, peso, talla, estado, cantidad, precio, descripcion) VALUES
(2, 1, 'Samsung', TRUE, 'Negro', '6.1"', 0.17, NULL, 'Nuevo', 10, 1500.00, 'Smartphone de prueba'),
(2, 2, 'Dell',    TRUE, 'Plateado','15.6"', 2.50, NULL, 'Nuevo',  5, 3200.00, 'Laptop de prueba');

-- 5. Carrito de un comprador
INSERT INTO Carrito (usuario_id) VALUES
(3);

-- Asumimos id_carrito = 1
INSERT INTO CarritoItem (carrito_id, producto_id, cantidad) VALUES
(1, 1, 1);

-- 6. Pedido y sus items
INSERT INTO Pedido (usuario_id, fecha_pedido, total, estado, direccion_envio, tipo_envio) VALUES
(3, '2025-05-22 14:00:00', 1500.00, 'PENDIENTE', 'Calle 4', 'Domicilio');

-- Asumimos id_pedido = 1
INSERT INTO PedidoItem (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 1500.00);

-- 7. Pago de ejemplo
INSERT INTO Pago (pedido_id, metodo_pago, estado_pago, numero_aprobacion) VALUES
(1, 'TARJETA', 'COMPLETADO', 'APROVED123');

-- 8. Suscripción de vendedor
INSERT INTO Suscripcion (usuario_id, fecha_inicio, fecha_fin, tipo_periodo, estado) VALUES
(2, '2025-05-01', '2025-05-31', 'MENSUAL', 'ACTIVA');

-- 9. Notificaciones de prueba
INSERT INTO Notificacion (usuario_id, fecha, tipo, mensaje, leido) VALUES
(2, '2025-05-21 12:00:00', 'INFO', 'Tu suscripción está activa', FALSE),
(3, '2025-05-22 14:05:00', 'INFO', 'Compra recibida, pedido #1', FALSE);
