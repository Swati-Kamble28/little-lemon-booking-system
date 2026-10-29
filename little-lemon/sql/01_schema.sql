CREATE DATABASE IF NOT EXISTS LittleLemonDB;
USE LittleLemonDB;
-- Run against a fresh database. No existing tables are deleted.
CREATE TABLE Customers (
 CustomerID INT PRIMARY KEY AUTO_INCREMENT,
 FullName VARCHAR(100) NOT NULL,
 ContactNumber VARCHAR(30), Email VARCHAR(150)
) ENGINE=InnoDB;
CREATE TABLE Staff (
 StaffID INT PRIMARY KEY AUTO_INCREMENT,
 FullName VARCHAR(100) NOT NULL, Role VARCHAR(50) NOT NULL,
 Salary DECIMAL(10,2) CHECK (Salary >= 0)
) ENGINE=InnoDB;
CREATE TABLE DiningTables (
 TableNumber INT PRIMARY KEY, Capacity INT NOT NULL CHECK (Capacity > 0)
) ENGINE=InnoDB;
CREATE TABLE Bookings (
 BookingID INT PRIMARY KEY AUTO_INCREMENT,
 BookingDate DATE NOT NULL, TableNumber INT NOT NULL,
 CustomerID INT NOT NULL, StaffID INT NULL,
 CONSTRAINT uq_booking_slot UNIQUE (BookingDate, TableNumber),
 FOREIGN KEY (TableNumber) REFERENCES DiningTables(TableNumber),
 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
 FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
) ENGINE=InnoDB;
CREATE TABLE MenuItems (
 MenuItemID INT PRIMARY KEY AUTO_INCREMENT, ItemName VARCHAR(100) NOT NULL,
 Category VARCHAR(50) NOT NULL, Cuisine VARCHAR(50),
 Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
) ENGINE=InnoDB;
CREATE TABLE Orders (
 OrderID INT PRIMARY KEY AUTO_INCREMENT, CustomerID INT NOT NULL,
 BookingID INT NULL, OrderDate DATE NOT NULL,
 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
 FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE OrderItems (
 OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
 OrderID INT NOT NULL, MenuItemID INT NOT NULL,
 Quantity INT NOT NULL CHECK (Quantity > 0),
 UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
 FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
 FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID)
) ENGINE=InnoDB;
CREATE TABLE OrderDeliveryStatus (
 DeliveryID INT PRIMARY KEY AUTO_INCREMENT, OrderID INT NOT NULL UNIQUE,
 DeliveryDate DATE, Status VARCHAR(30) NOT NULL,
 FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
) ENGINE=InnoDB;
CREATE VIEW OrderSummary AS
SELECT o.OrderID, o.CustomerID, o.BookingID, o.OrderDate,
 SUM(i.Quantity) AS Quantity, SUM(i.Quantity*i.UnitPrice) AS TotalCost
FROM Orders o JOIN OrderItems i ON o.OrderID=i.OrderID
GROUP BY o.OrderID,o.CustomerID,o.BookingID,o.OrderDate;
CREATE VIEW TableauSales AS
SELECT o.OrderID, o.OrderDate, c.CustomerID, c.FullName AS CustomerName,
 m.MenuItemID,m.ItemName,m.Category,m.Cuisine,
 i.Quantity,i.UnitPrice,i.Quantity*i.UnitPrice AS Sales
FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID
JOIN OrderItems i ON i.OrderID=o.OrderID
JOIN MenuItems m ON m.MenuItemID=i.MenuItemID;
