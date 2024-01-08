USE transaction_test;

#5
DELIMITER //
DROP PROCEDURE IF EXISTS transfer_money;
CREATE PROCEDURE transfer_money(IN from_acc_id INT, IN to_acc_id INT, IN transferAmount DECIMAL(10, 2))
BEGIN
    DECLARE from_acc_balance DECIMAL(10, 2);
    DECLARE to_acc_balance DECIMAL(10, 2);

    START TRANSACTION;

    SELECT amount INTO from_acc_balance FROM customer_accounts WHERE id = from_acc_id FOR UPDATE;
    SELECT amount INTO to_acc_balance FROM customer_accounts WHERE id = to_acc_id FOR UPDATE;

    IF from_acc_balance < transferAmount THEN
        SET @error_message = 'Недостатъчно пари на сметката за трансфер.';
    ELSE
        UPDATE customer_accounts SET amount = amount - transferAmount WHERE id = from_acc_id;
        
        IF ROW_COUNT() = 0 THEN
            SET @error_message = 'Неуспешна транзакция.';
            ROLLBACK;
            SELECT @error_message;
        ELSE
            UPDATE customer_accounts SET amount = amount + transferAmount WHERE id = to_acc_id;
            IF ROW_COUNT() = 0 THEN
                SET @error_message = 'Неуспешна транзакция.';
                ROLLBACK;
                SELECT @error_message;
            ELSE
                COMMIT;
                SELECT 'Транзакцията беше успешна.';
            END IF;
        END IF;
    END IF;
END 
//
DELIMITER ;

CALL transfer_money(1, 2, 5000.00);

#6
DELIMITER //
DROP PROCEDURE IF EXISTS transfer_money;
CREATE PROCEDURE transfer_money (
    IN sender_name VARCHAR(255),
    IN recipient_name VARCHAR(255),
    IN transferAmount DOUBLE,
    IN currency VARCHAR(10)
)
BEGIN
    DECLARE sender_id, recipient_id, affected_rows INT;
    DECLARE sender_balance, recipient_balance DOUBLE;
    
    SELECT id INTO sender_id FROM customers WHERE name = sender_name;
    SELECT id INTO recipient_id FROM customers WHERE name = recipient_name;
    
    SELECT transferAmount INTO sender_balance FROM customer_accounts WHERE customer_id = sender_id AND currency = currency;
    SELECT transferAmount INTO recipient_balance FROM customer_accounts WHERE customer_id = recipient_id AND currency = currency;
    
    IF sender_balance < amount THEN
        SELECT 'Not enough funds' AS error_message;
    ELSE
        UPDATE customer_accounts SET transferAmount = sender_balance - transferAmount WHERE customer_id = sender_id AND currency = currency;
        SET affected_rows = ROW_COUNT();
        IF affected_rows = 0 THEN
            SELECT 'Transaction failed' AS error_message;
        ELSE
            UPDATE customer_accounts SET transferAmount = recipient_balance + transferAmount WHERE customer_id = recipient_id AND currency = currency;
            SET affected_rows = ROW_COUNT();
            IF affected_rows = 0 THEN
                UPDATE customer_accounts SET transferAmount = sender_balance WHERE customer_id = sender_id AND currency = currency;
                SELECT 'Transaction failed' AS error_message;
            ELSE
                SELECT 'Transaction successful' AS status_message;
            END IF;
        END IF;
    END IF;
END;
//
DELIMITER ;