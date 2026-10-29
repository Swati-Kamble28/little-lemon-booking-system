USE LittleLemonDB;
-- Synthetic demonstration data, NOT the course spreadsheet. Run once.
INSERT INTO Customers VALUES (1,'Alex Morgan','000-001','alex@example.com'),(2,'Sam Lee','000-002','sam@example.com'),(3,'Jordan Patel','000-003','jordan@example.com');
INSERT INTO Staff VALUES(1,'Casey Taylor','Manager',40000);
INSERT INTO DiningTables VALUES(1,2),(2,4),(3,4),(4,6),(5,2);
INSERT INTO Bookings VALUES(1,'2026-11-01',1,1,1),(2,'2026-11-01',2,2,1),(3,'2026-11-02',1,3,1);
INSERT INTO MenuItems VALUES(1,'Greek salad','Starter','Greek',8.50),(2,'Lemon chicken','Main','Mediterranean',18.00),(3,'Baklava','Dessert','Turkish',6.00),(4,'Lemonade','Drink','Mediterranean',4.00);
INSERT INTO Orders VALUES(1,1,1,'2026-11-01'),(2,2,2,'2026-11-01'),(3,3,3,'2026-11-02');
INSERT INTO OrderItems VALUES(1,1,1,2,8.50),(2,1,2,2,18.00),(3,2,2,3,18.00),(4,2,4,3,4.00),(5,3,3,2,6.00);
INSERT INTO OrderDeliveryStatus VALUES(1,1,'2026-11-01','Delivered'),(2,2,'2026-11-01','Delivered');
-- Expected max order quantity: 6. Expected total sales: 131.00.
