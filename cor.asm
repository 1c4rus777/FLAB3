%macro print_text 2
   mov ecx, %1
   mov edx, %2
   call print_proc
%endmacro
section .data
   title_msg db 10, "===== CERTIFICATE OF REGISTRATION =====", 10
   title_len equ $-title_msg
   ask_name db "Enter Student Name: "
   ask_name_len equ $-ask_name
   ask_id db "Enter Student Number: "
   ask_id_len equ $-ask_id
   ask_course db "Enter Course: "
   ask_course_len equ $-ask_course
   ask_units db 10, "Enter Total Units: "
   ask_units_len equ $-ask_units
   line db "========================================", 10
   line_len equ $-line
   label_name db "Student Name: "
   label_name_len equ $-label_name
   label_id db "Student Number: "
   label_id_len equ $-label_id
   label_course db "Course: "
   label_course_len equ $-label_course
   year_msg db "Year Level: 3", 10
   year_len equ $-year_msg
   sem_msg db "Semester: 1st, SY 2026-2027", 10
   sem_len equ $-sem_msg
   subjects db 10, "ENROLLED SUBJECTS", 10
            db "CS0003  - Computer Systems & Architecture", 10
            db "CS0003L - Computer Systems & Architecture Lab", 10
            db "CS0011  - Mobile Programming", 10
            db "CS0019  - Modeling and Simulation", 10
            db "CS0025  - Software Engineering 1", 10
            db "CS0037  - Social Issues and Professional Practice", 10
            db "GED0004 - Physical Education 1", 10
   subjects_len equ $-subjects
   assessment_msg db 10, "===== ASSESSMENT OF FEES =====", 10
   assessment_len equ $-assessment_msg
   units_msg db "Total Units: "
   units_len equ $-units_msg
   tuition_msg db "Tuition Fee: PHP "
   tuition_len equ $-tuition_msg
   misc_msg db "Miscellaneous Fee: PHP 12305", 10
   misc_len equ $-misc_msg
   id_msg db "ID Validation Fee: PHP 80", 10
   id_len equ $-id_msg
   lab1_msg db "CS0019 Lab Fee: PHP 6209", 10
   lab1_len equ $-lab1_msg
   lab2_msg db "CS0003 Lab Fee: PHP 4008", 10
   lab2_len equ $-lab2_msg
   lab3_msg db "CS0025 Lab Fee: PHP 4008", 10
   lab3_len equ $-lab3_msg
   lab4_msg db "CS0011 Lab Fee: PHP 6276", 10
   lab4_len equ $-lab4_msg
   total_msg db 10, "TOTAL ASSESSMENT: PHP "
   total_len equ $-total_msg
   payment_msg db 10, "===== PAYMENT BREAKDOWN =====", 10
   payment_len equ $-payment_msg
   down_msg db "Down Payment (40%): PHP "
   down_len equ $-down_msg
   mid_msg db "Midterm (30%): PHP "
   mid_len equ $-mid_msg
   final_msg db "Final (30%): PHP "
   final_len equ $-final_msg
   newline db 10
   rate dd 2108
   misc_fee dd 12305
   id_fee dd 80
   lab1 dd 6209
   lab2 dd 4008
   lab3 dd 4008
   lab4 dd 6276
section .bss
   student_name resb 100
   student_id resb 30
   student_course resb 50
   units_input resb 20
   name_size resd 1
   id_size resd 1
   course_size resd 1
   units resd 1
   tuition resd 1
   total resd 1
   downpay resd 1
   midterm resd 1
   finalpay resd 1
   num_buffer resb 20
section .text
   global _start
_start:
; ===== PART 1: INPUT =====
   print_text title_msg, title_len
   print_text ask_name, ask_name_len
   mov ecx, student_name
   mov edx, 100
   call input_proc
   mov [name_size], eax
   print_text ask_id, ask_id_len
   mov ecx, student_id
   mov edx, 30
   call input_proc
   mov [id_size], eax
   print_text ask_course, ask_course_len
   mov ecx, student_course
   mov edx, 50
   call input_proc
   mov [course_size], eax
; ===== PART 2: PRINT COR =====
   print_text newline, 1
   print_text line, line_len
   print_text title_msg, title_len
   print_text label_name, label_name_len
   print_text student_name, [name_size]
   print_text newline, 1
   print_text label_id, label_id_len
   print_text student_id, [id_size]
   print_text newline, 1
   print_text label_course, label_course_len
   print_text student_course, [course_size]
   print_text newline, 1
   print_text year_msg, year_len
   print_text sem_msg, sem_len
   print_text subjects, subjects_len
   print_text line, line_len
; ===== PART 3: INPUT AND COMPUTE =====
   print_text ask_units, ask_units_len
   mov ecx, units_input
   mov edx, 20
   call input_proc
   mov esi, units_input
   call string_to_int
   mov [units], eax
   call compute_tuition
   call compute_total
   call compute_payments
; ===== DISPLAY COMPUTATION =====
   print_text assessment_msg, assessment_len
   print_text units_msg, units_len
   mov eax, [units]
   call print_number
   print_text newline, 1
   print_text tuition_msg, tuition_len
   mov eax, [tuition]
   call print_number
   print_text newline, 1
   print_text misc_msg, misc_len
   print_text id_msg, id_len
   print_text lab1_msg, lab1_len
   print_text lab2_msg, lab2_len
   print_text lab3_msg, lab3_len
   print_text lab4_msg, lab4_len
   print_text total_msg, total_len
   mov eax, [total]
   call print_number
   print_text newline, 1
   print_text payment_msg, payment_len
   print_text down_msg, down_len
   mov eax, [downpay]
   call print_number
   print_text newline, 1
   print_text mid_msg, mid_len
   mov eax, [midterm]
   call print_number
   print_text newline, 1
   print_text final_msg, final_len
   mov eax, [finalpay]
   call print_number
   print_text newline, 1
   print_text line, line_len
   mov eax, 1
   xor ebx, ebx
   int 0x80
; ===== PROCEDURES =====
print_proc:
   push ebx
   mov eax, 4
   mov ebx, 1
   int 0x80
   pop ebx
   ret
input_proc:
   mov eax, 3
   mov ebx, 0
   int 0x80
   cmp eax, 0
   jle .empty
   cmp byte [ecx + eax - 1], 10
   jne .done
   dec eax
   ret
.empty:
   xor eax, eax
.done:
   ret
string_to_int:
   xor eax, eax
   xor ebx, ebx
.convert:
   mov bl, [esi]
   cmp bl, '0'
   jb .done
   cmp bl, '9'
   ja .done
   sub bl, '0'
   imul eax, eax, 10
   add eax, ebx
   inc esi
   jmp .convert
.done:
   ret
compute_tuition:
   mov eax, [units]
   mul dword [rate]
   mov [tuition], eax
   ret
compute_total:
   mov eax, [tuition]
   add eax, [misc_fee]
   add eax, [id_fee]
   add eax, [lab1]
   add eax, [lab2]
   add eax, [lab3]
   add eax, [lab4]
   mov [total], eax
   ret
compute_payments:
   mov eax, [total]
   mov ebx, 40
   mul ebx
   mov ebx, 100
   div ebx
   mov [downpay], eax
   mov eax, [total]
   mov ebx, 30
   mul ebx
   mov ebx, 100
   div ebx
   mov [midterm], eax
   mov eax, [total]
   sub eax, [downpay]
   sub eax, [midterm]
   mov [finalpay], eax
   ret
print_number:
   mov edi, num_buffer + 20
   mov ebx, 10
   xor ecx, ecx
.convert:
   xor edx, edx
   div ebx
   add dl, '0'
   dec edi
   mov [edi], dl
   inc ecx
   test eax, eax
   jnz .convert
   mov edx, ecx
   mov ecx, edi
   call print_proc
   ret