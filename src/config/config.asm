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