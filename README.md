# To-Do List Application (x86 Assembly)# To-Do List Application

[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)](https://www.microsoft.com/windows)## App Description

[![Assembly](https://img.shields.io/badge/language-x86%20Assembly-orange.svg)](https://www.nasm.us/)This is a console-based To-Do List application written in 32-bit x86 assembly language using NASM, designed for Windows environments. Currently in its early development stage, the app features an interactive menu, multi-task input via semicolons, selective deletion and toggling, and customizable task slot limits (10, 15, 20, or 30)—with room for expanding features—making it a practical educational project for low-level programming concepts like file I/O and console handling.

[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## App File Components and Generation

A feature-rich, console-based task management application written in 32-bit x86 assembly language using NASM for Windows. This project demonstrates low-level programming concepts including Windows API integration, file I/O, memory management, and user-friendly console interfaces—all without using high-level languages.The project consists of two main files: `todo32.asm` (the source code) and `build32.bat` (the build script). The assembly source defines the program's data sections for strings, buffers, and UI elements like menus, prompts, and ASCII borders, along with the text section implementing the main loop, input/output via Windows API calls (e.g., \_WriteFile, \_ReadFile, \_CreateFileA), and logic for task operations.

---To generate the executable, place both files in the same directory and run `build32.bat` in a Developer Command Prompt for VS 2022. This script first assembles `todo32.asm` into `todo32.obj` using `nasm -f win32`, then links it with `link.exe` from Visual Studio to produce `todo32.exe`, linking against kernel32.lib for console subsystem and x86 machine targeting. If errors occur during assembly or linking, the script displays "Build failed!" and exits; success outputs "Build successful! Run todo32.exe".

## 📋 Features## App Standalone

Once built, `todo32.exe` is a standalone 32-bit Windows console executable that runs without additional dependencies beyond the standard Windows kernel32.dll library, which is pre-installed on modern Windows systems. It handles all task data in memory and saves/loads from "tasks.dat" in the current directory, requiring no runtime installation of NASM or Visual Studio tools for execution. Users can distribute the .exe file alone for others to run on 32-bit or 64-bit Windows machines compatible with x86 emulation, though it performs best in a 32-bit environment to avoid potential compatibility issues.

### Core Task Management

- ✅ **Add Tasks** - Single or multiple tasks at once (separated by `;`)## App Prerequisites for Updating

- ✅ **View All Tasks** - Display tasks in a clean, bordered table formatTo update the app (e.g., modify source code, rebuild, or customize features like task limits), install NASM and Visual Studio 2022 as outlined in the setup guide below. No other prerequisites are needed, but ensure you're working in a 32-bit build context for compatibility. For source changes in `todo32.asm`, adjust constants like MAX_TASKS or add new menu options, then rebuild with `build32.bat` to generate an updated `todo32.exe`. If extending file persistence or UI, verify Windows API externs remain compatible with kernel32.lib.

- ✅ **Update Task** - Modify task descriptions

- ✅ **Delete Task** - Remove all tasks or select specific ones## Setup Guide

- ✅ **Toggle Complete** - Mark tasks as done/undone with checkbox indicators `[ ]` / `[+]`

- ✅ **Save/Load** - Persist tasks to disk in binary format### Install NASM (The Assembler)

- ✅ **Modify Slots** - Adjust task limit (10, 15, 20, or 30 tasks)NASM assembles the 32-bit assembly code into an object file. Download NASM 3.01 for Win32 from the [official release builds](https://www.nasm.us/pub/nasm/releasebuilds/3.01/win32/nasm-3.01-win32.zip). Extract the ZIP to a path like C:\nasm-3.01, then add this path to your Windows system PATH via [Environment Variables in System Properties](https://www.youtube.com/shorts/X1vFywT0--g). Verify by opening a new Command Prompt and running `nasm -v` to display the version.

### User Experience Enhancements### Install Visual Studio 2022 (The Linker)

- 🎯 **ESC to Cancel** - Press `0` to cancel any operationVisual Studio provides the linker (link.exe) for creating the executable from the object file. Download the free Community edition installer from the [official site](https://visualstudio.microsoft.com/downloads/). During installation, select the "Desktop development with C++" workload and include only essential components: C++ core desktop features, MSVC v143 - VS 2022 C++ x64/x86 build tools, the latest Windows SDK, and Just-In-Time debugger. Complete the installation to access the Developer Command Prompt.

- 👀 **Task Preview** - See all tasks before Update/Delete/Toggle operations

- ⏸️ **Press Enter to Continue** - Read output before returning to menu### Build the Application

- 🧹 **Input Validation** - Automatic whitespace trimming, empty task rejectionUse the "Developer Command Prompt for VS 2022" (search in Start Menu) to ensure link.exe is in PATH—do not use standard Command Prompt. Navigate to your project directory with `cd`, for example:

- 📊 **Task Counters** - Shows completed vs. remaining tasks in real-time```

- 🎨 **Bordered UI** - Clean ASCII art borders and formatted displaysC:\Users\Admin\App> cd C:\Path\To\Your\Project

- 💡 **Helpful Hints** - Contextual tips for complex operations```

Then execute `build32.bat` by typing its name and pressing Enter:

---```

C:\Path\To\Your\Project> build32.bat

## 🚀 Quick Start```

On success, `todo32.exe` appears in the folder; run it directly to use the app.

### For End Users (Just Run It)

1. Download `todo32.exe`## Troubleshooting

2. Double-click or run from command prompt:Common issues arise from setup errors; refer to this table for solutions.

   ````powershell

   .\todo32.exe| Error Message | Cause and Solution |

   ```|---------------|--------------------|

   ````

3. Start managing your tasks!| `'nasm' is not recognized...` | NASM PATH not set correctly. Re-add C:\nasm-3.01 to system PATH and restart Command Prompt.|

| `'link.exe' is not recognized...` | Wrong prompt used. Switch to "Developer Command Prompt for VS 2022".|

**Note:** Requires Windows (32-bit or 64-bit). No installation needed.| `Build failed!` | Missing files or assembly errors. Confirm `todo32.asm` and `build32.bat` are in the same directory; check source for syntax issues in .asm file.|

---

## 🛠️ For Developers (Build from Source)

### Prerequisites

- **NASM** (Netwide Assembler) - Version 2.x or higher
- **GoLink** (Linker) - v1.0.4.6 or higher (included in repo)
- **Windows** - Any modern version with kernel32.dll

### Option 1: Easy Build (Recommended)

Use the included GoLink linker (no Visual Studio needed):

```powershell
# Run the build script
.\build-golink.bat
```

### Option 2: Manual Build

```powershell
# Assemble
nasm -f win32 todo32.asm -o todo32.obj

# Link (using GoLink)
.\Golink\GoLink.exe /console /entry main todo32.obj kernel32.dll
```

### Option 3: Visual Studio Linker

If you have Visual Studio 2022 installed:

```powershell
.\build32.bat
```

---

## 📦 What's Included

### Essential Files (Required)

- `todo32.asm` - Main application source code (2,182 lines)
- `todo32.exe` - Compiled executable (ready to run)
- `build-golink.bat` - Build script using GoLink
- `Golink/GoLink.exe` - Lightweight linker (no VS required)
- `README.md` - This file

### Optional Files

- `build32.bat` - Alternative build script (requires Visual Studio)
- `tasks.dat` - Task data file (auto-created on first save)

---

## 💻 Usage Guide

### Basic Operations

```
===== TO-DO LIST APPLICATION =====
Status: 0 completed, 0 remaining
Total: 0/10 tasks

  1. Add Task
  2. View All Tasks
  3. Update Task
  4. Delete Task
  5. Toggle Complete
  6. Save Tasks
  7. Load Tasks
  8. Modify Task Slots
  9. Exit

  Choose option: _
```

### Quick Tips

- **Add multiple tasks:** Type `task1;task2;task3` to add three tasks at once
- **Cancel any operation:** Press `0` then Enter
- **Delete specific tasks:** Enter task numbers separated by spaces: `1 3 5`
- **Toggle multiple tasks:** Enter task numbers separated by spaces: `2 4 6`
- **Save your work:** Always save (option 6) before exiting!

---

## 🏗️ Architecture & Implementation

### Technical Highlights

- **Language:** Pure x86 assembly (NASM syntax)
- **Architecture:** 32-bit Windows PE executable
- **API:** Windows kernel32.dll (stdcall convention)
- **File Format:** Binary task storage in `tasks.dat`
- **Code Size:** 2,182 lines of assembly
- **Executable Size:** ~9 KB

### Key Functions

- `main` - Application entry point and menu loop
- `add_task` - Multi-task input with semicolon parsing
- `view_tasks` - Bordered table display with status icons
- `update_task` - Task modification with preview
- `delete_task` - Single/multi/all deletion modes
- `toggle_complete` - Status toggling with checkbox updates
- `save_tasks` / `load_tasks` - Binary file persistence
- `modify_slots` - Dynamic task limit adjustment
- `display_tasks_preview` - Preview table for operations
- `wait_for_enter` - User-friendly pause mechanism
- `cancel_operation` - ESC/cancel handling

### Memory Layout

```
section .data    - Constant strings, messages, UI elements
section .bss     - Runtime buffers, counters, task storage
section .text    - Program code and logic
```

---

## 📚 Development Phases

This project was developed in phases with comprehensive testing:

### ✅ Phase 1: ESC Cancel Functionality

- Added ability to cancel operations with `0` key
- Implemented across all input prompts
- Prevents accidental operations

### ✅ Phase 2: Task Preview

- Shows task list before Update/Delete/Toggle
- Reduces "guessing" task numbers
- Improves user decision-making

### ✅ Phase 3: Press Enter to Continue

- Pauses after successful operations
- Prevents menu from appearing too quickly
- Gives time to read output messages

### ✅ Phase 4: Documentation & Organization

- Comprehensive README
- File organization and cleanup
- Complete project documentation

---

## 🎯 Use Cases

### Educational

- Learn x86 assembly programming
- Understand Windows API calls
- Practice low-level file I/O
- Study memory management
- Explore console application development

### Practical

- Lightweight task management
- No bloat, no dependencies
- Instant startup (< 10 KB executable)
- Works on any Windows machine
- Complete offline functionality

---

## 🔧 Customization

### Modify Task Limit

Change `MAX_TASKS` constant in `todo32.asm`:

```nasm
MAX_TASKS equ 50    ; Default is 30
```

### Change Task Size

Adjust `TASK_SIZE` constant:

```nasm
TASK_SIZE equ 100   ; Default is 64 (63 chars + status byte)
```

### Rebuild After Changes

```powershell
nasm -f win32 todo32.asm -o todo32.obj
.\Golink\GoLink.exe /console /entry main todo32.obj kernel32.dll
```

---

## 🐛 Troubleshooting

| Issue                      | Solution                                               |
| -------------------------- | ------------------------------------------------------ |
| `'nasm' is not recognized` | Add NASM to system PATH or use full path to nasm.exe   |
| `GoLink.exe not found`     | Ensure `Golink/GoLink.exe` exists in project folder    |
| `tasks.dat` won't load     | File may be corrupted; delete and recreate by saving   |
| Garbled text display       | Ensure console uses Code Page 437 or compatible        |
| Program crashes            | Check that you're running on Windows with kernel32.dll |

---

## 📊 Project Stats

- **Total Code:** 2,182 lines of assembly
- **Development Time:** Multiple phases over several iterations
- **Test Coverage:** 25+ test cases across 3 test suites
- **Functions:** 15+ major functions
- **API Calls:** 8 Windows API functions utilized
- **File Size:** ~9 KB (executable)

---

## 🤝 Contributing

This is an educational project, but contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Ideas for Contributions

- Add color support (ANSI codes)
- Implement task priorities
- Add due dates
- Create task categories
- Export to text/CSV
- Add search functionality

---

## 📄 License

This project is open source and available under the MIT License.

---

## � Authors

**Group 3:**

- CARTONEROS, BEOMARC ANDREW D.
- CARVAJAL, CHRISTIAN EZEKIEL L.
- CASTILLO, CHARLES
- GO, MARCO ENRICO S.
- HANGINON, MARIA FATIMA T.
- SILVESTRE, DASHIELL B.

---

## �🙏 Acknowledgments

- **NASM** - The Netwide Assembler team
- **GoLink** - Jeremy Gordon for the lightweight linker
- **Windows API** - Microsoft for comprehensive documentation
- **Assembly Community** - For tutorials and support resources

---

## 📞 Support

Having issues? Check the troubleshooting section above or review the build instructions.

For bug reports or feature requests, please open an issue on the repository.

---

**Made with ❤️ and Assembly** - Because sometimes you need to get close to the metal! 🔧

---

## Version History

- **v2.0** (2025) - Enhanced version with ESC cancel, task preview, and press-enter pauses
- **v1.0** (2025) - Initial release with core task management features
