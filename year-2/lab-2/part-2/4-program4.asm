global _start

section .text
_start:
mov ebx, 1
mov ecx, 4

placeholder:
add ebx, ebx
dec ecx
cmp ecx, 0
jg placeholder
mov eax, 1
int 0x80