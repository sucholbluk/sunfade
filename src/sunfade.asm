section .text
global sunfade

sunfade:
    push ebp
    mov ebp, esp
    sub esp, 4              ;will be stored current distance^2

    ; Save the function arguments
    push ebx
    push esi
    push edi

    mov ecx, [ebp + 8]      ; img
                            ;[ebp + 12]   ; width
                            ;[ebp + 16]   ; height
                            ;[ebp + 20]   ; dist, later dist^2
                            ;[ebp + 24]   ; x
                            ;[ebp + 28]   ; y

init:
    mov eax, [ebp + 12]
    xor edi, edi                ; current y starting with 0, in first pixel will be inc to 1
    mov edx, [ebp + 20]
    imul edx, edx
    mov [ebp + 20], edx         ; now [ebp + 20] dist^2

nextrow:
    cmp edi, [ebp + 16]
    je  fin
    inc edi
    xor esi, esi                ; setting x to 0

nextpixel:
    inc esi
    mov eax, [ebp + 24]
    sub eax, esi
    imul eax, eax
    mov edx, [ebp + 28]
    sub edx, edi
    imul edx, edx
    add eax, edx                ; eax - current distance^2 = delta x^2 + delta y^2
    mov ebx, [ebp + 20]         ; ebx - distance^2
    xor edx, edx

    test eax, eax
    je  centre
    cmp eax, ebx
    jge  skipcoloring
    
    mov [ebp - 4], eax          ; save current distance^2

    mov dl, 0xFF
    mov dh, [ecx]
    sub dl, dh
    mov dh, 0x0                 ; ebx - color difference

    imul eax, edx               ; now in eax color_diff * current_dist^2
    xor edx, edx
    div ebx                      ; result in eax
    mov edx, 0xFF
    sub edx, eax
    mov byte [ecx], dl

; second byte of a pixel
    mov eax, [ebp - 4]          
    mov ebx, [ebp + 20]

    mov dl, 0xFF
    mov dh, [ecx+1]
    sub dl, dh
    mov dh, 0x0                 ; ebx - color difference
    imul eax, edx               ; now in eax color_diff * current_dist^2
    xor edx, edx
    div ebx                      ; result in eax
    mov edx, 0xFF
    sub edx, eax
    mov byte [ecx+1], dl
    
; third byte of a pixel
    mov eax, [ebp - 4]                ; eax - current distance^2
    mov ebx, [ebp + 20]

    mov dl, 0xFF
    mov dh, [ecx+2]
    sub dl, dh
    mov dh, 0x0                 ; ebx - color difference

    imul eax, edx               ; now in eax color_diff * current_dist^2
    xor edx, edx
    div ebx                      ; result in eax

    mov edx, 0xFF
    sub edx, eax
    mov byte [ecx+2], dl
    add ecx, 3

    cmp esi, [ebp + 12]
    jl  nextpixel

    cmp esi, [ebp + 12]
    je  padding


skipcoloring:
    add ecx, 3
    cmp esi, [ebp + 12]
    jne nextpixel
padding:
    mov eax, [ebp + 12]
    and eax, 0x3
    add ecx, eax
    jmp nextrow


centre:
    mov byte [ecx], 0xFF
    mov byte [ecx+1], 0xFF
    mov byte [ecx+2], 0xFF
    add ecx, 0x3
    cmp esi, [ebp + 12]
    jl  nextpixel
    cmp esi, [ebp + 12]
    je  padding

fin:
    pop edi
    pop esi
    pop ebx
    ; mov esp, ebp
    add esp, 4
    pop ebp
    ret
