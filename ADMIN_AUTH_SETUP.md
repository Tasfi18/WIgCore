# Admin Authentication Setup Guide

## 🔐 Overview

Your admin panel now uses **Supabase authentication** with role-based access control.

### Admin Credentials
- **Email**: `admin@example.com`
- **Password**: a strong password of your choice (never `admin`)
- **Role**: `admin` (stored in Supabase `profiles` table)

---

## 📋 Setup Steps

### Step 1: Run SQL Script in Supabase

1. **Open Supabase Dashboard** → SQL Editor
2. **Copy and paste** the contents of `supabase_admin_setup.sql`
3. **Click "Run"**

This will:
- Add `role` column to `profiles` table
- Set your account (`your-email@example.com`) as admin

---

### Step 2: Create Admin User in Supabase

**Option A: Using Supabase Dashboard (Recommended)**

1. Go to: **Authentication** → **Users** → **Add User**
2. Fill in:
   - **Email**: `admin@example.com`
   - **Password**: a strong password of your choice (never `admin`)
   - **Auto Confirm User**: ✅ YES (Enable this!)
3. Click **"Create User"**
4. The user will automatically get a profile with role `customer`
5. You need to update the role to `admin` - see Step 3

**Option B: Using Registration Page**

1. Go to: `http://localhost:3000/register` (or your production URL)
2. Register with:
   - **Full Name**: Admin
   - **Email**: `admin@example.com`
   - **Password**: a strong password of your choice (never `admin`)
3. Click verification link in email
4. Update role in database - see Step 3

---

### Step 3: Set User as Admin

After creating the user, you need to set their role to `admin`:

1. Go to **Supabase Dashboard** → **SQL Editor**
2. Run this query:

```sql
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'admin@example.com';
```

3. Verify it worked:

```sql
SELECT email, full_name, role 
FROM profiles 
WHERE role = 'admin';
```

You should see `admin@example.com` with role `admin`.

---

## 🧪 Testing

### Test Admin Login

1. Go to: **`/admin/login`** (or `/admin` - it will redirect)
2. Enter:
   - **Email**: `admin@example.com` 
   - **Password**: a strong password of your choice (never `admin`)
3. Click **"Sign In"**
4. You should be redirected to `/admin` dashboard

### Test Access Control

**Test 1: Non-admin user trying to access admin**
1. Create a regular customer account
2. Try accessing `/admin`
3. Should be redirected to **Access Denied** page

**Test 2: Not logged in**
1. Log out
2. Try accessing `/admin`
3. Should be redirected to `/admin/login`

---

## 🔧 Managing Admin Users

### Make any user an admin

```sql
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'user@example.com';
```

### Remove admin access

```sql
UPDATE profiles 
SET role = 'customer' 
WHERE email = 'user@example.com';
```

### List all admins

```sql
SELECT email, full_name, created_at 
FROM profiles 
WHERE role = 'admin';
```

---

## 📁 Files Created/Modified

### New Files
- `src/app/admin/login/page.tsx` - Admin login page with Supabase auth
- `src/app/access-denied/page.tsx` - Access denied page for non-admins
- `supabase_admin_setup.sql` - SQL script to add role column

### Modified Files
- `src/app/admin/layout.tsx` - Now uses Supabase auth instead of localStorage
- `src/lib/types.ts` - Added `role` field to User interface

---

## 🚀 Production Deployment

After deploying to Vercel:

1. **Run SQL script** on production Supabase (same steps as above)
2. **Create admin user** using production Supabase dashboard
3. **Test login** at your production URL: `https://your-domain.vercel.app/admin/login`

---

## 🔒 Security Notes

- ⚠️ **Change the default password** in production!
- Admin users are authenticated via Supabase Auth (secure)
- Role is stored in the `profiles` table with RLS enabled
- Sessions are managed by Supabase (JWT tokens)

---

## ❓ Troubleshooting

### "Access denied: You do not have admin privileges"

**Solution**: The user's role is not set to `admin` in the database.

```sql
-- Check user's role
SELECT email, role FROM profiles WHERE email = 'admin@example.com';

-- Set role to admin
UPDATE profiles SET role = 'admin' WHERE email = 'admin@example.com';
```

### Can't login / "Email not confirmed"

**Solution**: Confirm the email in Supabase dashboard.

1. Go to: **Authentication** → **Users**
2. Find the user
3. Click **"..."** → **"Confirm email"**

### Admin page redirects to login immediately

**Solution**: Check browser console for errors. Make sure:
- Supabase keys are correct in `.env.local`
- User is logged in and has `role = 'admin'`

---

## 📞 Quick Reference

| Route | Description |
|-------|-------------|
| `/admin/login` | Admin login page |
| `/admin` | Admin dashboard (protected) |
| `/admin/products` | Product management (protected) |
| `/admin/orders` | Order management (protected) |
| `/admin/chat` | Live chat panel (protected) |
| `/access-denied` | Shown when non-admin tries to access admin routes |

**Default Admin Credentials:**
- Email: `admin@example.com`
- Password: the strong password you chose

✅ **Setup complete!** Your admin panel is now secured with Supabase authentication.
