-- Migration Script: Add show_in_landing column to projects table
-- Apply this on production cPanel database
-- Date: 2026-02-04

ALTER TABLE projects 
ADD COLUMN show_in_landing BOOLEAN DEFAULT 0 
COMMENT 'Show project in landing page animation slider' 
AFTER is_visible_on_public;

-- Create index for faster queries
CREATE INDEX idx_show_in_landing ON projects(show_in_landing);

-- Optional: Mark first 5 projects to show in landing
UPDATE projects 
SET show_in_landing = 1 
ORDER BY created_at DESC 
LIMIT 5;
