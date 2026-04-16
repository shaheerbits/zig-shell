# 🐚 Zig Shell

A minimal, cross-functional command-line shell built in **Zig (0.15.2)** , a low-level system programming language.

---

## 🚀 Overview

**Zig Shell** is a simple REPL-based shell that demonstrates core concepts of system programming:

- Process creation and management
- Command parsing
- Built-in command handling
- OS-level interaction

It behaves like a hybrid shell:
- Executes real system binaries directly
- Falls back to the Windows shell (`cmd`) for built-in commands

---

## ✨ Features

- 🔁 Interactive REPL loop (Read–Eval–Print Loop)
- ⚡ Executes external programs (e.g., `notepad`, `ping`)
- 🧠 Built-in commands:
  - `cd` — Change directory
  - `pwd` — Print current directory
  - `exit` — Exit the shell
- 🔧 Argument parsing (space-based tokenization)
- 🔄 Smart fallback to `cmd /c` for commands like:
  - `echo`
  - `dir`
- 🪟 Windows-compatible design

---

## 🧪 Example Usage

shaheer's zig shell> pwd
C:\changeYourLife\mini-shell

shaheer's zig shell> cd ..
shaheer's zig shell> pwd
C:\changeYourLife

shaheer's zig shell> notepad

shaheer's zig shell> echo Hello, World!
Hello, World!


---

## 🛠️ Tech Stack

- **Language:** Zig (0.15.2)
- **Core Modules Used:**
  - `std.process` — process spawning
  - `std.mem` — string handling
  - `std.ArrayList` — dynamic argument storage
  - `std.fs` — IO handling

---

## 🧠 How It Works

1. Displays a prompt and waits for user input
2. Reads input using buffered stdin
3. Cleans input (`\r\n` trimming)
4. Parses command into tokens
5. Checks for built-in commands (`cd`, `pwd`, `exit`)
6. Attempts to execute command directly
7. Falls back to `cmd /c` if command is not found

---

## ⚠️ Limitations

- Basic argument parsing (no support for quotes yet)
- No piping (`|`) support (planned)
- No input/output redirection (`>`, `<`)
- No command history or autocomplete

---

## 🧩 Future Improvements

- [ ] Pipe support (`|`)
- [ ] Redirection (`>`, `<`)
- [ ] Command history (↑ key)
- [ ] Autocomplete (TAB)
- [ ] Cross-platform support (Linux/macOS)
- [ ] Better tokenizer (handle quotes and escapes)

---

## 🏗️ Getting Started

### Prerequisites
- Zig 0.15.2 installed

### Run the shell

zig run main.zig


---

## 📚 Learning Goals

This project was built to understand:

- Low-level process control
- How real shells work internally
- OS interaction from a systems language
- Practical Zig programming

---

## 👨‍💻 Author

**Shaheer Shaikh**

---

## ⭐ If you like this project

Give it a star ⭐ and feel free to contribute or suggest improvements!
