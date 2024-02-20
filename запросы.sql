DROP DATABASE `assembly_systes_lousql`;
CREATE TABLE Номенклатура (
    id INT AUTO_INCREMENT PRIMARY KEY,
    название VARCHAR(100) CHARACTER SET utf8mb4,
    тип VARCHAR(50) CHARACTER SET utf8mb4,
    срок_сборки INT
) CHARACTER SET utf8mb4;
CREATE TABLE Заказы ( id INT AUTO_INCREMENT PRIMARY KEY, номер_заказа NVARCHAR(50), дата_заказа DATE );
CREATE TABLE Состав_заказа ( id INT AUTO_INCREMENT PRIMARY KEY, id_заказа INT, id_номенклатуры INT, количество INT );
show tables;
INSERT INTO Номенклатура (id, название, тип, срок_сборки)
VALUES
(1, 'Запчасть 1', 'запчасть', 1),
(2, 'Запчасть 2', 'запчасть', 2),
(3, 'Комплект 1', 'комплект', 3),
(4, 'Комплект 2', 'комплект', 4);
INSERT INTO Сборочные_площадки (id, название)
VALUES
(1, 'Площадка 1'),
(2, 'Площадка 2');
INSERT INTO Заказы (id, номер_заказа, дата_заказа)
VALUES		
(1, 'Заказ 1', '2022-07-15'),
(2, 'Заказ 2', '2022-07-20');
INSERT INTO Состав_заказа (id, id_заказа, id_номенклатуры, количество)
VALUES
(1, 1, 1, 5),
(2, 1, 3, 2),
(3, 2, 2, 3),
(4, 2, 4, 1);
