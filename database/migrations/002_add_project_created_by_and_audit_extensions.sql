-- Migration Script: Add project ownership + extend audit logs for richer activity tracking
-- Date: 2026-02-15

START TRANSACTION;

-- 1) Scope projects to the staff user who created them
ALTER TABLE projects
  ADD COLUMN IF NOT EXISTS created_by VARCHAR(36) NULL AFTER assistant_name,
  ADD KEY IF NOT EXISTS idx_projects_created_by (created_by);

-- Optional FK (safe only if you are sure all created_by values will exist in users)
-- ALTER TABLE projects
--   ADD CONSTRAINT projects_created_by_fk FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL;

-- 2) Extend audit logs so we can show per-project and client activity in one place
ALTER TABLE audit_logs
  ADD COLUMN IF NOT EXISTS actor_type ENUM('staff','client','system') NOT NULL DEFAULT 'system' AFTER user_name,
  ADD COLUMN IF NOT EXISTS actor_id VARCHAR(36) NULL AFTER actor_type,
  ADD COLUMN IF NOT EXISTS project_id VARCHAR(20) NULL AFTER actor_id,
  ADD COLUMN IF NOT EXISTS customer_id VARCHAR(20) NULL AFTER project_id,
  ADD KEY IF NOT EXISTS idx_audit_project_id (project_id),
  ADD KEY IF NOT EXISTS idx_audit_customer_id (customer_id),
  ADD KEY IF NOT EXISTS idx_audit_actor (actor_type, actor_id);

COMMIT;
