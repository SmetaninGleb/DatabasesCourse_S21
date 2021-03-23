CREATE TABLE public.bank_account
(
    id integer NOT NULL,
    name character varying NOT NULL,
    credit numeric NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE public.bank_account
    OWNER to postgres;

INSERT INTO bank_account VALUES (1, 'Mike', 1000);
INSERT INTO bank_account VALUES (2, 'Alexander', 1000);
INSERT INTO bank_account VALUES (3, 'John', 1000);

BEGIN;
SAVEPOINT T1;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 1) - 500) WHERE id = 1;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 3) + 500) WHERE id = 3;
SAVEPOINT T2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 2) - 700) WHERE id = 2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 1) + 700) WHERE id = 1;
SAVEPOINT T3;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 2) - 100) WHERE id = 2;
UPDATE bank_account SET credit = ((SELECT ba.credit FROM bank_account AS ba WHERE ba.id = 3) + 100) WHERE id = 3;
ROLLBACK TO T1;
-- ROLLBACK TO T2;
-- ROLLBACK TO T3;
COMMIT;

SELECT id, credit FROM bank_account;