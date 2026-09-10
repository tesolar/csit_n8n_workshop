# รายงานการออกแบบหลักสูตรอบรม
## "สร้าง AI Agent และ Automation สำหรับครูด้วย n8n + PostgreSQL (pgvector)"
ระยะเวลา: 3 ชั่วโมง (180 นาที)

---

# 1. หลักการและเหตุผล

ครูในปัจจุบันมีภาระงานด้านการประมวลผลข้อมูล การวิเคราะห์ผลการเรียน และการจัดทำข้อสอบจำนวนมาก ซึ่งเป็นงานที่สามารถนำ AI และ Workflow Automation มาช่วยลดภาระได้

หลักสูตรนี้ออกแบบให้ผู้เข้าร่วมสามารถสร้างระบบ AI และ Automation ด้วย **n8n Self-hosted บน Docker** ทำงานร่วมกับ **PostgreSQL (พร้อม pgvector)** เพื่อการจัดเก็บข้อมูลและการค้นหาเชิงความหมาย (Semantic Search / Vector Store) โดยใช้ Gemini API Key เพียงรายการเดียว ลดความยุ่งยากในการเตรียมระบบ และเน้นการลงมือปฏิบัติ (Hands-on Workshop) มากกว่า 80% ของเวลาอบรม

---

# 2. วัตถุประสงค์

เมื่อจบการอบรม ผู้เข้าร่วมจะสามารถ:

1. เข้าใจแนวคิด Workflow Automation และสถาปัตยกรรม n8n
2. สร้าง AI Agent ด้วย n8n และ Gemini API
3. ออกแบบ Prompt สำหรับงานวิเคราะห์และจัดการด้านการศึกษา
4. สร้างแบบฟอร์มออนไลน์ด้วย n8n Form
5. เชื่อมต่อและจัดเก็บข้อมูลลง PostgreSQL / pgvector
6. นำ AI มาวิเคราะห์ผลคะแนนสอบและสร้างรายงานสรุปอัตโนมัติ
7. เข้าใจพื้นฐานการต่อยอดสู่ระบบ RAG / Vector Search สำหรับสืบค้นเอกสารการสอน

---

# 3. เครื่องมือและสิ่งแวดล้อมที่ใช้

## 3.1 Software Stack (Docker Compose)

- **n8n (Self-hosted)**: ระบบ Workflow Automation Engine (Port `5678`)
- **PostgreSQL + pgvector (v16)**: ระบบฐานข้อมูลหลัก และรองรับ Vector Embeddings สำหรับ RAG (Port `5432`)
- **pgAdmin 4**: Web UI สำหรับตรวจสอบและจัดการฐานข้อมูล (Port `5050`)
- **Gemini API**: โมเดล AI จาก Google (รองรับทั้ง Chat Model และ Embedding Model)

## 3.2 ข้อมูลการเชื่อมต่อระบบ (Default Credentials)

| บริการ | URL / Host | Username / Email | Password | รายละเอียด |
|---|---|---|---|---|
| **n8n Web UI** | `http://localhost:5678` | *(ตั้งค่าตอนเริ่มใช้งาน)* | *(ตั้งค่าตอนเริ่มใช้งาน)* | แพลตฟอร์มสร้าง Workflow |
| **pgAdmin Web UI** | `http://localhost:5050` | `admin@workshop.local` | `adminpass` | หน้าต่างดูตารางฐานข้อมูล |
| **PostgreSQL (n8n Node)** | Host: `postgres` / Port: `5432` | `n8n` | `n8npass` | Database: `n8n` |
| **Gemini API** | Google AI Studio | - | *(API Key ส่วนตัว)* | ใช้สำหรับ AI Agent / Embeddings |

---

# 4. แผนการอบรมแบบละเอียด (3 ชั่วโมง)

## ช่วงที่ 1: Introduction & Environment Setup (15 นาที)
- แนะนำ n8n, Workflow Automation และ AI Agent ในงานการศึกษา
- ตรวจสอบระบบ Docker, การเข้าใช้งาน n8n (`http://localhost:5678`) และ pgAdmin (`http://localhost:5050`)
- การขอ Gemini API Key จาก [Google AI Studio](https://aistudio.google.com/)

---

## ช่วงที่ 2: Workshop 1 - AI Agent ผู้ช่วยครูประจำชั้น (60 นาที)

### กิจกรรม 1: สร้าง AI Agent พื้นฐาน
เชื่อมต่อ Node:
```text
Chat Trigger ──> AI Agent (Gemini Chat Model) ──> Memory (Window Buffer)
```

### กิจกรรม 2: ติดตั้ง Credential & ตั้งค่า Gemini
- เชื่อมต่อ Google Gemini Chat Model (`gemini-1.5-flash` หรือ `gemini-2.0-flash`)

### กิจกรรม 3: ออกแบบ System Prompt ผู้ช่วยครู
```text
คุณคือผู้ช่วยครูประจำชั้นอัจฉริยะ

หน้าที่ของคุณคือ:
1. วิเคราะห์ผลการเรียนและพฤติกรรมของนักเรียน
2. ค้นหานักเรียนกลุ่มเสี่ยงที่ต้องการความช่วยเหลือเร่งด่วน
3. จัดทำรายงานสรุปผลสัมฤทธิ์ทางการเรียน
4. เสนอแนะกิจกรรมเสริมและแนวทางการพัฒนาผู้เรียนเป็นรายบุคคล

กฎการตอบ: สุภาพ ทางการ กระชับ และให้ข้อเสนอแนะที่ครูนำไปปฏิบัติได้จริง
```

### กิจกรรม 4: ทดสอบการสนทนาและวิเคราะห์ข้อความตัวอย่าง
```text
ช่วยวิเคราะห์คะแนนสอบเก็บคะแนนบทที่ 1 วิชาคณิตศาสตร์:
สมชาย: 45/100, สมหญิง: 88/100, กิตติ: 62/100, วิภา: 38/100, ธนกร: 92/100
```

---

## ช่วงที่ 3: Workshop 2 - ระบบทำข้อสอบออนไลน์ด้วย n8n Form & บันทึกลง PostgreSQL (45 นาที)

### กิจกรรม 1: สร้างแบบฟอร์มข้อสอบ (n8n Form Trigger)
กำหนดฟิลด์ในแบบฟอร์ม:
- ชื่อ-นามสกุล (`student_name`)
- ระดับชั้น (`grade_level`)
- วิชา (`subject`)
- คำถามข้อที่ 1, 2, 3 (ตัวเลือก / เติมคำ)

### กิจกรรม 2: คำนวณคะแนนอัตโนมัติ (Code Node / Edit Fields)
คำนวณ:
- `score` (คะแนนที่ได้)
- `total_score` (คะแนนเต็ม)
- `percentage` = `(score / total_score) * 100`
- `pass_status` = `percentage >= 50 ? 'ผ่าน' : 'ไม่ผ่าน'`

### กิจกรรม 3: บันทึกข้อมูลลงตาราง `exam_results` บน PostgreSQL
Workflow:
```text
n8n Form Trigger ──> Calculate Score ──> PostgreSQL Node (Insert) ──> Respond to Webhook (แสดงผลคะแนนให้นักเรียน)
```
- ตั้งค่า Postgres Node:
  - Operation: `Insert`
  - Table: `exam_results`

---

## ช่วงที่ 4: Workshop 3 - AI วิเคราะห์ผลสอบภาพรวมจาก Database (40 นาที)

### กิจกรรม 1: ดึงข้อมูลคะแนนสอบจาก PostgreSQL
- ใช้ Postgres Node Query:
  ```sql
  SELECT student_name, grade_level, subject, score, total_score, percentage, pass_status 
  FROM exam_results 
  WHERE subject = 'วิทยาศาสตร์';
  ```

### กิจกรรม 2: ส่งข้อมูลให้ AI Agent สรุปรายงานเชิงลึก
Workflow:
```text
Manual / Schedule Trigger ──> PostgreSQL (Execute Query) ──> Aggregate / Code ──> AI Agent (Gemini) ──> Generate HTML / Email Report
```

### Prompt ตัวอย่าง:
```text
จากข้อมูลผลการสอบต่อไปนี้:
{{ $json.exam_data }}

โปรดจัดทำ "รายงานสรุปผลการประเมินการเรียนรู้":
1. สถิติภาพรวม (จำนวนผู้สอบ, คะแนนเฉลี่ย, สูงสุด, ต่ำสุด, อัตราการสอบผ่าน)
2. รายชื่อนักเรียนกลุ่มที่ต้องพัฒนาเร่งด่วน พร้อมระบุจุดที่ควรปรับปรุง
3. ข้อเสนอแนะในการปรับปรุงแผนการจัดการเรียนรู้สำหรับครูผู้สอน
```

---

## ช่วงที่ 5: Mini Challenge & Bonus Vector Store (20 นาที)

- **Mini Challenge**: ให้นำแนวคิดไปประยุกต์ทำแบบประเมินความพึงพอใจ หรือระบบคัดกรองนักเรียน SDQ
- **Bonus Feature (pgvector)**: แนะนำการต่อยอด Vector Store ด้วยตาราง `knowledge_documents` เพื่อทำระบบค้นหาแผนการสอนและคู่มือครูด้วย AI (Semantic Search)

---

# 5. โครงสร้างฐานข้อมูล (Database Schema)

### ตาราง `exam_results` (จัดเก็บผลการสอบ)

```sql
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
```

### ตาราง `knowledge_documents` (Vector Store สำหรับ pgvector)

```sql
CREATE TABLE IF NOT EXISTS knowledge_documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding vector(768), -- รองรับ Gemini text-embedding-004
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

---

# 6. คำสั่งเริ่มต้นใช้งานสำหรับผู้สอนและผู้เรียน

```bash
# 1. คัดลอก .env (หากยังไม่มี)
cp .env.example .env

# 2. เริ่มต้นระบบทั้งหมด
docker compose up -d

# 3. ตรวจสอบสถานะการทำงาน
docker compose ps
```

- เข้าใช้งาน **n8n**: [http://localhost:5678](http://localhost:5678)
- เข้าใช้งาน **pgAdmin**: [http://localhost:5050](http://localhost:5050)