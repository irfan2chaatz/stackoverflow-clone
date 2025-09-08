# 📘 Stack Overflow Clone (Elixir + React)

This project is a **single-page clone of Stack Overflow**.  
The app allows users to search questions, fetch answers from the official Stack Overflow API, and view **AI-powered re-ranked answers** using a Large Language Model (LLM).  

---

## 🚀 Features
- 🔍 Search for programming questions.  
- 🌐 Fetch answers from the **Stack Overflow public API**.  
- 🖥 Display answers in a **React UI** (similar to Stack Overflow).  
- 🤖 **AI Re-Ranking:** Answers reordered by an LLM (OpenAI, Google Gemini, or local model).  
- 🔄 Toggle between **original** and **AI-ranked** answers.  
- 🗄 Cache the **last 5 recent searches** per user in PostgreSQL.  
- 📦 Fully containerized with **Docker & Docker Compose**.  

---

## 🛠 Tech Stack
- **Backend:** Elixir + Phoenix (API only)  
- **Frontend:** React (Vite) + Tailwind/MUI  
- **Database:** PostgreSQL  
- **LLM Integration:** OpenAI API / Google Gemini / Local LLM (Ollama, llama.cpp, etc.)  
- **Infra:** Docker + Docker Compose  

---

## ⚙️ Local Setup

### **Prerequisites**
- [Docker](https://docs.docker.com/get-docker/)  
- [Docker Compose](https://docs.docker.com/compose/install/)

---

### **1. Clone the repository**

```bash
git clone <YOUR_REPO_URL> stackoverflow-clone
cd stackoverflow-clone
```

### **2. Build and start containers**

```bash
docker compose up --build -d
```

### **3. Database setup**

Enter the backend container:
```bash
docker compose exec backend bash

# Create the database
mix ecto.create

# Run migrations
mix ecto.migrate

# Ensure backend/.env contains correct DB credentials:
DB_USER=postgres
DB_PASS=postgres
DB_HOST=db
DB_NAME=backend_dev
```
Exit the container:
```bash
exit
```
### **4. View logs**
```bash
docker compose logs -f backend   # Backend logs
docker compose logs -f frontend  # Frontend logs
docker compose logs -f db        # Database logs
```

### **5. Stop containers**
```bash
docker compose down
```

This version includes:  

1. Prerequisites  
2. Docker Compose commands  
3. Ecto database setup  
4. Optional logs

