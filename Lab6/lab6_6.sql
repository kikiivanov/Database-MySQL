USE transaction_test;

BEGIN;

-- избираме сметката на Stoyan Pavlov Pavlov в лева
SELECT customers.name, amount, currency 
FROM customers
JOIN customer_accounts 
ON customers.id = customer_id
WHERE currency = 'BGN' 
AND customer_id = (
	SELECT id 
    FROM customers 
    WHERE name = 'Stoyan Pavlov Pavlov'
);

-- намаляме баланса на сметката на Stoyan Pavlov Pavlov с 50 000 лева
UPDATE customer_accounts 
SET amount = amount - 50000 
WHERE currency = 'BGN' 
AND customer_id = (
	SELECT id 
    FROM customers 
    WHERE name = 'Stoyan Pavlov Pavlov'
);

-- увеличаваме баланса на сметката на Ivan Petrov Iordanov с 50 000 лева
UPDATE customer_accounts 
SET amount = amount + 50000 
WHERE currency = 'BGN' 
AND customer_id IN (
	SELECT id 
    FROM customers 
    WHERE name = 'Ivan Petrov Iordanov'
);

COMMIT;