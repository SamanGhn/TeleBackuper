# 🚀 TeleBackuper

> 🛡️ A modular, interactive backup automation tool that compresses directories and sends them to Telegram — built with Python & Bash

---

## 🌟 Overview

**TeleBackuper** is a powerful and lightweight backup automation system designed for sysadmins, DevOps engineers, and developers who want a simple way to:

- 📦 Backup selected directories
- 🗜 Compress them to a `.tar.gz` archive
- 🔁 Schedule automated backups using `cron`
- 📤 Securely send backups to a Telegram bot

The tool offers a fully interactive CLI with a beautiful interface powered by [`rich`](https://github.com/Textualize/rich), making the backup process clean, customizable, and user-friendly.

---

## ✨ Key Features

- 🎛️ **Interactive Setup Wizard**  
  Choose directories, set backup intervals, and configure Telegram in seconds.

- 🤖 **Telegram Integration**  
  Send backups directly to your private bot/chat using your bot token and numeric ID.

- 🗂️ **Multi-directory Support**  
  Backup one or multiple directories at once (comma-separated input).

- 📅 **Dynamic Cron Job Creation**  
  Automatically schedules recurring backups based on your input (e.g., every 2 hours).

- 📄 **Clean Logs & Error Handling**  
  Uses Python's `logging` and `rich` for clear, traceable output and better debugging.

---

## ⚙️ Technologies Used

- **Python** — main logic (modular architecture)
- **Bash** — setup and installation script
- **cron** — job scheduling
- **Telegram Bot API** — file delivery
- **Rich** — beautiful terminal output and prompts

---

## 🧑‍💻 Use Cases

- 🔐 Regular server or VPS backups
- 🧰 Personal tool for sysadmins & DevOps engineers
- 🔄 Lightweight alternative to cloud-based backup solutions
- 💼 Useful in freelance projects to automate client data backup

---

## 🚀 Quick Start

1. **Clone the repo**:
   ```bash
   git clone https://github.com/yourusername/TeleBackuper.git
   cd TeleBackuper
