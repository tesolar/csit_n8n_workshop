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

### ติดตั้งด้วยคำสั่งเดียว (ใช้ได้ทั้ง Windows / macOS / Linux)

ต้องมี **Docker Desktop** (Windows/macOS) หรือ **Docker Engine + Compose plugin** (Linux) ติดตั้งไว้แล้ว จากนั้นรันคำสั่งเดียวนี้ใน Terminal (macOS/Linux/Git Bash) หรือ Command Prompt / PowerShell 7+ (Windows):

```bash
git clone https://github.com/tesolar/csit_n8n_workshop.git csit-n8n-workshop && cd csit-n8n-workshop && docker compose up -d
```

คำสั่งนี้จะ clone โปรเจกต์ แล้วสั่ง build + start ทุก container ให้อัตโนมัติ — ได้ n8n instance ที่มีข้อมูล/บัญชีผู้ใช้/workflows เหมือนต้นทางทุกอย่าง (ดู [หัวข้อ Export/Import ฐานข้อมูล](#-export--import-ฐานข้อมูล-ย้ายไปเครื่องอื่น)) โดยไม่ต้องสร้างไฟล์ `.env` เอง (ค่า default ในโปรเจกต์เหมือนกับใน `.env.example` อยู่แล้ว)

> ⚠️ **Windows PowerShell รุ่นเก่า (5.1 ที่มากับ Windows โดย default)** ไม่รองรับ `&&` ให้รันทีละบรรทัดแทน:
> ```powershell
> git clone https://github.com/tesolar/csit_n8n_workshop.git csit-n8n-workshop
> cd csit-n8n-workshop
> docker compose up -d
> ```

ตรวจสอบสถานะหลังติดตั้ง:

```bash
docker compose ps
```

### ปรับแต่งค่า (ไม่บังคับ)

ถ้าต้องการเปลี่ยน port/password/ค่าอื่น ๆ ให้คัดลอกไฟล์ environment ก่อนรัน `docker compose up -d`:

```bash
cp .env.example .env   # Windows (cmd/PowerShell): copy .env.example .env
```

---

## 🌐 ลิงก์เข้าใช้งาน

- 🤖 **n8n Web UI**: [http://localhost:5678](http://localhost:5678)
  - เข้าสู่ระบบด้วยบัญชีที่มากับฐานข้อมูล (ดู [หัวข้อ Export/Import ฐานข้อมูล](#-export--import-ฐานข้อมูล-ย้ายไปเครื่องอื่น) ด้านล่าง): **Email**: `workshop@csit.ac.th`, **Password**: `CSIT@2026`
- 🐘 **pgAdmin Web UI**: [http://localhost:5050](http://localhost:5050)
  - **Email**: `admin@csit-n8n-workshop.com`
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
2. **Workshop 2: ระบบทำข้อสอบออนไลน์ด้วย n8n Form** — มี 2 รูปแบบให้เลือก:
   - ✅ **แนะนำ:** [`workflows/02_exam_form_to_datatable.json`](workflows/02_exam_form_to_datatable.json) — บันทึกผลลง **n8n Data Table** (มีปุ่ม ⚙️ Setup สร้างตารางให้อัตโนมัติในตัว ไม่ต้องสร้างมือ) **ต้องใช้ไฟล์นี้ถ้าต้องการให้ Workshop 3 เห็นข้อมูลจริงจากนักเรียน**
   - [`workflows/02_exam_form_to_postgres.json`](workflows/02_exam_form_to_postgres.json) — บันทึกผลลงตาราง **Postgres** `exam_results` แทน (เหมาะสำหรับสาธิตการเขียนลง Postgres โดยเฉพาะ, Workshop 3 ในปัจจุบันไม่ได้อ่านจากตารางนี้)
3. **Workshop 3: AI วิเคราะห์ผลสอบภาพรวมจาก Database** ([`workflows/03_ai_exam_analytics.json`](workflows/03_ai_exam_analytics.json))
   - ดึงข้อมูลจาก **n8n Data Table** `exam_results` (ไม่ใช่ Postgres) ➡️ สรุปสถิติ + อัตราตอบผิดรายข้อ ➡️ AI Agent สรุปรายงานเชิงลึกและค้นหากลุ่มเสี่ยง
4. **Bonus: pgvector & Semantic Search**
   - ตาราง `knowledge_documents` สำหรับทำคลังความรู้/แผนการสอนด้วย Embeddings

---

## 📥 วิธีนำเข้า Workflow (Import) เข้า n8n

1. เปิด [http://localhost:5678](http://localhost:5678)
2. สร้าง Workflow ใหม่ แล้วคลิกจุดสามจุด `...` ที่มุมขวาบน ➡️ เลือก **Import from File...**
3. เลือกไฟล์ `.json` จากโฟลเดอร์ `workflows/` ได้ทันที (หรือเปิดไฟล์ copy ข้อความทั้งหมดแล้วกด `Ctrl+V` วางบน Canvas)

---

## 💾 Export / Import ฐานข้อมูล (ย้ายไปเครื่องอื่น)

โปรเจกต์นี้เก็บทุกอย่างไว้ใน Postgres ฐานข้อมูลเดียว ทั้งข้อมูลของ n8n เอง (บัญชีผู้ใช้/รหัสผ่าน, workflows, credentials, settings) และตารางของ workshop (`exam_results`, `knowledge_documents`) ไฟล์ [`init-db/01-init.sql`](init-db/01-init.sql) คือ **full dump** ของฐานข้อมูลปัจจุบัน — Postgres จะรันไฟล์ในโฟลเดอร์ `init-db/` ให้อัตโนมัติ **เฉพาะตอนที่ volume ของฐานข้อมูลยังว่างเปล่า (รันครั้งแรกเท่านั้น)**

### วิธี Duplicate ไปเครื่องอื่น

1. คัดลอกทั้งโปรเจกต์ไปเครื่องปลายทาง (รวมไฟล์ `.env` ด้วย เพราะไฟล์นี้ไม่ได้ push ขึ้น git — ถ้าไม่มีให้ `cp .env.example .env`)
2. ที่เครื่องปลายทาง ตรวจสอบว่ายังไม่เคยสร้าง volume ชื่อ `${COMPOSE_PROJECT_NAME}_postgres_data` มาก่อน (เครื่องใหม่จะไม่มีอยู่แล้ว)
3. รัน `docker compose up -d`
4. ฐานข้อมูลจะถูกสร้างจาก `init-db/01-init.sql` ทันที ได้ n8n instance ที่เหมือนเครื่องต้นทางทุกอย่าง — login ด้วย `workshop@csit.ac.th` / `CSIT@2026` แล้วเห็น workflows และข้อมูลเดิมครบ ไม่ต้องตั้งค่าใหม่

> ⚠️ ค่า `N8N_ENCRYPTION_KEY` ใน `.env` ต้องเหมือนกันทั้งสองเครื่อง (มีค่า default อยู่ใน `.env.example` แล้ว) ไม่งั้น credentials ที่เข้ารหัสไว้ในฐานข้อมูลจะถอดรหัสไม่ได้

### อัปเดต dump หลังแก้ไขงานใน n8n

ทุกครั้งที่ทำ workflow เพิ่ม/แก้ credential/มีข้อมูลใหม่ แล้วอยากให้เครื่องอื่น sync ตาม ให้รัน:

```bash
./scripts/export-db.sh
```

สคริปต์นี้จะ `pg_dump` ฐานข้อมูลที่กำลังรันอยู่ทับไฟล์ `init-db/01-init.sql` ให้ใหม่ (commit ไฟล์นี้เข้า git แล้ว push/copy ไปเครื่องอื่นได้เลย) — ใช้ได้เฉพาะกับเครื่องที่ยังไม่เคย `docker compose up -d` มาก่อน (volume ว่าง) เพราะสคริปต์ init จะไม่รันซ้ำถ้า volume มีข้อมูลอยู่แล้ว ถ้าต้องการบังคับ import ทับ instance ที่มีอยู่แล้ว ให้ลบ volume เดิมก่อน (**จะลบข้อมูลปัจจุบันของ instance นั้นทั้งหมด**):

```bash
docker compose down -v
docker compose up -d
```

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
