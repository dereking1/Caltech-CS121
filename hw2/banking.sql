-- [Problem 0a]
-- What could go wrong if we were to use FLOAT or DOUBLE 
-- instead of NUMERIC to represent bank account balances?
-- FLOAT and DOUBLE are approximations, while NUMERIC gives exact numbers
-- with a user-specified precision. 
-- If we were to use FLOAT or DOUBLE, 
-- the exact balance of an account may not be correct.

-- [Problem 0b]
-- Identify one attribute in the account relation 
-- which could reasonably be represented with a type other than VARCHAR.
-- The attribute balance could be represented with a NUMERIC 
-- instead of a VARCHAR.
-- With a NUMERIC, you could perform arithmetic operations with.

-- [Problem 1a]
-- Retrieve the loan-numbers and amounts of loans 
-- with amounts of at least 1000 dollars, and at most 2000 dollars.
SELECT loan_number, amount FROM loan 
    WHERE amount BETWEEN 1000 AND 2000;

-- [Problem 1b]
-- Retrieve the loan-number and amount of all loans owned by Smith.
-- Order the results by increasing loan number.
SELECT loan_number, amount FROM loan NATURAL JOIN borrower
    WHERE customer_name = 'Smith' ORDER BY loan_number;

-- [Problem 1c]
-- Retrieve the city of the branch where account A-446 is open.
SELECT branch_city FROM account, branch
    WHERE branch.branch_name = account.branch_name
    AND account_number = 'A-446';

-- [Problem 1d]
-- Retrieve the customer name, account number, branch name, and balance, 
-- of accounts owned by customers whose names start with J. 
-- Order the results by customer name in increasing alphabetical order.
SELECT depositor.customer_name, depositor.account_number, 
    account.branch_name, account.balance
    FROM account, depositor 
    WHERE customer_name LIKE 'J%'
    AND account.account_number = depositor.account_number
    ORDER BY customer_name;

-- [Problem 1e]
-- Retrieve the names of all customers with more than five bank accounts.
SELECT customer_name FROM depositor
    GROUP BY customer_name
    HAVING COUNT(DISTINCT account_number) > 5;
    
-- [Problem 2a]
-- Generate a list of all cities that customers live in, 
-- where there is no bank branch in that city.
SELECT DISTINCT customer_city FROM customer
    WHERE customer_city NOT IN
    (SELECT branch_city FROM branch) 
    ORDER BY customer_city;

-- [Problem 2b] 
-- Write a SQL query that reports the name of any customers 
-- that have neither an account nor a loan.
SELECT DISTINCT customer_name FROM customer
    WHERE customer_name NOT IN (SELECT customer_name FROM depositor)
    AND customer_name NOT IN (SELECT customer_name FROM borrower);

-- [Problem 2c]
-- The bank decides to promote its branches located in the city of Horseneck, 
-- so it wants to make a 75 dollar gift deposit into all accounts 
-- held at branches in the city of Horseneck.  
-- Write the SQL UPDATE command for performing this operation.
UPDATE account SET balance = balance + 75
    WHERE branch_name IN 
    (SELECT account.branch_name FROM branch
    WHERE branch_city = 'Horseneck'
    AND account.branch_name = branch.branch_name);

-- [Problem 2d]
-- Write another answer to part c, using this syntax.  
UPDATE account, branch SET account.balance = account.balance + 75
    WHERE account.branch_name = branch.branch_name 
    AND branch_city = 'Horseneck';

-- [Problem 2e]
-- Retrieve all details (account_number,branch_name,balance) 
-- for the largest account at each branch. 
-- Implement this query as a join against a derived relation in the FROM clause.
SELECT a1.account_number, a1.branch_name, a1.balance 
    FROM (account AS a1 JOIN
    (SELECT branch_name, MAX(balance) as balance FROM account
    GROUP BY branch_name) as a2
    ON a1.branch_name = a2.branch_name
    AND a1.balance = a2.balance);

-- [Problem 2f]
-- Implement the same query as in the previous problem, 
-- this time using an IN predicate with multiple columns.
SELECT account_number, branch_name, balance FROM account
    WHERE (branch_name, balance) IN 
    (SELECT branch_name, MAX(balance) as balance
    FROM account GROUP BY branch_name);

-- [Problem 3]
-- Compute the rank of all bank branches, 
-- based on the amount of assets that each branch holds.
SELECT b1.branch_name, b1.assets, COUNT(b2.branch_name) AS 'rank'
    FROM branch AS b1 LEFT OUTER JOIN branch AS b2
    ON b1.assets < b2.assets OR b1.branch_name = b2.branch_name
    GROUP BY b1.branch_name
    ORDER BY b1.assets DESC;
