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
DELIMITER //

CREATE PROCEDURE Добавить_Заказ (
    IN номер_заказа NVARCHAR(50),
    IN дата_заказа DATE,
    IN id_номенклатуры INT,
    IN количество INT
)
BEGIN
    DECLARE id_заказа INT;

    INSERT INTO Заказы (номер_заказа, дата_заказа)
    VALUES (номер_заказа, дата_заказа);

    SET id_заказа = LAST_INSERT_ID();

    INSERT INTO Состав_заказа (id_заказа, id_номенклатуры, количество)
    VALUES (id_заказа, id_номенклатуры, количество);
END //

DELIMITER //

CREATE PROCEDURE Добавить_Заказ (
    IN номер_заказа CHAR(50) CHARACTER SET utf8mb4,
    IN дата_заказа DATE,
    IN id_номенклатуры INT,
    IN количество INT
)  
BEGIN
    DECLARE id_заказа INT;

    INSERT INTO Заказы (номер_заказа, дата_заказа)  
    VALUES (номер_заказа, дата_заказа); 

    SET id_заказа = LAST_INSERT_ID(); 

    INSERT INTO Состав_заказа (id_заказа, id_номенклатуры, количество)  
    VALUES (id_заказа, id_номенклатуры, количество); 
END //

DELIMITER ;

SELECT * FROM Заказы;
CALL Добавить_Заказ('Заказ 3', '2022-08-01', 1, 3);
CALL Добавить_Заказ('Заказ 4', '2022-08-05', 2, 5);
DROP PROCEDURE IF EXISTS Добавить_Заказ;
INSERT INTO Заказы (id, номер_заказа, дата_заказа)
VALUES (5, 'Заказ 5', '2022-08-10');
DELIMITER //
CREATE FUNCTION CountItemsOnAssemblySites()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE количество_номенклатуры INT;
    
    SELECT COUNT(o.id) INTO количество_номенклатуры
    FROM Сборочные_площадки p
    LEFT JOIN Заказы o ON p.id = o.id_площадки
    GROUP BY p.id;

    RETURN количество_номенклатуры;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION CreateAssemblyPlan(площадка INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE план INT;
    
    SELECT COUNT(id_заказа) INTO план
    FROM Состав_заказа
    WHERE id_заказа = (SELECT id FROM Заказы WHERE id_площадки = площадка);
    
    RETURN план;
END //

DELIMITER ;

создать еще одну функцию для определения возможности выполнения заказа. Эта функция будет проверять, достаточно ли свободных остатков и времени на сборке для выполнения заказа на каждой сборочной площадке.

Вот пример того, как можно создать функцию для определения возможности выполнения заказа:

Picture of the author
DELIMITER //

CREATE FUNCTION CheckOrderFeasibility(площадка INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE возможность BOOLEAN;
    
    IF EXISTS (SELECT * FROM Свободные_остатки WHERE id_площадки = площадка) AND целесообразность_сборки(площадка) = TRUE THEN
        SET возможность = TRUE;
    ELSE
        SET возможность = FALSE;
    END IF;
    
    RETURN возможность;
END //

DELIMITER ;
Создайте функцию, которая будет определять общее время, необходимое для сборки всех номенклатур заказа на определенной сборочной площадке.

Пример функции:
Picture of the author
DELIMITER //

CREATE FUNCTION CalculateAssemblyTime(площадка INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE время_сборки INT;
    
    SELECT SUM(срок_сборки) INTO время_сборки
    FROM Состав_заказа
    INNER JOIN orders ON Состав_заказа.id_заказа = orders.id
    WHERE id_площадки = площадка;
    
    RETURN время_сборки;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE GetPickUpPlaces(заказ INT)
BEGIN
    SELECT p.id AS id_площадки, SUM(s.количество) AS количество
    FROM Состав_заказа s
    JOIN Сборочные_площадки p ON s.id_площадки = p.id
    WHERE s.id_заказа = заказ
    GROUP BY p.id;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION FinalAssemblyTimeEstimate(заказ INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE время_сборки INT;
    
    SELECT SUM(срок_сборки) INTO время_сборки
    FROM Состав_заказа s
    JOIN Свободные_остатки o ON s.id_номенклатуры = o.id_номенклатуры
    WHERE s.id_заказа = заказ;
    
    RETURN время_сборки;
END //

DELIMITER ;
SET @заказ := 45; 
CALL GetPickUpPlaces(@заказ); 