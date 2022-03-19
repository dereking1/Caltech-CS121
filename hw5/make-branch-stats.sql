-- [Problem 1]
CREATE INDEX account_idx ON account (branch_name, balance);

-- [Problem 2]
-- Table holding materialized results of the view branch_account_stats.
DROP TABLE IF EXISTS mv_branch_account_stats;

CREATE TABLE mv_branch_account_stats (
    branch_name VARCHAR(15) NOT NULL,
    num_accounts INT NOT NULL,
    total_deposits NUMERIC(14, 2) NOT NULL,
    min_balance NUMERIC(12, 2) NOT NULL,
    max_balance NUMERIC(12, 2) NOT NULL,
    PRIMARY KEY (branch_name)
);

-- [Problem 3]
INSERT INTO mv_branch_account_stats (
    SELECT branch_name,
        COUNT(*) AS num_accounts,
        SUM(balance) AS total_deposits,
        MIN(balance) AS min_balance,
        MAX(balance) AS max_balance
    FROM account GROUP BY branch_name);

-- [Problem 4]
DROP VIEW IF EXISTS branch_account_stats;
CREATE VIEW branch_account_stats AS
    SELECT branch_name, num_accounts, total_deposits,
        total_deposits / num_accounts AS avg_balance, 
        min_balance, max_balance
        FROM mv_branch_account_stats;

-- [Problem 5]
-- Provided solution for Problem 5
DELIMITER !

-- A procedure to execute when inserting a new branch name and balance
-- to the bank account stats materialized view (mv_branch_account_stats).
-- If a branch is already in view, its current balance is updated
-- to account for total deposits and adjusted min/max balances.
CREATE PROCEDURE sp_branchstat_newacct(
    new_branch_name VARCHAR(15),
    new_balance NUMERIC(12, 2)
)
BEGIN 
    INSERT INTO mv_branch_account_stats 
        -- branch not already in view; add row
        VALUES (new_branch_name, 1, new_balance, new_balance, new_balance)
    ON DUPLICATE KEY UPDATE 
        -- branch already in view; update existing row
        num_accounts = num_accounts + 1,
        total_deposits = total_deposits + new_balance,
        min_balance = LEAST(min_balance, new_balance),
        max_balance = GREATEST(max_balance, new_balance);
END !

-- Handles new rows added to account table, updates stats accordingly
CREATE TRIGGER trg_account_insert AFTER INSERT
        ON account FOR EACH ROW
BEGIN
    CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);
END !
DELIMITER ;

-- [Problem 6]
DELIMITER !

-- A procedure to execute when deleting a branch name and balance
-- to the bank account stats materialized view (mv_branch_account_stats).
-- If a branch is already in view, its current balance is updated
-- to account for total deposits and adjusted min/max balances.
CREATE PROCEDURE sp_branchstat_deleteacct(
    delete_branch VARCHAR(15),
    delete_balance NUMERIC(12, 2)
)
BEGIN
    DELETE FROM mv_branch_account_stats WHERE
        branch_name = delete_branch AND num_accounts = 1;
	
    IF old_branch IN (SELECT branch_name FROM
        mv_branch_account_stats) THEN
        UPDATE mv_branch_account_stats
            SET num_accounts = num_accounts - 1,
            total_deposits = total_deposits - delete_balance;
    END IF;
    
    IF delete_balance = (SELECT min_balance FROM mv_branch_account_stats 
        WHERE branch_name = delete_branch)
        THEN UPDATE mv_branch_account_stats SET min_balance =
            (SELECT MIN(balance) FROM account
                WHERE branch_name = delete_branch)
            WHERE branch_name = delete_branch;
    
    ELSEIF delete_balance = (SELECT max_balance FROM mv_branch_account_stats 
        WHERE branch_name = delete_branch)
        THEN UPDATE mv_branch_account_stats SET max_balance =
            (SELECT MAX(balance) FROM account
                WHERE branch_name = delete_branch)
            WHERE branch_name = delete_branch;
    END IF;
END !

-- Handles new rows deleted from account table, updates stats accordingly
CREATE TRIGGER trg_account_delete AFTER DELETE
        ON account FOR EACH ROW
BEGIN
    CALL sp_branchstat_deleteacct(OLD.branch_name, OLD.balance);
END !
DELIMITER ;
            
-- [Problem 7]
DELIMITER !

-- Handles new rows deleted from account table, updates stats accordingly
CREATE TRIGGER trg_account_update AFTER UPDATE
        ON account FOR EACH ROW
BEGIN
    IF OLD.branch_name <> NEW.branch_name THEN
        CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);
        CALL sp_branchstat_deleteacct(OLD.branch_name, OLD.balance);

    ELSEIF OLD.balance <> NEW.balance THEN
        UPDATE mv_branch_account_stats
            SET total_deposits = total_deposits + NEW.balance - OLD.balance,
            min_balance = LEAST(min_balance, NEW.balance),
            max_balance = GREATEST(max_balance, NEW.balance)
            WHERE branch_name = NEW.branch_name;
        
        IF OLD.balance = (SELECT min_balance FROM mv_branch_account_stats 
            WHERE branch_name = OLD.branch)
            THEN UPDATE mv_branch_account_stats SET min_balance =
                (SELECT MIN(balance) FROM account
                WHERE branch_name = OLD.branch)
                WHERE branch_name = OLD.branch;
        
        ELSEIF OLD.balance = (SELECT max_balance FROM mv_branch_account_stats 
            WHERE branch_name = OLD.branch)
            THEN UPDATE mv_branch_account_stats SET OLD.balance =
                (SELECT MAX(balance) FROM account
                    WHERE branch_name = OLD.branch)
            WHERE branch_name = OLD.branch;
        END IF;

    END IF;
END !
DELIMITER ;
