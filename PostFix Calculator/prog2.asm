;
;
;
.ORIG x3000
	
; Introduction:
; This program makes use of many subroutines. The PUSH and POP subroutines were not made by me, but everything else was
; The PRINT_HEX subroutine is taken from mp1 and only is called if the expression is valid AND an equals is present
; The evaluate subroutine is the heart of the program. It first calls an input from the user and prints it back to the screen
; It then proceeds to check if the entered character is a valid character, 0-9, +,-,/,^, or =. If it is not one of these characters then it prints, invalid expression
; and terminates the program. However, if it is one of the operands, 0-9, it will detect it and push it to the stack. If it is an operand, it will pop 2 values from
; the stack and store them in R3 and R4. It will then call the respective subroutine, named PLUS, MIN, MUL, DIV, or EXP. The given subroutine then performs the 
; calculation and returns R0 to EVALUATE subroutine. Something to note is the EXP subroutine calls the MUL subroutine for the repeated multiplication. In order to 
; Get around the change in R7, I store R7 at the beginning of the EXP subroutine and then load it back at the end to RET the program back to the correct spot. 
; Once R0 is back into evaluate, it is pushed onto the stack, and then the program carries on, eventually asking for another input until it reads an equals sign.
; Once it reads an equals sign it decides if the function is valid, and if it is will POP the value off the top of the stack, which will be the running answer, store
; it in R5 and send it over to PRINT_HEX to be displayed on the console in hex format. 







BRnzp EVALUATE ; If coming from the start of the program, we want to go to evaluate first to take the input. 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal



PRINT_HEX
	 AND R4,R4,#0
	 ADD R4,R4,#4           ; Setting R4 as the counter of 4-bit sections
	 ADD R3,R5,#0           ; Setting R3 to the value that is calculated from evalutate
	 AND R1,R1,#0           ; Set R1 to 0
	 ADD R1,R1,#4           ; Set R1 to 4, for the 4 bit counter
	 AND R2,R2,#0           ; Setting R2 to 0


REDO    ADD R3,R3,#0           ; Adds 0 to R3 to check if it is + or negative

	BRzp POS               ; Branches if positive

	ADD R2,R2, #1          ; Add one to R1
	ADD R1,R1,#-1          ; Subtracting 1 from R1
	BRnzp   BOTTOM         ; Going to the bottom to check if done
                
POS     ADD R1,R1,#-1          ; Subtracting 1 from R1
	BRnzp   BOTTOM         ; Going to the bottom to check if done

	
	
BOTTOM	ADD R3,R3,R3           ; Left shift R3 to get to the next in R3 value
	ADD R1,R1,#0           ; Checking the value of R4
	BRz FOUR_BIT           ; Checking to see if it is ready to print
	ADD R2,R2,R2           ; Left shift in R2 to cement the value into R2
	BRnzp   REDO           ; Goes to redo
	
	

FOUR_BIT ADD R0,R2,#-9      ; checking to see if R2 is <= 9
	 BRnz ADD_O         ; going to add a 0
	 
	 LD R0, HEX_A       ; loading R0 with the desired ASCII_Hex value
	 ADD R0,R2,R0       ; Adding the desired ASCII_hex to the calculated value
	 ADD R0,R0,#-10
	 OUT                ; Printing the value
	 BRnzp DONE_PRINT   ; Branches when done printing a letter

ADD_O    LD R0, HEX_ZERO    ; loading R0 with the desired ASCII Hex value
	 ADD R0,R2,R0       ; Adding the desired ASCII Hex to the calculated value
	 OUT                ; Printing the value
	 BRnzp DONE_PRINT   ; Branches when done printing a letter



DONE_PRINT AND R2,R2,#0     ; Resets R2 to 0 to prepare for the next set of bits
	   AND R1,R1,#0      ; Sets R1 to 0 just in case
	   ADD R1,R1,#4      ; Resets the bit counter
	   ADD R4,R4,#-1     ; Subtracts one from the counter
	   BRz TERM          ; if the counter is up, the hex is printed and can terminate the program
	   BRnzp REDO        ; Branches to finish the number

HEX_ZERO .FILL x0030
HEX_A    .FILL x0041


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE

INPUT	GETC
	OUT
	NOT R1,R0    ; Notting R0 into R1 to check what was entered
	ADD R1,R1,#1 ; Adding 1 to be the negative of R0, will use later
	AND R4,R4,#0 ; Setting R4 to 0


; Is it *space*?
LD R0,CHSP
ADD R2,R1,R0
BRz INPUT ; Branches to ask for another character if it is a space
BRnzp NOTSPACE

; This starts the checking for values 0-9. If it does not find the value, then it hops to the next one to check
; If it does find the number, it will push it to the stack and then jump to the bottom to check for invalid entries
NOTSPACE

; Is it 0?
LD R0,NUM0
ADD R2,R1,R0
BRnp NOT0
ADD R0,R4,#0
JSR PUSH
BRnzp NUM_FOUND

NOT0

; Is it 1?
LD R0,NUM1
ADD R2,R1,R0
BRnp NOT1
ADD R0,R4,#1
JSR PUSH
BRnzp NUM_FOUND

NOT1

; Is it 2?
LD R0,NUM2
ADD R2,R1,R0
BRnp NOT2
ADD R0,R4,#2
JSR PUSH
BRnzp NUM_FOUND

NOT2

; Is it 3?
LD R0,NUM3
ADD R2,R1,R0
BRnp NOT3
ADD R0,R4,#3
JSR PUSH
BRnzp NUM_FOUND

NOT3

; Is it 4?
LD R0,NUM4
ADD R2,R1,R0
BRnp NOT4
ADD R0,R4,#4
JSR PUSH
BRnzp NUM_FOUND

NOT4

; Is it 5?
LD R0,NUM5
ADD R2,R1,R0
BRnp NOT5
ADD R0,R4,#5
JSR PUSH
BRnzp NUM_FOUND

NOT5

; Is it 6?
LD R0,NUM6
ADD R2,R1,R0
BRnp NOT6
ADD R0,R4,#6
JSR PUSH
BRnzp NUM_FOUND

NOT6

; Is it 7?
LD R0,NUM7
ADD R2,R1,R0
BRnp NOT7
ADD R0,R4,#7
JSR PUSH
BRnzp NUM_FOUND

NOT7

; Is it 8?
LD R0,NUM8
ADD R2,R1,R0
BRnp NOT8
ADD R0,R4,#8
JSR PUSH
BRnzp NUM_FOUND

NOT8

; Is it 9?
LD R0,NUM9
ADD R2,R1,R0
BRnp NOT9
ADD R0,R4,#9
JSR PUSH
BRnzp NUM_FOUND

NOT9


; This starts the operator checking. This section checks for operands, if it finds a given operator then
; it will call that subroutine after popping 2 values from the stack into R3 and R4. An answer will be returned
; From the subroutine into R0 and that value is then PUSHed onto the stack, ready for the next input. 

; Is it +?
LD R0,CHP
ADD R2,R1,R0
BRnp NOTPLUS
JSR POP
AND R3,R3,#0
ADD R3,R3,R0
JSR POP
AND R4,R4,#0
ADD R4,R4,R0  ; The following pops the previous 2 values and puts them into R3 and R4 to be added
JSR PLUS
JSR PUSH
BRnzp STORED_VALUE

NOTPLUS

; Is it -?
LD R0,CHS
ADD R2,R1,R0
BRnp NOTMINUS
JSR POP
AND R3,R3,#0
ADD R3,R3,R0
JSR POP
AND R4,R4,#0
ADD R4,R4,R0  ; The following pops the previous 2 values and puts them into R3 and R4 to be subtracted
JSR MIN
JSR PUSH
BRnzp STORED_VALUE


NOTMINUS

; Is it *?
LD R0,CHM
ADD R2,R1,R0
BRnp NOTMUL
JSR POP
AND R3,R3,#0
ADD R3,R3,R0
JSR POP
AND R4,R4,#0
ADD R4,R4,R0  ; The following pops the previous 2 values and puts them into R3 and R4 to be subtracted
JSR MUL
JSR PUSH
BRnzp STORED_VALUE

NOTMUL

; Is it /?
LD R0,CHD
ADD R2,R1,R0
BRnp NOTDIV
JSR POP
AND R3,R3,#0
ADD R3,R3,R0
JSR POP
AND R4,R4,#0
ADD R4,R4,R0  ; The following pops the previous 2 values and puts them into R3 and R4 to be subtracted
JSR DIV
JSR PUSH
BRnzp STORED_VALUE

NOTDIV


; Is it ^?
LD R0,CHEX
ADD R2,R1,R0
BRnp NOTEX
JSR POP
AND R3,R3,#0
ADD R3,R3,R0
JSR POP
AND R4,R4,#0
ADD R4,R4,R0  ; The following pops the previous 2 values and puts them into R3 and R4 to be subtracted
JSR EXP
JSR PUSH
BRnzp STORED_VALUE

NOTEX

; This final one check for equals sign, if an equals sign is found then it will check for an invalid expression and
; if it does not find one then it will POP the top value off the stack, the running answer, and send it to R5 and 
; to the PRINT_HEX subroutine that will print the value to the console after the equals sign. 

; Is it =?
LD R0,CHE
ADD R2,R1,R0
BRnp NOTEQUALS

; Checking to see if the stack has 1 value
LD R1, STACK_TOP
LD R2, STACK_START ; Loading the addresses of the STACK_TOP and STACK_START to see if they are one apart
ADD R1,R1,#-1 ; Adding -1 to the top of the stack to see if it is the same as the stack start
NOT R1,R1
ADD R1,R1,#1
ADD R2,R1,R2 ; If the answer is 0, it is an invalid expression
BRz INVALID
; If it gets this far it is valid and it will go on to print and finish the program
JSR POP
AND R5,R5,#0
ADD R5,R0,#0
BRnzp PRINT_HEX


NOTEQUALS

; If the character is not an equals sign, then is has failed every character test so far so
; it is an invalid expression, and the program will terminate after telling the user such.

INVALID
LEA R0,INVALID_ST
PUTS
BRnzp TERM

NUM_FOUND
STORED_VALUE

ADD R5,R5,#-1 ;Checking for stack underflow to see if there is an invalid expression
BRz INVALID ; There was a stakc underlflow, therefore invalid expression


BRnzp INPUT


TERM HALT
INVALID_ST .STRINGZ "Invalid Expression\n"
NUM0 .FILL x0030
NUM1 .FILL x0031
NUM2 .FILL x0032
NUM3 .FILL x0033
NUM4 .FILL x0034
NUM5 .FILL x0035
NUM6 .FILL x0036
NUM7 .FILL x0037
NUM8 .FILL x0038
NUM9 .FILL x0039

CHP  .FILL x002B ; +
CHS  .FILL x002D ; -
CHM  .FILL x002A ; *
CHD  .FILL x002F ; /
CHE  .FILL x003D ; = 
CHEX .FILL x005E ; ^
CHNL .FILL x000A ; New Line Character
CHSP .FILL x0020 ; Space




;your code goes here


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0

PLUS
ST R3, PUSH_SaveR3	;save R3
ST R4, PUSH_SaveR4	;save R4

ADD R0,R3,R4             ; Addition stored here

LD R3, PUSH_SaveR3	;
LD R4, PUSH_SaveR4	;

RET
	
;your code goes here
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN	
ST R3, PUSH_SaveR3	;save R3
ST R4, PUSH_SaveR4	;save R4

	NOT R3,R3
	ADD R3,R3,#1
	ADD R0,R4,R3

LD R3, PUSH_SaveR3	;
LD R4, PUSH_SaveR4	;
RET
;your code goes here
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL	
ST R3, PUSH_SaveR3	;save R3
ST R4, PUSH_SaveR4	;save R4

	AND R2,R2,#0
	ADD R4,R4,#0
	BRz END_MUL_L  ; Checking to see if the answer is 0
MUL_L	ADD R2,R2,R4
	ADD R3,R3,#-1 ; Subtracting 1 from R3
	BRnp MUL_L

END_MUL_L 
	ADD R0,R2,#0

LD R3, PUSH_SaveR3	;
LD R4, PUSH_SaveR4	;	
	
RET
	
;your code goes here
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
DIV	
ST R3, PUSH_SaveR3	;save R3
ST R4, PUSH_SaveR4	;save R4


ADD R1,R4,#0
AND R2,R2,#0    ; Will serve as the divison counter
NOT R3,R3
ADD R3,R3,#1      ; these lines set R3 to the negative of R3


DIV_L   ADD R4,R4,R3    ; Does the repeat subtraction for the division
	BRnz END_DIV_L  ; Marks the end of the division loop, R3 is now lower than R4
	ADD R2,R2,#1    ; Adds 1 to the running total of the divison
	BRnzp DIV_L

END_DIV_L
	
ADD R1,R3,R1
BRz ONE
ADD R0,R2,#0	; sets R0 as the divison counter
BRz NOONE

ONE
ADD R0,R0,#1  ;To account for the loop ending 1 too early
NOONE

LD R3, PUSH_SaveR3	;
LD R4, PUSH_SaveR4	;
RET
;your code goes here
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
EXP
ST R3, PUSH_SaveR3	;save R3
ST R4, PUSH_SaveR4	;save R4
ST R7, RET_SaveR7      ;save R7

AND R1,R1,#0
AND R2,R2,#0
ADD R1,R3,#0  ; Getting a placeholder for R4
ADD R3,R4,#0  ; Setting R4 as R3, to send to the multiply loop
ADD R1,R1,#-1 ; Subtracting 1 from R1 to get the count correct

EXP_L   JSR MUL
	ADD R4,R0,#0
	ADD R1,R1,#-1
	BRz EXPDONE
	BRnzp EXP_L
EXPDONE

ADD R0,R4,#0


LD R3, PUSH_SaveR3	;
LD R4, PUSH_SaveR4	;
LD R7,RET_SaveR7        ; Returns R7 for the return
RET
;your code goes here
	
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACK_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;
RET_SaveR7      .BLKW #1        ;

.END
