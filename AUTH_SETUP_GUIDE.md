# Customer Authentication Setup Guide

## 🎯 Overview

This guide will help you set up complete customer authentication for your Wig Store using Supabase Auth. The system includes:

- ✅ Email/password registration and login
- ✅ Email verification
- ✅ Password reset functionality
- ✅ Customer account management page
- ✅ Profile and address editing
- ✅ Protected routes

---

## 📋 Step-by-Step Setup

### Step 1: Create Database Tables (REQUIRED)

1. **Open Supabase Dashboard**: https://supabase.com/dashboard
2. Navigate to your project: `mrfxtdsilzywqhyxzvfq`
3. Go to **SQL Editor** (left sidebar)
4. Click **"New Query"**
5. Open the file `supabase_auth_setup.sql` in your project directory
6. **Copy all the SQL content** and paste it into the SQL Editor
7. Click **"Run"** or press `Ctrl+Enter`

#### ✅ Verify Database Setup

After running the SQL, you should see messages like:
- "Profiles table created successfully!"
- "RLS policies created!"
- "Auto-profile creation trigger set up!"

---

### Step 2: Configure Email Settings in Supabase

#### A. Enable Email Confirmations

1. In Supabase Dashboard, go to **Authentication** → **Settings**
2. Scroll to **"Email Auth"** section
3. **Enable "Confirm email"** if it's not already enabled
4. **Save changes**

#### B. Set Confirmation URL

1. Still in **Authentication** → **Settings**
2. Find **"Site URL"** setting
3. For **local development**, set it to: `http://localhost:3000`
4. For **production**, set it to your Vercel URL (e.g., `https://your-site.vercel.app`)
5. Find **"Redirect URLs"** and add:
   - `http://localhost:3000/auth/confirm`
   - `https://your-site.vercel.app/auth/confirm` (for production)

#### C. Customize Email Templates (Optional)

1. Go to **Authentication** → **Email Templates**
2. Customize these templates if desired:
   - **Confirm signup** - Email verification
   - **Reset password** - Password reset
   - **Magic Link** - Passwordless login

> **Note**: The default templates work fine. You can customize them later with your branding.

---

### Step 3: Test Locally

#### A. Start Dev Server

```bash
npm run dev
```

Visit: http://localhost:3000

#### B. Test Registration Flow

1. Go to http://localhost:3000/register
2. Fill in the registration form:
   - **Name**: Test User
   - **Email**: your-email@example.com (use a real email you can access)
   - **Password**: testpassword123
   - **Confirm Password**: testpassword123
3. Check "I agree to Terms" checkbox
4. Click **"Create Account"**
5. **Check your email** for verification link
6. Click the verification link in the email
   - Should redirect to http://localhost:3000/login with success message
7. Login with your credentials

#### C. Test Login Flow

1. Go to http://localhost:3000/login
2. Enter the email and password you just registered
3. Click **"Sign In"**
4. Should redirect to http://localhost:3000/account

#### D. Test Account Page

1. You should now be on the account page
2. Try editing your profile:
   - Click **"Edit Profile"**
   - Update your name, phone, etc.
   - Click **"Save Changes"**
   - Should see success message
3. Try the **"Address"** tab:
   - Click **"Edit Address"**
   - Fill in address fields
   - Click **"Save Changes"**

#### E. Test Password Reset

1. Go to http://localhost:3000/forgot-password
2. Enter your email
3. Click **"Send Reset Link"**
4. Check your email for password reset link
5. Click the link
6. Should open http://localhost:3000/reset-password
7. Enter new password and confirm
8. Click **"Reset Password"**
9. Should see success message and redirect to login
10. Login with new password

#### F. Test Logout

1. While logged in, click the **user avatar/dropdown** in header
2. Click **"Logout"** (you may need to add this button - see below)
3. Should redirect to homepage
4. Try accessing http://localhost:3000/account
5. Should redirect to login page

---

### Step 4: Add Logout Button to Header (If Missing)

Check if your `Header.tsx` component has a logout button. If not, you'll need to add one.

**Location**: `src/components/layout/Header.tsx`

Look for a user menu dropdown and add:

```tsx
import { useAuth } from '@/contexts/AuthContext'

// Inside component...
const { user, signOut } = useAuth()

// In the user menu dropdown:
<button onClick={signOut} className="...">
  Logout
</button>
```

---

## 🚀 Deploy to Production

### Step 1: Push to Git

```bash
git add .
git commit -m "Implement customer authentication system"
git push origin development
```

### Step 2: Configure Supabase for Production

1. Go to **Authentication** → **Settings** in Supabase
2. Update **"Site URL"** to your production URL:
   - Example: `https://wig-store-xyz.vercel.app`
3. Add your production URL to **"Redirect URLs"**:
   - `https://wig-store-xyz.vercel.app/auth/confirm`
   - `https://wig-store-xyz.vercel.app/reset-password`

### Step 3: Deploy on Vercel

Vercel should auto-deploy when you push to GitHub. If not:
1. Go to https://vercel.com
2. Import your project
3. Make sure environment variables are set (they should already be from earlier)

### Step 4: Test Production

1. Visit your production site
2. Test registration with a real email
3. Test email verification
4. Test login
5. Test profile editing
6. Test password reset

---

## 🐛 Troubleshooting

### Issue: "User already registered" error when signing up

**Solution**: The user might already exist in Supabase Auth. Check in:
- Supabase Dashboard → **Authentication** → **Users**

Delete the test user if needed, or use a different email.

### Issue: Email confirmation not working

**Possible causes**:
1. Email not configured in Supabase
2. Wrong redirect URL
3. Email in spam folder

**Solutions**:
- Check Supabase email settings (Step 2 above)
- Verify redirect URLs are correct
- Check spam/junk folder
- Check Supabase logs: **Authentication** → **Logs**

### Issue: "profiles table does not exist" error

**Solution**: You didn't run the SQL script. Go back to Step 1 and run `supabase_auth_setup.sql`.

### Issue: Can't update profile

**Possible causes**:
1. RLS policies not set correctly
2. User not properly authenticated

**Solutions**:
- Re-run the SQL setup script
- Check browser console for errors
- Verify user is logged in (check AuthContext state)

### Issue: Password reset email not sending

**Solutions**:
- Check Supabase email templates are enabled
- Verify SMTP settings in Supabase
- Check Supabase logs for email errors
- For development, emails might take a few minutes

---

## 📁 Files Created

### New Files
1. `supabase_auth_setup.sql` - Database setup script
2. `src/app/auth/confirm/route.ts` - Email verification handler
3. `src/app/account/page.tsx` - Customer account management
4. `src/app/forgot-password/page.tsx` - Request password reset
5. `src/app/reset-password/page.tsx` - Set new password

### Existing Files (Already Configured)
- `src/contexts/AuthContext.tsx` - Authentication context
- `src/app/login/page.tsx` - Login page
- `src/app/register/page.tsx` - Registration page
- `src/lib/supabase/client.ts` - Supabase client
- `src/lib/supabase/server.ts` - Supabase server client

---

## 🎉 What's Working

- ✅ User registration with email/password
- ✅ Email verification (must verify before login)
- ✅ User login with session management
- ✅ Automatic profile creation on signup
- ✅ Customer account page with three tabs
- ✅ Profile editing (name, phone, etc.)
- ✅ Address management
- ✅ Password reset via email
- ✅ Protected routes (redirect to login if not authenticated)
- ✅ User logout

---

## 📝 Next Steps (Optional Enhancements)

1. **Social Login** (Google, Facebook, Apple):
   - Requires OAuth app setup
   - Update AuthContext to handle social auth
   - Enable in Supabase: **Authentication** → **Providers**

2. **Order History**:
   - Create orders table in database
   - Fetch and display user's orders in account page

3. **Middleware for Protected Routes**:
   - Create `src/middleware.ts` for automatic redirects
   - Protect `/account`, `/checkout`, `/orders` routes

4. **Email Preferences**:
   - Add newsletter subscription toggle
   - Marketing email preferences

5. **Avatar Upload**:
   - Add file upload to Supabase Storage
   - Allow users to upload profile picture

---

## 🔒 Security Notes

- ✅ Row Level Security (RLS) enabled on profiles table
- ✅ Users can only access their own data
- ✅ Email verification required before full access
- ✅ Passwords hashed by Supabase Auth
- ✅ HTTPS required for production (automatic on Vercel)

---

## ✅ Verification Checklist

Before considering authentication complete, verify:

- [ ] Can register new user
- [ ] Receive verification email
- [ ] Email verification works
- [ ] Can login with verified email
- [ ] Redirects to `/account` after login
- [ ] Can edit profile information
- [ ] Can edit address information
- [ ] Can request password reset
- [ ] Can reset password via email link
- [ ] Can logout successfully
- [ ] Cannot access `/account` when logged out
- [ ] All features work in production

---

**Need help?** Check the browser console (F12) for detailed error messages, or check Supabase logs in the dashboard.
