global _start

_start:
push 21
call addNumbers
mov ebx, eax
mov eax, 1
int 0x80

addNumbers:
push ebp
mov ebp, esp
mov eax, [ebp+8]
add eax, eax
mov esp, ebp
pop ebp
ret