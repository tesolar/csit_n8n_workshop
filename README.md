# 🚀 CSIT n8n Workshop: AI Agent & Automation สำหรับครู

ชุด Docker Project สำหรับการจัดอบรมเชิงปฏิบัติการ (Workshop) **"สร้าง AI Agent และ Automation สำหรับครูด้วย n8n"** ทำงานร่วมกับ **PostgreSQL + pgvector** และ **Google Gemini API**

---

## 📦 โครงสร้างระบบ (Architecture Stack)

| บริการ | Container Name | Port | หน้าที่ |
|---|---|---|---|
| **n8n** | `csit_n8n_app` | `5678` | ระบบ Workflow Automation & AI Agent Engine |
| **PostgreSQL + pgvector** | `csit_n8n_postgres` | `5432` | ฐานข้อมูลหลัก (Data Storage) + Vector Database (pgvector) |
| **pgAdmin 4** | `csit_n8n_pgadmin` | `5050` | Web UI จัดการฐานข้อมูลและดูตารางข้อมูล |

---

## ⚡ วิธีการเริ่มต้นใช้งาน (Quick Start)

### 1. คัดลอกไฟล์ Environment

```bash
cp .env.example .env
```

### 2. สั่งรัน Docker Compose

```bash
docker compose up -d
```

### 3. ตรวจสอบสถานะ

```bash
docker compose ps
```

---

## 🌐 ลิงก์เข้าใช้งาน

- 🤖 **n8n Web UI**: [http://localhost:5678](http://localhost:5678)
  - เข้าใช้งานครั้งแรก: ให้ตั้งชื่อบัญชีผู้ใช้และรหัสผ่านของท่าน
- 🐘 **pgAdmin Web UI**: [http://localhost:5050](http://localhost:5050)
  - **Email**: `admin@workshop.local`
  - **Password**: `adminpass`
  - *ระบบได้เชื่อมต่อฐานข้อมูล PostgreSQL ไว้ให้โดยอัตโนมัติแล้ว*

---

## 🔑 ข้อมูลการเชื่อมต่อฐานข้อมูลใน n8n (Postgres Credential)

เมื่อต้องการเชื่อมต่อ PostgreSQL ใน Node ของ n8n:

- **Host**: `postgres`
- **Database**: `n8n`
- **User**: `n8n`
- **Password**: `n8npass`
- **Port**: `5432`
- **SSL**: `Disable`

---

## 📑 เนื้อหา Workshop (3 ชั่วโมง)

ดูรายละเอียดกำหนดการและโจทย์กิจกรรมแบบเต็มได้ที่ [instructure.md](instructure.md) หรือเปิดไฟล์ Workflow สำเร็จรูปพร้อม Sticky Note ได้ที่โฟลเดอร์ [workflows/](workflows/):

1. **Workshop 1: AI Agent ผู้ช่วยครูประจำชั้น** ([`workflows/01_ai_agent_teacher_assistant.json`](workflows/01_ai_agent_teacher_assistant.json))
   - Chat Trigger ➡️ AI Agent (Gemini) ➡️ Chat Response + Memory
2. **Workshop 2: ระบบทำข้อสอบออนไลน์ด้วย n8n Form** ([`workflows/02_exam_form_to_postgres.json`](workflows/02_exam_form_to_postgres.json))
   - n8n Form ➡️ คำนวณคะแนน ➡️ บันทึกผลลงตาราง `exam_results` ➡️ คืนหน้าผลคะแนน HTML
3. **Workshop 3: AI วิเคราะห์ผลสอบภาพรวมจาก Database** ([`workflows/03_ai_exam_analytics.json`](workflows/03_ai_exam_analytics.json))
   - ดึงข้อมูลจากตาราง `exam_results` ➡️ สรุปสถิติ ➡️ AI Agent สรุปรายงานเชิงลึกและค้นหากลุ่มเสี่ยง
4. **Bonus: pgvector & Semantic Search**
   - ตาราง `knowledge_documents` สำหรับทำคลังความรู้/แผนการสอนด้วย Embeddings

---

## 📥 วิธีนำเข้า Workflow (Import) เข้า n8n

1. เปิด [http://localhost:5678](http://localhost:5678)
2. สร้าง Workflow ใหม่ แล้วคลิกจุดสามจุด `...` ที่มุมขวาบน ➡️ เลือก **Import from File...**
3. เลือกไฟล์ `.json` จากโฟลเดอร์ `workflows/` ได้ทันที (หรือเปิดไฟล์ copy ข้อความทั้งหมดแล้วกด `Ctrl+V` วางบน Canvas)

---

## 🛑 คำสั่งจัดการระบบ

```bash
# หยุดการทำงานของ container
docker compose down

# หยุดการทำงานและล้างข้อมูลทั้งหมด (รวม volumes)
docker compose down -v

# ดู log ของระบบ
docker compose logs -f n8n
```
