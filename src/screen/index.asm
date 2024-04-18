screen :
    ; Initialize mouse
    mov ax, 0      ; Reset mouse
    int 0x33
    mov ax, 0x0C00 ; Enable mouse
    int 0x33

    ; Initialize graphics mode
    mov ax, 0x0013 ; Set VGA 320x200 256-color mode
    int 0x10

    ; Main loop
main_loop:
    ; Get mouse status
    mov ax, 0x03   ; Get mouse position and button status
    int 0x33
    cmp bx, 1      ; Check if left mouse button is pressed
    jne main_loop  ; If not pressed, continue the loop

    ; Calculate pixel position
    mov cx, dx     ; Mouse x-coordinate
    mov dx, bx     ; Mouse y-coordinate
    mov ax, 320    ; Screen width
    mul dx         ; Calculate offset for y-coordinate
    add ax, cx     ; Add x-coordinate
    mov di, ax     ; Store the offset in di
    
    ; Draw pixel
    mov ax, 0x0C00 ; Set pixel color to 0 (black)
    stosb          ; Store the byte (color) at [es:di]

    ; Wait for the button release to avoid drawing multiple pixels at once
wait_release:
    mov ax, 0x03   ; Get mouse status
    int 0x33
    cmp bx, 0      ; Check if left mouse button is released
    jne wait_release ; If not released, continue waiting

    jmp main_loop  ; Continue the main loop

    jmp $

    ; Restore text mode and terminate program
    ; mov ax, 0x0003 ; Set text mode (80x25)
    ; int 0x10       ; BIOS video services
    ; mov ax, 0x4C00 ; Terminate program
    ; int 0x21       ; DOS interrupt