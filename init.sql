-- Tabla Entidad
CREATE TABLE Entidad (
    EntidadID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Tipo ENUM('Sistema', 'Agente', 'Recurso', 'CIIU', 'Embalse', 'Rio', 'Area', 'Subarea') NOT NULL,
    CodigoFiltro VARCHAR(20),
    UNIQUE KEY unique_entidad (Nombre, Tipo)
) ENGINE=InnoDB;

-- Tabla Metrica
CREATE TABLE Metrica (
    MetricaID INT AUTO_INCREMENT PRIMARY KEY,
    NombreMetrica VARCHAR(150) NOT NULL,
    Unidad VARCHAR(20) NOT NULL,
    Descripcion TEXT,
    Filtro VARCHAR(50),
    TipoFrecuencia ENUM('Horaria', 'Diaria', 'Mensual') NOT NULL,
    URL_API VARCHAR(255),
    UNIQUE KEY unique_metrica (NombreMetrica, Unidad)
) ENGINE=InnoDB;

-- Tabla DatosHora
CREATE TABLE DatosHora (
    DatoID BIGINT AUTO_INCREMENT PRIMARY KEY,
    MetricaID INT NOT NULL,
    EntidadID INT NOT NULL,
    Fecha DATE NOT NULL,
    CodigoFiltro VARCHAR(20),
    Hora01 DECIMAL(18,5),
    Hora02 DECIMAL(18,5),
    Hora03 DECIMAL(18,5),
    -- ... Repetir hasta Hora24
    Hora24 DECIMAL(18,5),
    FOREIGN KEY (MetricaID) REFERENCES Metrica(MetricaID),
    FOREIGN KEY (EntidadID) REFERENCES Entidad(EntidadID),
    INDEX idx_fecha (Fecha),
    INDEX idx_metrica_entidad (MetricaID, EntidadID)
) ENGINE=InnoDB;

-- Tabla Transacciones
CREATE TABLE Transacciones (
    TransaccionID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Tipo ENUM('Compra', 'Venta') NOT NULL,
    Mercado ENUM('Bolsa Nacional', 'Contrato', 'Internacional', 'TIE') NOT NULL,
    EntidadOrigenID INT,
    EntidadDestinoID INT,
    Fecha DATE NOT NULL,
    EnergiaTotal DECIMAL(18,5),
    MonedaTotal DECIMAL(18,2),
    FOREIGN KEY (EntidadOrigenID) REFERENCES Entidad(EntidadID),
    FOREIGN KEY (EntidadDestinoID) REFERENCES Entidad(EntidadID),
    INDEX idx_transaccion_fecha (Fecha, Mercado)
) ENGINE=InnoDB;

-- Tabla para métricas diarias/mensuales
CREATE TABLE DatosDiarios (
    DatoID BIGINT AUTO_INCREMENT PRIMARY KEY,
    MetricaID INT NOT NULL,
    EntidadID INT NOT NULL,
    Fecha DATE NOT NULL,
    Valor DECIMAL(18,5),
    FOREIGN KEY (MetricaID) REFERENCES Metrica(MetricaID),
    FOREIGN KEY (EntidadID) REFERENCES Entidad(EntidadID),
    INDEX idx_diarios_fecha (Fecha)
) ENGINE=InnoDB; 

-- Particiones:
ALTER TABLE DatosHora 
PARTITION BY RANGE (YEAR(Fecha)*100 + MONTH(Fecha)) (
    PARTITION p202304 VALUES LESS THAN (202305),
    PARTITION p202305 VALUES LESS THAN (202306),
    PARTITION p202306 VALUES LESS THAN (202307)
);
-- Indices:]
ALTER TABLE Entidad ADD INDEX idx_tipo_entidad (Tipo);
ALTER TABLE Metrica ADD INDEX idx_filtros (Filtro);

-- Fragmentación Horizontal:
-- Tabla para datos horarios de Demanda
CREATE TABLE DatosDemanda LIKE DatosHora;
ALTER TABLE DatosDemanda 
ADD CONSTRAINT chk_metrica_demanda 
CHECK (MetricaID IN (1,2,3)); -- IDs de métricas de demanda
