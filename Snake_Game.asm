[org 0x100]
jmp start
;------------------------ Clear screen --------------------------------------------
clrscr:
   mov ax, 0xb800
   mov es, ax
   mov di, 0
   mov ah, 0x07
   mov al, ' '
   mov cx, 2000          ; 2000 characters (80*25)
loop1:
   mov [es:di], ax
   add di, 2
   loop loop1
   ret 

;------------------------ Delay --------------------------------------------------
delay:
   mov dx, 1000
loop2:
   mov si, 250
loop3:
   dec si
   jnz loop3
   dec dx
   jnz loop2
   ret 

;------------------------ Main Program --------------------------------------------
start:
    call clrscr
    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07
    mov al, '-'
    mov di, 0
    
border_top:
    mov [es:di], ax
    add di, 2
    cmp di, 160           ; 80 characters * 2 = 160 bytes
    jl border_top
    
    ; Bottom border (row 24)
    mov di, 3840          ; Row 24: 24 * 160 = 3840
    mov al, '-'
    
border_bottom:
    mov [es:di], ax
    add di, 2
    cmp di, 4000          ; 3840 + 160 = 4000
    jl border_bottom
    
    ; Left border
    mov di, 160           ; Start at row 1
    mov al, '|'
    
border_left:
    mov [es:di], ax
    add di, 160
    cmp di, 3840          ; Stop before row 24
    jl border_left
    
    ; Right border (column 79)
    mov di, 318           ; Row 1, column 79: 160 + (79*2) = 318
    mov al, '|'
    
border_right:
    mov [es:di], ax
    add di, 160
    cmp di, 3998          ; Row 24, column 79: 3840 + 158 = 3998
    jl border_right
    
    ; Star animation - Phase 1: Left to Right (top)
    mov di, 164           ; Row 1, Column 2: 160 + (2*2) = 164
    
phase1_right:
    ; Draw 3 stars
    mov ah, 0x07
    mov al, '*'
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    
    call delay
    
    push di
    
    ; Erase 3 stars
    mov ah, 0x07
    mov al, ' '
    mov [es:di], ax
    sub di, 2
    mov [es:di], ax
    sub di, 2
    mov [es:di], ax
    
    pop di
    
    ; Check if reached right side (column 76)
    mov bx, di
    push ax
    push dx
    mov ax, bx
    mov dx, 0
    mov cx, 160
    div cx                ; AX = row, DX = column offset
    
    cmp dx, 152           ; Column 76: 76*2 = 152
    pop dx
    pop ax
    jge phase2_down       ; If >= column 76, go to phase 2
    
    ; Move right
    add di, 2
    jmp phase1_right
    
phase2_down:
    ; Phase 2: Top to Bottom (right side)
    ; di is currently at row 1, column 78 (3rd star position)
    
phase2_down_loop:
    ; Draw 3 stars vertically
    mov ah, 0x07
    mov al, '*'
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    
    call delay
    
    push di
    
    ; Erase 3 stars
    mov ah, 0x07
    mov al, ' '
    mov [es:di], ax
    sub di, 160
    mov [es:di], ax
    sub di, 160
    mov [es:di], ax
    
    pop di
    
    ; Check if reached bottom (row 21)
    mov bx, di
    push ax
    push dx
    mov ax, bx
    mov dx, 0
    mov cx, 160
    div cx                ; AX = row number
    
    cmp ax, 21            ; Row 21
    pop dx
    pop ax
    jge phase3_left       ; If >= row 21, go to phase 3
    
    ; Move down
    add di, 160
    jmp phase2_down_loop
    
phase3_left:
    ; Phase 3: Right to Left (bottom)
    ; di is currently at row 23, column 78
    
phase3_left_loop:
    ; Draw 3 stars
    mov ah, 0x07
    mov al, '*'
    mov [es:di], ax
    sub di, 2
    mov [es:di], ax
    sub di, 2
    mov [es:di], ax
    
    call delay
    
    push di
    
    ; Erase 3 stars
    mov ah, 0x07
    mov al, ' '
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    
    pop di
    
    ; Check if reached left side (column 4)
    mov bx, di
    push ax
    push dx
    mov ax, bx
    mov dx, 0
    mov cx, 160
    div cx                ; AX = row, DX = column offset
    
    cmp dx, 8             ; Column 4: 4*2 = 8
    pop dx
    pop ax
    jle phase4_up         ; If <= column 4, go to phase 4
    
    ; Move left
    sub di, 2
    jmp phase3_left_loop
    
phase4_up:
    ; Phase 4: Bottom to Top (left side)
    ; di is currently at row 23, column 2
    
phase4_up_loop:
    ; Draw 3 stars vertically
    mov ah, 0x07
    mov al, '*'
    mov [es:di], ax
    sub di, 160
    mov [es:di], ax
    sub di, 160
    mov [es:di], ax
    
    call delay
    
    push di
    
    ; Erase 3 stars
    mov ah, 0x07
    mov al, ' '
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    
    pop di
    
    ; Check if reached top (row 3)
    mov bx, di
    push ax
    push dx
    mov ax, bx
    mov dx, 0
    mov cx, 160
    div cx                ; AX = row number
    
    cmp ax, 3            
    pop dx
    pop ax
    jle end_animation    
    
    ; Move up
    sub di, 160
    jmp phase4_up_loop
    
end_animation:
    ; Wait for keypress
    mov ah, 0x00
    int 0x16
    
    ; Exit program
    mov ax, 0x4c00
    int 0x21