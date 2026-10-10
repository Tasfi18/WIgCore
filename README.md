# WigCore

Setup files for **WigCore**, an online wig store built with Next.js, Supabase and Stripe: customer accounts, an admin panel with role-based access, and live chat between customers and the store.

> **Note:** this repository holds the project configuration, database scripts and setup guides. The application source (the `app/` folder) is not included here.

## Tech stack

| Part | Built with |
| --- | --- |
| Web app | Next.js 16, React 19, TypeScript, Tailwind CSS 4 |
| Auth and database | Supabase (Auth, PostgreSQL, row-level security) |
| Payments | Stripe |

## What's in this repository

| File | What it is |
| --- | --- |
| `supabase_auth_setup.sql` | `profiles` table, sign-up trigger and row-level security for customer accounts |
| `supabase_profiles_fix.sql` | Adds the address columns to `profiles` |
| `supabase_admin_setup.sql` | Adds a `role` column (`customer` or `admin`) and promotes an account to admin |
| `supabase_chat_setup.sql` | `chat_conversations` and `chat_messages` tables for customer support chat |
| `AUTH_SETUP_GUIDE.md` | Customer sign-up, email verification, password reset and account pages |
| `ADMIN_AUTH_SETUP.md` | Setting up admin access |
| `CHAT_SETUP_GUIDE.md` | Setting up the chat tables |
| `auth_test_checklist.html` | A checklist for testing sign-up, login and password reset |
| `stitch_lace_front_product_details.zip` | UI designs for the store pages |

## Database setup

In the Supabase SQL editor, run the scripts in this order:

1. `supabase_auth_setup.sql`
2. `supabase_profiles_fix.sql`
3. `supabase_chat_setup.sql`
4. `supabase_admin_setup.sql` (edit the email address first)

Create admin accounts with a strong, unique password, and keep the Supabase service role key and Stripe secret key in `.env.local`, which git ignores.

## Run the app

With the application source in place:

```bash
npm install
npm run dev     # http://localhost:3000
```

The app needs `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY` and the Stripe keys in `.env.local`.
