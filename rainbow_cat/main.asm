; Rainbow cat animation assembly code
; Inspired by https://www.youtube.com/watch?v=QH2-TGUlwu4
; Compile with NASM and run with QEMU

[org 0x7c00] ; BIOS loads the boot sector at 0x7c00
[bits 16] ; Use 16-bit mode

mov ax, 0x13 ; Set video mode to 320x200x256
int 0x10 ; BIOS interrupt

mov ax, 0xa000 ; Set segment register to video memory
mov es, ax

call clear_screen ; Clear the screen with black color

mov si, cat_frames ; Load the address of cat frames array
mov di, rainbow_colors ; Load the address of rainbow colors array
mov cx, 6 ; Set the number of rainbow colors

main_loop:
call draw_cat ; Draw the cat with the current frame and color
call delay ; Wait for a while
call next_frame ; Advance to the next frame and color
jmp main_loop ; Repeat the loop

; Subroutine to clear the screen with black color
clear_screen:
pusha ; Save all registers
mov di, 0 ; Start from the first pixel
mov al, 0 ; Set the color to black
mov cx, 320*200 ; Set the number of pixels to fill
rep stosb ; Fill the video memory with black color
popa ; Restore all registers
ret ; Return from subroutine

; Subroutine to draw the cat with the current frame and color
draw_cat:
pusha ; Save all registers
mov bp, si ; Save the current frame address in bp
mov dx, 100 ; Set the y coordinate to 100
cat_loop_y:
mov bx, dx ; Save the y coordinate in bx
mov al, [si] ; Load the width of the current row in al
cmp al, 0 ; Check if it is zero (end of frame)
je cat_done ; If yes, jump to cat_done label
inc si ; If no, increment si to point to the next byte
mov ah, al ; Save the width in ah
shr al, 1 ; Divide the width by 2 to get the x offset
neg al ; Negate the x offset to get the leftmost x coordinate
add al, 160 ; Add 160 to center the cat horizontally
mov cx, al ; Save the x coordinate in cx
cat_loop_x:
mov al, [si] ; Load the color of the current pixel in al
cmp al, 255 ; Check if it is 255 (transparent)
je cat_skip_pixel ; If yes, jump to cat_skip_pixel label
add al, [di] ; If no, add the rainbow color offset in di
mov word [es:bx*320+cx], ax; Store the color in video memory at (cx + bx*320)
cat_skip_pixel:
inc cx; Increment the x coordinate 
dec ah; Decrement the width counter 
jnz cat_loop_x; If not zero, repeat the x loop 
inc dx; Increment the y coordinate 
inc si; Increment si to point to the next byte 
jmp cat_loop_y; Repeat the y loop 

cat_done: 
mov si, bp; Restore si to point to the current frame address 
popa; Restore all registers 
ret; Return from subroutine 

; Subroutine to wait for a while (about 0.1 second) 
delay: 
pusha; Save all registers 
mov cx, 0xffff; Set cx to a large value 
delay_loop_1: 
push cx; Save cx on stack 
mov cx, 0x1f40; Set cx to another large value 
delay_loop_2: 
loop delay_loop_2; Decrement cx and repeat if not zero 
pop cx; Restore cx from stack 
loop delay_loop_1; Decrement cx and repeat if not zero 
popa; Restore all registers 
ret; Return from subroutine 

; Subroutine to advance to the next frame and color 
next_frame: 
pusha; Save all registers 
inc si; Increment si to point to the next byte 
cmp byte [si], 0; Check if it is zero (end of frames array) 
je reset_frames; If yes, jump to reset_frames label 
inc di; Increment di to point to the next byte 
cmp di, rainbow_colors + 6; Check if it is past the end of colors array 
je reset_colors; If yes, jump to reset_colors label 
popa; Restore all registers 
ret; Return from subroutine 

reset_frames: 
mov si, cat_frames; Reset si to point to the first frame 
jmp next_frame; Jump back to next_frame label 

reset_colors: 
mov di, rainbow_colors; Reset di to point to the first color 
jmp next_frame; Jump back to next_frame label 

; Data section 

; An array of rainbow colors offsets (add these values to original colors) 
rainbow_colors: db 0x00, 0x40, 0x80, 0xc0, -0x40, -0x80 

; An array of cat frames encoded as run-length (each frame starts with a row width and ends with a zero) 
cat_frames: db \
18 db \
255 db \
255 db \
255 db \
255 db \
255 db \
255 db \
255 db \
255 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \


db \
18 db \
255 db \
255 db \
255 db \
255 db \
255 db \
255 db \
255 db \
255 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \
254 db \


db 0; End of frames array 

times 510-($-$$) db 0; Pad with zeros to make 512 bytes 
dw 0xaa55; Boot signature 

; The end of the assembly code


