global _start
section .data
msg db "Mashed Potatoes!!!", 0x0a ; oxoa makes new line
len equ $ - msg

section .text;


_start:
mov eax, 4
mov ebx, 1
mov ecx, msg
mov edx, len
int 0x80
mov eax, 1
mov ebx, 0
int 0x80