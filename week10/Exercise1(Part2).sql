ALTER TABLE public.bank_account
    ADD COLUMN bank_name character varying;

UPDATE bank_account SET bank_name = 'SpearBank' WHERE id = 1;
UPDATE bank_account SET bank_name = 'SpearBank' WHERE id = 3;
UPDATE bank_account SET bank_name = 'Tinkoff' WHERE id = 2;

INSERT INTO bank_account VALUES (4, 'Fees', 0);

BEGIN;
SAVEPOINT T1;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 1) - 500) WHERE id = 1;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 3) + 500) WHERE id = 3;
SAVEPOINT T2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 2) - 730) WHERE id = 2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 1) + 700) WHERE id = 1;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 4) + 30) WHERE id = 4;
SAVEPOINT T3;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 2) - 130) WHERE id = 2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 3) + 100) WHERE id = 3;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 4) + 30) WHERE id = 4;
ROLLBACK TO T1;
-- ROLLBACK TO T2;
-- ROLLBACK TO T3;
COMMIT;

SELECT id, credit FROM bank_account;