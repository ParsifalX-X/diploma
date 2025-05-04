-- Выбираем базу данных
USE ServiceCenterDB;
GO

-- Добавляем статусы заявок
INSERT INTO RequestStatuses (StatusName) VALUES
('Открыта'),
('В процессе ремонта'),
('Ожидание комплектующих'),
('Завершена');
GO

-- Добавляем типы оборудования (примеры, можешь добавить свои)
INSERT INTO EquipmentTypes (TypeName) VALUES
('Кондиционер'),
('Вентиляционная система'),
('Отопительная система'),
('Холодильное оборудование');
GO

-- Добавляем пользователей (примеры)
-- !!! ВАЖНО: Замени 'YourSecurePasswordHashHere' на РЕАЛЬНЫЙ ХЭШ пароля при реализации логина !!!
-- Пока можно временно использовать простую строку для теста, но это НЕБЕЗОПАСНО.
INSERT INTO Users (Username, PasswordHash, FullName, Role, IsActive) VALUES
('admin', 'AdminPassword123', 'Иванов Иван Иванович', 'Admin', 1), -- Администратор
('technician1', 'TechPassword456', 'Петров Петр Петрович', 'Technician', 1), -- Специалист
('operator1', 'OperatorPassword789', 'Сидорова Анна Сергеевна', 'Operator', 1); -- Оператор
GO

PRINT 'Initial data (Statuses, Equipment Types, Users) inserted successfully!';