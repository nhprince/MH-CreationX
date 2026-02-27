ALTER TABLE customers
  ADD COLUMN created_by CHAR(36) NULL;

CREATE INDEX idx_customers_created_by ON customers(created_by);
