%include "simple_io.inc"
   
global  asm_main

SECTION   .data
err1: db "incorrect number of command line arguments",10,0
err2: db "imput string too long",10,0
imps: db "imput string: ",0 
bday: db "border array: ",0
plus: db "+++  ",0
dot: db "...  " ,0
ept: db "     ",0
debug: db "WTF",10,0
array: dq 0,0,0,0,0,0,0,0,0,0,0,0

SECTION   .text

;r12 = $2   r13 = length

  	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  	; subroutine Maxbord, calc the maxbord, 2 params
  	; 1 fake 1 length 1 address
  	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Maxbord:
	enter	0,0             ; setup routine
    saveregs              ; save all registers
	mov r15, [rbp+32]  ;first address
	mov r12, [rbp+24]  ;second length
	
    ;add r15, r12
    ;inc r15
	
	
	;mov al, byte 99
	;call print_char

	
	mov r13, qword 0  ;max = 0
	mov rcx,  qword 1 ;r = 1
	maxloop1:
		mov r14, qword 1 ;is border = 1
		
		mov rbx, qword 0; i = 0
		maxloop2:
			push r13
			push r14
			
			mov r13, r15
			add r13, rbx  ;string[i]
			
			mov r14,r13
			add r14, r12
			sub r14, rcx ;string[L - r + i]

			
			mov al, [r13]
			mov dl, [r14]
			
			pop r14
			pop r13
			
			cmp  al,  dl
			jnz maxelse

		
		inc rbx
		cmp rbx, rcx
		jb maxloop2
		;end loop2
		
		maxelse:
			mov r14, qword 0
			jmp loop2stop
		
	loop2stop:	
	cmp r14, qword 1 ;isborder == 1
	jnz loop1con
	cmp r13, rcx
	jnb loop1con
	mov r13, rcx
	
	loop1con:
	inc rcx
	cmp rcx, r12
	jbe maxloop1
	;end loop1

   mov rax, r13
   restoregs     ; restore all registers
   leave
   ret

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; end of subroutine Maxbord
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   
   
   
   
 	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  	; subroutine simple, simple display, 2 params
  	; 1 fake 1 length 1 string
  	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SIMPLE:
   	enter	0,0             ; setup routine
    saveregs              ; save all registers
	
	mov r12, [rbp+32]  ;first address
	mov rcx, [rbp+24]  ;second length
	mov rbx, qword 0
	mov rax, bday
	call print_string  
	mov rax, [r12]
	call print_int         ;print text + array[0]
	
   simpleloop:
    mov al , ','
	call print_char
	add r12,qword 8
	mov rax, [r12]
	call print_int     ;print , + array[i]
	dec rcx
	cmp rcx,qword 1
	ja simpleloop
   

   call print_nl
   jmp simple_end
   
   simple_end:
   restoregs     ; restore all registers
   leave
   ret
   
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; end of subroutine simple
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  	; subroutine fancy, FANCY display, 2 params
  	; 1 fake 1 length 1 string
  	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FANCY:
   	enter	0,0             ; setup routine
    saveregs              ; save all registers
	
	;mov r12, [rbp+32]  ;first address
	mov rcx, [rbp+24]  ;second length
	mov r15, rcx        ;r15 = L      rcs = level
	
   fancybigloop:
   
 
   ;mov rax, rcx
   ;call print_int  ;test code for correct level
   mov r13, qword 0          ;count = 0
   
   mov r12, [rbp+32]
   
   
	   fancysmalllop:
	
	   mov r14, [r12]         ;x = array[i]
	   
	   ;mov rax, r12
	   ;call print_int
	   
	   
	   inc r13
	   
	   cmp r13, r15
	   ja smallend ;if count > L: break
	   
	   cmp rcx, 1 ;if level == 1:
	   jne bigelse
	   
	   cmp r14, 0 ;if x > 0:
	   jna upperelse
	   
			mov rax, plus
			call print_string ;print("+++  ", end='')
			jmp bigengif
			
			upperelse:
			
			mov rax, dot
			call print_string ;print("...  ", end='')

	   jmp bigengif
	   
	   bigelse:
	   
	   cmp r14, rcx ;if x < 0:
	   jnb lowerelse
	   
			mov rax, ept
			call print_string ;print("     ", end='')
			jmp bigengif
			
			lowerelse:
			
			mov rax, plus
			call print_string ;print("...  ", end='')
			
	   
	   bigengif:
	   ;dec 13
	   ;inc r14  ;x = x + 1
	   add r12,qword 8
	   cmp r14, r15 ; x L
	   jnz fancysmalllop
	   ;end small loop
  smallend:
   call print_nl
   
   
   dec rcx
   cmp rcx, 0
   ja fancybigloop
   ;end bigloop
	
   jmp fancy_end
   
   fancy_end:
   restoregs     ; restore all registers
   leave
   ret
   
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; end of subroutine fancy
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   
   
   
   
   	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  	; 
	;subroutine asm_main, main function
	;
  	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_main:
   enter	0,0             ; setup routine
   saveregs              ; save all registers
   
	;mov al, byte 99
	;call print_char
   
   cmp	rdi, qword 2         ; argc should be 2
   jne ERROR1					;if len != 2 then error1
   
   mov r12, [rsi+8]  ;snd arg in r12
   ;mov rax, r12
   ;call print_string
   ;call print_nl
   ;all good above
 count: 
   mov rax, [r12 + rbx] 
   cmp al, byte 0        ;check if char is null
   je aftercount                 ;end loop if yes
   inc rbx
   inc rax
   jmp count

  aftercount:
   cmp rbx, qword 12
   jg ERROR2 ;if len > 12 then error2
   
   mov r13, rbx  ;r13 is the length    L=length
   
   mov rax, imps
   call print_string
   mov rax, r12
   call print_string
   call print_nl ; print string with "input leng"
   
   
   

   ;dec r13
   
   mov r14, r13              ;r14 = L1         L1=L
   mov r8, array; move empty array of size 12 in r8
   
   mov r15, 0        ;     for i in range r13-1

  loopInmain:

	   
	   push r12 ; r12 hold the address
	   push r14 ; r13 hold the length
	   

	   ;mov rax, [rsi+8]
	   ;call print_string
	   ;mov rax, ":"
	   ;call print_char
	   
	   
	   sub rsp, 8 ;push fake para 
	   call Maxbord         ;call here-----------
	   add rsp, 24    ;clean stack
	   
	   
	   mov [r8], rax     ;store value into array
								;bordar[i] = maxbord(string[i:], L1)
	   add r8, 8
	   
	   
	   add r12, qword 1 ;rax = string[i:]
	   
	   dec r14
	   inc r15
	   
	   cmp r15, r13
	   jbe loopInmain ;end loop for maxbord
   

   
   
   mov r8, array            ;return to the array[0]
   
   push r8       ;first para address of array
   push r13		;second para length of array
   

   sub rsp, 8 ;push fake para 
   
   call SIMPLE
   call FANCY
   
   add rsp, 24    ;clean stack
   
   jmp asm_main_end 
   
   
  ERROR1: ;wrong argument #
   mov rax, err1
   call print_string
   jmp  asm_main_end  ;print error and end
   
  ERROR2: ;string too long
   mov rax, err2
   call print_string
   jmp  asm_main_end  ;print error and end

  asm_main_end:
   restoregs                  ; restore all registers
   leave                     
   ret
   
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; end of subroutine asm_main
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;