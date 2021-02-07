global _start

_start:
    push 21
    call addNumbers
    call subtractNumbers
    call multiplyNumbers
    call divideNumbers
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

subtractNumbers:
    push ebp
    mov ebp, esp
    mov eax, [ebp+9]
    sub eax, eax
    mov esp, ebp
    pop ebp
    ret

multiplyNumbers:
    push ebp
    mov ebp, esp
    mov eax, [ebp+10]
    mul eax, eax
    mov esp, ebp
    pop ebp
    ret

divideNumbers:
    push ebp
    mov ebp, esp
    mov eax, [ebp+11]
    div eax, eax
    mov esp, ebp
    pop ebp
    ret