DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS documents CASCADE;
DROP SERVER IF EXISTS node2 CASCADE;

CREATE EXTENSION IF NOT EXISTS postgres_fdw;
CREATE EXTENSION IF NOT EXISTS silk;

CREATE SERVER node2 FOREIGN DATA WRAPPER postgres_fdw options (host '127.0.0.1');
-- OPTIONS (port '5433');
-- CREATE SERVER node2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (port '5433');
CREATE USER MAPPING FOR current_user SERVER node2;

CREATE TABLE companies (
    company_id      int not null,
    created_at      timestamp without time zone default current_timestamp,
    name            text
) PARTITION BY HASH (company_id);

CREATE TABLE users (
    company_id      int not null,
    id              int not null,
    created_at      timestamp without time zone default current_timestamp,
    name            text
) PARTITION BY HASH (company_id);

CREATE TABLE documents (
    company_id      int not null,
    id              int not null,
    user_id         int not null,
    created_at      timestamp without time zone default current_timestamp,
    text            text
) PARTITION BY HASH (company_id);

CREATE TABLE companies_node1 PARTITION OF companies
    FOR VALUES WITH (MODULUS 2, REMAINDER 0);
CREATE FOREIGN TABLE companies_node2 PARTITION OF companies
    FOR VALUES WITH (MODULUS 2, REMAINDER 1)
    SERVER node2 OPTIONS (table_name 'c2');

CREATE TABLE users_node1 PARTITION OF users
    FOR VALUES WITH (MODULUS 2, REMAINDER 0);
CREATE FOREIGN TABLE users_node2 PARTITION OF users
    FOR VALUES WITH (MODULUS 2, REMAINDER 1)
    SERVER node2 OPTIONS (table_name 'u2');

CREATE TABLE documents_node1 PARTITION OF documents
    FOR VALUES WITH (MODULUS 2, REMAINDER 0);
CREATE FOREIGN TABLE documents_node2 PARTITION OF documents
    FOR VALUES WITH (MODULUS 2, REMAINDER 1)
    SERVER node2 OPTIONS (table_name 'd2');

ALTER TABLE companies_node1 ADD CONSTRAINT companies_pk PRIMARY KEY (company_id);
ALTER TABLE users_node1 ADD CONSTRAINT users_pk PRIMARY KEY (company_id, id);
ALTER TABLE documents_node1 ADD CONSTRAINT documents_pk PRIMARY KEY (company_id, id);

CREATE TABLE c2 (
    company_id      int not null,
    created_at      timestamp without time zone default current_timestamp,
    name            text
);
-- PARTITION BY HASH (company_id);

CREATE TABLE u2 (
    company_id      int not null,
    id              int not null,
    created_at      timestamp without time zone default current_timestamp,
    name            text
);
-- PARTITION BY HASH (company_id);

CREATE TABLE d2 (
    company_id      int not null,
    id              int not null,
    user_id         int not null,
    created_at      timestamp without time zone default current_timestamp,
    text            text
);
-- PARTITION BY HASH (company_id);
