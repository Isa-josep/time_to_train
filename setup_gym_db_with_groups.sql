CREATE DATABASE gym_db;

USE gym_db;

-- Tabla de Usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nombre_usuario VARCHAR(100) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('usuario', 'entrenador', 'admin') DEFAULT 'usuario',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Grupos
CREATE TABLE grupos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creador_id INT NOT NULL, -- ID del usuario que crea el grupo
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creador_id) REFERENCES usuarios(id)
);

-- Tabla intermedia de Grupos y Usuarios (Relación muchos a muchos)
CREATE TABLE grupo_usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    grupo_id INT,
    usuario_id INT UNIQUE, -- Un usuario solo puede estar en un grupo a la vez
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (grupo_id) REFERENCES grupos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabla de Rutinas
CREATE TABLE rutinas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    usuario_id INT,
    grupo_id INT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (grupo_id) REFERENCES grupos(id)
);

-- Tabla de Ejercicios
CREATE TABLE ejercicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Rutinas-Ejercicios
CREATE TABLE rutinas_ejercicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rutina_id INT,
    ejercicio_id INT,
    sets INT NOT NULL,
    reps INT NOT NULL,
    peso FLOAT,
    FOREIGN KEY (rutina_id) REFERENCES rutinas(id),
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id)
);

-- Tabla de Registros de PR (Personal Records)
CREATE TABLE registros_pr (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    ejercicio_id INT,
    peso FLOAT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id)
);
