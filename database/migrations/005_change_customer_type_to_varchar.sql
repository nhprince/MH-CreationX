-- Migration: Change customers.type from ENUM to VARCHAR
-- This allows arbitrary partner classes/types instead of being restricted to a fixed list.

ALTER TABLE customers MODIFY COLUMN type VARCHAR(100) NOT NULL;
