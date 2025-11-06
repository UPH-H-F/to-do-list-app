@echo off
echo Assembling 32-bit todo32.asm...
nasm -f win32 todo32.asm -o todo32.obj
if errorlevel 1 goto error

echo Linking 32-bit executable...
link todo32.obj /subsystem:console /entry:main /machine:x86 /out:todo32.exe kernel32.lib
if errorlevel 1 goto error

echo Build successful! Run todo32.exe
goto end

:error
echo Build failed!

:end
