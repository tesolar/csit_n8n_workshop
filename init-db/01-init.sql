-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Table: exam_results (สำหรับ Workshop 2 และ Workshop 3)
CREATE TABLE IF NOT EXISTS exam_results (
    id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    grade_level VARCHAR(50) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    test_name VARCHAR(150) NOT NULL,
    score NUMERIC(5, 2) NOT NULL,
    total_score NUMERIC(5, 2) NOT NULL,
    percentage NUMERIC(5, 2) NOT NULL,
    pass_status VARCHAR(20) NOT NULL,
    submit_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- เพิ่มข้อมูลตัวอย่างเริ่มต้นตามเอกสาร instructure.md
INSERT INTO exam_results (student_name, grade_level, subject, test_name, score, total_score, percentage, pass_status, submit_time)
VALUES 
    ('สมชาย ใจดี', 'ม.1/1', 'วิทยาศาสตร์', 'แบบทดสอบบทที่ 1', 8, 10, 80.0, 'ผ่าน', '2026-09-09 09:15:00+07'),
    ('วิภา สดใส', 'ม.1/1', 'วิทยาศาสตร์', 'แบบทดสอบบทที่ 1', 4, 10, 40.0, 'ไม่ผ่าน', '2026-09-09 09:17:00+07'),
    ('สมหญิง เรียนดี', 'ม.1/1', 'วิทยาศาสตร์', 'แบบทดสอบบทที่ 1', 10, 10, 100.0, 'ผ่าน', '2026-09-09 09:18:00+07'),
    ('กิตติ ขยัน', 'ม.1/1', 'วิทยาศาสตร์', 'แบบทดสอบบทที่ 1', 7, 10, 70.0, 'ผ่าน', '2026-09-09 09:20:00+07'),
    ('อนันต์ มุ่งมั่น', 'ม.1/1', 'วิทยาศาสตร์', 'แบบทดสอบบทที่ 1', 3, 10, 30.0, 'ไม่ผ่าน', '2026-09-09 09:22:00+07'),
    ('พรทิพย์ สวยงาม', 'ม.1/1', 'วิทยาศาสตร์', 'แบบทดสอบบทที่ 1', 9, 10, 90.0, 'ผ่าน', '2026-09-09 09:25:00+07')
ON CONFLICT DO NOTHING;

-- 2. Table: knowledge_documents (ตัวอย่างตาราง Vector Store สำหรับ RAG กับ Gemini Embeddings 768 dimensions)
CREATE TABLE IF NOT EXISTS knowledge_documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding vector(768), -- เหมาะสำหรับ text-embedding-004 ของ Gemini
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- สร้าง Vector index (HNSW) สำหรับการค้นหาความคล้ายคลึงแบบรวดเร็ว
CREATE INDEX IF NOT EXISTS knowledge_documents_embedding_idx 
ON knowledge_documents 
USING hnsw (embedding vector_cosine_ops);
