; To-Do List Application for Windows x86 (32-bit)
; FINAL VERSION - Correct Prompts
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

section .data
    STD_OUTPUT_HANDLE equ -11
    STD_INPUT_HANDLE equ -10
    MAX_TASKS equ 30
    TASK_SIZE equ 64
    STATUS_OFFSET equ 63

    GENERIC_READ equ 0x80000000
    GENERIC_WRITE equ 0x40000000
    CREATE_ALWAYS equ 2
    OPEN_EXISTING equ 3
    FILE_ATTRIBUTE_NORMAL equ 0x80
    INVALID_HANDLE_VALUE equ -1

    filename db "tasks.dat", 0

    separator_thin db 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 196, 13, 10
    separator_thin_len equ $ - separator_thin

    separator_top db 201, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 187, 13, 10
    separator_top_len equ $ - separator_top

    separator_bottom db 200, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 188, 13, 10
    separator_bottom_len equ $ - separator_bottom

    border_left db 186, " "
    border_left_len equ $ - border_left

    newline_only db 13, 10
    newline_only_len equ $ - newline_only

    spinner_1 db "  |", 13, 10
    spinner_1_len equ $ - spinner_1

    spinner_2 db "  /", 13, 10
    spinner_2_len equ $ - spinner_2

    spinner_3 db "  -", 13, 10
    spinner_3_len equ $ - spinner_3

    spinner_4 db "  \", 13, 10
    spinner_4_len equ $ - spinner_4

    saving_msg db "  Saving", 13, 10
    saving_msg_len equ $ - saving_msg

    loading_msg db "  Loading", 13, 10
    loading_msg_len equ $ - loading_msg

    header_welcome db 13, 10, "Welcome to Your To-Do List!", 13, 10
    header_welcome_len equ $ - header_welcome

    header_add db 13, 10, "Adding New Task", 13, 10
    header_add_len equ $ - header_add

    header_view db 13, 10, "Your Task List", 13, 10
    header_view_len equ $ - header_view

    header_update db 13, 10, "Updating Task", 13, 10
    header_update_len equ $ - header_update

    header_delete db 13, 10, "Deleting Tasks", 13, 10
    header_delete_len equ $ - header_delete

    header_toggle db 13, 10, "Managing Task Status", 13, 10
    header_toggle_len equ $ - header_toggle

    header_save db 13, 10, "Saving Your Tasks", 13, 10
    header_save_len equ $ - header_save

    header_load db 13, 10, "Loading Your Tasks", 13, 10
    header_load_len equ $ - header_load

    header_search db 13, 10, "Search Tasks", 13, 10
    header_search_len equ $ - header_search

    prompt_search db "  Enter search term: "
    prompt_search_len equ $ - prompt_search

    msg_search_results db 13, 10, "  >>> Found matching tasks:", 13, 10
    msg_search_results_len equ $ - msg_search_results

    msg_no_search_results db 13, 10, "  ... No tasks found matching your search", 13, 10
    msg_no_search_results_len equ $ - msg_no_search_results

; ===== MODIFY TASK SLOTS FEATURE =====
header_modify_slots db 13, 10, "Modifying Task Slots", 13, 10
header_modify_slots_len equ $ - header_modify_slots

modify_slots_menu db 13, 10, " Select task slot limit:", 13, 10
modify_slots_menu_len equ $ - modify_slots_menu

modify_option_1 db " 1. 10 Tasks (Default)", 13, 10
modify_option_1_len equ $ - modify_option_1

modify_option_2 db " 2. 15 Tasks", 13, 10
modify_option_2_len equ $ - modify_option_2

modify_option_3 db " 3. 20 Tasks", 13, 10
modify_option_3_len equ $ - modify_option_3

modify_option_4 db " 4. 30 Tasks", 13, 10
modify_option_4_len equ $ - modify_option_4

modify_prompt db " Enter choice: "
modify_prompt_len equ $ - modify_prompt

msg_slots_10 db 13, 10, " >>> Task limit set to 10 slots", 13, 10
msg_slots_10_len equ $ - msg_slots_10

msg_slots_15 db 13, 10, " >>> Task limit set to 15 slots", 13, 10
msg_slots_15_len equ $ - msg_slots_15

msg_slots_20 db 13, 10, " >>> Task limit set to 20 slots", 13, 10
msg_slots_20_len equ $ - msg_slots_20

msg_slots_30 db 13, 10, " >>> Task limit set to 30 slots", 13, 10
msg_slots_30_len equ $ - msg_slots_30

msg_slot_restored_10 db 13, 10, " >>> Slot limit restored: 10 slots", 13, 10
msg_slot_restored_10_len equ $ - msg_slot_restored_10

msg_slot_restored_15 db 13, 10, " >>> Slot limit restored: 15 slots", 13, 10
msg_slot_restored_15_len equ $ - msg_slot_restored_15

msg_slot_restored_20 db 13, 10, " >>> Slot limit restored: 20 slots", 13, 10
msg_slot_restored_20_len equ $ - msg_slot_restored_20

msg_slot_restored_30 db 13, 10, " >>> Slot limit restored: 30 slots", 13, 10
msg_slot_restored_30_len equ $ - msg_slot_restored_30

hint_add_task db 13, 10, "  Tip: Separate multiple tasks with semicolon (;)", 13, 10, "  Example: task1;task2;task3", 13, 10
hint_add_task_len equ $ - hint_add_task

hint_delete_selection db 13, 10, "  Tip: Enter 0 to cancel, or task numbers separated by space", 13, 10, "  Example: 1 3 5", 13, 10
hint_delete_selection_len equ $ - hint_delete_selection

hint_toggle_multiple db 13, 10, "  Tip: Enter task numbers separated by space", 13, 10, "  Example: 2 4 6", 13, 10
hint_toggle_multiple_len equ $ - hint_toggle_multiple

hint_esc_cancel db 13, 10, " >>> Tip: Press 0 then Enter to cancel any operation", 13, 10
hint_esc_cancel_len equ $ - hint_esc_cancel



delete_selection_prompt db " Enter task numbers: "
delete_selection_prompt_len equ $ - delete_selection_prompt

msg_operation_cancelled db 13, 10, " ... Operation cancelled", 13, 10
msg_operation_cancelled_len equ $ - msg_operation_cancelled

toggle_multiple_prompt db " Enter task numbers: "
toggle_multiple_prompt_len equ $ - toggle_multiple_prompt

msg_tasks_toggled db 13, 10, " >>> Tasks toggled successfully!", 13, 10
msg_tasks_toggled_len equ $ - msg_tasks_toggled

msg_no_valid_tasks db 13, 10, "  ... No valid tasks toggled", 13, 10
msg_no_valid_tasks_len equ $ - msg_no_valid_tasks

msg_tasks_added db 13, 10, " >>> Tasks added successfully!", 13, 10
msg_tasks_added_len equ $ - msg_tasks_added

msg_task_updated db 13, 10, "  >>> Task updated successfully!", 13, 10
msg_task_updated_len equ $ - msg_task_updated


    menu_header db 13, 10, "===== TO-DO LIST APPLICATION =====", 13, 10
    menu_header_len equ $ - menu_header

    status_header db "Status: "
    status_header_len equ $ - status_header

    completed_text db " completed, "
    completed_text_len equ $ - completed_text

    remaining_text db " remaining"
    remaining_text_len equ $ - remaining_text

    total_text db 13, 10, "Total: "
    total_text_len equ $ - total_text


    menu_part1 db "  1. Add Task", 13, 10, "  2. View All Tasks", 13, 10, "  3. Update Task", 13, 10, "  4. Delete Task", 13, 10
    menu_part2 db "  5. Toggle Complete", 13, 10, "  6. Save Tasks", 13, 10, "  7. Load Tasks", 13, 10, "  8. Modify Task Slots", 13, 10, "  9. Search Tasks", 13, 10, "  10. Exit", 13, 10
    menu_part1_len equ menu_part2 - menu_part1
    menu_part2_len equ $ - menu_part2

    delete_mode_prompt db 13, 10, "  Choose delete mode:", 13, 10, "    1. Delete All Tasks", 13, 10, "    2. Delete Selection", 13, 10, "  Enter choice: "
    delete_mode_prompt_len equ $ - delete_mode_prompt

    delete_selection_hint db 13, 10, "  Enter task numbers separated by space:", 13, 10, "  Example: 1 3 5", 13, 10, "  Enter: "
    delete_selection_hint_len equ $ - delete_selection_hint

    choose_option db "  Choose option: "
    choose_option_len equ $ - choose_option

    checkbox_incomplete db 91, 32, 93, 32
    checkbox_incomplete_len equ $ - checkbox_incomplete

    checkbox_complete db 91, 43, 93, 32
    checkbox_complete_len equ $ - checkbox_complete

    prompt_task db 13, 10, "  Enter task (max 60 chars): "
    prompt_task_len equ $ - prompt_task

    prompt_update db 13, 10, "  Enter task number to update: "
    prompt_update_len equ $ - prompt_update

    prompt_new_task db 13, 10, "  Enter new task text: "
    prompt_new_task_len equ $ - prompt_new_task

    prompt_delete db 13, 10, "  Enter task number to delete: "
    prompt_delete_len equ $ - prompt_delete

    prompt_toggle db 13, 10, "  Enter task number to toggle: "
    prompt_toggle_len equ $ - prompt_toggle

    msg_added db 13, 10, "  >>> Task added successfully!", 13, 10
    msg_added_len equ $ - msg_added

    msg_updated db 13, 10, "  >>> Task updated successfully!", 13, 10
    msg_updated_len equ $ - msg_updated

    msg_deleted db 13, 10, "  >>> Task(s) deleted!", 13, 10
    msg_deleted_len equ $ - msg_deleted

    msg_deleted_all db 13, 10, "  >>> All tasks deleted!", 13, 10
    msg_deleted_all_len equ $ - msg_deleted_all

    msg_toggled db 13, 10, "  >>> Task status toggled!", 13, 10
    msg_toggled_len equ $ - msg_toggled

    msg_saved db 13, 10, "  >>> Tasks saved to file!", 13, 10
    msg_saved_len equ $ - msg_saved

    msg_loaded db 13, 10, "  >>> Tasks loaded from file!", 13, 10
    msg_loaded_len equ $ - msg_loaded

    msg_save_error db 13, 10, "  ... Error saving to file", 13, 10
    msg_save_error_len equ $ - msg_save_error

    msg_load_error db 13, 10, "  ... No saved tasks found", 13, 10
    msg_load_error_len equ $ - msg_load_error

    msg_full db 13, 10, "  ... Task list is full", 13, 10
    msg_full_len equ $ - msg_full

    msg_empty db 13, 10, "  ... No tasks in list", 13, 10
    msg_empty_len equ $ - msg_empty

    msg_invalid db 13, 10, "  ... Invalid option", 13, 10
    msg_invalid_len equ $ - msg_invalid

    newline db 13, 10
    newline_len equ $ - newline

    task_item_prefix db "  "
    task_item_prefix_len equ $ - task_item_prefix

    dot_space db ". "
    dot_space_len equ $ - dot_space

section .bss
    max_tasks_limit resd 1
    toggle_count resd 1
    added_count resd 1
    tasks resb MAX_TASKS * TASK_SIZE
    task_count resd 1
    completed_count resd 1
    first_run resd 1
    input_buffer resb 64
    bytes_read resd 1
    bytes_written resd 1
    stdout_handle resd 1
    stdin_handle resd 1
    file_handle resd 1
    num_buffer resb 12
    delete_flags resb MAX_TASKS

section .text
main:
    push STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov [stdout_handle], eax

    push STD_INPUT_HANDLE
    call _GetStdHandle@4
    mov [stdin_handle], eax

    mov dword [task_count], 0
    mov dword [max_tasks_limit], 10
    mov dword [completed_count], 0
    mov dword [first_run], 1

main_loop:
    call display_menu
    call read_input
    movzx eax, byte [input_buffer]

    mov dword [first_run], 0

    cmp al, '1'
    je add_task
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
    cmp al, '1'
    je check_exit
    cmp al, '0'
    je exit_program
    jmp main_loop

check_exit:
    ; Check if the input was "10" for exit
    cmp byte [input_buffer+1], '0'
    je exit_program
    jmp add_task  ; If not "10", treat as "1" for add task

    call print_invalid
    jmp main_loop

modify_slots:
    push 0
    push bytes_written
    push header_modify_slots_len
    push header_modify_slots
    push dword [stdout_handle]
    call _WriteFile@20

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

    push 0
    push bytes_written
    push modify_prompt_len
    push modify_prompt
    push dword [stdout_handle]
    call _WriteFile@20

    call read_input
    movzx eax, byte [input_buffer]

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

search_tasks:
    mov eax, [task_count]
    cmp eax, 0
    je task_list_empty

    push 0
    push bytes_written
    push header_search_len
    push header_search
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
    xor ebx, ebx
    mov dword [toggle_count], 0  ; Use as match counter

.search_loop:
    cmp ebx, [task_count]
    jge .search_done

    ; Get current task
    mov eax, ebx
    mov ecx, TASK_SIZE
    mul ecx
    lea esi, [tasks + eax]

    ; Search in task text
    mov edi, input_buffer
    call string_contains

    cmp eax, 1
    jne .next_task

    ; Found match - display the task
    cmp dword [toggle_count], 0
    jne .display_task
    
    ; First match - show results header
    push 0
    push bytes_written
    push msg_search_results_len
    push msg_search_results
    push dword [stdout_handle]
    call _WriteFile@20

.display_task:
    ; First match - show results header and top border
    cmp dword [toggle_count], 1
    jne .skip_header
    
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

.skip_header:
    call print_single_task
    inc dword [toggle_count]

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
    xor ebx, ebx

.parse_loop:
    movzx eax, byte [esi + ebx]
    cmp al, 0
    je .finish_adding
    cmp al, 13
    je .finish_adding
    cmp al, 10
    je .finish_adding

    mov eax, [task_count]
    mov ecx, [max_tasks_limit]
    cmp eax, ecx
    jge .finish_adding

    mov eax, [task_count]
    mov ecx, TASK_SIZE
    mul ecx
    lea edi, [tasks + eax]

    xor ecx, ecx

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
    cmp ecx, TASK_SIZE - 1
    jge .save_task

    mov byte [edi + ecx], al
    inc ebx
    inc ecx
    jmp .copy_chars

.save_task:
    mov byte [edi + ecx], 0
    inc dword [task_count]

    cmp byte [esi + ebx], ';'
    jne .finish_adding
    inc ebx
    jmp .parse_loop

.finish_adding:
    push 0
    push bytes_written
    push msg_tasks_added_len
    push msg_tasks_added
    push dword [stdout_handle]
    call _WriteFile@20

.skip_success_message:
    jmp main_loop
    jmp .skip_success_message

task_list_full:
    push 0
    push bytes_written
    push msg_full_len
    push msg_full
    push dword [stdout_handle]
    call _WriteFile@20
    jmp main_loop

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

display_menu:
    call print_newline

    cmp dword [first_run], 1
    je .show_welcome

    movzx eax, byte [input_buffer]
    cmp al, '1'
    je .show_add
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
    jmp .show_menu

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

read_input:
    lea edi, [input_buffer]
    mov ecx, 64
    xor al, al
    rep stosb

    push 0
    push bytes_read
    push 63
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

print_newline:
    push 0
    push bytes_written
    push newline_len
    push newline
    push dword [stdout_handle]
    call _WriteFile@20
    ret

print_invalid:
    push 0
    push bytes_written
    push msg_invalid_len
    push msg_invalid
    push dword [stdout_handle]
    call _WriteFile@20
    ret

cancel_operation:
    push 0
    push bytes_written
    push msg_operation_cancelled_len
    push msg_operation_cancelled
    push dword [stdout_handle]
    call _WriteFile@20
    ret

exit_program:
    push 0
    call _ExitProcess@4
