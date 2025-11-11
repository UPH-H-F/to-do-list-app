@echo off
echo ========================================
echo Building To-Do List (32-bit)
echo ========================================
echo.

REM Step 1: Assemble
echo [1/2] Assembling todo32.asm...
nasm -f win32 todo32.asm -o todo32.obj
if errorlevel 1 goto error

echo [1/2] Assembly successful!
echo.

REM Step 2: Link with GoLink
echo [2/2] Linking with GoLink...
if exist golink.exe (
    golink.exe /console /entry _main todo32.obj kernel32.dll
    if errorlevel 1 goto error
    echo [2/2] Linking successful!
    goto success
)

REM If GoLink not found, try Microsoft link
echo GoLink not found, trying Microsoft link...
link todo32.obj /subsystem:console /entry:main /machine:x86 kernel32.lib >nul 2>&1
if errorlevel 1 goto nolinker

:success
echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo Run: todo32.exe
echo.
goto end

:nolinker
echo.
echo ========================================
echo ERROR: No linker found!
echo ========================================
echo.
echo Please download GoLink:
echo 1. Go to: https://www.godevtool.com/
echo 2. Download GoLink.zip
echo 3. Extract golink.exe to this folder
echo 4. Run build-golink.bat again
echo.
echo OR see DOWNLOAD_GOLINK.md for help
goto end

:error
echo.
echo ========================================
echo BUILD FAILED!
echo ========================================
goto end

:end
