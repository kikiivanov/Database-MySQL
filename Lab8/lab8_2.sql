USE transaction_test;

#4
DELIMITER |
DROP PROCEDURE IF EXISTS converter;
CREATE PROCEDURE converter (IN amount DOUBLE, IN currency VARCHAR(5), OUT returnAmount DOUBLE)
BEGIN
	IF (currency = "BGN")
    THEN
		SET returnAmount = amount * 0.51;
	ELSE IF (currency = "EUR")
	THEN	
		SET returnAmount = amount * 1.94;
	END IF;
    END IF;
END;
|
DELIMITER ;

CALL converter('1000.00', 'BGN', @returnAmount);

#5
DROP PROCEDURE IF EXISTS transactionIds;
DELIMITER //
CREATE PROCEDURE transactionIds(IN firstId INT, IN secondId INT, IN transferAmount DOUBLE)
BEGIN
	DECLARE firstCurrency VARCHAR(5);
    DECLARE secondCurrency VARCHAR(5);
    
    SELECT currency
    INTO firstCurrency
    FROM customer_accounts
    WHERE id = firstId;
    
    SELECT currency
    INTO secondCurrency
    FROM customer_accounts
    WHERE id = secondId;
    
    IF ((firstCurrency != 'BGN' AND firstCurrency != 'EUR') AND (secondCurrency != 'BGN' AND secondCurrency != 'EUR'))
    THEN
		SELECT "Currencies must be either 'BGN' or 'EUR'!";
	ELSE
		IF ((SELECT amount
			FROM customer_accounts
			WHERE id = firstId) - transferAmount < 0)
		THEN
			SELECT "Not enough money to withdraw!";
		ELSE
			START TRANSACTION;
				UPDATE customer_accounts
                SET amount = amount - transferAmount
                WHERE id = firstId;
                
                IF (ROW_COUNT() = 0)
                THEN
					SELECT "Transaction couldn't execute!";
                    ROLLBACK;
				ELSE
					IF (firstCurrency != secondCurrency)
                    THEN
						SET @returnAmount = 0;
                        CALL converter(transferAmount, firstCurrency, @returnAmount);
					ELSE
						SET @returnAmount = transferAmount;
					END IF;
                    
                    UPDATE customer_accounts
                    SET amount = amount + @returnAmount
                    WHERE id = secondId;
                    
                    IF (ROW_COUNT() = 0)
                    THEN
						SELECT "Transaction couldn't execute!";
                        ROLLBACK;
					ELSE
						COMMIT;
					END IF;
				END IF;
			END IF;
		END IF;
END;
//
DELIMITER ;
