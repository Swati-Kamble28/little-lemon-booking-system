USE LittleLemonDB;
DELIMITER $$
DROP PROCEDURE IF EXISTS GetMaxQuantity$$
CREATE PROCEDURE GetMaxQuantity()
BEGIN
 -- Quantity means total item units per order in this normalized schema.
 SELECT COALESCE(MAX(Quantity),0) AS MaxQuantityInOrder FROM OrderSummary;
END$$
DROP PROCEDURE IF EXISTS ManageBooking$$
CREATE PROCEDURE ManageBooking(IN p_Date DATE, IN p_Table INT)
BEGIN
 IF p_Date IS NULL OR NOT EXISTS (SELECT 1 FROM DiningTables WHERE TableNumber=p_Table) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Valid date and existing table required';
 END IF;
 SELECT CASE WHEN EXISTS(SELECT 1 FROM Bookings WHERE BookingDate=p_Date AND TableNumber=p_Table)
  THEN CONCAT('Table ',p_Table,' is already booked')
  ELSE CONCAT('Table ',p_Table,' is available') END AS BookingStatus;
END$$
DROP PROCEDURE IF EXISTS AddBooking$$
CREATE PROCEDURE AddBooking(IN p_ID INT, IN p_Customer INT, IN p_Table INT, IN p_Date DATE)
BEGIN
 -- UNIQUE(date,table) enforces availability even with simultaneous requests.
 DECLARE EXIT HANDLER FOR 1062
 BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Booking ID or table/date already booked';
 END;
 IF p_ID IS NULL OR p_ID <= 0 OR p_Date IS NULL THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Positive booking ID and date required';
 END IF;
 INSERT INTO Bookings(BookingID,CustomerID,TableNumber,BookingDate)
 VALUES(p_ID,p_Customer,p_Table,p_Date);
 SELECT CONCAT('New booking ',p_ID,' added') AS Confirmation;
END$$
DROP PROCEDURE IF EXISTS UpdateBooking$$
CREATE PROCEDURE UpdateBooking(IN p_ID INT, IN p_Date DATE)
BEGIN
 DECLARE v_ID INT DEFAULT NULL;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 IF p_Date IS NULL THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Booking date required';
 END IF;
 START TRANSACTION;
 SELECT BookingID INTO v_ID FROM Bookings WHERE BookingID=p_ID FOR UPDATE;
 IF v_ID IS NULL THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Booking not found';
 END IF;
 UPDATE Bookings SET BookingDate=p_Date WHERE BookingID=p_ID;
 COMMIT;
 SELECT CONCAT('Booking ',p_ID,' updated') AS Confirmation;
END$$
DROP PROCEDURE IF EXISTS CancelBooking$$
CREATE PROCEDURE CancelBooking(IN p_ID INT)
BEGIN
 DECLARE v_Count INT;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 DELETE FROM Bookings WHERE BookingID=p_ID;
 SET v_Count=ROW_COUNT();
 IF v_Count=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Booking not found'; END IF;
 COMMIT;
 SELECT CONCAT('Booking ',p_ID,' cancelled') AS Confirmation;
END$$
DELIMITER ;
