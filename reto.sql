
DROP DATABASE IF EXISTS ControlAcademico;
CREATE DATABASE ControlAcademico;
USE ControlAcademico;


-- Tabla de estudiantes (para tener el registro general)
CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de notas (donde se guardan las calificaciones por asignatura)
CREATE TABLE notas (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT,
    asignatura VARCHAR(50),
    nota_final DECIMAL(3,2),
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante)
);


-- Registramos 4 estudiantes
INSERT INTO estudiantes (nombre) VALUES 
('Juan Pérez'),     -- Su promedio será Bajo (< 3.0)
('María López'),    -- Su promedio será Aceptable (3.0 - 4.0)
('Carlos Mendoza'), -- Su promedio será Sobresaliente (> 4.0)
('Ana Gómez');      -- Estudiante sin notas aún

-- Insertamos notas para simular los promedios
INSERT INTO notas (id_estudiante, asignatura, nota_final) VALUES
-- Juan Pérez (Promedio: 2.5)
(1, 'Matemáticas', 2.0),
(1, 'Historia', 3.0),

-- María López (Promedio: 3.75)
(2, 'Matemáticas', 4.0),
(2, 'Historia', 3.5),

-- Carlos Mendoza (Promedio: 4.6)
(3, 'Matemáticas', 4.8),
(3, 'Historia', 4.4);


DELIMITER //

CREATE FUNCTION ClasificarDesempeño(estudiante_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_promedio DECIMAL(3,2);
    DECLARE v_clasificacion VARCHAR(20);

    -- Calcular el promedio del estudiante seleccionado
    SELECT AVG(nota_final) INTO v_promedio
    FROM notas
    WHERE id_estudiante = estudiante_id;

    -- Validación por si el estudiante no cuenta con registros de notas
    IF v_promedio IS NULL THEN
        RETURN 'Sin Calificaciones';
    END IF;

    -- Lógica de clasificación según los rangos del reto
    CASE 
        WHEN v_promedio < 3.0 THEN 
            SET v_clasificacion = 'Bajo';
        WHEN v_promedio >= 3.0 AND v_promedio <= 4.0 THEN 
            SET v_clasificacion = 'Aceptable';
        WHEN v_promedio > 4.0 THEN 
            SET v_clasificacion = 'Sobresaliente';
    END CASE;

    RETURN v_clasificacion;
END //

DELIMITER ;

-- Ejecutamos la consulta usando la función para ver los resultados reflejados
SELECT 
    e.id_estudiante,
    e.nombre,
    ClasificarDesempeño(e.id_estudiante) AS clasificacion_desempeño
FROM estudiantes e;