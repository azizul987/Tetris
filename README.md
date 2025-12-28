# Tetris Clone (Godot)

![Godot Engine](https://img.shields.io/badge/Godot_Engine-4.5-478cbf?style=for-the-badge&logo=godotengine&logoColor=white)
![Language](https://img.shields.io/badge/Language-GDScript-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In_Development-orange?style=for-the-badge)

A modern Tetris clone built with the **Godot Engine 4.5**. This project focuses on replicating the smooth feel of modern block-stacking games, implementing advanced mechanics like the **Super Rotation System (SRS)** and Next Piece preview.

> **Note:** This is a learning & portfolio project. It is not an official Tetris® product.

![Game Screenshot](Img/Screenshot_2025-12-28_08-38-18.png)

---

## ✨ Features

### Core Gameplay
- ✅ **Grid-based Movement:** Precise collision detection and movement logic.
- ✅ **Line Clears:** Detects and removes full rows with visual feedback (Slow-mo & Flash effect).
- ✅ **Scoring System:** Points for clearing lines.
- ✅ **Leveling:** Speed increases as you clear more lines.

### Modern Mechanics
- ✅ **Next Queue:** Preview the next upcoming pieces (7-bag system logic).
- ✅ **SRS (Super Rotation System):** Authentic rotation rules including **Wall Kicks**.

---

## 🎮 Controls

Currently, the game uses a simple control scheme:

| Action | Key |
| :--- | :--- |
| **Move Left** | `Arrow Left` |
| **Move Right** | `Arrow Right` |
| **Rotate Piece** | `Arrow Up` |
| **Fast Drop (Speed Up)** | `Arrow Down` |

---

## 🧠 Technical Deep Dive: SRS Rotation

This project implements the **Super Rotation System (SRS)**, the standard guideline for modern Tetris games.

**Why is this important?**
In a basic grid system, rotating a piece next to a wall often fails because the rotated shape would overlap the wall. SRS solves this by attempting **"Wall Kicks"**:
1. The game tries to rotate the piece naturally.
2. If blocked, it checks a series of pre-defined offset positions (up, left, right, down).
3. If a valid space is found, the piece "kicks" into that spot.

---

## 🛠️ Installation & Setup

### Prerequisites
- [Godot Engine 4.5](https://godotengine.org/) (or compatible 4.x version)

### Running from Source
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/Sestro-Dev/Tetris-Godot.git](https://github.com/Sestro-Dev/Tetris-Godot.git)
   ```

2. **Open in Godot:**
* Launch Godot Engine.
* Click **Import** and navigate to the cloned folder.
* Select the `project.godot` file.


3. **Run:**
* Press **F5** or click the Play button in the top right corner.



### Exporting (Build)

1. Go to **Project → Export**.
2. Click **Add...** and select your platform (Windows, Linux, Web, macOS).
3. Click **Export Project**.

---

## 🗺️ Roadmap

* [x] Core Gameplay Loop
* [x] SRS Rotation & Wall Kicks
* [x] UI (Score, Next Piece)
* [x] Visual Effects (Line Clear Flash & Slow Motion)
* [ ] **Advanced Controls:** Hard Drop (Space), Hold Piece (C).
> Note: Hard Drop and Hold Piece are planned features and not yet implemented.
* [x] **Audio:** Sound effects (SFX) and Background Music (BGM).
* [ ] **Save System:** Local high score leaderboard.

---

## 📂 Project Structure

```text
res://
├── assets/          # Sprites, Fonts, Audio
├── scenes/          # .tscn files (Board, Pieces, UI)
├── scripts/         # .gd files (Game logic, SRS data)
├── resources/       # Custom resources (TileSets)
└── project.godot    # Main configuration file

```

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](https://mit-license.org/) file for details.

---

## 🤝 Credits

* **Developer:** [Sestro_Dev](https://www.google.com/search?q=https://github.com/Sestro-Dev)
* **Engine:** [Godot Engine](https://godotengine.org/)
* **Assets:** -

---

*If you enjoyed this project, don't forget to give it a ⭐ star!*
