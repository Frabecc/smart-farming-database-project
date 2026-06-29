CREATE SCHEMA IF NOT EXISTS smart_farming;
USE smart_farming;

CREATE TABLE produttore (
    id_produttore INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    nome_azienda VARCHAR(150) NULL,
    indirizzo_email VARCHAR(150) NOT NULL UNIQUE,
    numero_telefono VARCHAR(25) NULL UNIQUE
);

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    indirizzo_email VARCHAR(150) NULL UNIQUE,
    numero_telefono VARCHAR(25) NULL UNIQUE,
    data_nascita DATE NULL,
    genere ENUM('M', 'F', 'Altro', 'Preferisco non specificare') NULL
);

CREATE TABLE risorsa (
    tipo_risorsa VARCHAR(100) PRIMARY KEY
);

CREATE TABLE prodotto (
    id_prodotto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE attivita (
    id_attivita INT AUTO_INCREMENT PRIMARY KEY,
    id_produttore INT NOT NULL,
    FOREIGN KEY (id_produttore) REFERENCES produttore(id_produttore) ON DELETE CASCADE
);

CREATE TABLE coltura (
    id_attivita INT PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL,
    varieta VARCHAR(100) NOT NULL,
    data_semina DATE NOT NULL,
    data_raccolta_prevista DATE NOT NULL,
    fase_crescita VARCHAR(50) NULL,
    stato_salute VARCHAR(50) NULL,
    FOREIGN KEY (id_attivita) REFERENCES attivita(id_attivita) ON DELETE CASCADE
);

CREATE TABLE bestiame (
    id_attivita INT PRIMARY KEY,
    specie VARCHAR(100) NOT NULL,
    razza VARCHAR(100) NOT NULL,
    numero_capi INT NOT NULL,
    stato_salute VARCHAR(50) NULL,
    data_ultimo_controllo DATE NULL,
    FOREIGN KEY (id_attivita) REFERENCES attivita(id_attivita) ON DELETE CASCADE
);

CREATE TABLE sensore (
    id_sensore INT AUTO_INCREMENT PRIMARY KEY,
    tipo_sensore VARCHAR(100) NOT NULL,
    data_installazione DATE NOT NULL,
    id_attivita INT NOT NULL,
    FOREIGN KEY (id_attivita) REFERENCES attivita(id_attivita) ON DELETE CASCADE
);

CREATE TABLE rilevazione_ambientale (
    id_sensore INT NOT NULL,
    data_ora DATETIME NOT NULL,
    condizione ENUM('Temperatura Aria', 'Temperatura Suolo', 'Umidità Aria', 'Umidità Suolo', 'pH Suolo', 'Livello CO2', 'Precipitazioni', 'Velocità Vento') NOT NULL,
    misurazione DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_sensore, data_ora),
    FOREIGN KEY (id_sensore) REFERENCES sensore(id_sensore) ON DELETE CASCADE
);

CREATE TABLE inventario_risorsa (
    id_produttore INT NOT NULL,
    tipo_risorsa VARCHAR(100) NOT NULL,
    quantita_disponibile DECIMAL(10,2) NOT NULL,
    unita_misura ENUM('L', 'Kg', 'm', 'mq', 'Pezzi') NOT NULL,
    PRIMARY KEY (id_produttore, tipo_risorsa),
    FOREIGN KEY (id_produttore) REFERENCES produttore(id_produttore) ON DELETE CASCADE,
    FOREIGN KEY (tipo_risorsa) REFERENCES risorsa(tipo_risorsa) ON DELETE CASCADE
);

CREATE TABLE uso_risorsa (
    id_uso INT AUTO_INCREMENT PRIMARY KEY,
    tipo_risorsa VARCHAR(100) NOT NULL,
    quantita_usata DECIMAL(10,2) NOT NULL,
    unita_misura ENUM('L', 'Kg', 'm', 'mq', 'Pezzi') NOT NULL,
    data_ora DATETIME NOT NULL,
    id_attivita INT NOT NULL,
    FOREIGN KEY (id_attivita) REFERENCES attivita(id_attivita) ON DELETE CASCADE,
    FOREIGN KEY (tipo_risorsa) REFERENCES risorsa(tipo_risorsa) ON DELETE RESTRICT
);

CREATE TABLE agricolo (
    id_prodotto INT PRIMARY KEY,
    categoria_commerciale ENUM('Classe Extra', 'Classe I', 'Classe II', 'Destinato alla trasformazione') NOT NULL,
    certificazione VARCHAR(100) NULL,
    FOREIGN KEY (id_prodotto) REFERENCES prodotto(id_prodotto) ON DELETE CASCADE
);

CREATE TABLE derivato_animale (
    id_prodotto INT PRIMARY KEY,
    tipologia_conservazione ENUM('Fresco', 'Stagionato', 'Surgelato', 'UHT', 'Essiccato') NOT NULL,
    trattamenti_subiti VARCHAR(250) NULL,
    FOREIGN KEY (id_prodotto) REFERENCES prodotto(id_prodotto) ON DELETE CASCADE
);

CREATE TABLE composizione_ricetta (
    id_prodotto_finito INT NOT NULL,
    id_ingrediente INT NOT NULL,
    quantita_utilizzata DECIMAL(10,2) NOT NULL,
    unita_misura ENUM('ml', 'g', 'Pezzi') NOT NULL,
    PRIMARY KEY (id_prodotto_finito, id_ingrediente),
    FOREIGN KEY (id_prodotto_finito) REFERENCES prodotto(id_prodotto) ON DELETE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES prodotto(id_prodotto) ON DELETE CASCADE
);

CREATE TABLE scorta (
    id_produttore INT NOT NULL,
    id_prodotto INT NOT NULL,
    quantita_disponibile DECIMAL(10,2) NOT NULL,
    unita_misura ENUM('L', 'Kg', 'Pezzi') NOT NULL,
    data_aggiornamento DATE NOT NULL,
    PRIMARY KEY (id_produttore, id_prodotto),
    FOREIGN KEY (id_produttore) REFERENCES produttore(id_produttore) ON DELETE CASCADE,
    FOREIGN KEY (id_prodotto) REFERENCES prodotto(id_prodotto) ON DELETE CASCADE
);

CREATE TABLE vendita (
    id_vendita INT AUTO_INCREMENT PRIMARY KEY,
    quantita DECIMAL(10,2) NOT NULL,
    unita_misura ENUM('L', 'Kg', 'Pezzi') NOT NULL,
    prezzo_totale DECIMAL(10,2) NOT NULL,
    data_ora DATETIME NOT NULL,
    id_produttore INT NOT NULL,
    id_prodotto INT NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE RESTRICT,
    FOREIGN KEY (id_produttore, id_prodotto) REFERENCES scorta(id_produttore, id_prodotto) ON DELETE RESTRICT
);