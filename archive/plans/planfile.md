# To-Do List Application - Enhancement Plan

**Date:** November 11, 2025  
**Project:** Assembly To-Do List Application Improvements  
**Status:** Planning Phase

---

## Overview

This document outlines the step-by-step plan to enhance the To-Do List application with better user experience features including:

1. ESC/Cancel functionality throughout the application
2. Task preview before operations (Update, Delete, Toggle)
3. "Press Enter to Continue" pauses after operations

---

## 📋 Feature 1: ESC to Cancel Functionality

### Goal

Allow users to press '0' (as ESC alternative) to cancel any operation and return to main menu, preventing misclicks.

### Implementation Steps

#### ✅ Phase 1.1: Review Current ESC Implementation

- [x] Add Task - Already has ESC cancel (input '0')
- [x] Update Task - Already has ESC cancel (input '0')
- [x] Delete Task - Already has ESC cancel (input '0')
- [x] Toggle Complete - Already has ESC cancel (input '0')

#### ⬜ Phase 1.2: Add ESC to Modify Slots

- [ ] Add ESC hint message to modify_slots function
- [ ] Implement cancel check after user selects slot option
- [ ] Test cancellation returns to main menu properly

#### ⬜ Phase 1.3: Verify All Cancel Points

- [ ] Test Add Task cancel functionality
- [ ] Test Update Task cancel (both prompts)
- [ ] Test Delete Task cancel (both prompts)
- [ ] Test Toggle cancel
- [ ] Test Modify Slots cancel
- [ ] Ensure consistent "Operation cancelled" message

---

## 📋 Feature 2: Task Preview Before Operations

### Goal

Display current task list before Update/Delete/Toggle operations so users can see task numbers.

### Implementation Steps

#### ⬜ Phase 2.1: Create Task Display Subroutine

- [ ] Create `display_tasks_preview` function
- [ ] Use same formatting as `view_tasks` (bordered table)
- [ ] Make it a callable subroutine (uses `ret` not `jmp`)
- [ ] Test standalone functionality

#### ⬜ Phase 2.2: Integrate Preview into Update Task

- [ ] Call `display_tasks_preview` before "Enter task number" prompt
- [ ] Add visual separator between preview and prompt
- [ ] Test that task numbers match correctly
- [ ] Verify update flow works correctly

#### ⬜ Phase 2.3: Integrate Preview into Delete Task

- [ ] Call `display_tasks_preview` before delete mode selection
- [ ] Keep preview visible during "Delete All" or "Delete Selection"
- [ ] For selection mode, show preview again before input
- [ ] Test deletion with correct task numbers

#### ⬜ Phase 2.4: Integrate Preview into Toggle Complete

- [ ] Call `display_tasks_preview` before "Enter task numbers" prompt
- [ ] Ensure checkboxes show current completion status
- [ ] Test toggle with multiple selections
- [ ] Verify toggled tasks show correct status

---

## 📋 Feature 3: "Press Enter to Continue" Pauses

### Goal

Add pauses after operations complete so users can read success messages before menu reappears.

### Implementation Steps

#### ⬜ Phase 3.1: Create "Press Enter" Function

- [ ] Create `wait_for_enter` function
- [ ] Display message: "Press Enter to continue..."
- [ ] Read single line of input (any key + Enter)
- [ ] Clear input buffer after read
- [ ] Make it reusable subroutine

#### ⬜ Phase 3.2: Add Pauses After Menu Options

**Option 1: Add Task**

- [ ] Call `wait_for_enter` after success message
- [ ] Test with single task
- [ ] Test with multiple tasks (semicolon-separated)
- [ ] Test with cancellation (should NOT pause)

**Option 2: View All Tasks**

- [ ] Call `wait_for_enter` after task list display
- [ ] Call `wait_for_enter` after "No tasks" message
- [ ] Test with empty list
- [ ] Test with full list

**Option 3: Update Task**

- [ ] Call `wait_for_enter` after "Task updated" message
- [ ] Test successful update
- [ ] Test with cancellation (should NOT pause)
- [ ] Test with invalid input

**Option 4: Delete Task**

- [ ] Call `wait_for_enter` after "Tasks deleted" message
- [ ] Call `wait_for_enter` after "All tasks deleted" message
- [ ] Test delete all
- [ ] Test delete selection
- [ ] Test with cancellation (should NOT pause)

**Option 5: Toggle Complete**

- [ ] Call `wait_for_enter` after "Tasks toggled" message
- [ ] Call `wait_for_enter` after "No valid tasks" message
- [ ] Test successful toggle
- [ ] Test with cancellation (should NOT pause)

**Option 6: Save Tasks**

- [ ] Call `wait_for_enter` after save success/error message
- [ ] Test successful save
- [ ] Test save error

**Option 7: Load Tasks**

- [ ] Call `wait_for_enter` after load success/error message
- [ ] Test successful load
- [ ] Test load error (no file)

**Option 8: Modify Task Slots**

- [ ] Call `wait_for_enter` after slot limit set message
- [ ] Test each slot option (10/15/20/30)
- [ ] Test with cancellation (should NOT pause)

---

## 📋 Feature 4: Code Organization & Documentation

### Implementation Steps

#### ⬜ Phase 4.1: Add Comments to New Functions

- [ ] Document `display_tasks_preview` function header
- [ ] Document `wait_for_enter` function header
- [ ] Add inline comments for new code sections
- [ ] Update section headers where needed

#### ⬜ Phase 4.2: Update Data Section

- [ ] Add new message strings (if any)
- [ ] Add length constants for new messages
- [ ] Organize and comment new data items

---

## 📋 Testing & Validation

### Test Cases

#### ⬜ ESC/Cancel Testing

- [ ] Test cancellation in Add Task
- [ ] Test cancellation in Update Task (first prompt)
- [ ] Test cancellation in Update Task (second prompt)
- [ ] Test cancellation in Delete Task (mode selection)
- [ ] Test cancellation in Delete Task (number input)
- [ ] Test cancellation in Toggle
- [ ] Test cancellation in Modify Slots
- [ ] Verify all return to main menu correctly

#### ⬜ Task Preview Testing

- [ ] Preview shown before Update
- [ ] Preview shown before Delete
- [ ] Preview shown before Toggle
- [ ] Task numbers match actual positions
- [ ] Empty list handled gracefully

#### ⬜ Press Enter Testing

- [ ] Pause after Add Task success
- [ ] Pause after View All
- [ ] Pause after Update success
- [ ] Pause after Delete success
- [ ] Pause after Toggle success
- [ ] Pause after Save (success/error)
- [ ] Pause after Load (success/error)
- [ ] Pause after Modify Slots
- [ ] NO pause on cancellations
- [ ] NO pause on invalid input

#### ⬜ Integration Testing

- [ ] Full workflow: Add → View → Update → Toggle → Delete
- [ ] Test with small terminal window
- [ ] Test with maximum tasks
- [ ] Test with empty list
- [ ] Test rapid menu selections
- [ ] Test multiple cancellations in a row

---

## 📋 Build & Deployment

#### ⬜ Final Steps

- [ ] Assemble with NASM (no errors)
- [ ] Link executable successfully
- [ ] Run full application test
- [ ] Update README if needed
- [ ] Update IMPROVEMENTS.md with new features
- [ ] Commit changes to repository

---

## Summary Checklist

### Major Features

- [ ] ✅ ESC to Cancel - Complete for all operations
- [ ] ✅ Task Preview - Implemented for Update/Delete/Toggle
- [ ] ✅ Press Enter to Continue - Added after all operations

### Quality Assurance

- [ ] All features tested individually
- [ ] Integration testing completed
- [ ] No build errors
- [ ] Documentation updated

---

## Notes

- **ESC Key Workaround:** Using '0' input as ESC since assembly console input doesn't easily detect ESC key
- **Consistency:** All cancel messages use same format
- **User Experience:** Previews use same styling as View All for consistency
- **Terminal Size:** Enter pauses help users with small terminal windows see responses

---

**End of Plan**
