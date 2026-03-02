-- ============================================
-- ADMIN AUTHENTICATION SETUP
-- ============================================
-- This script creates admin authentication
-- ============================================

-- Step 1: Add 'role' column to profiles table
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'customer' CHECK (role IN ('customer', 'admin'));

-- Step 2: Create admin user manually in Supabase
-- You need to do this in Supabase Dashboard:
-- 1. Go to Authentication → Users
-- 2. Click "Add User"
-- 3. Email: admin@admin.com
-- 4. Password: admin
-- 5. Auto-confirm user: YES (enable this)
-- 6. Click "Create User"

-- Step 3: After creating the admin user, get their UUID and update their role
-- Replace 'USER_ID_HERE' with the actual UUID from Supabase Auth
-- UPDATE profiles SET role = 'admin' WHERE email = 'admin@admin.com';

-- Step 4: You can also make your existing account an admin
UPDATE profiles SET role = 'admin' WHERE email = 'muntakim880@gmail.com';

-- Step 5: Verify admin users
SELECT id, email, full_name, role, created_at
FROM profiles
WHERE role = 'admin';

-- Step 6: Create index for role lookups (performance)
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);

-- Quick reference queries:
-- Make a user admin:
-- UPDATE profiles SET role = 'admin' WHERE email = 'your-email@example.com';

-- Remove admin access:
-- UPDATE profiles SET role = 'customer' WHERE email = 'your-email@example.com';

-- List all admins:
-- SELECT email, full_name FROM profiles WHERE role = 'admin';
