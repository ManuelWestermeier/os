ORG 0
BITS 16

_start:
	jmp short start
	nop
	times 33 db 0

start :
	jmp 0x7c0:step2
step2 :
	cli ; clear Interrupts
	mov ax, 0x7c0
	mov ds, ax
	mov es, ax
	mov ax, 0x00
	mov ss, ax
	mov sp, 0x7c00
	sti ; enable Interrupts
	; print hello world
	mov si, message
	call print
	jmp screen
	jmp $

print :
	mov bx, 0
.loop :
	lodsb
	cmp al, 0
	je .done
	call print_char
	jmp .loop
.done :
	ret

print_char :
	mov ah, 0eh
	int 0x10
	ret
screen :
    mov ax,13h
    int 10h
    ; draw palette in 32x8 squares, each square 5x5 pixels big (so 160x40px)
    push 0a000h
    pop es
    xor di,di
    xor ax,ax  ; color
    mov cx,8   ; big rows (each having 32 5x5 squares)
bigRowLoop:
    mov bx,10 ; pixel height of single row
rowLoop:
    mov dx,32 ; squares per row
    push ax
    push di
squareLoop:
    ; draw 10 pixels with "ah:al" color, ++color, di += 5
    mov [es:di],ax
    mov [es:di+2],ax
    mov [es:di+4],al
    add ax,0101h
    add di,10
    dec dx
    jnz squareLoop
    pop di
    pop ax     ; restore color for first square
    add di,320 ; move di to start of next line
    dec bx     ; do next single pixel line
    jnz rowLoop
    ; one row of color squares is drawn, now next 32 colors
    add ax,02020h ; color += 32
    dec cx
    jnz bigRowLoop
    ; wait for any key and exit
    xor ah,ah
    int 16h
    ret

message: db '/Manuel/Westermeier/OS/V1.0/', 0
times 510-($ - $$) db 0
dw 0xAA55
