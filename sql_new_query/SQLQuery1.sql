-- Выбираем базу данных для работы (на всякий случай)
USE ServiceCenterDB;
GO -- Разделитель пакетов команд

-- Таблица 1: Справочник типов оборудования
CREATE TABLE EquipmentTypes (
    EquipmentTypeID INT PRIMARY KEY IDENTITY(1,1), -- ID типа, автоинкремент
    TypeName NVARCHAR(100) NOT NULL UNIQUE       -- Название типа, обязательное, уникальное
);
GO

-- Таблица 2: Справочник статусов заявок
CREATE TABLE RequestStatuses (
    StatusID INT PRIMARY KEY IDENTITY(1,1),   -- ID статуса, автоинкремент
    StatusName NVARCHAR(50) NOT NULL UNIQUE   -- Название статуса, обязательное, уникальное
);
GO

-- Таблица 3: Пользователи системы (сотрудники)
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),      -- ID пользователя, автоинкремент
    Username NVARCHAR(50) NOT NULL UNIQUE,     -- Логин, обязательный, уникальный
    PasswordHash NVARCHAR(MAX) NOT NULL,       -- ХЭШ пароля, обязательный (!!! НЕ ХРАНИТЬ ПАРОЛЬ В ЧИСТОМ ВИДЕ !!!)
    FullName NVARCHAR(150) NOT NULL,           -- ФИО сотрудника, обязательное
    Role NVARCHAR(20) NOT NULL,                -- Роль (Admin, Technician, Operator), обязательная
    IsActive BIT NOT NULL DEFAULT 1            -- Флаг активности (1 - активен, 0 - не активен), по умолчанию активен
);
GO

-- Таблица 4: Заказчики
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1), -- ID заказчика, автоинкремент
    FullName NVARCHAR(150) NOT NULL,        -- ФИО заказчика, обязательное
    PhoneNumber NVARCHAR(30) NOT NULL,      -- Номер телефона, обязательный
    Email NVARCHAR(100) NULL,               -- Email (необязательно)
    Address NVARCHAR(255) NULL              -- Адрес (необязательно)
);
GO

-- Таблица 5: Заявки на ремонт
CREATE TABLE Requests (
    RequestID INT PRIMARY KEY IDENTITY(1,1),       -- ID заявки, автоинкремент
    DateCreated DATETIME NOT NULL DEFAULT GETDATE(), -- Дата создания, по умолчанию текущая дата и время
    EquipmentTypeID INT NOT NULL,                  -- Ссылка на тип оборудования, обязательная
    DeviceModel NVARCHAR(100) NULL,                -- Модель устройства (необязательно)
    ProblemDescription NVARCHAR(MAX) NOT NULL,     -- Описание проблемы, обязательное
    CustomerID INT NOT NULL,                       -- Ссылка на заказчика, обязательная
    StatusID INT NOT NULL,                         -- Ссылка на текущий статус, обязательная
    AssignedTechnicianID INT NULL,                 -- Ссылка на назначенного специалиста (необязательно)
    CreatorUserID INT NOT NULL,                    -- Ссылка на сотрудника, создавшего заявку, обязательная
    DateCompleted DATETIME NULL,                   -- Дата завершения (необязательно)

    -- Внешние ключи (связи с другими таблицами)
    FOREIGN KEY (EquipmentTypeID) REFERENCES EquipmentTypes(EquipmentTypeID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (StatusID) REFERENCES RequestStatuses(StatusID),
    FOREIGN KEY (AssignedTechnicianID) REFERENCES Users(UserID),
    FOREIGN KEY (CreatorUserID) REFERENCES Users(UserID)
);
GO

-- Таблица 6: Комментарии к заявкам
CREATE TABLE RequestComments (
    CommentID INT PRIMARY KEY IDENTITY(1,1),       -- ID комментария, автоинкремент
    RequestID INT NOT NULL,                        -- Ссылка на заявку, обязательная
    UserID INT NOT NULL,                           -- Ссылка на пользователя (сотрудника), оставившего комментарий, обязательная
    CommentText NVARCHAR(MAX) NOT NULL,            -- Текст комментария, обязательный
    DateAdded DATETIME NOT NULL DEFAULT GETDATE(), -- Дата добавления, по умолчанию текущая

    -- Внешние ключи
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- Таблица 7: Комплектующие, связанные с заявкой
CREATE TABLE RequestParts (
    RequestPartID INT PRIMARY KEY IDENTITY(1,1), -- ID записи, автоинкремент
    RequestID INT NOT NULL,                     -- Ссылка на заявку, обязательная
    PartName NVARCHAR(150) NOT NULL,           -- Название комплектующего, обязательное
    PartNumber NVARCHAR(50) NULL,              -- Артикул/номер (необязательно)
    Quantity INT NOT NULL DEFAULT 1,            -- Количество, по умолчанию 1
    Notes NVARCHAR(255) NULL,                   -- Примечания (необязательно)
    AddedByUserID INT NOT NULL,                 -- Ссылка на сотрудника, добавившего запись, обязательная
    DateAdded DATETIME NOT NULL DEFAULT GETDATE(), -- Дата добавления записи, по умолчанию текущая

    -- Внешние ключи
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (AddedByUserID) REFERENCES Users(UserID)
);
GO

-- Сообщение об успешном создании таблиц
PRINT 'All tables created successfully in ServiceCenterDB!';