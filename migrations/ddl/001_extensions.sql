-- Database-level extensions.
-- pgcrypto gives us gen_random_uuid() for synthetic identifiers if needed.
-- citext is useful for case-insensitive emails and SKUs.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
