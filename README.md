# To-Do List Application

## App Description
This is a console-based To-Do List application written in 32-bit x86 assembly language using NASM, designed for Windows environments. It allows users to add, view, update, delete, and toggle the completion status of tasks, with support for up to 30 tasks stored in memory and persisted to a file named "tasks.dat". The app features an interactive menu, multi-task input via semicolons, selective deletion and toggling, and customizable task slot limits (10, 15, 20, or 30), making it a practical educational project for low-level programming concepts like file I/O and console handling.

## App File Components and Generation
The project consists of two main files: `todo32.asm` (the source code) and `build32.bat` (the build script). The assembly source defines the program's data sections for strings, buffers, and UI elements like menus, prompts, and ASCII borders, along with the text section implementing the main loop, input/output via Windows API calls (e.g., _WriteFile, _ReadFile, _CreateFileA), and logic for task operations.

To generate the executable, place both files in the same directory and run `build32.bat` in a Developer Command Prompt for VS 2022. This script first assembles `todo32.asm` into `todo32.obj` using `nasm -f win32`, then links it with `link.exe` from Visual Studio to produce `todo32.exe`, linking against kernel32.lib for console subsystem and x86 machine targeting. If errors occur during assembly or linking, the script displays "Build failed!" and exits; success outputs "Build successful! Run todo32.exe".

## App Standalone
Once built, `todo32.exe` is a standalone 32-bit Windows console executable that runs without additional dependencies beyond the standard Windows kernel32.dll library, which is pre-installed on modern Windows systems. It handles all task data in memory and saves/loads from "tasks.dat" in the current directory, requiring no runtime installation of NASM or Visual Studio tools for execution. Users can distribute the .exe file alone for others to run on 32-bit or 64-bit Windows machines compatible with x86 emulation, though it performs best in a 32-bit environment to avoid potential compatibility issues.

## App Prerequisites for Updating
To update the app (e.g., modify source code, rebuild, or customize features like task limits), install NASM and Visual Studio 2022 as outlined in the setup guide below. No other prerequisites are needed, but ensure you're working in a 32-bit build context for compatibility. For source changes in `todo32.asm`, adjust constants like MAX_TASKS or add new menu options, then rebuild with `build32.bat` to generate an updated `todo32.exe`. If extending file persistence or UI, verify Windows API externs remain compatible with kernel32.lib.

## Setup Guide

### Install NASM (The Assembler)
NASM assembles the 32-bit assembly code into an object file. Download NASM 3.01 for Win32 from the official release builds. Extract the ZIP to a path like C:\nasm-3.01, then add this path to your Windows system PATH via Environment Variables in System Properties. Verify by opening a new Command Prompt and running `nasm -v` to display the version.

### Install Visual Studio 2022 (The Linker)
Visual Studio provides the linker (link.exe) for creating the executable from the object file. Download the free Community edition installer from the official site. During installation, select the "Desktop development with C++" workload and include only essential components: C++ core desktop features, MSVC v143 - VS 2022 C++ x64/x86 build tools, the latest Windows SDK, and Just-In-Time debugger. Complete the installation to access the Developer Command Prompt.

### Build the Application
Use the "Developer Command Prompt for VS 2022" (search in Start Menu) to ensure link.exe is in PATH—do not use standard Command Prompt. Navigate to your project directory with `cd`, then execute `build32.bat`. On success, `todo32.exe` appears in the folder; run it directly to use the app. The build process targets console subsystem and x86 architecture for 32-bit compatibility.

## Troubleshooting
Common issues arise from setup errors; refer to this table for solutions.

| Error Message | Cause and Solution |
|---------------|--------------------|
| `'nasm' is not recognized...` | NASM PATH not set correctly. Re-add C:\nasm-3.01 to system PATH and restart Command Prompt. [2] |
| `'link.exe' is not recognized...` | Wrong prompt used. Switch to "Developer Command Prompt for VS 2022".|
| `Build failed!` | Missing files or assembly errors. Confirm `todo32.asm` and `build32.bat` are in the same directory; check source for syntax issues in .asm file.|
