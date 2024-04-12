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
    jmp init

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
; print hello world
init :
	mov si, message
	call print
	jmp screen
	jmp $

screen :
    ;set video mode
    mov ah, 00h
    mov al, 13h
    int 10h
    ; draw pixels
    ; color
    mov al, 101010b
    ; dx = pos.y ; cx = pos.x
    mov dx, 20
    mov cx, 30
    call drawPixel

drawPixel: 
    ;write pixels on screen
    mov ah, 0ch
    mov bh, 0
    int 10h
message: db '/Manuel/Westermeier/OS/V1.0/', 0
times 510-($ - $$) db 0
dw 0xAA55