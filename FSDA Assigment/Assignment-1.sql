USE INEURON_ASSIGNMENT_DB;

------------------------------------------------------------ TASK 1 -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE PK_SHOPPING_HISTORY(
    PRODUCT VARCHAR2 NOT NULL,
    QUANTITY INT NOT NULL,
    UNIT_PRICE INT NOT NULL
);

DESCRIBE TABLE PK_SHOPPING_HISTORY;

INSERT INTO PK_SHOPPING_HISTORY VALUES('MILK',3,10);
INSERT INTO PK_SHOPPING_HISTORY VALUES('BREAD',7,3);
INSERT INTO PK_SHOPPING_HISTORY VALUES('EGG',4,6);
INSERT INTO PK_SHOPPING_HISTORY VALUES('MILK',2,6);
INSERT INTO PK_SHOPPING_HISTORY VALUES('SUGAR',2,20);
INSERT INTO PK_SHOPPING_HISTORY VALUES('MILK',6,8);
INSERT INTO PK_SHOPPING_HISTORY VALUES('EGG',7,5);
INSERT INTO PK_SHOPPING_HISTORY VALUES('BREAD',3,5);
INSERT INTO PK_SHOPPING_HISTORY VALUES('SUGAR',6,15);
INSERT INTO PK_SHOPPING_HISTORY VALUES('EGG',20,4);
INSERT INTO PK_SHOPPING_HISTORY VALUES('MILK',7,9);

SELECT * FROM PK_SHOPPING_HISTORY;

SELECT PRODUCT, SUM(QUANTITY*UNIT_PRICE) AS TOTAL_PRICE
FROM PK_SHOPPING_HISTORY
GROUP BY 1
ORDER BY 1 DESC;

------------------------------------------------------------- TASK 2 ----------------------------------------------------------------------------------------

CREATE TABLE PK_PHONES(
    NAME VARCHAR2 NOT NULL UNIQUE,
    PHONE INT NOT NULL UNIQUE
);

DESCRIBE TABLE PK_PHONES;

INSERT INTO PK_PHONES VALUES ('JACK',1234);
INSERT INTO PK_PHONES VALUES ('LENA',3333);
INSERT INTO PK_PHONES VALUES ('MARK',9999);
INSERT INTO PK_PHONES VALUES ('ANNA',7582);

SELECT * FROM PK_PHONES;

CREATE TABLE PK_CALLS(
    ID INTEGER NOT NULL,
    CALLER INTEGER NOT NULL,
    CALLEE INTEGER NOT NULL,
    DURATION INTEGER NOT NULL,
    UNIQUE(ID)
);

DESCRIBE TABLE PK_CALLS;

INSERT INTO PK_CALLS VALUES (25,1234,7582,8);
INSERT INTO PK_CALLS VALUES (7,9999,7582,1);
INSERT INTO PK_CALLS VALUES (18,9999,3333,4);
INSERT INTO PK_CALLS VALUES (2,7582,3333,3);
INSERT INTO PK_CALLS VALUES (3,3333,1234,1);
INSERT INTO PK_CALLS VALUES (21,3333,1234,1);

SELECT * FROM PK_CALLS;


WITH CALL_DURATION AS (
SELECT CALLER AS PHONE_NUMBER, SUM(DURATION) AS DURATION FROM PK_CALLS GROUP BY CALLER
UNION ALL
SELECT CALLEE AS PHONE_NUMBER, SUM(DURATION) AS DURATION FROM PK_CALLS GROUP BY CALLEE
)
SELECT NAME
FROM PK_PHONES
INNER JOIN CALL_DURATION ON CALL_DURATION.PHONE_NUMBER = PK_PHONES.PHONE
GROUP BY NAME
HAVING SUM(DURATION)>=10
ORDER BY NAME;

------------------------------------------------------------------ TASK 3 ------------------------------------------------------------------------------------------------
-- DROP TABLE PK_TRANSACTIONS;
CREATE TABLE PK_TRANSACTIONS(
    AMOUNT INT NOT NULL,
    DATE DATE NOT NULL
);

DESCRIBE TABLE PK_TRANSACTIONS;

INSERT INTO PK_TRANSACTIONS VALUES (1000, '2020-01-06'),
(-10,'2020-01-14'),
(-75, '2020-01-20'),
(-5, '2020-01-25'),
(-4, '2020-01-29'),
(2000, '2020-03-10'),
(-75, '2020-03-12'),
(-20, '2020-03-15'),
(40, '2020-03-15'),
(-50, '2020-03-17'),
(200, '2020-10-10'),
(-200, '2020-10-10')
;

SELECT * FROM PK_TRANSACTIONS;

SELECT SUM(AMOUNT)
FROM PK_TRANSACTIONS;

WITH 
 CREDIT_TRANSACTIONS AS(
    SELECT DATE_TRUNC('month',DATE), SUM(-AMOUNT) AS CREDIT_TRANS, COUNT(DATE) AS NO_OF_TRANS_MON
    FROM PK_TRANSACTIONS
    WHERE AMOUNT<0 
    GROUP BY DATE_TRUNC('MONTH',DATE)
    HAVING NO_OF_TRANS_MON>1
),
 EXCEPT_MONTHLY_COUNT AS(
    SELECT COUNT(CREDIT_TRANS) AS CHARGES_MONTHLY 
    FROM CREDIT_TRANSACTIONS
    WHERE CREDIT_TRANS>100),
 BALANCE_WITHOUT_CREDIT AS(
    SELECT SUM(AMOUNT) AS TOTAL_SUM FROM PK_TRANSACTIONS
 )
SELECT (TOTAL_SUM - (12-CHARGES_MONTHLY)*5) AS BALANCE FROM EXCEPT_MONTHLY_COUNT,BALANCE_WITHOUT_CREDIT;

----------------------------------------------------- TASK3 2ND TEST CASE ----------------------------------------------------------------------

CREATE OR REPLACE TABLE PK_TRANSACTIONS_2(
    AMOUNT INT NOT NULL,
    DATE DATE NOT NULL
);
INSERT INTO PK_TRANSACTIONS_2 VALUES
(6000,'2020-04-03'),
(5000, '2020-04-02'),
(4000, '2020-04-01'),
(3000, '2020-03-01'),
(2000, '2020-02-01'),
(1000, '2020-01-01');
SELECT * FROM PK_TRANSACTIONS_2;

WITH 
 CREDIT_TRANSACTIONS_2 AS(
    SELECT DATE_TRUNC('month',DATE), SUM(-AMOUNT) AS CREDIT_TRANS, COUNT(DATE) AS NO_OF_TRANS_MON
    FROM PK_TRANSACTIONS_2
    WHERE AMOUNT<0 
    GROUP BY DATE_TRUNC('MONTH',DATE)
    HAVING NO_OF_TRANS_MON>1
),
 EXCEPT_MONTHLY_COUNT_2 AS(
    SELECT COUNT(CREDIT_TRANS) AS CHARGES_MONTHLY 
    FROM CREDIT_TRANSACTIONS_2
    WHERE CREDIT_TRANS>100),
 BALANCE_WITHOUT_CREDIT_2 AS(
    SELECT SUM(AMOUNT) AS TOTAL_SUM FROM PK_TRANSACTIONS_2
 )
SELECT (TOTAL_SUM - (12-CHARGES_MONTHLY)*5) AS BALANCE FROM EXCEPT_MONTHLY_COUNT_2, BALANCE_WITHOUT_CREDIT_2;
