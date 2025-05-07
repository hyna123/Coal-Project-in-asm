

.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE Irvine32.inc

.data
    prompt1 BYTE "Enter a number to check if it's prime: ", 0
    isPrimeMsg BYTE "The number is prime.", 0
    notPrimeMsg BYTE "The number is not prime.", 0
    invalidMsg BYTE "Please enter a number greater than 1.", 0
    num DWORD ?

.code
main PROC
    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov num, eax
    
    cmp eax, 1
    jg CheckPrime
    mov edx, OFFSET invalidMsg
    call WriteString
    call Crlf
    jmp Done
    
CheckPrime:
    cmp eax, 2
    je Prime
    
    test eax, 1
    jz NotPrime
    
    mov ebx, 3
    mov ecx, eax
    
    mov edx, 0
    mov eax, ecx
    call SqrtEstimate
    mov esi, eax
    
    mov eax, ecx
    
CheckDivisor:
    cmp ebx, esi
    jg Prime
    
    mov edx, 0
    div ebx
    cmp edx, 0
    je NotPrime
    
    mov eax, ecx
    add ebx, 2
    jmp CheckDivisor
    
Prime:
    mov edx, OFFSET isPrimeMsg
    call WriteString
    call Crlf
    jmp Done
    
NotPrime:
    mov edx, OFFSET notPrimeMsg
    call WriteString
    call Crlf
    
Done:
    invoke ExitProcess, 0
main ENDP

SqrtEstimate PROC
    push ebx
    push ecx
    push edx
    
    mov ebx, eax
    xor ecx, ecx
    
    mov eax, 1
    shl eax, 30
    
FindPower:
    cmp eax, ebx
    jbe FoundPower
    shr eax, 2
    jmp FindPower
    
FoundPower:
    mov edx, 0
    
SqrtLoop:
    or ecx, eax
    mov edx, ecx
    imul edx, edx
    
    cmp edx, ebx
    jbe BitSet
    xor ecx, eax
    
BitSet:
    shr eax, 1
    test eax, eax
    jnz SqrtLoop
    
    mov eax, ecx
    
    pop edx
    pop ecx
    pop ebx
    ret
SqrtEstimate ENDP

END main