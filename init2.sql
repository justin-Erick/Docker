-- Tabla Entidad (ampliada para soportar filtros y relaciones)
CREATE TABLE Entidad (
    EntidadID INT AUTO_INCREMENT PRIMARY KEY,
    Codigo VARCHAR(20) NOT NULL, -- Ej: 'AAGG', '2QBW', '0510'
    Nombre VARCHAR(100) NOT NULL,
    Tipo ENUM('Sistema', 'Agente', 'Recurso', 'CIIU', 'Embalse', 'Rio', 'Area', 'Subarea') NOT NULL,
    TipoFiltro ENUM('Comercializador', 'Submercado', 'Agente', 'Embalse', 'Rio', 'N/A') DEFAULT 'N/A',
    UNIQUE KEY unique_entidad (Codigo, Tipo)
) ENGINE=InnoDB;

-- Tabla Metrica (actualizada con IDs explícitos para las métricas clave)
CREATE TABLE Metrica (
    MetricaID INT PRIMARY KEY, -- IDs fijos para facilitar fragmentación
    NombreMetrica VARCHAR(150) NOT NULL,
    Unidad VARCHAR(20) NOT NULL,
    Descripcion TEXT,
    Filtro VARCHAR(50),
    TipoFrecuencia ENUM('Horaria', 'Diaria', 'Mensual') NOT NULL,
    URL_API VARCHAR(255),
    Categoria ENUM('Demanda', 'Generación', 'Precios', 'Pérdidas', 'Sostenibilidad', 'Transacciones'),
    UNIQUE KEY unique_metrica (NombreMetrica, Unidad)
) ENGINE=InnoDB;
-- Tabla DatosHora (optimizada con particiones y compresión)
CREATE TABLE DatosHora (
    DatoID BIGINT AUTO_INCREMENT,
    MetricaID INT NOT NULL,
    EntidadID INT NOT NULL,
    Fecha DATE NOT NULL,
    Hora01 DECIMAL(18,5),
    Hora02 DECIMAL(18,5),
    Hora03 DECIMAL(18,5),
    Hora04 DECIMAL(18,5), 
    Hora05 DECIMAL(18,5),
    Hora06 DECIMAL(18,5),
    Hora07 DECIMAL(18,5),
    Hora08 DECIMAL(18,5),
    Hora09 DECIMAL(18,5), 
    Hora10 DECIMAL(18,5),
    Hora11 DECIMAL(18,5),
    Hora12 DECIMAL(18,5),
    Hora13 DECIMAL(18,5),
    Hora14 DECIMAL(18,5), 
    Hora15 DECIMAL(18,5),
    Hora16 DECIMAL(18,5),
    Hora17 DECIMAL(18,5),
    Hora18 DECIMAL(18,5),
    Hora19 DECIMAL(18,5), 
    Hora20 DECIMAL(18,5),
    Hora21 DECIMAL(18,5),
    Hora22 DECIMAL(18,5),
    Hora23 DECIMAL(18,5),
    Hora24 DECIMAL(18,5), 
    PRIMARY KEY (DatoID, Fecha), -- Clave compuesta para particionamiento
    FOREIGN KEY (MetricaID) REFERENCES Metrica(MetricaID),
    FOREIGN KEY (EntidadID) REFERENCES Entidad(EntidadID)
) ENGINE=InnoDB
PARTITION BY RANGE COLUMNS(Fecha) (
    PARTITION p2020 VALUES LESS THAN ('2021-01-01'),
    PARTITION p2021 VALUES LESS THAN ('2022-01-01'),
    PARTITION p2022 VALUES LESS THAN ('2023-01-01'),
    PARTITION p2023 VALUES LESS THAN ('2024-01-01')
);

-- Tabla Transacciones (especializada para análisis de mercado)
CREATE TABLE Transacciones (
    TransaccionID BIGINT AUTO_INCREMENT PRIMARY KEY,
    Tipo ENUM('Compra', 'Venta') NOT NULL,
    Mercado ENUM('Bolsa', 'Contrato', 'TIE', 'Internacional') NOT NULL,
    EntidadID INT, -- Agente o Sistema
    Fecha DATE NOT NULL,
    EnergiaTotal DECIMAL(18,5),
    PrecioPromedio DECIMAL(18,2),
    FOREIGN KEY (EntidadID) REFERENCES Entidad(EntidadID),
    INDEX idx_mercado_fecha (Mercado, Fecha)
) ENGINE=InnoDB;

-- Fragmentación Horizontal para categorías (ejemplo):
CREATE TABLE DatosDemanda (
    CHECK (MetricaID IN (1,2)) -- DemandaReal y DemaComeNoReg
) INHERITS (DatosHora);

CREATE TABLE DatosGeneracion (
    CHECK (MetricaID IN (3,4)) -- Gene y DispoReal
) INHERITS (DatosHora);