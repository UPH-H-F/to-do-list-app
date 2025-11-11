# Download GoLink - Step by Step Guide

## Option 1: Download GoLink Manually (Recommended)

1. **Open your web browser**

2. **Go to one of these sites:**

   - https://www.godevtool.com/ (Official site)
   - Search Google for "GoLink assembler download"

3. **Download GoLink.zip**

   - Look for the download link on the homepage
   - It's a very small file (~100KB)

4. **Extract the ZIP file**

   - Right-click GoLink.zip
   - Select "Extract All..."
   - Extract to: `C:\Users\Beo\Downloads\to-do-list-app\`

5. **You should now have:** `golink.exe` in your project folder

6. **Link your program:**
   ```
   .\golink.exe /console /entry _main todo32.obj kernel32.dll
   ```

---

## Option 2: Use Online Assembler/Linker

If downloading is difficult, you can use an online service temporarily.

---

## Option 3: Install MinGW (Has linker included)

1. Download MinGW from: https://sourceforge.net/projects/mingw/
2. Install it
3. Use `ld` linker (though it's more complex)

---

## Option 4: I Can Create a Pre-Built EXE for You

Since you have the `.obj` file, I can:

1. Guide you to upload the `.obj` file somewhere
2. Link it myself
3. Send you back the `.exe`

**But this is not ideal for learning/development!**

---

## What I Recommend:

**Just download GoLink manually** - it's the easiest!

1. Go to: **https://www.godevtool.com/**
2. Click download
3. Extract to your project folder
4. Run: `.\golink.exe /console /entry _main todo32.obj kernel32.dll`

---

## After You Get GoLink:

Run this command in your project folder:

```powershell
.\golink.exe /console /entry _main todo32.obj kernel32.dll
```

You should see:

```
GoLink.Exe Version 0.XX.XX - Copyright Jeremy Gordon 2002-20XX - JG@JGnet.co.uk
Output file: todo32.exe
Format: Win32
Entry point: 0x00401000 (_main)
```

Then your `todo32.exe` will have my changes! ✅

---

**Let me know when you've downloaded GoLink and I'll help you run it!**
