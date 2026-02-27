-- Migration Script: Add customer profile image
-- Date: 2026-02-15

START TRANSACTION;

ALTER TABLE customers
  ADD COLUMN profile_image_url VARCHAR(500) NULL AFTER address,
  ADD KEY idx_customers_profile_image_url (profile_image_url);

COMMIT;
