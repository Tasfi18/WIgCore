-- ============================================
-- FIX: Add Missing Address Columns to Profiles Table
-- ============================================
-- Run this in Supabase SQL Editor
-- ============================================

-- Add address columns if they don't exist
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS address_line1 TEXT,
ADD COLUMN IF NOT EXISTS address_line2 TEXT,
ADD COLUMN IF NOT EXISTS city TEXT,
ADD COLUMN IF NOT EXISTS state TEXT,
ADD COLUMN IF NOT EXISTS postal_code TEXT,
ADD COLUMN IF NOT EXISTS country TEXT DEFAULT 'Bangladesh';

-- Verify columns were added
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'profiles'
ORDER BY ordinal_position;

-- Check current data
SELECT id, email, full_name, phone, 
       address_line1, address_line2, city, state, postal_code, country
FROM profiles;
