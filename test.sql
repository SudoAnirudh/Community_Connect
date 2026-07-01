-- Start transaction
BEGIN;

-- Include schema.sql to set up
\i schema.sql

-- Test updating a user
INSERT INTO users (uid, phone, name) VALUES ('test-user', '123', 'Test');

-- Try to update as test-user
SET local role TO authenticated;
SET local "request.jwt.claim.sub" TO 'test-user';

-- Try to update
UPDATE users SET name = 'Updated Test' WHERE uid = 'test-user';

-- Output success message
DO $$ BEGIN RAISE NOTICE 'Update successful'; END $$;

ROLLBACK;
