# 📁 n8n Workflows สำหรับ Workshop

โฟลเดอร์นี้รวบรวมไฟล์ Workflow สำเร็จรูป (.json) พร้อม **Sticky Note อธิบายขั้นตอนการทำงานอย่างละเอียด** ในทุกโหนด สามารถนำเข้า (Import) เข้าสู่ n8n ได้ทันที

---

## 📋 รายการ Workflows

| ไฟล์ | ชื่อ Workshop | จุดเด่น / การทำงาน |
|---|---|---|
| [`01_ai_agent_teacher_assistant.json`](./01_ai_agent_teacher_assistant.json) | **Workshop 1: AI Agent ผู้ช่วยครูประจำชั้น** | Chat Trigger + AI Agent (Gemini) + Window Buffer Memory |
| [`02_exam_form_to_datatable.json`](./02_exam_form_to_datatable.json) | **Workshop 2 (Data Table, แนะนำ): ระบบทำข้อสอบ + Check If** | มีปุ่ม ⚙️ Setup สร้างตาราง `exam_results` ให้อัตโนมัติ ➡️ n8n Form ➡️ คำนวณคะแนน (เก็บคำตอบรายข้อด้วย) ➡️ ค้นหา Data Table ➡️ If เช็คซ้ำ (ถ้ามีแจ้งเตือน / ถ้าไม่มีบันทึกลง Data Table ➡️ HTML Certificate) — **ไฟล์นี้คือไฟล์ที่ Workshop 3 อ่านข้อมูลมาใช้** |
| [`02_exam_form_to_postgres.json`](./02_exam_form_to_postgres.json) | **Workshop 2 (PostgreSQL): ระบบทำข้อสอบ** | n8n Form Trigger ➡️ คำนวณคะแนน (Code, เก็บคำตอบรายข้อด้วย) ➡️ บันทึกลง PostgreSQL ➡️ คืนผลลัพธ์ HTML Certificate — ตาราง Postgres นี้ปัจจุบัน Workshop 3 ไม่ได้อ่าน (อ่านจาก Data Table แทน) |
| [`03_ai_exam_analytics.json`](./03_ai_exam_analytics.json) | **Workshop 3: AI วิเคราะห์ผลสอบจาก Database** | Manual Trigger ➡️ ดึงข้อมูลจาก **n8n Data Table** `exam_results` (กรอง + เรียงคะแนน) ➡️ สรุปสถิติ + อัตราตอบผิดรายข้อ ➡️ AI Agent (Gemini) สร้างรายงานเชิงลึก |
| [`Workshop 4 - สรุปการประชุมด้วย AI จากไฟล์ Local.json`](./Workshop%204%20-%20สรุปการประชุมด้วย%20AI%20จากไฟล์%20Local.json) | **Workshop 4: สรุปการประชุมด้วย AI + จัดหมวดหมู่ไฟล์อัตโนมัติ** | Manual Trigger ➡️ อ่านไฟล์ `.txt` ทั้งหมดใน `data/input/` (bind mount `./data:/data`) ➡️ แปลงไฟล์เป็นข้อความ ➡️ AI Agent (Gemini) + Structured Output Parser ทำ 4 อย่างพร้อมกัน: ตรวจแก้คำผิด/คำตก, คัดข้อความไม่เกี่ยวข้องออก, สรุปให้สั้นกว่าต้นฉบับ, และจัดหมวดหมู่คณะทำงาน ➡️ เขียนไฟล์สรุปลง `data/output/<หมวดหมู่>/` อัตโนมัติ — มีไฟล์ตัวอย่างบันทึกการประชุม 15 ไฟล์ จาก 5 คณะทำงานที่ตำแหน่งต่าง ๆ ประชุมร่วมกันเป็นประจำ เตรียมไว้ให้ใน `data/input/` |
| [`Workshop 5 - LINE Chatbot ถามผลสอบ.json`](./Workshop%205%20-%20LINE%20Chatbot%20ถามผลสอบ.json) | **Workshop 5: LINE Chatbot ถามผลสอบ + คำแนะนำปรับปรุง** | Community Node `@aotoki/n8n-nodes-line-messaging`: **Line Messaging Trigger** (ตรวจสอบ `X-Line-Signature` ให้อัตโนมัติ) ➡️ แยก `replyToken`/ข้อความจาก event (ข้าม event ที่ไม่ใช่ข้อความตัวอักษร) ➡️ ดึงข้อมูลจาก Data Table `exam_results` (ตารางเดียวกับ Workshop 2/3) ➡️ Code คำนวณสถิติภาพรวม + อัตราตอบผิดรายข้อล่วงหน้า ➡️ AI Agent (Gemini) ตอบคำถามสั้น ๆ พร้อม**คำแนะนำเชิงคุณภาพ**ว่าควรปรับปรุง/ทบทวนเรื่องอะไร (รายบุคคลดูจากข้อที่ตอบผิด, ภาพรวมดูจากข้อที่ทั้งห้องตอบผิดเยอะสุด) ➡️ **Line Messaging** node (operation: Reply) ส่งกลับผู้ใช้ — มีตัวอย่าง event จริงปักหมุด (Pin Data) ไว้ที่โหนด Trigger ให้ทดสอบต่อสายได้ทันทีโดยไม่ต้องรอข้อความจริง — ต้องติดตั้ง Community Node และตั้งค่า LINE Messaging API Channel ก่อน (ดู Sticky Note ในไฟล์) |

---

## 🚀 วิธีการนำไฟล์ Workflow เข้าสู่ n8n

### วิธีที่ 1: Import ผ่านเมนู n8n (แนะนำ)
1. เปิด n8n ที่ [http://localhost:5678](http://localhost:5678)
2. ไปที่เมนู **Workflows** ➡️ กดปุ่ม **Add workflow** (หรือเปิดหน้าว่าง)
3. คลิกปุ่มเมนู **`...` (จุดสามจุด)** ที่มุมขวาบนของหน้าจอ
4. เลือก **Import from File...** แล้วเลือกไฟล์ `.json` ที่ต้องการ

### วิธีที่ 2: Copy & Paste
1. เปิดไฟล์ `.json` แล้วคัดลอกข้อความทั้งหมด (`Ctrl+A` / `Cmd+A` และ `Ctrl+C` / `Cmd+C`)
2. คลิกบนพื้นที่ว่างของหน้าจอ Canvas ใน n8n แล้วกด **`Ctrl+V` / `Cmd+V`** เพื่อวาง Workflow ลงบนหน้าจอทันที

---

## 🔑 การตั้งค่า Credentials ที่จำเป็น

### 1. Google Gemini API (สำหรับ Workshop 1 & 3)
- ไปที่ **Credentials** ใน n8n ➡️ กด **Add Credential** ➡️ ค้นหา `Google Gemini (PaLM) API`
- ใส่ **API Key** ที่ได้จาก [Google AI Studio](https://aistudio.google.com/)

### 2. n8n Data Table (สำหรับ Workshop 2 Data Table variant & Workshop 3)
- ไม่ต้องตั้งค่า Credential ใด ๆ — Data Table เป็นฟีเจอร์ในตัว n8n เอง
- ก่อนใช้งานครั้งแรก ให้เปิด `02_exam_form_to_datatable.json` แล้วกดปุ่ม ▶️ **Execute step** บนโหนด **⚙️ Setup: สร้างตาราง exam_results** หนึ่งครั้งเพื่อสร้างตารางที่ทั้ง Workshop 2 และ 3 ใช้ร่วมกัน

### 3. PostgreSQL (สำหรับ Workshop 2 PostgreSQL variant เท่านั้น)
- ไปที่ **Credentials** ใน n8n ➡️ กด **Add Credential** ➡️ ค้นหา `Postgres`
- กำหนดค่าดังนี้:
  - **Host**: `postgres`
  - **Database**: `n8n`
  - **User**: `n8n`
  - **Password**: `n8npass`
  - **Port**: `5432`
  - **SSL**: `Disable`

### 4. LINE Messaging API (สำหรับ Workshop 5)
- ติดตั้ง Community Node `@aotoki/n8n-nodes-line-messaging` ก่อน (n8n → **Settings → Community Nodes**)
- สร้าง Channel ที่ [LINE Developers Console](https://developers.line.biz/console/) แล้วคัดลอก **Channel access token** และ **Channel secret**
- ไปที่ **Credentials** ใน n8n ➡️ กด **Add Credential** ➡️ ค้นหา `Line Messaging API`
- กรอก **Channel Access Token** และ **Channel Secret** แล้วผูก Credential เดียวกันนี้กับทั้งโหนด **Line Messaging Trigger** และ **Line Messaging**
- n8n ต้องมี URL แบบ HTTPS ที่ LINE ยิง webhook เข้ามาถึงได้ (เช่น deploy จริง หรือ tunnel เช่น ngrok/cloudflared ระหว่าง demo) — ดูรายละเอียดใน Sticky Note ของไฟล์ Workshop 5
