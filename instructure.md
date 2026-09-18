# รายงานการออกแบบหลักสูตรอบรม
## "สร้าง AI Agent และ Automation สำหรับครูด้วย n8n + PostgreSQL (pgvector)"
ระยะเวลา: 3 ชั่วโมง (180 นาที)

---

# 1. หลักการและเหตุผล

ครูในปัจจุบันมีภาระงานด้านการประมวลผลข้อมูล การวิเคราะห์ผลการเรียน และการจัดทำข้อสอบจำนวนมาก ซึ่งเป็นงานที่สามารถนำ AI และ Workflow Automation มาช่วยลดภาระได้

หลักสูตรนี้ออกแบบให้ผู้เข้าร่วมสามารถสร้างระบบ AI และ Automation ด้วย **n8n Self-hosted บน Docker** ทำงานร่วมกับ **PostgreSQL (พร้อม pgvector)** เพื่อการจัดเก็บข้อมูลและการค้นหาเชิงความหมาย (Semantic Search / Vector Store) โดยใช้ Gemini API Key เพียงรายการเดียว ลดความยุ่งยากในการเตรียมระบบ และเน้นการลงมือปฏิบัติ (Hands-on Workshop) มากกว่า 80% ของเวลาอบรม

โปรเจกต์มาพร้อม **ไฟล์ Workflow สำเร็จรูป** (พร้อม Sticky Note อธิบายทุกขั้นตอน) ในโฟลเดอร์ [`workflows/`](workflows/) และระบบ **Export/Import ฐานข้อมูลแบบเต็ม** (`init-db/01-init.sql`) ที่ทำให้เครื่องผู้เรียนทุกเครื่อง (หรือเครื่องผู้สอนที่ทำไว้ล่วงหน้า) ตั้งค่า n8n instance ให้เหมือนกันทุกประการได้ด้วยคำสั่งเดียว โดยไม่ต้องตั้งค่าบัญชีผู้ใช้หรือ Credential ใหม่ทีละเครื่อง

---

# 2. วัตถุประสงค์

เมื่อจบการอบรม ผู้เข้าร่วมจะสามารถ:

1. เข้าใจแนวคิด Workflow Automation และองค์ประกอบพื้นฐานของ n8n (Node, Trigger, Connection, Credential, Expression)
2. สร้าง AI Agent ด้วย n8n และ Gemini API
3. ออกแบบ Prompt สำหรับงานวิเคราะห์และจัดการด้านการศึกษา
4. สร้างแบบฟอร์มออนไลน์ด้วย n8n Form
5. เชื่อมต่อและจัดเก็บข้อมูลด้วย n8n Data Table และ PostgreSQL / pgvector
6. นำ AI มาวิเคราะห์ผลคะแนนสอบและสร้างรายงานสรุปอัตโนมัติ
7. เข้าใจพื้นฐานการต่อยอดสู่ระบบ RAG / Vector Search สำหรับสืบค้นเอกสารการสอน

---

# 3. เครื่องมือและสิ่งแวดล้อมที่ใช้

## 3.1 Software Stack (Docker Compose)

| บริการ | Container Name | Port | หน้าที่ |
|---|---|---|---|
| **n8n** | `csit_n8n_app` | `5678` | ระบบ Workflow Automation & AI Agent Engine |
| **PostgreSQL + pgvector (v16)** | `csit_n8n_postgres` | `5432` | ฐานข้อมูลหลัก (Data Storage) + Vector Database สำหรับ RAG |
| **pgAdmin 4** | `csit_n8n_pgadmin` | `5050` | Web UI สำหรับตรวจสอบและจัดการฐานข้อมูล |
| **Gemini API** | - | - | โมเดล AI จาก Google (รองรับทั้ง Chat Model และ Embedding Model) |

## 3.2 ข้อมูลการเชื่อมต่อระบบ (Default Credentials)

โปรเจกต์นี้แจก **ฐานข้อมูลตั้งต้น** (`init-db/01-init.sql`) ที่มีบัญชีผู้ใช้ n8n และ Workflow ตัวอย่างติดตั้งไว้ให้แล้ว ผู้เรียนที่ clone โปรเจกต์และรัน `docker compose up -d` จะได้ระบบที่ล็อกอินได้ทันทีโดยไม่ต้องสมัครบัญชีใหม่

| บริการ | URL / Host | Username / Email | Password | รายละเอียด |
|---|---|---|---|---|
| **n8n Web UI** | `http://localhost:5678` | `workshop@csit.ac.th` | `CSIT@2026` | แพลตฟอร์มสร้าง Workflow |
| **pgAdmin Web UI** | `http://localhost:5050` | `admin@csit-n8n-workshop.com` | `adminpass` | หน้าต่างดูตารางฐานข้อมูล (เชื่อมต่อ Postgres ให้อัตโนมัติแล้ว) |
| **PostgreSQL (n8n Node)** | Host: `postgres` / Port: `5432` | `n8n` | `n8npass` | Database: `n8n`, SSL: `Disable` |
| **Gemini API** | Google AI Studio | - | *(API Key ส่วนตัวของผู้เรียน)* | ใช้สำหรับ AI Agent / Embeddings |

> ค่าเริ่มต้นทั้งหมดตรงกับไฟล์ `.env.example` อยู่แล้ว จึงไม่จำเป็นต้องสร้างไฟล์ `.env` เองก็ใช้งานได้ทันที (ปรับแก้ได้หากต้องการเปลี่ยน port/password)

---

# 4. พื้นฐาน n8n ที่ควรรู้ก่อนเริ่ม Workshop

หัวข้อนี้เป็นเนื้อหาปูพื้นฐานแบบบรรยายในช่วงที่ 1 สำหรับผู้ที่ไม่เคยใช้ n8n มาก่อน ก่อนลงมือฝึกจริงกับ Node และ Workflow ตัวอย่างในช่วงที่ 2 (ดูหัวข้อ **5. แผนการอบรม**)

## 4.1 n8n คืออะไร
n8n เป็นเครื่องมือ **Workflow Automation** แบบ Low-code/No-code ที่ให้ผู้ใช้ต่อ "โหนด" (Node) เป็นเส้นทาง (Flow) เพื่อรับข้อมูล ประมวลผล และส่งต่อไปยังปลายทางต่าง ๆ โดยอัตโนมัติ รองรับทั้งการเชื่อมต่อ API, ฐานข้อมูล, AI Model และบริการภายนอกนับพันตัว

## 4.2 องค์ประกอบหลักของ Workflow

| องค์ประกอบ | ความหมาย | ตัวอย่างในโปรเจกต์นี้ |
|---|---|---|
| **Node** | บล็อกการทำงาน 1 หน่วย เช่น รับข้อมูล / แปลงข้อมูล / เรียก API | AI Agent, Postgres, Edit Fields |
| **Trigger** | โหนดที่เริ่มต้น Workflow (จุดเริ่มเสมอ 1 workflow มีได้หลาย trigger) | Chat Trigger, Form Trigger, Manual Trigger, Schedule Trigger |
| **Connection** | เส้นเชื่อมระหว่างโหนด กำหนดลำดับการไหลของข้อมูล | เส้นลูกศรระหว่างโหนดบน Canvas |
| **Credential** | ข้อมูล API Key / Login ที่เก็บแบบเข้ารหัสไว้ใช้ซ้ำในหลาย Node | Google Gemini API, Postgres Credential |
| **Expression (`{{ }}`)** | ไวยากรณ์ดึงค่าจากโหนดก่อนหน้า เขียนด้วย JavaScript สั้น ๆ | `{{ $json.student_name }}`, `{{ $json.score }}` |
| **Execution** | ประวัติการรันแต่ละครั้งของ Workflow ดูย้อนหลังได้ว่าแต่ละโหนดได้ข้อมูลอะไร | แท็บ *Executions* มุมซ้ายของ n8n |

## 4.3 ประเภท Trigger ที่ใช้บ่อย
- **Manual Trigger**: กดรันเองด้วยปุ่ม ▶️ ใช้ตอนทดสอบ Workflow
- **Chat Trigger**: เปิดหน้าต่างแชทสำหรับคุยกับ AI Agent แบบ Real-time
- **Form Trigger**: สร้างแบบฟอร์มออนไลน์ (URL เฉพาะ) ให้กรอกข้อมูลแล้วเริ่ม Workflow อัตโนมัติ
- **Schedule Trigger**: ตั้งเวลารันอัตโนมัติ (เช่น รันทุกเช้า สรุปผลสอบประจำวัน)
- **Webhook Trigger**: รับข้อมูลจากระบบภายนอกผ่าน HTTP Request

## 4.4 การส่งต่อข้อมูลระหว่างโหนด
- ทุกโหนดรับ-ส่งข้อมูลเป็น **JSON array ของ item** เสมอ
- ใช้ `$json` อ้างอิงข้อมูลจาก item ปัจจุบัน และ `$node["ชื่อโหนด"].json` อ้างอิงข้อมูลจากโหนดอื่นที่รันไปแล้ว
- โหนดยอดนิยมสำหรับแปลงข้อมูล: **Edit Fields (Set)** สำหรับกำหนด/เปลี่ยนชื่อฟิลด์, **Code** สำหรับเขียน JavaScript คำนวณเอง, **If / Switch** สำหรับแยกเงื่อนไข, **Aggregate** สำหรับรวมหลาย item เป็นก้อนเดียว

## 4.5 การจัดเก็บข้อมูลใน n8n: Data Table vs PostgreSQL
โปรเจกต์นี้ให้ผู้เรียนเห็นการจัดเก็บข้อมูล 2 รูปแบบเพื่อเปรียบเทียบ:
- **n8n Data Table**: ฟีเจอร์ในตัว n8n เอง ไม่ต้องตั้งค่า Credential สร้างตารางได้จากหน้า UI หรือให้ Workflow สร้างให้อัตโนมัติ เหมาะกับการเริ่มต้นเร็ว
- **PostgreSQL Node**: เชื่อมต่อฐานข้อมูลจริงด้วย Credential ที่ตั้งเอง เหมาะกับระบบที่ต้องการความสามารถของ SQL เต็มรูปแบบ (Query ซับซ้อน, Join, Vector Search ด้วย pgvector)

---

# 5. แผนการอบรมแบบละเอียด (3 ชั่วโมง)

## ช่วงที่ 1: Introduction & Environment Setup (10 นาที)
- แนะนำ n8n, Workflow Automation และ AI Agent ในงานการศึกษา
- ตรวจสอบระบบ Docker, การเข้าใช้งาน n8n (`http://localhost:5678`) และ pgAdmin (`http://localhost:5050`)
- การขอ Gemini API Key จาก [Google AI Studio](https://aistudio.google.com/)
- ปูพื้นฐานแนวคิดตามหัวข้อ **4. พื้นฐาน n8n ที่ควรรู้ก่อนเริ่ม Workshop** (Node / Trigger / Credential / Expression) แบบบรรยายสั้น ๆ ก่อนลงมือจริงในช่วงถัดไป

---

## ช่วงที่ 2: พื้นฐาน n8n ด้วย Node และ Workflow ตัวอย่าง (Hands-on) (30 นาที)

ช่วงนี้ให้ผู้เรียนลงมือใช้ n8n จริงเป็นครั้งแรก ผ่านไฟล์ฝึกในโฟลเดอร์ [`workflows/01 - Basic/`](workflows/01%20-%20Basic/) ที่มี Sticky Note อธิบายและมีคำตอบให้ตรวจสอบในตัว (โหนด "Check Answer" / "Is Correct?") เหมาะสำหรับปูพื้นก่อนเข้า Workshop 1-3

### กิจกรรม 1: รู้จักประเภท Node หลัก (10 นาที)
ไฟล์: [`BSC01-Understandn8nNodes.json`](workflows/01%20-%20Basic/BSC01-Understandn8nNodes.json)
- สำรวจ Canvas ที่รวม Node แทบทุกประเภทไว้ในไฟล์เดียว เพื่อให้เห็นภาพรวม: **Trigger Node** (Schedule, Webhook, Manual, Chat), **Regular Node** (Edit Fields, Filter, If/Switch, Merge, Sort, Code, Wait), **AI Node** (AI Agent, Basic LLM Chain, Chat Model, Memory)
- ให้ผู้เรียนคลิกเปิดแต่ละ Sticky Note อ่านคำอธิบาย แล้วลองกด ▶️ Execute step ทีละโหนดเพื่อดูข้อมูลที่ไหลผ่าน

### กิจกรรม 2: ฝึกต่อ Node และแปลงข้อมูล (10 นาที)
ไฟล์: [`BSC02-NodeConnection.json`](workflows/01%20-%20Basic/BSC02-NodeConnection.json) และ [`BSC03-DataTransformation.json`](workflows/01%20-%20Basic/BSC03-DataTransformation.json)
- ฝึกลาก Connection เชื่อม Node ตามโจทย์ที่ Sticky Note กำหนด (เช่น กรองข้อมูลลูกค้าเฉพาะประเทศ US ด้วย **Filter**, เปลี่ยนค่าฟิลด์ด้วย **Edit Fields**, รวมข้อมูลด้วย **Merge**)
- กด Execute แล้วเทียบผลกับ Node **"✅ Yes, Correct Answer" / "❌ No, Wrong Answer"** เพื่อตรวจคำตอบด้วยตนเอง

### กิจกรรม 3: ฝึกคำนวณค่าด้วย Expression/Code (10 นาที)
ไฟล์: [`BSC04-BMICalculation.json`](workflows/01%20-%20Basic/BSC04-BMICalculation.json) และ [`BSC89-HTTPRequest.json`](workflows/01%20-%20Basic/BSC89-HTTPRequest.json)
- ใช้ **If / Switch** แยกเงื่อนไขคำนวณค่าดัชนีมวลกาย (BMI) จากข้อมูลตัวอย่าง แล้วสรุปผลด้วย **Summarize**
- ทดลองเรียก API ภายนอกด้วย **HTTP Request Node** และแปลงผลลัพธ์ด้วย **Code Node** เพื่อเตรียมความเข้าใจก่อนเรียก Gemini API ใน Workshop 1

> โหนดที่เหลือในโฟลเดอร์ (`BSC05`-`BSC06` Google Credential/Service, `BSC08`/`BSC99` AI Agent เบื้องต้น, `BSC09` STT/TTS) เป็นแบบฝึกหัดเสริมนอกเวลา ดูรายละเอียดที่ [§6.2](#62-เนื้อหาเสริมสำหรับฝึกฝนเพิ่มเติม-ไม่บังคับในเวลา-3-ชม)

---

## ช่วงที่ 3: Workshop 1 - AI Agent ผู้ช่วยครูประจำชั้น (50 นาที)

ไฟล์สำเร็จรูป: [`workflows/01_ai_agent_teacher_assistant.json`](workflows/01_ai_agent_teacher_assistant.json)

### กิจกรรม 1: สร้าง AI Agent พื้นฐาน
เชื่อมต่อ Node:
```text
Chat Trigger ──> AI Agent (Gemini Chat Model) ──> Memory (Window Buffer)
```

### กิจกรรม 2: ติดตั้ง Credential & ตั้งค่า Gemini
- เชื่อมต่อ Google Gemini Chat Model (`gemini-flash-latest` — alias ที่ชี้ไปยังรุ่น Flash ล่าสุดของ Gemini เสมอ เพื่อไม่ให้ Workflow เสียเมื่อ Google ปลดรุ่นโมเดลเก่า เช่น `gemini-1.5-flash` และ `gemini-2.0-flash` ที่ถูกปลดระวางไปแล้ว)

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

## ช่วงที่ 4: Workshop 2 - ระบบทำข้อสอบออนไลน์ด้วย n8n Form (45 นาที)

โปรเจกต์เตรียมไฟล์สำเร็จรูปไว้ **2 รูปแบบ** ให้เลือกใช้ตามจุดเน้นของการสอน:

| ไฟล์ | รูปแบบการจัดเก็บ | หมายเหตุ |
|---|---|---|
| [`workflows/02_exam_form_to_datatable.json`](workflows/02_exam_form_to_datatable.json) | **n8n Data Table** (แนะนำ) | มีปุ่ม ⚙️ Setup สร้างตาราง `exam_results` ให้อัตโนมัติ ไม่ต้องตั้งค่า Credential — **ต้องใช้ไฟล์นี้ถ้าต้องการให้ Workshop 3 เห็นข้อมูลจริงจากนักเรียน** |
| [`workflows/02_exam_form_to_postgres.json`](workflows/02_exam_form_to_postgres.json) | **PostgreSQL** | เหมาะสำหรับสาธิตการเขียนข้อมูลลง Postgres โดยเฉพาะ (Workshop 3 เวอร์ชันปัจจุบันไม่ได้อ่านจากตารางนี้) |

### กิจกรรม 1: สร้างแบบฟอร์มข้อสอบ (n8n Form Trigger)
กำหนดฟิลด์ในแบบฟอร์ม:
- ชื่อ-นามสกุล (`student_name`)
- ระดับชั้น (`grade_level`)
- วิชา (`subject`)
- คำถามข้อที่ 1-10 (แบบเลือกตอบ Dropdown, คะแนนเต็มข้อละ 1 คะแนน รวม 10 คะแนน)

### กิจกรรม 2: คำนวณคะแนนอัตโนมัติ (Code Node / Edit Fields)
คำนวณ:
- `score` (คะแนนที่ได้)
- `total_score` (คะแนนเต็ม)
- `percentage` = `(score / total_score) * 100`
- `pass_status` = `percentage >= 50 ? 'ผ่าน' : 'ไม่ผ่าน'`
- เก็บคำตอบรายข้อ (`answer_1`...`answer_10`) และผลถูก/ผิดรายข้อ (`is_correct_1`...`is_correct_10`) ไว้ด้วย เพื่อใช้วิเคราะห์ใน Workshop 3

### กิจกรรม 3: บันทึกผลและป้องกันข้อมูลซ้ำ
Workflow (เวอร์ชัน Data Table):
```text
n8n Form Trigger ──> Calculate Score ──> ค้นหา Data Table (เช็คทำซ้ำ) ──> If มีข้อมูลอยู่แล้ว?
   ├─ มี  ──> แจ้งเตือนว่าเคยทำแบบทดสอบนี้ไปแล้ว
   └─ ไม่มี ──> บันทึกลง Data Table ──> ตอบกลับด้วย HTML Certificate
```
Workflow (เวอร์ชัน PostgreSQL):
```text
n8n Form Trigger ──> Calculate Score ──> PostgreSQL Node (Insert ตาราง exam_results) ──> ตอบกลับด้วย HTML Certificate
```
- ตั้งค่า Postgres Node (เวอร์ชัน PostgreSQL เท่านั้น): Operation = `Insert`, Table = `exam_results`

---

## ช่วงที่ 5: Workshop 3 - AI วิเคราะห์ผลสอบภาพรวมจาก Database (35 นาที)

ไฟล์สำเร็จรูป: [`workflows/03_ai_exam_analytics.json`](workflows/03_ai_exam_analytics.json)

### กิจกรรม 1: ดึงข้อมูลคะแนนสอบจาก n8n Data Table
- ใช้โหนด **Data Table (Get Many Rows)** ไม่ต้องตั้งค่า Credential:
  - Resource: `Row` / Operation: `Get Many Rows`
  - Data Table: `exam_results`
  - Filter: `subject` = `วิทยาศาสตร์`
  - Order By: `score` แบบ `Ascending`
- *(ทางเลือก: ถ้าใช้ Workshop 2 แบบ PostgreSQL แทน สามารถเปลี่ยนมาใช้ Postgres Node Query แบบเดิมได้เช่นกัน)*
  ```sql
  SELECT student_name, grade_level, subject, score, total_score, percentage, pass_status 
  FROM exam_results 
  WHERE subject = 'วิทยาศาสตร์';
  ```

### กิจกรรม 2: สรุปสถิติและอัตราตอบผิดรายข้อ
- ใช้โหนด **Aggregate / Code** คำนวณสถิติภาพรวม (จำนวนผู้สอบ, คะแนนเฉลี่ย, สูงสุด, ต่ำสุด, อัตราสอบผ่าน) และอัตราการตอบผิดของแต่ละข้อ (`is_correct_1`...`is_correct_10`) เพื่อดูว่าข้อไหนนักเรียนพลาดมากที่สุด

### กิจกรรม 3: ส่งข้อมูลให้ AI Agent สรุปรายงานเชิงลึก
Workflow:
```text
Manual / Schedule Trigger ──> n8n Data Table (Get Many Rows) ──> Aggregate / Code (สถิติ + อัตราตอบผิด) ──> AI Agent (Gemini) ──> Generate HTML / Email Report
```

### Prompt ตัวอย่าง:
```text
จากข้อมูลผลการสอบต่อไปนี้:
{{ $json.exam_data }}

โปรดจัดทำ "รายงานสรุปผลการประเมินการเรียนรู้":
1. สถิติภาพรวม (จำนวนผู้สอบ, คะแนนเฉลี่ย, สูงสุด, ต่ำสุด, อัตราการสอบผ่าน)
2. ข้อที่นักเรียนตอบผิดมากที่สุด พร้อมข้อสันนิษฐานสาเหตุ
3. รายชื่อนักเรียนกลุ่มที่ต้องพัฒนาเร่งด่วน พร้อมระบุจุดที่ควรปรับปรุง
4. ข้อเสนอแนะในการปรับปรุงแผนการจัดการเรียนรู้สำหรับครูผู้สอน
```

---

## ช่วงที่ 6: Mini Challenge & Bonus Vector Store (10 นาที)

- **Mini Challenge**: ให้นำแนวคิดไปประยุกต์ทำแบบประเมินความพึงพอใจ หรือระบบคัดกรองนักเรียน SDQ
- **Bonus Feature (pgvector)**: แนะนำการต่อยอด Vector Store ด้วยตาราง `knowledge_documents` เพื่อทำระบบค้นหาแผนการสอนและคู่มือครูด้วย AI (Semantic Search)

---

# 6. ไฟล์ Workflow สำเร็จรูปและเนื้อหาเสริม

## 6.1 ไฟล์หลักของ Workshop (โฟลเดอร์ `workflows/`)

| ไฟล์ | Workshop | จุดเด่น |
|---|---|---|
| [`01_ai_agent_teacher_assistant.json`](workflows/01_ai_agent_teacher_assistant.json) | Workshop 1 | Chat Trigger + AI Agent (Gemini) + Window Buffer Memory |
| [`02_exam_form_to_datatable.json`](workflows/02_exam_form_to_datatable.json) | Workshop 2 (แนะนำ) | Form ➡️ คำนวณคะแนน ➡️ กันข้อมูลซ้ำ ➡️ บันทึกลง n8n Data Table ➡️ HTML Certificate |
| [`02_exam_form_to_postgres.json`](workflows/02_exam_form_to_postgres.json) | Workshop 2 (ทางเลือก) | Form ➡️ คำนวณคะแนน ➡️ บันทึกลง PostgreSQL ➡️ HTML Certificate |
| [`03_ai_exam_analytics.json`](workflows/03_ai_exam_analytics.json) | Workshop 3 | ดึงข้อมูลจาก Data Table ➡️ สรุปสถิติ + อัตราตอบผิดรายข้อ ➡️ AI Agent สรุปรายงาน |

รายละเอียดวิธี Import และการตั้งค่า Credential ของแต่ละไฟล์ดูเพิ่มเติมได้ที่ [`workflows/README.md`](workflows/README.md)

## 6.2 เนื้อหาเสริมสำหรับฝึกฝนเพิ่มเติม (ไม่บังคับในเวลา 3 ชม.)

ไฟล์ `BSC01`, `BSC02`, `BSC03`, `BSC04` และ `BSC89` ในโฟลเดอร์ [`workflows/01 - Basic/`](workflows/01%20-%20Basic/) ถูกใช้จริงแล้วในช่วงที่ 2 ของแผนการอบรม (ดูหัวข้อ **5. แผนการอบรมแบบละเอียด**) ส่วนไฟล์และโฟลเดอร์ที่เหลือเป็นเนื้อหาเสริมสำหรับผู้เรียนที่ต้องการฝึกด้วยตนเองหลังจบ Workshop:

- **`workflows/01 - Basic/`** (ไฟล์เสริมที่เหลือ) — การตั้งค่า Google Credential/Service (`BSC05`-`BSC06`), AI Agent เบื้องต้น (`BSC08`/`BSC99`) และ Speech-to-Text/Text-to-Speech (`BSC09`)
- **[`workflows/02 - Example/`](workflows/02%20-%20Example/)** — ตัวอย่าง Use Case ขั้นสูงสำหรับต่อยอด เช่น RAG กับ Postgres Vector Store, OCR เอกสาร/ใบเสร็จด้วย Gemini, Web Scraping/Web Search, AI Voice Chat, AI Agent Guardrails, AI Observability และการเชื่อมต่อ Google Drive/Sheet

---

# 7. โครงสร้างฐานข้อมูล (Database Schema)

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
    -- คำตอบที่นักเรียนเลือกในแต่ละข้อ (ข้อสอบ 10 ข้อ) ใช้ย้อนดูว่าตอบผิดข้อไหนบ้าง
    answer_1 VARCHAR(255),
    answer_2 VARCHAR(255),
    answer_3 VARCHAR(255),
    answer_4 VARCHAR(255),
    answer_5 VARCHAR(255),
    answer_6 VARCHAR(255),
    answer_7 VARCHAR(255),
    answer_8 VARCHAR(255),
    answer_9 VARCHAR(255),
    answer_10 VARCHAR(255),
    is_correct_1 BOOLEAN,
    is_correct_2 BOOLEAN,
    is_correct_3 BOOLEAN,
    is_correct_4 BOOLEAN,
    is_correct_5 BOOLEAN,
    is_correct_6 BOOLEAN,
    is_correct_7 BOOLEAN,
    is_correct_8 BOOLEAN,
    is_correct_9 BOOLEAN,
    is_correct_10 BOOLEAN,
    submit_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

> เวอร์ชัน Workshop 2 ที่ใช้ **n8n Data Table** จะมีโครงสร้างฟิลด์เทียบเท่ากันนี้ แต่สร้าง/จัดการผ่านฟีเจอร์ Data Table ในตัว n8n แทนการรัน SQL เอง (ใช้ปุ่ม ⚙️ Setup ในไฟล์ `02_exam_form_to_datatable.json` สร้างให้อัตโนมัติ)

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

# 8. คำสั่งเริ่มต้นใช้งานสำหรับผู้สอนและผู้เรียน

## 8.1 ติดตั้งด้วยคำสั่งเดียว (macOS / Linux / Windows PowerShell 7+)

```bash
git clone https://github.com/tesolar/csit_n8n_workshop.git csit-n8n-workshop && cd csit-n8n-workshop && docker compose up -d
```

คำสั่งนี้ clone โปรเจกต์และสั่ง build + start ทุก container ให้อัตโนมัติ ได้ n8n instance ที่มีบัญชีผู้ใช้และ Workflow ตัวอย่างพร้อมใช้งานทันที (ดูข้อมูลล็อกอินที่ตาราง [3.2](#32-ข้อมูลการเชื่อมต่อระบบ-default-credentials)) โดยไม่ต้องสร้างไฟล์ `.env` เอง

> ⚠️ Windows PowerShell 5.1 (รุ่นเก่าที่มากับ Windows โดย default) ไม่รองรับ `&&` ให้รันทีละบรรทัดแทน

## 8.2 ปรับแต่งค่า (ไม่บังคับ)

```bash
cp .env.example .env   # Windows (cmd/PowerShell): copy .env.example .env
```

## 8.3 ตรวจสอบสถานะและจัดการระบบ

```bash
# ตรวจสอบสถานะ container
docker compose ps

# ดู log ของ n8n
docker compose logs -f n8n

# หยุดการทำงานของ container
docker compose down

# หยุดการทำงานและล้างข้อมูลทั้งหมด (รวม volumes)
docker compose down -v
```

- เข้าใช้งาน **n8n**: [http://localhost:5678](http://localhost:5678)
- เข้าใช้งาน **pgAdmin**: [http://localhost:5050](http://localhost:5050)

## 8.4 การ Export/Import ฐานข้อมูล (สำหรับผู้สอน — เตรียม/อัปเดต instance ต้นแบบ)

ทุกอย่าง (บัญชีผู้ใช้ n8n, Credentials, Workflows, ตาราง Workshop) เก็บอยู่ใน Postgres ฐานข้อมูลเดียว หลังแก้ไข Workflow หรือเพิ่มข้อมูลใหม่ในเครื่องต้นแบบ ให้รันสคริปต์นี้เพื่ออัปเดต dump ที่แจกให้ผู้เรียน:

```bash
./scripts/export-db.sh
```

สคริปต์จะ `pg_dump` ทับไฟล์ `init-db/01-init.sql` ให้ใหม่ — commit เข้า git แล้วแจกต่อให้ผู้เรียน `git clone` ไปใช้ได้ทันที (รายละเอียดเพิ่มเติมดูที่ [README.md](README.md#-export--import-ฐานข้อมูล-ย้ายไปเครื่องอื่น))
</content>
