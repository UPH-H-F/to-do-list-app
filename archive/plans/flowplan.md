# To-Do List Application - Implementation Flowchart

**Date:** November 11, 2025  
**Project:** Visual Flow Diagrams for Enhancement Plan

---

## Main Application Flow with New Features

```mermaid
flowchart TD
    Start([Start Application]) --> Init[Initialize Handles & Variables]
    Init --> MainMenu[Display Main Menu]

    MainMenu --> GetChoice{User Choice?}

    GetChoice -->|1| AddTask[Add Task]
    GetChoice -->|2| ViewTask[View All Tasks]
    GetChoice -->|3| UpdateTask[Update Task]
    GetChoice -->|4| DeleteTask[Delete Task]
    GetChoice -->|5| ToggleTask[Toggle Complete]
    GetChoice -->|6| SaveTask[Save Tasks]
    GetChoice -->|7| LoadTask[Load Tasks]
    GetChoice -->|8| ModifySlots[Modify Task Slots]
    GetChoice -->|9| Exit([Exit Program])
    GetChoice -->|Invalid| Invalid[Show Error] --> PressEnter1[Press Enter to Continue] --> MainMenu

    AddTask --> PressEnter2[Press Enter to Continue] --> MainMenu
    ViewTask --> PressEnter3[Press Enter to Continue] --> MainMenu
    UpdateTask --> PressEnter4[Press Enter to Continue] --> MainMenu
    DeleteTask --> PressEnter5[Press Enter to Continue] --> MainMenu
    ToggleTask --> PressEnter6[Press Enter to Continue] --> MainMenu
    SaveTask --> PressEnter7[Press Enter to Continue] --> MainMenu
    LoadTask --> PressEnter8[Press Enter to Continue] --> MainMenu
    ModifySlots --> PressEnter9[Press Enter to Continue] --> MainMenu

    style Start fill:#90EE90
    style Exit fill:#FFB6C1
    style MainMenu fill:#87CEEB
    style PressEnter2 fill:#FFD700
    style PressEnter3 fill:#FFD700
    style PressEnter4 fill:#FFD700
    style PressEnter5 fill:#FFD700
    style PressEnter6 fill:#FFD700
    style PressEnter7 fill:#FFD700
    style PressEnter8 fill:#FFD700
    style PressEnter9 fill:#FFD700
```

---

## Feature 1: Add Task Flow with ESC Cancel

```mermaid
flowchart TD
    A1[Add Task Selected] --> A2[Show Hint: Use semicolon to separate]
    A2 --> A3[Show: Press 0 to cancel]
    A3 --> A4[Prompt: Enter task]
    A4 --> A5[Read Input]

    A5 --> A6{Input = '0'?}
    A6 -->|Yes| A7[Show: Operation cancelled]
    A7 --> A8[Return to Main Menu]

    A6 -->|No| A9[Parse Input]
    A9 --> A10[Skip Leading Whitespace]
    A10 --> A11[Copy Characters]
    A11 --> A12[Trim Trailing Whitespace]
    A12 --> A13{Empty Task?}

    A13 -->|Yes| A14[Skip Task]
    A13 -->|No| A15[Save Task]

    A14 --> A16{More Tasks?}
    A15 --> A16

    A16 -->|Yes| A10
    A16 -->|No| A17[Show: Tasks added successfully]
    A17 --> A18[Press Enter to Continue]
    A18 --> A8

    style A6 fill:#FFB6C1
    style A7 fill:#FFA500
    style A18 fill:#FFD700
```

---

## Feature 2: Update Task Flow with Preview

```mermaid
flowchart TD
    U1[Update Task Selected] --> U2{Task Count > 0?}
    U2 -->|No| U3[Show: No tasks in list]
    U3 --> U4[Press Enter to Continue]
    U4 --> U5[Return to Main Menu]

    U2 -->|Yes| U6[**NEW: Display Tasks Preview**]
    U6 --> U7[Show bordered table with all tasks]
    U7 --> U8[Show: Press 0 to cancel]
    U8 --> U9[Prompt: Enter task number]
    U9 --> U10[Read Input]

    U10 --> U11{Input = '0'?}
    U11 -->|Yes| U12[Show: Operation cancelled]
    U12 --> U5

    U11 -->|No| U13{Valid Number?}
    U13 -->|No| U14[Ignore Input]
    U14 --> U5

    U13 -->|Yes| U15[Prompt: Enter new task text]
    U15 --> U16[Read Input]

    U16 --> U17{Input = '0'?}
    U17 -->|Yes| U12

    U17 -->|No| U18[Update Task Content]
    U18 --> U19[Preserve Completion Status]
    U19 --> U20[Show: Task updated successfully]
    U20 --> U21[Press Enter to Continue]
    U21 --> U5

    style U6 fill:#98FB98
    style U7 fill:#98FB98
    style U11 fill:#FFB6C1
    style U17 fill:#FFB6C1
    style U21 fill:#FFD700
```

---

## Feature 3: Delete Task Flow with Preview

```mermaid
flowchart TD
    D1[Delete Task Selected] --> D2{Task Count > 0?}
    D2 -->|No| D3[Show: No tasks in list]
    D3 --> D4[Press Enter to Continue]
    D4 --> D5[Return to Main Menu]

    D2 -->|Yes| D6[**NEW: Display Tasks Preview**]
    D6 --> D7[Show bordered table with all tasks]
    D7 --> D8[Show: Press 0 to cancel]
    D8 --> D9[Prompt: Choose delete mode]
    D9 --> D10[Show: 1=Delete All, 2=Delete Selection]
    D10 --> D11[Read Input]

    D11 --> D12{Input = '0'?}
    D12 -->|Yes| D13[Show: Operation cancelled]
    D13 --> D5

    D12 -->|No| D14{Input = '1'?}
    D14 -->|Yes| D15[Clear All Tasks]
    D15 --> D16[Show: All tasks deleted]
    D16 --> D17[Press Enter to Continue]
    D17 --> D5

    D14 -->|No| D18{Input = '2'?}
    D18 -->|No| D19[Show: Invalid option]
    D19 --> D20[Press Enter to Continue]
    D20 --> D5

    D18 -->|Yes| D21[Show: Press 0 to cancel]
    D21 --> D22[Prompt: Enter task numbers]
    D22 --> D23[Read Input]

    D23 --> D24{Input = '0'?}
    D24 -->|Yes| D13

    D24 -->|No| D25[Parse Numbers]
    D25 --> D26[Mark Tasks for Deletion]
    D26 --> D27[Shift Remaining Tasks]
    D27 --> D28[Update Task Count]
    D28 --> D29[Show: Tasks deleted]
    D29 --> D30[Press Enter to Continue]
    D30 --> D5

    style D6 fill:#98FB98
    style D7 fill:#98FB98
    style D12 fill:#FFB6C1
    style D24 fill:#FFB6C1
    style D17 fill:#FFD700
    style D20 fill:#FFD700
    style D30 fill:#FFD700
```

---

## Feature 4: Toggle Complete Flow with Preview

```mermaid
flowchart TD
    T1[Toggle Complete Selected] --> T2{Task Count > 0?}
    T2 -->|No| T3[Show: No tasks in list]
    T3 --> T4[Press Enter to Continue]
    T4 --> T5[Return to Main Menu]

    T2 -->|Yes| T6[**NEW: Display Tasks Preview**]
    T6 --> T7[Show bordered table with checkboxes]
    T7 --> T8[Show: Enter task numbers separated by space]
    T8 --> T9[Show: Press 0 to cancel]
    T9 --> T10[Prompt: Enter task numbers]
    T10 --> T11[Read Input]

    T11 --> T12{Input = '0'?}
    T12 -->|Yes| T13[Show: Operation cancelled]
    T13 --> T5

    T12 -->|No| T14[Parse Numbers]
    T14 --> T15[Clear Toggle Flags]
    T15 --> T16[Mark Valid Tasks]
    T16 --> T17[Count Valid Tasks]

    T17 --> T18{Valid Count > 0?}
    T18 -->|No| T19[Show: No valid tasks toggled]
    T19 --> T20[Press Enter to Continue]
    T20 --> T5

    T18 -->|Yes| T21[Toggle Each Marked Task]
    T21 --> T22[Show: Tasks toggled successfully]
    T22 --> T23[Press Enter to Continue]
    T23 --> T5

    style T6 fill:#98FB98
    style T7 fill:#98FB98
    style T12 fill:#FFB6C1
    style T20 fill:#FFD700
    style T23 fill:#FFD700
```

---

## Feature 5: Modify Slots Flow with ESC Cancel

```mermaid
flowchart TD
    M1[Modify Slots Selected] --> M2[Show Menu: Select task slot limit]
    M2 --> M3[Show: 1=10, 2=15, 3=20, 4=30]
    M3 --> M4[**NEW: Show: Press 0 to cancel**]
    M4 --> M5[Prompt: Enter choice]
    M5 --> M6[Read Input]

    M6 --> M7{Input = '0'?}
    M7 -->|Yes| M8[Show: Operation cancelled]
    M8 --> M9[Return to Main Menu]

    M7 -->|No| M10{Input = '1'?}
    M10 -->|Yes| M11[Set Limit = 10]
    M11 --> M12[Show: Task limit set to 10 slots]
    M12 --> M13[Press Enter to Continue]
    M13 --> M9

    M10 -->|No| M14{Input = '2'?}
    M14 -->|Yes| M15[Set Limit = 15]
    M15 --> M16[Show: Task limit set to 15 slots]
    M16 --> M17[Press Enter to Continue]
    M17 --> M9

    M14 -->|No| M18{Input = '3'?}
    M18 -->|Yes| M19[Set Limit = 20]
    M19 --> M20[Show: Task limit set to 20 slots]
    M20 --> M21[Press Enter to Continue]
    M21 --> M9

    M18 -->|No| M22{Input = '4'?}
    M22 -->|Yes| M23[Set Limit = 30]
    M23 --> M24[Show: Task limit set to 30 slots]
    M24 --> M25[Press Enter to Continue]
    M25 --> M9

    M22 -->|No| M26[Show: Invalid option]
    M26 --> M27[Press Enter to Continue]
    M27 --> M9

    style M4 fill:#98FB98
    style M7 fill:#FFB6C1
    style M13 fill:#FFD700
    style M17 fill:#FFD700
    style M21 fill:#FFD700
    style M25 fill:#FFD700
    style M27 fill:#FFD700
```

---

## Supporting Function: Display Tasks Preview

```mermaid
flowchart TD
    P1[display_tasks_preview Called] --> P2[Print Newline]
    P2 --> P3[Print Top Border]
    P3 --> P4[Initialize Task Counter = 0]

    P4 --> P5{Counter < Task Count?}
    P5 -->|No| P6[Print Bottom Border]
    P6 --> P7[Return to Caller]

    P5 -->|Yes| P8[Print Left Border]
    P8 --> P9[Print Task Number]
    P9 --> P10[Print Dot and Space]
    P10 --> P11{Task Complete?}

    P11 -->|Yes| P12[Print ✓ Checkbox]
    P11 -->|No| P13[Print ☐ Checkbox]

    P12 --> P14[Print Task Text]
    P13 --> P14
    P14 --> P15[Print Newline]
    P15 --> P16[Increment Counter]
    P16 --> P5

    style P1 fill:#98FB98
    style P7 fill:#90EE90
```

---

## Supporting Function: Wait for Enter

```mermaid
flowchart TD
    W1[wait_for_enter Called] --> W2[Print: 'Press Enter to continue...']
    W2 --> W3[Clear Input Buffer]
    W3 --> W4[Read Line from Console]
    W4 --> W5[User Presses Enter]
    W5 --> W6[Return to Caller]

    style W1 fill:#FFD700
    style W6 fill:#90EE90
```

---

## Implementation Sequence

```mermaid
gantt
    title Enhancement Implementation Timeline
    dateFormat YYYY-MM-DD
    section Phase 1: ESC Cancel
    Review Current ESC          :done, p1a, 2025-11-11, 1d
    Add ESC to Modify Slots     :active, p1b, 2025-11-11, 1d
    Test All Cancel Points      :p1c, after p1b, 1d

    section Phase 2: Task Preview
    Create Preview Function     :p2a, after p1c, 1d
    Add to Update Task          :p2b, after p2a, 1d
    Add to Delete Task          :p2c, after p2b, 1d
    Add to Toggle Complete      :p2d, after p2c, 1d

    section Phase 3: Press Enter
    Create wait_for_enter       :p3a, after p2d, 1d
    Add to All Operations       :p3b, after p3a, 2d
    Test All Pauses            :p3c, after p3b, 1d

    section Phase 4: Testing
    Individual Feature Tests    :p4a, after p3c, 1d
    Integration Testing         :p4b, after p4a, 1d
    Final Build & Deploy        :p4c, after p4b, 1d
```

---

## Legend

### Color Coding

- 🟢 **Green** - New Feature/Addition
- 🔴 **Pink/Red** - Decision Point / Cancel Check
- 🟡 **Yellow** - Press Enter Pause
- 🔵 **Blue** - Standard Process Flow

### Symbols

- **Bold Text** - NEW feature being added
- Diamond `{...?}` - Decision/Conditional
- Rectangle `[...]` - Process/Action
- Rounded `([...])` - Start/End point

---

**End of Flowchart Documentation**
