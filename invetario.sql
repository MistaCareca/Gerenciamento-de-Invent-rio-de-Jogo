-- Criar o banco de dados
CREATE DATABASE inventario;
USE inventario;

-- Criando Tabelas
CREATE TABLE jogador (
    id_jogador INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    nick VARCHAR(255) UNIQUE,
    total_itens INT DEFAULT 0,
    data_registro DATE NOT NULL
);

CREATE TABLE item (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    tipo ENUM('arma', 'armadura', 'consumivel') NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE inventario (
    id_inventario INT PRIMARY KEY AUTO_INCREMENT,
    id_jogador INT,
    id_item INT,
    quantidade INT NOT NULL CHECK (quantidade >= 0),
    data_adicao DATE NOT NULL,
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) ON DELETE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE
);

-- Trigger para atualizar total_itens em jogador após INSERT
DELIMITER //
CREATE TRIGGER atualiza_total_itens
AFTER INSERT ON inventario
FOR EACH ROW
BEGIN
    UPDATE jogador
    SET total_itens = (
        SELECT COALESCE(SUM(quantidade), 0)
        FROM inventario
        WHERE id_jogador = NEW.id_jogador
    )
    WHERE id_jogador = NEW.id_jogador;
END //
DELIMITER ;

-- Inseririndo dados nas tabelas
INSERT INTO jogador (nome, nick, data_registro) VALUES
('Tryndamere', 'Tirano', '2025-05-01'),
('Ash', 'SUPERGAME', '2025-05-02'),
('Ryze', 'Rayzenberg', '2025-05-03');

INSERT INTO item (nome, tipo, preco, estoque) VALUES
('Espada G.P.C', 'arma', 150.00, 10),
('JakSho, o Inconstante', 'armadura', 100.00, 8),
('Poção de Vida', 'consumivel', 25.00, 50);

INSERT INTO inventario (id_jogador, id_item, quantidade, data_adicao) VALUES
(1, 1, 1, '2025-05-04'), 
(1, 3, 3, '2025-05-05'), 
(2, 2, 1, '2025-05-06'); 

-- Consultas para verificar o trigger
SELECT nome, total_itens
FROM jogador;

-- Detalhar inventário com JOIN
SELECT 
    j.nome AS jogador,
    i.nome AS item,
    inv.quantidade,
    inv.data_adicao
FROM inventario inv
INNER JOIN jogador j ON inv.id_jogador = j.id_jogador
INNER JOIN item i ON inv.id_item = i.id_item;