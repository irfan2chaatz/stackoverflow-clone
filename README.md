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
