-- ============================================
-- LIVE CHAT SYSTEM - DATABASE SETUP
-- ============================================
-- Run this script in your Supabase SQL Editor
-- ============================================

-- Drop existing tables if you want to start fresh (OPTIONAL - remove if you want to keep existing data)
-- DROP TABLE IF EXISTS chat_messages CASCADE;
-- DROP TABLE IF EXISTS chat_conversations CASCADE;

-- Create chat_conversations table
CREATE TABLE IF NOT EXISTS chat_conversations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_name TEXT NOT NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'closed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create chat_messages table
CREATE TABLE IF NOT EXISTS chat_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  conversation_id UUID REFERENCES chat_conversations(id) ON DELETE CASCADE NOT NULL,
  message TEXT NOT NULL,
  is_admin BOOLEAN DEFAULT FALSE,
  sender_name TEXT,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation ON chat_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at ON chat_messages(created_at);
CREATE INDEX IF NOT EXISTS idx_chat_conversations_status ON chat_conversations(status);

-- Enable Row Level Security (RLS)
ALTER TABLE chat_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow public read access to conversations" ON chat_conversations;
DROP POLICY IF EXISTS "Allow public insert to conversations" ON chat_conversations;
DROP POLICY IF EXISTS "Allow public update to conversations" ON chat_conversations;
DROP POLICY IF EXISTS "Allow public read access to messages" ON chat_messages;
DROP POLICY IF EXISTS "Allow public insert to messages" ON chat_messages;
DROP POLICY IF EXISTS "Allow public update to messages" ON chat_messages;

-- Create RLS policies for chat_conversations
-- Allow anyone to read conversations (for simplicity, you can restrict this later)
CREATE POLICY "Allow public read access to conversations"
  ON chat_conversations FOR SELECT
  USING (true);

-- Allow anyone to create conversations
CREATE POLICY "Allow public insert to conversations"
  ON chat_conversations FOR INSERT
  WITH CHECK (true);

-- Allow anyone to update conversations (for status changes)
CREATE POLICY "Allow public update to conversations"
  ON chat_conversations FOR UPDATE
  USING (true);

-- Create RLS policies for chat_messages
-- Allow anyone to read messages
CREATE POLICY "Allow public read access to messages"
  ON chat_messages FOR SELECT
  USING (true);

-- Allow anyone to insert messages
CREATE POLICY "Allow public insert to messages"
  ON chat_messages FOR INSERT
  WITH CHECK (true);

-- Allow anyone to update messages (for marking as read)
CREATE POLICY "Allow public update to messages"
  ON chat_messages FOR UPDATE
  USING (true);

-- Enable Realtime for both tables
ALTER PUBLICATION supabase_realtime ADD TABLE chat_conversations;
ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;

-- Insert a test conversation (OPTIONAL - for testing purposes)
-- INSERT INTO chat_conversations (customer_name, status) 
-- VALUES ('Test Customer', 'active')
-- RETURNING *;

-- Verify the setup
SELECT 'Chat conversations table created successfully!' as message;
SELECT 'Chat messages table created successfully!' as message;
SELECT 'Realtime enabled for chat tables!' as message;

-- Show table info
SELECT 
  'chat_conversations' as table_name,
  COUNT(*) as row_count
FROM chat_conversations
UNION ALL
SELECT 
  'chat_messages' as table_name,
  COUNT(*) as row_count
FROM chat_messages;
