section .text
global sunfade

sunfade:
    push ebp
    mov ebp, esp

    ; Save the function arguments
    push ebx
    push esi
    push edi

    mov ecx, [ebp + 8]      ; img
                            ;[ebp + 12]   ; width
                            ;[ebp + 16]   ; height
                            ;[ebp + 20]   ; dist
                            ;[ebp + 24]   ; x
                            ;[ebp + 28]   ; y

init:
    mov eax, [ebp + 12]
    mov esi, 0x0                ; current x starting with 0, in first pixel will be inc to 1
    mov edi, 0x0                ; current y starting with 0, in first pixel will be inc to 1

nextrow:
    cmp edi, [ebp + 16]
    je  fin
    inc edi
    mov esi, 0x0

nextpixel:
    inc esi
    mov eax, [ebp + 24]
    sub eax, esi
    imul eax, eax
    mov edx, [ebp + 28]
    sub edx, edi
    imul edx, edx
    add eax, edx                ; eax - current distance^2 = delta x^2 + delta y^2 
    mov edx, [ebp + 20]
    imul edx, edx               ; edx - distance^2

    cmp eax, 0
    je  centre
    cmp eax, edx
    jge  skipcoloring

    xor ebx, ebx
    mov bl, 0xFF
    mov bh, [ecx]
    sub bl, bh
    mov bh, 0x0

    imul eax, ebx               ; now in eax color_diff * current_dist^2
    mov bx, dx                  ; now in bx - distance^2
    xor edx, edx
    div ebx                      ; result in eax
    mov edx, 0xFF
    sub edx, eax
    mov byte [ecx], dl

; second byte of a pixel
    mov eax, [ebp + 24]
    sub eax, esi
    imul eax, eax
    mov edx, [ebp + 28]
    sub edx, edi
    imul edx, edx
    add eax, edx                ; eax - current distance^2
    mov edx, [ebp + 20]
    imul edx, edx

    xor ebx, ebx
    mov bl, 0xFF
    mov bh, [ecx+1]
    sub bl, bh
    mov bh, 0x0                 ; ebx - color difference
    imul eax, ebx               ; now in eax color_diff * current_dist^2
    mov bx, dx                  ; now in bx - distance^2
    xor edx, edx
    div ebx                      ; result in eax
    mov edx, 0xFF
    sub edx, eax
    mov byte [ecx+1], dl
    

; third byte of a pixel
    mov eax, [ebp + 24]
    sub eax, esi
    imul eax, eax
    mov edx, [ebp + 28]
    sub edx, edi
    imul edx, edx
    add eax, edx                ; eax - current distance^2
    mov edx, [ebp + 20]
    imul edx, edx

    xor ebx, ebx
    mov bl, 0xFF
    mov bh, [ecx+2]
    sub bl, bh
    mov bh, 0x0                 ; ebx - color difference
    imul eax, ebx               ; now in eax color_diff * current_dist^2
    mov bx, dx                  ; now in bx - distance^2
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
    mov esp, ebp
    pop ebp
    ret
