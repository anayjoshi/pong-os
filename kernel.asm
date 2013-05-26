[BITS 16]


main:
	

	mov ax,0x2000
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov sp,0x0FFFF
	mov al,0x03
	mov ah,0x00
	int 0x10


	mov ah,0x30
	mov dl,ah
	mov dh,0x01 
	mov al,0x30
	mov bl,0x05
	mov bh,0x05
;ch,cl maintains direction of cursor movement
	mov cl,0x00
	mov ch,0x00
;bh,bl maintains head of player 1 and player 2 respectively
	call clear_screen
	call set_cursor_pos
loop:
	pusha
	mov dl,0x23
	mov dh,0x0b
	call set_cursor_pos
	mov si,intro
	call print_string
	call increment_cursor
	mov si,points
	call print_string
	popa
	call set_cursor_pos
	call delay
	mov al,0x00
	call print_char
	call update_cursor_col_pos
	call update_cursor_row_pos
	call set_cursor_pos
	mov al,0x38
	call print_char
	call display_p1
	call display_c1
	jmp loop	
;routines ------------------------------------


display_p1:
	pusha
	mov dl,0x00
	mov dh,bl
	call set_cursor_pos
	mov al,0x00
	call print_char
	inc dh 
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	
	call check_keyboard_input

	cmp al,0x75
	jz .up
	cmp al,0x6a
	jz .down
	jmp .done

	.up:
	dec bl
	dec bl
	jmp .done
	.down:
	inc bl	
	inc bl

	.done:
	mov dl,0x00
	mov dh,bl
	call set_cursor_pos
	mov al,0x30
	call print_char
	inc dh 
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	mov [keyboard_buf],bl
	popa
	mov bl,[keyboard_buf]
	call set_cursor_pos
	ret


display_c1:
	pusha
	mov ch,dh
	mov cl,dl
	mov dl,0x4f
	mov dh,bh
	call set_cursor_pos
	mov al,0x00
	call print_char
	inc dh 
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char

	inc dh
	call set_cursor_pos
	call print_char
	call clear_key_buf
	
	
	mov bh,ch

	mov dl,0x4f
	mov dh,bh
	call set_cursor_pos
	mov al,0x30
	call print_char
	inc dh 
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	inc dh
	call set_cursor_pos
	call print_char
	mov [keyboard_buf],bh
	popa
	mov bh,[keyboard_buf]
	call set_cursor_pos
	ret


update_cursor_row_pos:
	cmp dh,0x18
	jz .resetcol
	cmp dh,0x00
	jz .resetcol
	jmp .display
	.resetcol:
	 xor ch,0xff

	.display:
		cmp ch,0x00
		jz .colforward
		dec dh	
		jmp .return
		.colforward:
		inc dh
	.return:
		ret

update_cursor_col_pos:
	cmp dl,0x00
	jz .resetcolp
	cmp dl,0x4f
	jz .resetcolc
	jmp .display
	.resetcolp:
		.cont:
			xor cl,0xff
			pusha
			mov ah,dh
			cmp ah,bl
			js game_over
			dec ah
			dec ah
			dec ah
			dec ah
			dec ah
			cmp bl,ah
			popa
			js game_over
				inc ah
				mov [points],ah
				cmp ah,0x35
				jz .win
				jmp .display
				.win:
					call winner
			jmp .display
	.resetcolc:
	xor cl,0xff

	.display:
		cmp cl,0x00
		jz .colforward
		dec dl	
		jmp .return
		.colforward:
		inc dl
	.return:
		ret
		
game_over:
	mov dl,0x23
	mov dh,0x0b
	mov si,over
	call set_cursor_pos
	call print_string
	call increment_cursor
	mov si,points
	call print_string
		mov ah,0x00
		mov [points],ah
		call wait_for_keyboard_char
		call clear_screen
		jmp main	

winner:
	mov dl,0x23
	mov dh,0x0b
	mov si,win
	call set_cursor_pos
	call print_string
		mov ah,0x00
		mov [points],ah
		call wait_for_keyboard_char
		call clear_screen
		jmp main	
clear_screen:
	pusha
	mov al,0x00
	mov bl,0x00
	mov ah,0x06
	int 0x10
	popa
	ret
; store a pointer to the message in si register and call this function
print_string:
	pusha
	mov ah,0x0E
	mov bh,0x00
	.loop:
		lodsb
		or al,al
		jz .return
		int 0x10
		jmp .loop
	.return:
		popa
		ret
;---------------------------------------------

;print whatever is stored in buffer pointed by si (ends with 03)


delay:
	pusha
	mov cl,0x00
	.outloop:
	inc cx
		mov al,0x00
		mov ah,0x01
		.inloop:
			inc ax
			or ah,ah
			jz .returnin
			jmp .inloop
		.returnin:
			or cl,cl
			jz .returnout
			jmp .outloop
	.returnout:
		popa
		ret
print_buffer:
	pusha
	call increment_cursor
	mov si,buffer
	mov ah,0x0E
	mov bh,0x00
	.loop:
		lodsb
		or al,al
		jz .return
		int 0x10
		jmp .loop
	.return:
		popa
		ret

;print whatever is there in the al register
print_char:
	pusha
	mov ah,0x0A
	mov bh,0x00
	mov cx,0x01
	int 0x10
	popa
	ret

;put the character stored in register al into the end of the buffer
put_char_in_buffer:
	mov  byte [si],al
	inc si
	ret

	

;wait for keyboard entry from user. and store the ascii code for the character in al

wait_for_keyboard_char:
	pusha
	mov ah,0x10
	int 0x16
	mov [keyboard_buf],al
	popa
	mov al,[keyboard_buf]
	ret

clear_key_buf:
	pusha
	mov ax,0x0000
	mov es,ax
	mov ax,0x041e
	mov [es:0x041a],ax
	mov [es:0x041c],ax
	popa
	ret

check_keyboard_input:
	pusha
	mov ah,0x01
	int 0x16
	mov [keyboard_buf],al
	popa
	mov al,[keyboard_buf]
	ret
;as the name says... note: as of now, the only page used is page 0
increment_cursor:
	pusha
	mov bh,0x00
	mov ah,0x03
	int 0x10
	inc dx
	mov ah,0x02
	int 0x10
	popa
	ret

decrement_cursor:
	pusha
	mov bh,0x00
	mov ah,0x03
	int 0x10
	dec dx
	mov ah,0x02
	int 0x10
	popa
	ret

; cursor position mentioned in dl(col), dh(row)
set_cursor_pos:
	pusha
	mov bh,0x00
	mov ah,0x02
	int 0x10
	popa
	ret

new_line:
	pusha
	mov bh,0x00
	mov ah,0x03
	int 0x10
	mov dl,0x00
	inc dh
	mov ah,0x02
	int 0x10
	popa
	ret

win dd "You Win :) ",0
over dd "Game Over ... ",0
points dd " ", 0
intro dd "Pong OS",0
keyboard_buf db 0
buffer:
