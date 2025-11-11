# How to Rebuild todo32.exe

## Quick Method (If you know how you built it before)

Just run whatever method you used before! The assembly step is already done.

---

## Method 1: Using GoLink (Recommended for NASM)

If you have GoLink installed:

```batch
golink /console /entry _main todo32.obj kernel32.dll
```

---

## Method 2: Using Microsoft Link (Visual Studio)

If you have Visual Studio or Windows SDK:

```batch
link todo32.obj /subsystem:console /entry:main /machine:x86 kernel32.lib
```

---

## Method 3: Using the Build Script

```batch
build32.bat
```

Note: The script uses Microsoft's `link`, so you need Visual Studio installed.

---

## Method 4: Manual Steps

### Step 1: Assemble (Already Done!)

```batch
nasm -f win32 todo32.asm -o todo32.obj
```

✅ This is done! You have `todo32.obj`

### Step 2: Link

Try one of these:

**Option A - GoLink:**

```batch
golink /console /entry _main todo32.obj kernel32.dll
```

**Option B - Microsoft Link:**

```batch
link todo32.obj /subsystem:console /entry:main /machine:x86 kernel32.lib
```

**Option C - jwlink (if installed):**

```batch
jwlink format windows pe file todo32.obj name todo32.exe
```

---

## Troubleshooting

### "link is not recognized"

You need to install:

- Visual Studio (free Community edition)
- OR Windows SDK
- OR GoLink (lightweight, just for linking)

### "GoLink not found"

Download from: http://www.godevtool.com/

### How did you build it before?

Check your command history or look for build scripts in your project.

---

## Current Status

✅ **Assembly:** Done (todo32.obj exists and is up to date)  
⏳ **Linking:** Need to run linker command

---

## What to Do

**Tell me:**

1. Do you have Visual Studio installed?
2. OR do you have GoLink?
3. OR how did you build todo32.exe before?

Then I can help you with the exact command!
