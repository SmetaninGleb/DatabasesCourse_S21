CREATE TABLE public.ledger
(
    id serial PRIMARY KEY NOT NULL,
    "from" integer NOT NULL,
    "to" integer NOT NULL,
    fee numeric NOT NULL,
    amount numeric NOT NULL,
    transaction_date_time time with time zone NOT NULL
);

ALTER TABLE public.ledger
    OWNER to postgres;

BEGIN;
SAVEPOINT T1;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 1) - 500) WHERE id = 1;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 3) + 500) WHERE id = 3;
INSERT INTO ledger(id, from_account, to_account, fee, amount, transaction_date_time) VALUES (DEFAULT, 1, 3, 0, 500, NOW());
SAVEPOINT T2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 2) - 730) WHERE id = 2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 1) + 700) WHERE id = 1;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 4) + 30) WHERE id = 4;
INSERT INTO ledger(id, from_account, to_account, fee, amount, transaction_date_time) VALUES (DEFAULT, 2, 1, 30, 700, NOW());
SAVEPOINT T3;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 2) - 130) WHERE id = 2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 3) + 100) WHERE id = 3;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 4) + 30) WHERE id = 4;
INSERT INTO ledger(id, from_account, to_account, fee, amount, transaction_date_time) VALUES (DEFAULT, 2, 3, 30, 100, NOW());
ROLLBACK TO T1;
-- ROLLBACK TO T2;
-- ROLLBACK TO T3;
COMMIT;

SELECT id, credit FROM bank_account;