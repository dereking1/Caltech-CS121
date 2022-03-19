-- [Problem 2a]
INSERT INTO person VALUES
    ('DING696969', 'Ing', '16 Stanley Beach Road, Hong Kong'),
    ('KILE984123', 'Kil', '32 Dasan-ro, Jung gu, Seoul'),
    ('JJKFC12345', 'Olatunji', 
    'Buckingham Palace, London SW1A 1AA, United Kingdom');

INSERT INTO car VALUES
    ('BEAST69', 'Bugatti', 2022),
    ('8008I35', 'Mercedes', 2020);
    
INSERT INTO car(license) VALUES ('KSIFLY1');

INSERT INTO accident(date_occured, location, summary) VALUES
    ('2015-04-28 04:12:34', 'Camden', 'Car totaled.'),
    ('2022-01-25 12:43:15', 'Wan Chai', 'Another car crashed into Ing.');

INSERT INTO accident(date_occured, location) VALUES
    ('2020-07-12 14:23:59', 'Los Angeles');

INSERT INTO owns VALUES
    ('DING696969', 'BEAST69'),
    ('KILE984123', '8008I35'),
    ('JJKFC12345', 'KSIFLY1');

INSERT INTO participated(driver_id, license, damage_amount) VALUES 
    ('JJKFC12345', 'KSIFLY1', 9999.99),
    ('KILE984123', '8008I35', 1.00);
    
INSERT INTO participated(driver_id, license) 
    VALUES ('DING696969', 'BEAST69');
   
-- [Problem 2b]
UPDATE person SET address = '1200 East California Boulevard' WHERE name = 'Ing';

UPDATE car SET license = 'KINGING' WHERE license = 'BEAST69';

-- [Problem 2c]
DELETE FROM car WHERE license = 'KSIFLY1';
