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