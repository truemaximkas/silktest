DELETE FROM companies;
DELETE FROM users;
DELETE FROM documents;

INSERT INTO companies(company_id, name)
SELECT id, md5(id::text) FROM generate_series(1, 10) c(id);

DO
$do$
BEGIN 
    FOR cid IN 1..10 LOOP
        INSERT INTO users(id, company_id, name)
        SELECT id, cid, md5(id::text) FROM generate_series(1, 100) u(id);
    END LOOP;
END
$do$;

INSERT INTO documents(id, company_id, user_id, text)
SELECT id, trunc(random() * 10 + 1)::int, trunc(random() * 100 + 1)::int, md5(id::text)
FROM generate_series(1, 200000) p(id);
