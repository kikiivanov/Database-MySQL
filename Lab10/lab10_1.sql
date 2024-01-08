USE `cableCompany`;

-- 1. Създайте процедура, всеки месец извършва превод от депозираната от клиента сума, с който се заплаща месечната такса. 
-- Нека процедурата получава като входни параметри id на клиента и сума за превод, ако преводът е успешен - третият изходен 
-- параметър от тип BIT да приема стойност 1, в противен случай 0.

DROP PROCEDURE IF EXISTS transfer_money;
DELIMITER |
CREATE PROCEDURE transfer_money(IN client_id INT, IN transferAmount DOUBLE, OUT res BIT)
BEGIN
	START TRANSACTION;
	IF (SELECT amount 
		FROM accounts 
        WHERE accounts.customer_id = client_id) < transferAmount THEN 
        SELECT 'Not enough money!';
	ELSE
		UPDATE accounts
		SET amount = amount - transferAmount 
		WHERE customer_id = client_id;
		IF(ROW_COUNT() = 0) 
		THEN 
			SET res = 0;
			ROLLBACK;
		ELSE 
			SET res = 1; 
			COMMIT;
		END IF;
		SELECT * FROM accounts;
		SELECT res;
	END IF;
END |
DELIMITER ;

SELECT * FROM accounts;
SET @res = 0;
CALL transfer_money(1, 550, @res);


-- 2. Създайте процедура, която извършва плащания в системата за потребителите, депозирали суми.  
-- Ако някое плащане е неуспешно, трябва да се направи запис в таблица длъжници. Използвайте трансакция и курсор.

DROP PROCEDURE IF EXISTS trans;
DELIMITER |
CREATE PROCEDURE trans()
BEGIN
	DECLARE done INT;
    DECLARE tempPaymentAmount DOUBLE;
    DECLARE tempMonth INT;
    DECLARE tempYear YEAR;
    DECLARE tempDateOfPayment DATETIME;
    DECLARE tempCustomerID INT;
    DECLARE tempPlanID INT;
    DECLARE tempAmount DOUBLE;
    
    DECLARE payment_cursor CURSOR FOR
    SELECT payments.paymentAmount, payments.month, payments.year, payments.DateOfPayment,
	payments.customer_id, payments.plan_id, accounts.amount 
    FROM payments 
    JOIN accounts 
    ON accounts.customer_id = payments.customer_id 
    JOIN plans ON plans.id = payments.plan_id
    WHERE accounts.amount >= payments.paymentAmount;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    SET done = 0;
    
    START TRANSACTION;
    
    OPEN payment_cursor;
    
    payment_loop: WHILE(done = 0)
    DO
		FETCH payment_cursor 
		INTO tempPaymentAmount, tempMonth, tempYear, tempDateOfPayment, tempCustomerID, tempPlanID, tempAmount;
		
        IF(done = 1) THEN 
			LEAVE payment_loop;
		ELSE
			UPDATE accounts
			SET amount = amount - tempPaymentAmount 
			WHERE customer_id = tempCustomerID;
				
			IF(ROW_COUNT() = 0) 
			THEN 
				INSERT INTO debtors (customer_id, plan_id, debt_amount) 
				VALUES (tempCustomerID, tempPlanID, tempPaymentAmount);
				ROLLBACK;
				LEAVE payment_loop;
			END IF;
			
			INSERT INTO payments(paymentAmount, month, year, dateOfPayment, customer_id, plan_id)
			VALUE(tempPaymentAmount, MONTH(NOW()), YEAR(NOW()), NOW(), tempCustomerID, tempPlanID);
		END IF;
	END WHILE;
    CLOSE payment_cursor;
    
    IF(done = 1) THEN 
		SELECT 'Commited';
        COMMIT;
    END IF;
END |
DELIMITER ;

CALL trans();


--  3. Създайте event, който се изпълнява на 28-я ден от всеки месец и извиква втората процедура.

DELIMITER |
CREATE EVENT monthlyPayment
ON SCHEDULE EVERY 28 DAY
DO
BEGIN
	CALL trans();
END |
DELIMITER ;


-- 4. Създайте VIEW, което да носи информация за трите имена на клиентите, 
-- дата на подписване на договор, план, дължимите суми.

DROP VIEW IF EXISTS clients_info;
CREATE VIEW clients_info 
AS
SELECT CONCAT(customers.firstName, ' ', customers.middleName, ' ', customers.lastName) AS customer_name, 
DATE_FORMAT(CONCAT(payments.year, '-', payments.month, '-01'), '%M, %Y') AS payment_date,
plans.name AS plan, plans.monthly_fee 
FROM payments 
JOIN customers ON payments.customer_id = customers.customerID
JOIN plans ON payments.plan_id = plans.planID 
WHERE plans.planID = 1;

SELECT * FROM clients_info;


-- 5. Създайте тригер, който при добавяне на нов план, проверява дали въведената такса 
-- е по-малка от 10 лева. Ако е по-малка, то добавянето се прекратява, ако не, то се осъществява.

DROP TRIGGER IF EXISTS before_plans_insert;
DELIMITER |
CREATE TRIGGER before_plans_insert BEFORE INSERT ON plans
FOR EACH ROW
BEGIN
    IF NEW.monthly_fee < 10 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Monthly fee < 10 lv';
    END IF;
END |
DELIMITER ;

INSERT INTO plans (name, monthly_fee) 
VALUES ('Basic', 10.00);


-- 6. Създайте тригер, който при добавяне на сума в клиентска сметка проверява дали сумата, 
-- която трябва да бъде добавена не е по-малка от дължимата сума. Ако е по-малка, 
-- то добавянето се прекратява, ако не, то се осъществява.

DROP TRIGGER IF EXISTS before_payments_insert;
DELIMITER |
CREATE TRIGGER before_payments_insert BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
	IF(NEW.paymentAmount < (SELECT monthly_fee 
							FROM plans 
							WHERE NEW.plan_id = plans.planID)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Amount < Fee !';
	END IF;
END | 
DELIMITER ;

INSERT INTO payments (paymentAmount, month, year, dateOfPayment, customer_id, plan_id) 
VALUES (10.00, 1, 2023, NOW(), 2, 1);


-- 7. Създайте процедура, която при подадени имена на клиент 
-- извежда всички данни за клиента, както и извършените плащания.

DROP PROCEDURE IF EXISTS clients_data;
DELIMITER |
CREATE PROCEDURE clients_data(IN fName VARCHAR(100), IN sName varchar(111), IN lName VARCHAR(100))
BEGIN
	SELECT customers.*, payments.* 
    FROM customers 
    JOIN payments ON customers.customerID = payments.customer_id 
    WHERE customers.firstName = fName 
    AND customers.middleName = sName 
    AND customers.lastName = lName;
END |
DELIMITER ;

CALL clients_data('John', 'Doe', 'Smith');