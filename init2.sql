DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS documents CASCADE;
DROP SERVER IF EXISTS node1 CASCADE;

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER node1 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (port '5432');
CREATE USER MAPPING FOR current_user SERVER node1;


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

CREATE TABLE companies_node2 PARTITION OF companies
    FOR VALUES WITH (MODULUS 2, REMAINDER 1);
CREATE FOREIGN TABLE companies_node1 PARTITION OF companies
    FOR VALUES WITH (MODULUS 2, REMAINDER 0)
    SERVER node1;

CREATE TABLE users_node2 PARTITION OF users
    FOR VALUES WITH (MODULUS 2, REMAINDER 1);
CREATE FOREIGN TABLE users_node1 PARTITION OF users
    FOR VALUES WITH (MODULUS 2, REMAINDER 0)
    SERVER node1;

CREATE TABLE documents_node2 PARTITION OF documents
    FOR VALUES WITH (MODULUS 2, REMAINDER 1);
CREATE FOREIGN TABLE documents_node1 PARTITION OF documents
    FOR VALUES WITH (MODULUS 2, REMAINDER 0)
    SERVER node1;

ALTER TABLE companies_node2 ADD CONSTRAINT companies_pk PRIMARY KEY (company_id);
ALTER TABLE users_node2 ADD CONSTRAINT users_pk PRIMARY KEY (company_id, id);
ALTER TABLE documents_node2 ADD CONSTRAINT documents_pk PRIMARY KEY (company_id, id);
