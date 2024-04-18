; print hello world
init :
	mov si, message
	call print
	jmp screen
	jmp $