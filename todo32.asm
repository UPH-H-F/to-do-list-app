; To-Do List Application for Windows x86 (32-bit)
; 
; GROUP 3 MEMBERS:
; "HANGINON, MARIA FATIMA T."
; "CASTILLO, CHARLES"
; "CARTONEROS, BEOMARC ANDREW D."
; "CARVAJAL, CHRISTIAN EZEKIEL L."
; "GO, MARCO ENRICO S."
; "SILVESTRE, DASHIELL B."
;
; Features:
; - Add, view, update, delete tasks
; - Toggle task completion status
; - Save/load tasks to file
; - Search and sort tasks
; - Modify task slot limits
;
; Assemble: nasm -f win32 todo32.asm -o todo32.obj
; Link: link todo32.obj /subsystem:console /entry:main /machine:x86 kernel32.lib

global main
extern _GetStdHandle@4
extern _WriteFile@20
extern _ReadFile@20
extern _ExitProcess@4
extern _CreateFileA@28
extern _CloseHandle@4
extern _Sleep@4

; =============================================================================
; CONSTANTS SECTION
; =============================================================================
section .data
    ; Windows API Constants
    STD_OUTPUT_HANDLE        equ -11
    STD_INPUT_HANDLE         equ -10
    
    ; File Operation Constants
    GENERIC_READ             equ 0x80000000
    GENERIC_WRITE            equ 0x40000000
    CREATE_ALWAYS            equ 2
    OPEN_EXISTING            equ 3
    FILE_ATTRIBUTE_NORMAL    equ 0x80
    INVALID_HANDLE_VALUE     equ -1
    
    ; Application Constants
    MAX_TASKS                equ 30
    TASK_SIZE                equ 64           ; 63 chars + 1 status byte
    STATUS_OFFSET            equ 63           ; Position of status byte in task buffer
    
    ; File name for persistent storage
    filename                 db "tasks.dat", 0

    ; ========================================================================
    ; UI ELEMENTS - VISUAL COMPONENTS
    ; ========================================================================
    
    ; Separators and Borders (Box-drawing characters for nice UI)
    separator_thin      db 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 13, 10
    separator_thin_len  equ $ - separator_thin

    separator_top       db 201, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 187, 13, 10
    separator_top_len   equ $ - separator_top

    separator_bottom    db 200, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 188, 13, 10
    separator_bottom_len equ $ - separator_bottom

    border_left         db 186, " "
    border_left_len     equ $ - border_left

    ; Basic formatting
    newline_only        db 13, 10
    newline_only_len    equ $ - newline_only

    ; ========================================================================
    ; ANIMATION ELEMENTS
    ; ========================================================================
    spinner_1           db "  |", 13, 10
    spinner_1_len       equ $ - spinner_1

    spinner_2           db "  /", 13, 10
    spinner_2_len       equ $ - spinner_2

    spinner_3           db "  -", 13, 10
    spinner_3_len       equ $ - spinner_3

    spinner_4           db "  \", 13, 10
    spinner_4_len       equ $ - spinner_4

    saving_msg          db "  Saving", 13, 10
    saving_msg_len      equ $ - saving_msg

    loading_msg         db "  Loading", 13, 10
    loading_msg_len     equ $ - loading_msg

    ; ========================================================================
    ; HEADERS FOR DIFFERENT SCREENS
    ; ========================================================================
    header_welcome      db 13, 10, "Welcome to Your To-Do List!", 13, 10
    header_welcome_len  equ $ - header_welcome

    header_add          db 13, 10, "Adding New Task", 13, 10
    header_add_len      equ $ - header_add

    header_view         db 13, 10, "Your Task List", 13, 10
    header_view_len     equ $ - header_view

    header_update       db 13, 10, "Updating Task", 13, 10
    header_update_len   equ $ - header_update

    header_delete       db 13, 10, "Deleting Tasks", 13, 10
    header_delete_len   equ $ - header_delete

    header_toggle       db 13, 10, "Managing Task Status", 13, 10
    header_toggle_len   equ $ - header_toggle

    header_save         db 13, 10, "Saving Your Tasks", 13, 10
    header_save_len     equ $ - header_save

    header_load         db 13, 10, "Loading Your Tasks", 13, 10
    header_load_len     equ $ - header_load

    header_search       db 13, 10, "Search Tasks", 13, 10
    header_search_len   equ $ - header_search

    header_sort         db 13, 10, "Sort Tasks", 13, 10
    header_sort_len     equ $ - header_sort

    header_modify_slots db 13, 10, "Modifying Task Slots", 13, 10
    header_modify_slots_len equ $ - header_modify_slots

    ; ========================================================================
    ; PROMPTS AND MESSAGES
    ; ========================================================================
    
    ; Search related messages
    prompt_search           db "  Enter search term: "
    prompt_search_len       equ $ - prompt_search

    hint_search_case        db 13, 10, "  Note: Search is case-sensitive", 13, 10
    hint_search_case_len    equ $ - hint_search_case

    msg_search_results     db 13, 10, "  >>> Found matching tasks:", 13, 10
    msg_search_results_len equ $ - msg_search_results

    msg_no_search_results  db 13, 10, "  ... No tasks found matching your search", 13, 10
    msg_no_search_results_len equ $ - msg_no_search_results

    ; Sort related messages
    sort_menu          db 13, 10, "  Sort by:", 13, 10, "  1. Alphabetical A-Z", 13, 10, "  2. Alphabetical Z-A", 13, 10, "  3. Status (Incomplete First)", 13, 10, "  4. Status (Complete First)", 13, 10, "  Enter choice: "
    sort_menu_len      equ $ - sort_menu

    msg_sorted         db 13, 10, "  >>> Tasks sorted successfully!", 13, 10
    msg_sorted_len     equ $ - msg_sorted

    ; Task slot modification messages
    modify_slots_menu  db 13, 10, " Select task slot limit:", 13, 10
    modify_slots_menu_len equ $ - modify_slots_menu

    modify_option_1    db " 1. 10 Tasks (Default)", 13, 10
    modify_option_1_len equ $ - modify_option_1

    modify_option_2    db " 2. 15 Tasks", 13, 10
    modify_option_2_len equ $ - modify_option_2

    modify_option_3    db " 3. 20 Tasks", 13, 10
    modify_option_3_len equ $ - modify_option_3

    modify_option_4    db " 4. 30 Tasks", 13, 10
    modify_option_4_len equ $ - modify_option_4

    modify_prompt      db " Enter choice: "
    modify_prompt_len  equ $ - modify_prompt

    ; Slot modification confirmation messages
    msg_slots_10       db 13, 10, " >>> Task limit set to 10 slots", 13, 10
    msg_slots_10_len   equ $ - msg_slots_10

    msg_slots_15       db 13, 10, " >>> Task limit set to 15 slots", 13, 10
    msg_slots_15_len   equ $ - msg_slots_15

    msg_slots_20       db 13, 10, " >>> Task limit set to 20 slots", 13, 10
    msg_slots_20_len   equ $ - msg_slots_20

    msg_slots_30       db 13, 10, " >>> Task limit set to 30 slots", 13, 10
    msg_slots_30_len   equ $ - msg_slots_30

    msg_slot_restored_10 db 13, 10, " >>> Slot limit restored: 10 slots", 13, 10
    msg_slot_restored_10_len equ $ - msg_slot_restored_10

    msg_slot_restored_15 db 13, 10, " >>> Slot limit restored: 15 slots", 13, 10
    msg_slot_restored_15_len equ $ - msg_slot_restored_15

    msg_slot_restored_20 db 13, 10, " >>> Slot limit restored: 20 slots", 13, 10
    msg_slot_restored_20_len equ $ - msg_slot_restored_20

    msg_slot_restored_30 db 13, 10, " >>> Slot limit restored: 30 slots", 13, 10
    msg_slot_restored_30_len equ $ - msg_slot_restored_30

    ; User guidance hints
    hint_add_task          db 13, 10, "  Tip: Separate multiple tasks with semicolon (;)", 13, 10, "  Example: task1;task2;task3", 13, 10
    hint_add_task_len      equ $ - hint_add_task

    hint_delete_selection  db 13, 10, "  Tip: Enter 0 to cancel, or task numbers separated by space", 13, 10, "  Example: 1 3 5", 13, 10
    hint_delete_selection_len equ $ - hint_delete_selection

    hint_toggle_multiple   db 13, 10, "  Tip: Enter task numbers separated by space", 13, 10, "  Example: 2 4 6", 13, 10
    hint_toggle_multiple_len equ $ - hint_toggle_multiple

    hint_esc_cancel        db 13, 10, " >>> Tip: Press 0 then Enter to cancel any operation", 13, 10
    hint_esc_cancel_len    equ $ - hint_esc_cancel

    ; Operation prompts
    delete_selection_prompt db " Enter task numbers: "
    delete_selection_prompt_len equ $ - delete_selection_prompt

    toggle_multiple_prompt db " Enter task numbers: "
    toggle_multiple_prompt_len equ $ - toggle_multiple_prompt

    ; Status messages
    msg_operation_cancelled db 13, 10, " ... Operation cancelled", 13, 10
    msg_operation_cancelled_len equ $ - msg_operation_cancelled

    msg_tasks_toggled      db 13, 10, " >>> Tasks toggled successfully!", 13, 10
    msg_tasks_toggled_len  equ $ - msg_tasks_toggled

    msg_no_valid_tasks     db 13, 10, "  ... No valid tasks toggled", 13, 10
    msg_no_valid_tasks_len equ $ - msg_no_valid_tasks

    msg_tasks_added        db 13, 10, " >>> Tasks added successfully!", 13, 10
    msg_tasks_added_len    equ $ - msg_tasks_added

    msg_task_updated       db 13, 10, "  >>> Task updated successfully!", 13, 10
    msg_task_updated_len   equ $ - msg_task_updated

    ; ========================================================================
    ; MAIN MENU AND CORE UI ELEMENTS
    ; ========================================================================
    menu_header        db 13, 10, "===== TO-DO LIST APPLICATION =====", 13, 10
    menu_header_len    equ $ - menu_header

    ; Status display components
    status_header      db "Status: "
    status_header_len  equ $ - status_header

    completed_text     db " completed, "
    completed_text_len equ $ - completed_text

    remaining_text     db " remaining"
    remaining_text_len equ $ - remaining_text

    total_text         db 13, 10, "Total: "
    total_text_len     equ $ - total_text

    ; Menu options (split for better organization)
    menu_part1         db "  1. Add Task", 13, 10, "  2. View All Tasks", 13, 10, "  3. Update Task", 13, 10, "  4. Delete Task", 13, 10
    menu_part2         db "  5. Toggle Complete", 13, 10, "  6. Save Tasks", 13, 10, "  7. Load Tasks", 13, 10, "  8. Modify Task Slots", 13, 10, "  9. Search Tasks", 13, 10, "  10. Sort Tasks", 13, 10, "  11. Exit", 13, 10
    menu_part1_len     equ menu_part2 - menu_part1
    menu_part2_len     equ $ - menu_part2

    ; Delete operation prompts
    delete_mode_prompt db 13, 10, "  Choose delete mode:", 13, 10, "    1. Delete All Tasks", 13, 10, "    2. Delete Selection", 13, 10, "  Enter choice: "
    delete_mode_prompt_len equ $ - delete_mode_prompt

    delete_selection_hint db 13, 10, "  Enter task numbers separated by space:", 13, 10, "  Example: 1 3 5", 13, 10, "  Enter: "
    delete_selection_hint_len equ $ - delete_selection_hint

    ; General prompts
    choose_option      db "  Choose option: "
    choose_option_len  equ $ - choose_option

    ; Task display elements
    checkbox_incomplete db 91, 32, 93, 32    ; [ ]
    checkbox_incomplete_len equ $ - checkbox_incomplete

    checkbox_complete   db 91, 43, 93, 32    ; [+]
    checkbox_complete_len equ $ - checkbox_complete

    prompt_task        db 13, 10, "  Enter task(s) (each task max 60 chars, separate with ;): "
    prompt_task_len    equ $ - prompt_task

    prompt_update      db 13, 10, "  Enter task number to update: "
    prompt_update_len  equ $ - prompt_update

    prompt_new_task    db 13, 10, "  Enter new task text: "
    prompt_new_task_len equ $ - prompt_new_task

    prompt_delete      db 13, 10, "  Enter task number to delete: "
    prompt_delete_len  equ $ - prompt_delete

    prompt_toggle      db 13, 10, "  Enter task number to toggle: "
    prompt_toggle_len  equ $ - prompt_toggle

    ; Success/error messages
    msg_added          db 13, 10, "  >>> Task added successfully!", 13, 10
    msg_added_len      equ $ - msg_added

    msg_updated        db 13, 10, "  >>> Task updated successfully!", 13, 10
    msg_updated_len    equ $ - msg_updated

    msg_deleted        db 13, 10, "  >>> Task(s) deleted!", 13, 10
    msg_deleted_len    equ $ - msg_deleted

    msg_deleted_all    db 13, 10, "  >>> All tasks deleted!", 13, 10
    msg_deleted_all_len equ $ - msg_deleted_all

    msg_toggled        db 13, 10, "  >>> Task status toggled!", 13, 10
    msg_toggled_len    equ $ - msg_toggled

    msg_saved          db 13, 10, "  >>> Tasks saved to file!", 13, 10
    msg_saved_len      equ $ - msg_saved

    msg_loaded         db 13, 10, "  >>> Tasks loaded from file!", 13, 10
    msg_loaded_len     equ $ - msg_loaded

    msg_save_error     db 13, 10, "  ... Error saving to file", 13, 10
    msg_save_error_len equ $ - msg_save_error

    msg_load_error     db 13, 10, "  ... No saved tasks found", 13, 10
    msg_load_error_len equ $ - msg_load_error

    msg_full           db 13, 10, "  ... Task list is full", 13, 10
    msg_full_len       equ $ - msg_full

    msg_empty          db 13, 10, "  ... No tasks in list", 13, 10
    msg_empty_len      equ $ - msg_empty

    msg_invalid        db 13, 10, "  ... Invalid option", 13, 10
    msg_invalid_len    equ $ - msg_invalid

    ; Basic formatting
    newline            db 13, 10
    newline_len        equ $ - newline

    task_item_prefix   db "  "
    task_item_prefix_len equ $ - task_item_prefix

    dot_space          db ". "
    dot_space_len      equ $ - dot_space

; =============================================================================
; UNINITIALIZED DATA SECTION
; =============================================================================
section .bss
    ; Application state variables
    max_tasks_limit    resd 1      ; Current maximum number of tasks allowed
    toggle_count       resd 1      ; Counter for toggle operations
    added_count        resd 1      ; Counter for added tasks
    
    ; Task storage - each task is TASK_SIZE bytes (63 chars + 1 status byte)
    tasks              resb MAX_TASKS * TASK_SIZE
    
    ; Counters
    task_count         resd 1      ; Current number of tasks
    completed_count    resd 1      ; Number of completed tasks
    
    ; Application flags
    first_run          resd 1      ; Flag for first application run
    
    ; I/O buffers and handles
    input_buffer       resb 1024   ; Buffer for user input
    bytes_read         resd 1      ; Bytes read from input
    bytes_written      resd 1      ; Bytes written to output
    stdout_handle      resd 1      ; Standard output handle
    stdin_handle       resd 1      ; Standard input handle
    file_handle        resd 1      ; File handle for save/load operations
    
    ; Utility buffers
    num_buffer         resb 12     ; Buffer for number-to-string conversion
    
    ; Operation flags (used in delete and toggle operations)
    delete_flags       resb MAX_TASKS  ; Flags marking tasks for deletion

; =============================================================================
; CODE SECTION - APPLICATION LOGIC
; =============================================================================
section .text

; -----------------------------------------------------------------------------
; MAIN PROGRAM ENTRY POINT
; -----------------------------------------------------------------------------
main:
    ; Initialize standard handles
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov [stdout_handle], eax

    push STD_INPUT_HANDLE
    call _GetStdHandle@4
    mov [stdin_handle], eax

    ; Initialize application state
    mov dword [task_count], 0           ; Start with no tasks
    mov dword [max_tasks_limit], 10     ; Default to 10 task slots
    mov dword [completed_count], 0      ; No completed tasks initially
    mov dword [first_run], 1            ; Set first run flag

; -----------------------------------------------------------------------------
; MAIN APPLICATION LOOP
; -----------------------------------------------------------------------------
main_loop:
    call display_menu                   ; Show the main menu
    call read_input                     ; Get user input
    
    movzx eax, byte [input_buffer]      ; Get first character of input
    mov dword [first_run], 0            ; Clear first run flag after first interaction

    ; Process menu options - single digit options first
    cmp al, '2'
    je view_tasks
    cmp al, '3'
    je update_task
    cmp al, '4'
    je delete_task
    cmp al, '5'
    je toggle_complete
    cmp al, '6'
    je save_tasks
    cmp al, '7'
    je load_tasks
    cmp al, '8'
    je modify_slots
    cmp al, '9'
    je search_tasks
    
    ; Check if it's '1' which could be Add Task (1) or multi-digit (10, 11)
    cmp al, '1'
    jne .check_exit_direct
    jmp check_extended_options
    
.check_exit_direct:
    ; Check for '0' for direct exit (shouldn't happen normally)
    cmp al, '0'
    je exit_program
    
    call print_invalid                  ; Invalid input handler
    jmp main_loop

; -----------------------------------------------------------------------------
; EXTENDED OPTIONS HANDLER (for multi-digit inputs)
; -----------------------------------------------------------------------------
check_extended_options:
    ; Check if the input was "10" for sort or "11" for exit
    cmp byte [input_buffer+1], '0'
    je sort_tasks
    cmp byte [input_buffer+1], '1'
    je exit_program
    
    ; If not "10" or "11", treat as "1" for add task
    jmp add_task

; -----------------------------------------------------------------------------
; TASK SLOT MODIFICATION FUNCTION
; Allows user to change the maximum number of task slots
; -----------------------------------------------------------------------------
modify_slots:
    ; Display modification header and menu
    push 0
    push bytes_written
    push header_modify_slots_len
    push header_modify_slots
    push dword [stdout_handle]
    call _WriteFile@20

    ; Display slot options
    push 0
    push bytes_written
    push modify_slots_menu_len
    push modify_slots_menu
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push modify_option_1_len
    push modify_option_1
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push modify_option_2_len
    push modify_option_2
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push modify_option_3_len
    push modify_option_3
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push modify_option_4_len
    push modify_option_4
    push dword [stdout_handle]
    call _WriteFile@20

    ; Get user choice
    push 0
    push bytes_written
    push modify_prompt_len
    push modify_prompt
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input
    movzx eax, byte [input_buffer]

    ; Process slot limit choice
    cmp al, '1'
    je .set_10
    cmp al, '2'
    je .set_15
    cmp al, '3'
    je .set_20
    cmp al, '4'
    je .set_30

    call print_invalid
    jmp main_loop

.set_10:
    mov dword [max_tasks_limit], 10
    push 0
    push bytes_written
    push msg_slots_10_len
    push msg_slots_10
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

.set_15:
    mov dword [max_tasks_limit], 15
    push 0
    push bytes_written
    push msg_slots_15_len
    push msg_slots_15
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

.set_20:
    mov dword [max_tasks_limit], 20
    push 0
    push bytes_written
    push msg_slots_20_len
    push msg_slots_20
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

.set_30:
    mov dword [max_tasks_limit], 30
    push 0
    push bytes_written
    push msg_slots_30_len
    push msg_slots_30
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

; -----------------------------------------------------------------------------
; TASK SEARCH FUNCTION
; Searches tasks for text matches (case-sensitive)
; -----------------------------------------------------------------------------
search_tasks:
    mov eax, [task_count]
    cmp eax, 0
    je task_list_empty

    ; Display search header and hints
    push 0
    push bytes_written
    push header_search_len
    push header_search
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push hint_search_case_len
    push hint_search_case
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push prompt_search_len
    push prompt_search
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input

    ; Check for empty search
    cmp byte [input_buffer], 0
    je .no_results

    ; Search through tasks
    xor ebx, ebx                        ; Task index counter
    mov dword [toggle_count], 0         ; Use as match counter

.search_loop:
    cmp ebx, [task_count]
    jge .search_done

    ; Get current task address
    mov eax, ebx
    mov ecx, TASK_SIZE
    mul ecx
    lea esi, [tasks + eax]              ; ESI points to current task

    ; Search in task text
    mov edi, input_buffer               ; EDI points to search term
    call string_contains                ; Check if task contains search term

    cmp eax, 1
    jne .next_task

    ; Found match - display the task
    cmp dword [toggle_count], 0
    jne .display_task
    
    ; First match - show results header and top border
    push 0
    push bytes_written
    push msg_search_results_len
    push msg_search_results
    push dword [stdout_handle]
    call _WriteFile@20
    
    push 0
    push bytes_written
    push separator_top_len
    push separator_top
    push dword [stdout_handle]
    call _WriteFile@20

.display_task:
    call print_single_task              ; Display the matching task
    inc dword [toggle_count]            ; Increment match counter

.next_task:
    inc ebx
    jmp .search_loop

.search_done:
    cmp dword [toggle_count], 0
    jne .has_results

.no_results:
    push 0
    push bytes_written
    push msg_no_search_results_len
    push msg_no_search_results
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .done

.has_results:
    ; Show bottom border after results
    push 0
    push bytes_written
    push separator_bottom_len
    push separator_bottom
    push dword [stdout_handle]
    call _WriteFile@20

.done:
    jmp main_loop

; -----------------------------------------------------------------------------
; TASK SORTING FUNCTION
; Provides multiple sorting options for tasks
; -----------------------------------------------------------------------------
sort_tasks:
    mov eax, [task_count]
    cmp eax, 0
    je task_list_empty

    ; Display sort menu
    push 0
    push bytes_written
    push header_sort_len
    push header_sort
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push hint_esc_cancel_len
    push hint_esc_cancel
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push sort_menu_len
    push sort_menu
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input
    movzx eax, byte [input_buffer]

    ; Check for cancellation
    cmp al, '0'
    jne .continue_sort
    call cancel_operation
    jmp main_loop

.continue_sort:
    ; Process sort choice
    cmp al, '1'
    je .sort_alpha_asc
    cmp al, '2'
    je .sort_alpha_desc
    cmp al, '3'
    je .sort_incomplete_first
    cmp al, '4'
    je .sort_complete_first
    
    call print_invalid
    jmp main_loop

.sort_alpha_asc:
    call bubble_sort_alpha_asc
    jmp .sort_done

.sort_alpha_desc:
    call bubble_sort_alpha_desc
    jmp .sort_done

.sort_incomplete_first:
    call bubble_sort_incomplete_first
    jmp .sort_done

.sort_complete_first:
    call bubble_sort_complete_first

.sort_done:
    push 0
    push bytes_written
    push msg_sorted_len
    push msg_sorted
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

; -----------------------------------------------------------------------------
; BUBBLE SORT IMPLEMENTATIONS
; Various sorting algorithms for different criteria
; -----------------------------------------------------------------------------

; Bubble sort for alphabetical A-Z
bubble_sort_alpha_asc:
    mov ecx, [task_count]
    dec ecx
    jle .done

.outer_loop:
    xor edx, edx  ; swapped flag
    mov ebx, 0    ; inner loop index

.inner_loop:
    ; Compare tasks[ebx] and tasks[ebx+1]
    mov eax, ebx
    mov esi, TASK_SIZE
    mul esi
    lea esi, [tasks + eax]   ; task1
    
    mov eax, ebx
    inc eax
    mov edi, TASK_SIZE
    mul edi
    lea edi, [tasks + eax]   ; task2
    
    ; Compare strings
    push ecx
    push ebx
    call compare_strings
    pop ebx
    pop ecx
    
    cmp eax, 0
    jle .no_swap
    
    ; Swap tasks
    call swap_tasks
    mov edx, 1  ; set swapped flag

.no_swap:
    inc ebx
    cmp ebx, ecx
    jl .inner_loop
    
    test edx, edx
    jz .done  ; no swaps, we're done
    
    dec ecx
    jnz .outer_loop

.done:
    ret

; Bubble sort for alphabetical Z-A (reverse of A-Z)
bubble_sort_alpha_desc:
    mov ecx, [task_count]
    dec ecx
    jle .done

.outer_loop:
    xor edx, edx  ; swapped flag
    mov ebx, 0    ; inner loop index

.inner_loop:
    ; Compare tasks[ebx] and tasks[ebx+1]
    mov eax, ebx
    mov esi, TASK_SIZE
    mul esi
    lea esi, [tasks + eax]   ; task1
    
    mov eax, ebx
    inc eax
    mov edi, TASK_SIZE
    mul edi
    lea edi, [tasks + eax]   ; task2
    
    ; Compare strings (reverse order)
    push ecx
    push ebx
    call compare_strings
    pop ebx
    pop ecx
    
    cmp eax, 0
    jge .no_swap
    
    ; Swap tasks
    call swap_tasks
    mov edx, 1  ; set swapped flag

.no_swap:
    inc ebx
    cmp ebx, ecx
    jl .inner_loop
    
    test edx, edx
    jz .done  ; no swaps, we're done
    
    dec ecx
    jnz .outer_loop

.done:
    ret

; Bubble sort for incomplete tasks first
bubble_sort_incomplete_first:
    mov ecx, [task_count]
    cmp ecx, 1
    jle .done
    
    dec ecx  ; outer loop counter

.outer_loop:
    xor edx, edx  ; swapped flag = 0
    mov ebx, 0    ; inner loop index

.inner_loop:
    ; Get task status at index ebx
    mov eax, ebx
    imul eax, TASK_SIZE
    movzx eax, byte [tasks + eax + STATUS_OFFSET]
    
    ; Get task status at index ebx+1
    mov edi, ebx
    inc edi
    imul edi, TASK_SIZE
    movzx edi, byte [tasks + edi + STATUS_OFFSET]
    
    ; Check if we need to swap: we want incomplete (0) before complete (1)
    ; So swap if left is complete (1) and right is incomplete (0)
    cmp eax, 1
    jne .no_swap
    cmp edi, 0
    jne .no_swap
    
    ; Swap the tasks
    push ecx
    push ebx
    call swap_tasks
    pop ebx
    pop ecx
    mov edx, 1  ; set swapped flag

.no_swap:
    inc ebx
    cmp ebx, ecx
    jl .inner_loop
    
    ; If no swaps in this pass, we're done
    test edx, edx
    jz .done
    
    dec ecx
    jnz .outer_loop

.done:
    ret

; Bubble sort for complete tasks first
bubble_sort_complete_first:
    mov ecx, [task_count]
    cmp ecx, 1
    jle .done
    
    dec ecx  ; outer loop counter

.outer_loop:
    xor edx, edx  ; swapped flag = 0
    mov ebx, 0    ; inner loop index

.inner_loop:
    ; Get task status at index ebx
    mov eax, ebx
    imul eax, TASK_SIZE
    movzx eax, byte [tasks + eax + STATUS_OFFSET]
    
    ; Get task status at index ebx+1
    mov edi, ebx
    inc edi
    imul edi, TASK_SIZE
    movzx edi, byte [tasks + edi + STATUS_OFFSET]
    
    ; Check if we need to swap: we want complete (1) before incomplete (0)
    ; So swap if left is incomplete (0) and right is complete (1)
    cmp eax, 0
    jne .no_swap
    cmp edi, 1
    jne .no_swap
    
    ; Swap the tasks
    push ecx
    push ebx
    call swap_tasks
    pop ebx
    pop ecx
    mov edx, 1  ; set swapped flag

.no_swap:
    inc ebx
    cmp ebx, ecx
    jl .inner_loop
    
    ; If no swaps in this pass, we're done
    test edx, edx
    jz .done
    
    dec ecx
    jnz .outer_loop

.done:
    ret

; -----------------------------------------------------------------------------
; UTILITY FUNCTIONS
; Helper functions for string operations and task management
; -----------------------------------------------------------------------------

; Helper function to compare two strings
; Input: ESI = string1, EDI = string2
; Output: EAX > 0 if string1 > string2, EAX < 0 if string1 < string2, EAX = 0 if equal
compare_strings:
    push ebx
    push ecx
    xor ecx, ecx

.compare_loop:
    mov al, [esi + ecx]
    mov bl, [edi + ecx]
    cmp al, bl
    jne .different
    test al, al  ; Check for null terminator
    jz .equal
    inc ecx
    cmp ecx, STATUS_OFFSET
    jl .compare_loop

.equal:
    xor eax, eax
    jmp .done

.different:
    movsx eax, al
    movsx ebx, bl
    sub eax, ebx

.done:
    pop ecx
    pop ebx
    ret

; Helper function to swap two tasks
; Input: EBX = index of first task
swap_tasks:
    push eax
    push ebx
    push ecx
    push esi
    push edi
    
    ; Calculate addresses
    mov eax, ebx
    mov ecx, TASK_SIZE
    mul ecx
    lea esi, [tasks + eax]   ; task1
    
    mov eax, ebx
    inc eax
    mul ecx
    lea edi, [tasks + eax]   ; task2
    
    ; Swap using stack as temporary storage
    sub esp, TASK_SIZE
    
    ; Copy task1 to temp
    mov ecx, TASK_SIZE
    push esi
    mov esi, esp
    add esi, 4  ; point to our temp buffer
    mov edi, esi
    pop esi
    push esi
    mov ecx, TASK_SIZE
    rep movsb
    
    ; Copy task2 to task1
    pop edi  ; task1 destination
    mov eax, ebx
    inc eax
    mov ecx, TASK_SIZE
    mul ecx
    lea esi, [tasks + eax]   ; task2 source
    mov ecx, TASK_SIZE
    rep movsb
    
    ; Copy temp to task2
    mov eax, ebx
    inc eax
    mov ecx, TASK_SIZE
    mul ecx
    lea edi, [tasks + eax]   ; task2 destination
    mov esi, esp
    mov ecx, TASK_SIZE
    rep movsb
    
    add esp, TASK_SIZE
    
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

; Helper function to check if string contains substring (case-sensitive)
; Input: ESI = string to search in, EDI = substring to find
; Output: EAX = 1 if found, 0 if not found
string_contains:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Check if search term is empty
    cmp byte [edi], 0
    je .not_found
    
.outer_loop:
    mov al, [esi]
    cmp al, 0
    je .not_found
    
    mov bl, [edi]
    cmp al, bl
    jne .next_char
    
    ; First character matches, check the rest
    push esi
    push edi
    
.check_rest:
    inc esi
    inc edi
    mov al, [esi]
    mov bl, [edi]
    
    cmp bl, 0
    je .found
    
    cmp al, 0
    je .not_found_rest
    
    cmp al, bl
    je .check_rest
    
.not_found_rest:
    pop edi
    pop esi
    jmp .next_char

.next_char:
    inc esi
    jmp .outer_loop

.found:
    pop edi
    pop esi
    mov eax, 1
    jmp .done

.not_found:
    xor eax, eax

.done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; Helper function to print a single task
; Input: EBX = task index
print_single_task:
    push 0
    push bytes_written
    push border_left_len
    push border_left
    push dword [stdout_handle]
    call _WriteFile@20

    mov eax, ebx
    inc eax
    call num_to_string

    push 0
    push bytes_written
    push eax
    push num_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push dot_space_len
    push dot_space
    push dword [stdout_handle]
    call _WriteFile@20

    mov eax, ebx
    mov ecx, TASK_SIZE
    mul ecx
    lea edx, [tasks + eax]

    push ebx
    push edx

    movzx eax, byte [edx + STATUS_OFFSET]
    cmp al, 1
    je .print_complete

    push 0
    push bytes_written
    push checkbox_incomplete_len
    push checkbox_incomplete
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .after_checkbox

.print_complete:
    push 0
    push bytes_written
    push checkbox_complete_len
    push checkbox_complete
    push dword [stdout_handle]
    call _WriteFile@20

.after_checkbox:
    pop edx
    pop ebx
    push ebx
    xor ecx, ecx

.find_len:
    cmp ecx, STATUS_OFFSET
    jge .len_found
    movzx eax, byte [edx + ecx]
    cmp al, 0
    je .len_found
    cmp al, 13
    je .len_found
    cmp al, 10
    je .len_found
    inc ecx
    jmp .find_len

.len_found:
    pop ebx
    cmp ecx, 0
    je .skip_print

    push 0
    push bytes_written
    push ecx
    push edx
    push dword [stdout_handle]
    call _WriteFile@20

.skip_print:
    push 0
    push bytes_written
    push newline_only_len
    push newline_only
    push dword [stdout_handle]
    call _WriteFile@20

    ret

; -----------------------------------------------------------------------------
; TASK MANAGEMENT FUNCTIONS
; Core functionality for task operations
; -----------------------------------------------------------------------------

; Add new task(s) function
add_task:
    push 0
    push bytes_written
    push hint_add_task_len
    push hint_add_task
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push hint_esc_cancel_len
    push hint_esc_cancel
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push prompt_task_len
    push prompt_task
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input
    
    ; Check for ESC cancellation
    cmp byte [input_buffer], '0'
    jne .continue_add
    call cancel_operation
    jmp .skip_success_message

.continue_add:
    lea esi, [input_buffer]
    xor ebx, ebx  ; input buffer index
    mov dword [added_count], 0  ; track how many tasks we actually add

.parse_loop:
    ; Skip leading spaces and semicolons
    movzx eax, byte [esi + ebx]
    cmp al, 0
    je .finish_adding
    cmp al, ' '
    je .skip_leading_char
    cmp al, ';'
    je .skip_leading_char
    cmp al, 13
    je .finish_adding
    cmp al, 10
    je .finish_adding

    ; Check if we have space for more tasks
    mov eax, [task_count]
    mov ecx, [max_tasks_limit]
    cmp eax, ecx
    jge .finish_adding

    ; Set up destination for new task
    mov eax, [task_count]
    mov ecx, TASK_SIZE
    mul ecx
    lea edi, [tasks + eax]

    xor ecx, ecx  ; task string index

.copy_chars:
    movzx eax, byte [esi + ebx]
    cmp al, 0
    je .save_task
    cmp al, ';'
    je .save_task
    cmp al, 13
    je .save_task
    cmp al, 10
    je .save_task
    cmp ecx, TASK_SIZE - 2  ; Leave room for null terminator and status byte
    jge .save_task

    ; Skip leading spaces at the beginning of a task
    cmp ecx, 0
    jne .not_leading_space
    cmp al, ' '
    je .skip_copy_char
    jmp .copy_char

.not_leading_space:
    ; Skip multiple consecutive spaces
    cmp al, ' '
    jne .copy_char
    cmp byte [edi + ecx - 1], ' '
    je .skip_copy_char

.copy_char:
    mov byte [edi + ecx], al
    inc ecx

.skip_copy_char:
    inc ebx
    jmp .copy_chars

.save_task:
    ; Remove trailing spaces
.remove_trailing_spaces:
    cmp ecx, 0
    je .empty_task
    cmp byte [edi + ecx - 1], ' '
    jne .not_empty
    dec ecx
    jmp .remove_trailing_spaces

.empty_task:
    ; If task is empty after trimming, skip it
    jmp .skip_empty_task

.not_empty:
    ; Only save non-empty tasks
    mov byte [edi + ecx], 0
    mov byte [edi + STATUS_OFFSET], 0  ; Set status to incomplete
    inc dword [task_count]
    inc dword [added_count]

.skip_empty_task:
    ; Skip any remaining semicolons or spaces after this task
    movzx eax, byte [esi + ebx]
    cmp al, 0
    je .finish_adding
    cmp al, ';'
    jne .check_next_char
    inc ebx
    jmp .parse_loop

.check_next_char:
    cmp al, ' '
    jne .finish_adding
    inc ebx
    jmp .parse_loop

.skip_leading_char:
    inc ebx
    jmp .parse_loop

.finish_adding:
    ; Only show success message if we actually added tasks
    cmp dword [added_count], 0
    jle .no_tasks_added
    
    push 0
    push bytes_written
    push msg_tasks_added_len
    push msg_tasks_added
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .skip_success_message

.no_tasks_added:
    push 0
    push bytes_written
    push msg_empty_len
    push msg_empty
    push dword [stdout_handle]
    call _WriteFile@20

.skip_success_message:
    jmp main_loop

task_list_full:
    push 0
    push bytes_written
    push msg_full_len
    push msg_full
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

; View all tasks function  
view_tasks:
    mov eax, [task_count]
    cmp eax, 0
    je task_list_empty

    call print_newline

    push 0
    push bytes_written
    push separator_top_len
    push separator_top
    push dword [stdout_handle]
    call _WriteFile@20

    xor ebx, ebx

view_loop:
    cmp ebx, [task_count]
    jge view_done

    push 0
    push bytes_written
    push border_left_len
    push border_left
    push dword [stdout_handle]
    call _WriteFile@20

    mov eax, ebx
    inc eax
    call num_to_string

    push 0
    push bytes_written
    push eax
    push num_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push dot_space_len
    push dot_space
    push dword [stdout_handle]
    call _WriteFile@20

    mov eax, ebx
    mov ecx, TASK_SIZE
    mul ecx
    lea edx, [tasks + eax]

    push ebx
    push edx

    movzx eax, byte [edx + STATUS_OFFSET]
    cmp al, 1
    je .print_complete

    push 0
    push bytes_written
    push checkbox_incomplete_len
    push checkbox_incomplete
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .after_checkbox

.print_complete:
    push 0
    push bytes_written
    push checkbox_complete_len
    push checkbox_complete
    push dword [stdout_handle]
    call _WriteFile@20

.after_checkbox:
    pop edx
    pop ebx
    push ebx
    xor ecx, ecx

.find_len:
    cmp ecx, STATUS_OFFSET
    jge .len_found
    movzx eax, byte [edx + ecx]
    cmp al, 0
    je .len_found
    cmp al, 13
    je .len_found
    cmp al, 10
    je .len_found
    inc ecx
    jmp .find_len

.len_found:
    pop ebx
    cmp ecx, 0
    je .skip_print

    push 0
    push bytes_written
    push ecx
    push edx
    push dword [stdout_handle]
    call _WriteFile@20

.skip_print:
    push 0
    push bytes_written
    push newline_only_len
    push newline_only
    push dword [stdout_handle]
    call _WriteFile@20

    inc ebx
    jmp view_loop

view_done:
    push 0
    push bytes_written
    push separator_bottom_len
    push separator_bottom
    push dword [stdout_handle]
    call _WriteFile@20

    jmp main_loop

task_list_empty:
    push 0
    push bytes_written
    push msg_empty_len
    push msg_empty
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

; Update existing task function
update_task:
    mov eax, [task_count]
    cmp eax, 0
    je task_list_empty

    ; Add the ESC hint at the beginning
    push 0
    push bytes_written
    push hint_esc_cancel_len
    push hint_esc_cancel
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push prompt_update_len
    push prompt_update
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input

    ; Check for ESC cancellation
    cmp byte [input_buffer], '0'
    jne .continue_update
    call cancel_operation
    jmp main_loop

.continue_update:

    ; Convert full string to integer (not just first char)
    lea esi, [input_buffer]
    xor edx, edx

.parse_number:
    movzx eax, byte [esi]
    cmp al, 0
    je .number_done
    cmp al, 10
    je .number_done
    cmp al, ' '
    je .number_done
    cmp al, '0'
    jl .number_done
    cmp al, '9'
    jg .number_done

    sub al, '0'
    movzx eax, al
    imul edx, 10
    add edx, eax
    inc esi
    jmp .parse_number

.number_done:
    mov eax, edx

    ; VALIDATION: Check if valid (1 to task_count)
    cmp eax, 1
    jl main_loop
    cmp eax, [task_count]
    jg main_loop

    ; Convert to 0-based index
    dec eax
    push eax

    push 0
    push bytes_written
    push prompt_new_task_len
    push prompt_new_task
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input

    ; Check for ESC cancellation on second input
    cmp byte [input_buffer], '0'
    jne .continue_update2
    call cancel_operation
    pop eax ; Clean up stack
    jmp main_loop

.continue_update2:

    pop eax

    mov ecx, TASK_SIZE
    mul ecx
    lea edi, [tasks + eax]

    movzx ecx, byte [edi + STATUS_OFFSET]
    push ecx

    mov ecx, TASK_SIZE
    rep stosb
    pop ecx
    mov byte [edi - 1], cl

    lea esi, [input_buffer]
    lea edi, [tasks + eax]
    mov ecx, TASK_SIZE - 1
    rep movsb
    mov byte [edi], 0

    push 0
    push bytes_written
    push msg_task_updated_len
    push msg_task_updated
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

; Delete task(s) function
delete_task:
    mov eax, [task_count]
    cmp eax, 0
    je task_list_empty

    ; Add the hint and first ESC check at the beginning
    push 0
    push bytes_written
    push hint_esc_cancel_len
    push hint_esc_cancel
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push delete_mode_prompt_len
    push delete_mode_prompt
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input

    ; Check for ESC cancellation
    cmp byte [input_buffer], '0'
    jne .continue_delete
    call cancel_operation
    jmp main_loop

.continue_delete:

    movzx eax, byte [input_buffer]

    cmp al, '1'
    je .delete_all
    cmp al, '2'
    je .delete_selection

    call print_invalid
    jmp main_loop

.delete_all:
    mov dword [task_count], 0

    push 0
    push bytes_written
    push msg_deleted_all_len
    push msg_deleted_all
    push dword [stdout_handle]
    call _WriteFile@20

    jmp main_loop

.delete_selection:
    ; Add ESC check
    push 0
    push bytes_written
    push hint_esc_cancel_len
    push hint_esc_cancel
    push dword [stdout_handle]
    call _WriteFile@20

    ; Fix: Properly clear delete_flags array
    mov ecx, MAX_TASKS
    lea edi, [delete_flags]
    xor eax, eax
    rep stosb

    push 0
    push bytes_written
    push delete_selection_hint_len
    push delete_selection_hint
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input

    ; Check for ESC cancellation on second input
    cmp byte [input_buffer], '0'
    jne .continue_delete_selection
    call cancel_operation
    jmp main_loop

.continue_delete_selection:

    lea esi, [input_buffer]

.parse_numbers:
    movzx eax, byte [esi]
    cmp al, 0
    je .execute_delete

    cmp al, ' '
    je .skip_space

    cmp al, '0'
    jl .skip_space
    cmp al, '9'
    jg .skip_space

    xor edx, edx

.build_number:
    movzx eax, byte [esi]
    cmp al, ' '
    je .number_done
    cmp al, 0
    je .number_done
    cmp al, '0'
    jl .skip_space
    cmp al, '9'
    jg .skip_space

    sub al, '0'
    movzx eax, al
    mov ebx, edx
    mov edx, 10
    imul ebx, edx
    add ebx, eax
    mov edx, ebx

    inc esi
    jmp .build_number

.number_done:
    mov eax, edx
    cmp eax, 0
    je .skip_space
    dec eax

    cmp eax, [max_tasks_limit]
    jge .skip_space

    cmp eax, [task_count]
    jge .skip_space

    lea edi, [delete_flags]
    mov byte [edi + eax], 1

.skip_space:
    movzx eax, byte [esi]
    cmp al, 0
    je .execute_delete
    inc esi
    jmp .parse_numbers

.execute_delete:
    xor ebx, ebx
    xor ecx, ecx

.copy_loop:
    cmp ebx, [task_count]
    jge .update_count

    lea edi, [delete_flags]
    movzx eax, byte [edi + ebx]
    cmp al, 1
    je .skip_copy

    mov eax, ebx
    mov edx, TASK_SIZE
    mul edx
    lea esi, [tasks + eax]

    mov eax, ecx
    mov edx, TASK_SIZE
    mul edx
    lea edi, [tasks + eax]

    push ecx
    mov ecx, TASK_SIZE
    rep movsb
    pop ecx

    inc ecx

.skip_copy:
    inc ebx
    jmp .copy_loop

.update_count:
    mov eax, ecx
    mov [task_count], eax

    push 0
    push bytes_written
    push msg_deleted_len
    push msg_deleted
    push dword [stdout_handle]
    call _WriteFile@20

    jmp main_loop

; Toggle task completion status function
toggle_complete:
    mov eax, [task_count]
    cmp eax, 0
    je task_list_empty

    push 0
    push bytes_written
    push hint_toggle_multiple_len
    push hint_toggle_multiple
    push dword [stdout_handle]
    call _WriteFile@20

    ; Add the hint and ESC check
    push 0
    push bytes_written
    push hint_esc_cancel_len
    push hint_esc_cancel
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push toggle_multiple_prompt_len
    push toggle_multiple_prompt
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input

    ; Check for ESC cancellation
    cmp byte [input_buffer], '0'
    jne .continue_toggle
    call cancel_operation
    jmp .skip_toggle_success

.continue_toggle:
    ; Fix: Properly clear delete_flags array
    mov ecx, MAX_TASKS
    lea edi, [delete_flags]
    xor eax, eax
    rep stosb

    mov dword [toggle_count], 0  ; Initialize counter
    lea esi, [input_buffer]

.parse_toggle:
    movzx eax, byte [esi]
    cmp al, 0
    je .execute_toggle

    cmp al, ' '
    je .skip_toggle_space

    cmp al, '0'
    jl .skip_toggle_space
    cmp al, '9'
    jg .skip_toggle_space

    xor edx, edx

.build_toggle_number:
    movzx eax, byte [esi]
    cmp al, ' '
    je .toggle_number_done
    cmp al, 0
    je .toggle_number_done
    cmp al, '0'
    jl .skip_toggle_space
    cmp al, '9'
    jg .skip_toggle_space

    sub al, '0'
    movzx eax, al
    mov ebx, edx
    mov edx, 10
    imul ebx, edx
    add ebx, eax
    mov edx, ebx

    inc esi
    jmp .build_toggle_number

.toggle_number_done:
    mov eax, edx
    cmp eax, 0
    je .skip_toggle_space
    dec eax

    cmp eax, [max_tasks_limit]
    jge .skip_toggle_space

    cmp eax, [task_count]
    jge .skip_toggle_space

    lea edi, [delete_flags]
    mov byte [edi + eax], 1
    inc dword [toggle_count]  ; Increment counter for valid task

.skip_toggle_space:
    movzx eax, byte [esi]
    cmp al, 0
    je .execute_toggle
    inc esi
    jmp .parse_toggle

.execute_toggle:
    xor ebx, ebx

.toggle_loop:
    cmp ebx, [max_tasks_limit]
    jge .toggle_done

    lea edi, [delete_flags]
    movzx eax, byte [edi + ebx]
    cmp al, 1
    jne .skip_toggle_item

    mov eax, ebx
    mov ecx, TASK_SIZE
    mul ecx
    lea edi, [tasks + eax + STATUS_OFFSET]

    movzx eax, byte [edi]
    xor al, 1
    mov byte [edi], al

.skip_toggle_item:
    inc ebx
    jmp .toggle_loop

.toggle_done:
    ; Check if any tasks were actually toggled
    cmp dword [toggle_count], 0
    jle .no_tasks_toggled
    
    push 0
    push bytes_written
    push msg_tasks_toggled_len
    push msg_tasks_toggled
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .skip_toggle_success

.no_tasks_toggled:
    push 0
    push bytes_written
    push msg_no_valid_tasks_len
    push msg_no_valid_tasks
    push dword [stdout_handle]
    call _WriteFile@20

.skip_toggle_success:
    jmp main_loop

; -----------------------------------------------------------------------------
; FILE OPERATIONS
; Save and load tasks to/from disk
; -----------------------------------------------------------------------------

; Save tasks to file
save_tasks:
    push 0
    push bytes_written
    push saving_msg_len
    push saving_msg
    push dword [stdout_handle]
    call _WriteFile@20

    call show_spinner

    push 0
    push FILE_ATTRIBUTE_NORMAL
    push CREATE_ALWAYS
    push 0
    push 0
    push GENERIC_WRITE
    push filename
    call _CreateFileA@28

    cmp eax, INVALID_HANDLE_VALUE
    je save_error

    mov [file_handle], eax

    push 0
    push bytes_written
    push 4
    push max_tasks_limit
    push dword [file_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push 4
    push task_count
    push dword [file_handle]
    call _WriteFile@20

    mov eax, [task_count]
    mov ebx, TASK_SIZE
    mul ebx
    mov ecx, eax

    push 0
    push bytes_written
    push ecx
    push tasks
    push dword [file_handle]
    call _WriteFile@20

    push dword [file_handle]
    call _CloseHandle@4

    push 0
    push bytes_written
    push msg_saved_len
    push msg_saved
    push dword [stdout_handle]
    call _WriteFile@20

    jmp main_loop

save_error:
    push 0
    push bytes_written
    push msg_save_error_len
    push msg_save_error
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

; Load tasks from file  
load_tasks:
    push 0
    push bytes_written
    push loading_msg_len
    push loading_msg
    push dword [stdout_handle]
    call _WriteFile@20

    call show_spinner

    push 0
    push FILE_ATTRIBUTE_NORMAL
    push OPEN_EXISTING
    push 0
    push 0
    push GENERIC_READ
    push filename
    call _CreateFileA@28

    cmp eax, INVALID_HANDLE_VALUE
    je load_error

    mov [file_handle], eax

    push 0
    push bytes_read
    push 4
    push max_tasks_limit
    push dword [file_handle]
    call _ReadFile@20

    push 0
    push bytes_read
    push 4
    push task_count
    push dword [file_handle]
    call _ReadFile@20

    mov eax, [task_count]
    cmp eax, 0
    jl load_error_close
    mov ebx, [max_tasks_limit]
    cmp eax, ebx
    jg load_error_close

    mov eax, [task_count]
    mov ebx, TASK_SIZE
    mul ebx
    mov ecx, eax

    push 0
    push bytes_read
    push ecx
    push tasks
    push dword [file_handle]
    call _ReadFile@20

    push dword [file_handle]
    call _CloseHandle@4

    push 0
    push bytes_written
    push msg_loaded_len
    push msg_loaded
    push dword [stdout_handle]
    call _WriteFile@20

    jmp main_loop

load_error_close:
    push dword [file_handle]
    call _CloseHandle@4

load_error:
    push 0
    push bytes_written
    push msg_load_error_len
    push msg_load_error
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

; -----------------------------------------------------------------------------
; UI AND HELPER FUNCTIONS
; User interface and utility functions
; -----------------------------------------------------------------------------

; Display loading animation
show_spinner:
    push 0
    push bytes_written
    push spinner_1_len
    push spinner_1
    push dword [stdout_handle]
    call _WriteFile@20

    push 200
    call _Sleep@4

    push 0
    push bytes_written
    push spinner_2_len
    push spinner_2
    push dword [stdout_handle]
    call _WriteFile@20

    push 200
    call _Sleep@4

    push 0
    push bytes_written
    push spinner_3_len
    push spinner_3
    push dword [stdout_handle]
    call _WriteFile@20

    push 200
    call _Sleep@4

    push 0
    push bytes_written
    push spinner_4_len
    push spinner_4
    push dword [stdout_handle]
    call _WriteFile@20

    push 200
    call _Sleep@4

    ret

; Count completed tasks
count_completed:
    push eax
    push ecx
    push edx
    push ebx

    xor eax, eax
    xor ecx, ecx

.count_loop:
    cmp ecx, [task_count]
    jge .count_done

    mov edx, ecx
    mov ebx, TASK_SIZE
    imul edx, ebx
    lea edx, [tasks + edx + STATUS_OFFSET]
    movzx ebx, byte [edx]
    cmp bl, 1
    jne .count_skip
    inc eax

.count_skip:
    inc ecx
    jmp .count_loop

.count_done:
    mov [completed_count], eax
    pop ebx
    pop edx
    pop ecx
    pop eax
    ret

; Display main menu
display_menu:
    call print_newline

    cmp dword [first_run], 1
    je .show_welcome

    movzx eax, byte [input_buffer]
    cmp al, '1'
    je .check_menu_sort
    cmp al, '2'
    je .show_view
    cmp al, '3'
    je .show_update
    cmp al, '4'
    je .show_delete
    cmp al, '5'
    je .show_toggle
    cmp al, '6'
    je .show_save
    cmp al, '7'
    je .show_load
    cmp al, '8'
    je .show_modify_slots
    cmp al, '9'
    je .show_search
    jmp .show_menu

.check_menu_sort:
    ; Check if it's actually "10" for sort, not just "1"
    cmp byte [input_buffer+1], '0'
    je .show_sort
    jmp .show_add  ; If not "10", show add header

.show_welcome:
    push 0
    push bytes_written
    push header_welcome_len
    push header_welcome
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_add:
    push 0
    push bytes_written
    push header_add_len
    push header_add
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_view:
    push 0
    push bytes_written
    push header_view_len
    push header_view
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_update:
    push 0
    push bytes_written
    push header_update_len
    push header_update
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_delete:
    push 0
    push bytes_written
    push header_delete_len
    push header_delete
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_toggle:
    push 0
    push bytes_written
    push header_toggle_len
    push header_toggle
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_save:
    push 0
    push bytes_written
    push header_save_len
    push header_save
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_load:
    push 0
    push bytes_written
    push header_load_len
    push header_load
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_modify_slots:
    push 0
    push bytes_written
    push header_modify_slots_len
    push header_modify_slots
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_search:
    push 0
    push bytes_written
    push header_search_len
    push header_search
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_sort:
    push 0
    push bytes_written
    push header_sort_len
    push header_sort
    push dword [stdout_handle]
    call _WriteFile@20
    jmp .show_menu

.show_menu:
    push 0
    push bytes_written
    push separator_thin_len
    push separator_thin
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push menu_header_len
    push menu_header
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push separator_thin_len
    push separator_thin
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push status_header_len
    push status_header
    push dword [stdout_handle]
    call _WriteFile@20

    mov eax, [task_count]
    cmp eax, 0
    je .no_tasks_display

    call count_completed

    mov eax, [completed_count]
    call num_to_string

    push 0
    push bytes_written
    push eax
    push num_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push completed_text_len
    push completed_text
    push dword [stdout_handle]
    call _WriteFile@20

    mov eax, [task_count]
    sub eax, [completed_count]
    call num_to_string

    push 0
    push bytes_written
    push eax
    push num_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push remaining_text_len
    push remaining_text
    push dword [stdout_handle]
    call _WriteFile@20

    jmp .status_done

.no_tasks_display:
    mov byte [input_buffer], '0'

    push 0
    push bytes_written
    push 1
    push input_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push completed_text_len
    push completed_text
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push 1
    push input_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push remaining_text_len
    push remaining_text
    push dword [stdout_handle]
    call _WriteFile@20

.status_done:
    push 0
    push bytes_written
    push total_text_len
    push total_text
    push dword [stdout_handle]
    call _WriteFile@20

    mov eax, [task_count]
    call num_to_string

    push 0
    push bytes_written
    push eax
    push num_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    mov byte [input_buffer], '/'

    push 0
    push bytes_written
    push 1
    push input_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    mov eax, [max_tasks_limit]
    call num_to_string

    push 0
    push bytes_written
    push eax
    push num_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    mov byte [input_buffer], ' '
    mov byte [input_buffer + 1], 't'
    mov byte [input_buffer + 2], 'a'
    mov byte [input_buffer + 3], 's'
    mov byte [input_buffer + 4], 'k'
    mov byte [input_buffer + 5], 's'
    mov byte [input_buffer + 6], 13
    mov byte [input_buffer + 7], 10

    push 0
    push bytes_written
    push 8
    push input_buffer
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push separator_thin_len
    push separator_thin
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push menu_part1_len
    push menu_part1
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push menu_part2_len
    push menu_part2
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push separator_thin_len
    push separator_thin
    push dword [stdout_handle]
    call _WriteFile@20

    push 0
    push bytes_written
    push choose_option_len
    push choose_option
    push dword [stdout_handle]
    call _WriteFile@20

    ret

; Number to string conversion
num_to_string:
    push ebx
    push ecx
    push edx

    lea edi, [num_buffer]
    mov ecx, 10
    xor ebx, ebx

    cmp eax, 0
    jne .convert_loop
    mov byte [edi], '0'
    inc ebx
    jmp .done

.convert_loop:
    cmp eax, 0
    je .reverse

    xor edx, edx
    div ecx
    add dl, '0'
    push edx
    inc ebx
    jmp .convert_loop

.reverse:
    lea edi, [num_buffer]
    mov ecx, ebx

.pop_digits:
    cmp ecx, 0
    je .done
    pop edx
    mov [edi], dl
    inc edi
    dec ecx
    jmp .pop_digits

.done:
    mov eax, ebx
    pop edx
    pop ecx
    pop ebx
    ret

; Read user input
read_input:
    lea edi, [input_buffer]
    mov ecx, 1024
    xor al, al
    rep stosb

    push 0
    push bytes_read
    push 1023
    push input_buffer
    push dword [stdin_handle]
    call _ReadFile@20

    mov ecx, [bytes_read]
    cmp ecx, 0
    je .done

    lea edi, [input_buffer]
    add edi, ecx

.remove_loop:
    cmp ecx, 0
    je .done
    dec edi
    dec ecx

    movzx eax, byte [edi]
    cmp al, 13
    je .remove_char
    cmp al, 10
    je .remove_char
    jmp .done

.remove_char:
    mov byte [edi], 0
    jmp .remove_loop

.done:
    ret

; Print newline
print_newline:
    push 0
    push bytes_written
    push newline_len
    push newline
    push dword [stdout_handle]
    call _WriteFile@20
    ret

; Print invalid option message
print_invalid:
    push 0
    push bytes_written
    push msg_invalid_len
    push msg_invalid
    push dword [stdout_handle]
    call _WriteFile@20
    ret

; Cancel operation handler
cancel_operation:
    push 0
    push bytes_written
    push msg_operation_cancelled_len
    push msg_operation_cancelled
    push dword [stdout_handle]
    call _WriteFile@20
    ret

; -----------------------------------------------------------------------------
; PROGRAM EXIT
; -----------------------------------------------------------------------------
exit_program:
    push 0
    call _ExitProcess@4