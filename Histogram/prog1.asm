;
; The code given to you here implements the histogram calculation that 
; we developed in class.  In programming lab, we will add code that
; prints a number in hexadecimal to the monitor.
;
; Your assignment for this program is to combine these two pieces of 
; code to print the histogram to the monitor.
;
; If you finish your program, 
;    ** commit a working version to your repository  **
;    ** (and make a note of the repository version)! **


	.ORIG	x3000		; starting address is x3000


;
; Count the occurrences of each letter (A to Z) in an ASCII string 
; terminated by a NUL character.  Lower case and upper case should 
; be counted together, and a count also kept of all non-alphabetic 
; characters (not counting the terminal NUL).
;
; The string starts at x4000.
;
; The resulting histogram (which will NOT be initialized in advance) 
; should be stored starting at x3F00, with the non-alphabetic count 
; at x3F00, and the count for each letter in x3F01 (A) through x3F1A (Z).
;
; table of register use in this part of the code
;    R0 holds a pointer to the histogram (x3F00)
;    R1 holds a pointer to the current position in the string
;       and as the loop count during histogram initialization
;    R2 holds the current character being counted
;       and is also used to point to the histogram entry
;    R3 holds the additive inverse of ASCII '@' (xFFC0)
;    R4 holds the difference between ASCII '@' and 'Z' (xFFE6)
;    R5 holds the difference between ASCII '@' and '`' (xFFE0)
;    R6 is used as a temporary register
;

	LD R0,HIST_ADDR      	; point R0 to the start of the histogram
	
	; fill the histogram with zeroes 
	AND R6,R6,#0		; put a zero into R6
	LD R1,NUM_BINS		; initialize loop count to 27
	ADD R2,R0,#0		; copy start of histogram into R2

	; loop to fill histogram starts here
HFLOOP	STR R6,R2,#0		; write a zero into histogram
	ADD R2,R2,#1		; point to next histogram entry
	ADD R1,R1,#-1		; decrement loop count
	BRp HFLOOP		; continue until loop count reaches zero

	; initialize R1, R3, R4, and R5 from memory
	LD R3,NEG_AT		; set R3 to additive inverse of ASCII '@'
	LD R4,AT_MIN_Z		; set R4 to difference between ASCII '@' and 'Z'
	LD R5,AT_MIN_BQ		; set R5 to difference between ASCII '@' and '`'
	LD R1,STR_START		; point R1 to start of string

	; the counting loop starts here
COUNTLOOP
	LDR R2,R1,#0		; read the next character from the string
	BRz PRINT_HIST		; found the end of the string

	ADD R2,R2,R3		; subtract '@' from the character
	BRp AT_LEAST_A		; branch if > '@', i.e., >= 'A'
NON_ALPHA
	LDR R6,R0,#0		; load the non-alpha count
	ADD R6,R6,#1		; add one to it
	STR R6,R0,#0		; store the new non-alpha count
	BRnzp GET_NEXT		; branch to end of conditional structure
AT_LEAST_A
	ADD R6,R2,R4		; compare with 'Z'
	BRp MORE_THAN_Z         ; branch if > 'Z'

; note that we no longer need the current character
; so we can reuse R2 for the pointer to the correct
; histogram entry for incrementing
ALPHA	ADD R2,R2,R0		; point to correct histogram entry
	LDR R6,R2,#0		; load the count
	ADD R6,R6,#1		; add one to it
	STR R6,R2,#0		; store the new count
	BRnzp GET_NEXT		; branch to end of conditional structure

; subtracting as below yields the original character minus '`'
MORE_THAN_Z
	ADD R2,R2,R5		; subtract '`' - '@' from the character
	BRnz NON_ALPHA		; if <= '`', i.e., < 'a', go increment non-alpha
	ADD R6,R2,R4		; compare with 'z'
	BRnz ALPHA		; if <= 'z', go increment alpha count
	BRnzp NON_ALPHA		; otherwise, go increment non-alpha

GET_NEXT
	ADD R1,R1,#1		; point to next character in string
	BRnzp COUNTLOOP		; go to start of counting loop



PRINT_HIST

; you will need to insert your code to print the histogram here



;START OF MY CODE
; This program is a lot. I first started by storing all of the ASCII values '@' through 'Z' in the memory postions
; right after the histogram values, x3F1B is the first. I then made a function to print out the string that was given,
; just as it was shown in the exmaple in the MP assignment with a new line character seperating it from the histogram. I then made a big loop. 
; The loop first prints out the correct ASCII character for that line, it then adds an ASCII space, 
; and then it iterates through a bit counter that goes by 4 in order to
; correctly print the hex values. Once the hex values are printed, the program prints a new line character and then does it all again. 
; It does this 27 times, 26 letter and 1 other, and then it HALTs


; do not forget to write a brief description of the approach/algorithm
; for your implementation, list registers used in this part of the code,
; and provide sufficient comments

; Register table for storing the ASCII values
; R0 as a temp register
; R1 as a pointer to the current ASCII memory location
; R3 as a counter, counting down
; R4 as the actual ASCII value to be stored


INIT_AS LD R1,ASCII_START      ; Setting R1 as the starting address to store the ASCII values
        AND R3,R3,#0           ; Setting R3 to 0, will serve as the starting ASCII value to store
	ADD R3,R3,#13          ;
	ADD R3,R3,#14          ; Previous 2 lines Set R3 as a counter, equal to 27
	LD R4,START_VALUE      ; Setitng R4 as the first ASCII value to print, '@'

ST_ASC  STR R4,R1,#0           ; Storing the current ASCII value into the correct  memory location
	ADD R3,R3,#-1          ; Subtracting 1 from the counter
	BRz ASCII_DONE         ; Branches if the ASCII characters have been stored
	ADD R4,R4,#1           ; Adding 1 to R4, or the ASCII character
	ADD R1,R1,#1           ; Adding 1 to R1, or the ASCII memory address
	BRnzp ST_ASC           ; Goes back to store another ASCII value
	

ASCII_DONE LD R1, STR_START   ; loads the address of the first value in the printed string into R0
STRING_L   LDR R0,R1,#0       ; Loads the actual ASCII_value into R0 to print
	   ADD R0,R0,#0       ; Testing to see if the string has finished printing yet
	   BRz INIT_BIT       ; Goes to the next step if the string is done
	   OUT                ; Prints the ASCII Character
	   ADD R1,R1,#1       ; Increments the counter to print the next letter of the string
	   BRnzp STRING_L     ; Loops back to the string loop

	   





; Register table for hex printing
; R0 will be a temp register
; R1 will be the bit counter, going for every 4 bits
; R2 will hold 4 bit chunks to be printed in hex
; R3 will have the the actual values that need to be printed out in hex
; R4 will hold the addresses for any given moment
; R5 is a counter that is used for checking if the number is finished, counting down every 4 bits instead of 1
; R6 is a row counter to let the program know when it is done
	
INIT_BIT LD R4, HIST_ADDR       ; Setting R4 to the Address of the first histogram value
	 LD R0,ASCII_NL         ; loads the new line character
	 OUT
	 OUT                    ; Prints the new line character twice
	 AND R6,R6,#0
	 ADD R6,R6,#14
	 ADD R6,R6,#13          ; these three lines create a row counter so the program knows when to stop

ALPHABET ADD R0,R4,#14      ;
	 ADD R0,R0,#13      ;  These 2 lines set R0 to be 27 more spots than the current value of R4, or the ASCII equivalent
	 LDR R0,R0,#0       ;  Sets R0 as the actual ASCII value rather than a memory address
	 OUT                ; Prints the letter
	 LD R0,SPACE        ; Loads R0 with the space ASCII character
	 OUT                ; Prints the space



BIT_LO	 AND R5,R5,#0           ; Set R5 to 0
	 ADD R5,R5,#4           ; Set R5 to 4, this will serve as the counter to when the program is done printing a line
	 AND R2,R2,#0           ; Set R2 as 0 to hold as the 4 bit holder
	 AND R3,R3,#0           ; Set R3 as 0


	 LDR R3,R4,#0           ; Setting R3 to the actual value stored in the histogram
	 AND R1,R1,#0           ; Set R1 to 0
	 ADD R1,R1,#4           ; Set R1 to 4, for the 4 bit counter


REDO    ADD R3,R3,#0           ; Adds 0 to R3 to check if it is + or negative

	BRzp POS                ; Branches if positive

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
	   ADD R5,R5,#-1     ; Subtracts one from the counter
	   BRz DON_L         ; if the counter is up, go to the next layer
	   BRnzp REDO        ; Branches to finish the number


DON_L     ADD R4,R4,#1       ; Add one to the address
	  LD R0, ASCII_NL    ; Load the new line character
	  OUT                ; Print the new line character
	  ADD R6,R6,#-1      ; Subtracting one from the ultimate program counter/row counter
	  BRz DONE           ; Branches to trap when the program is finally done
	  BRnzp ALPHABET       ; Repeat with the next histogram letter




DONE	HALT			; done


; the data needed by the program
NUM_BINS	.FILL #27	; 27 loop iterations
NEG_AT		.FILL xFFC0	; the additive inverse of ASCII '@'
AT_MIN_Z	.FILL xFFE6	; the difference between ASCII '@' and 'Z'
AT_MIN_BQ	.FILL xFFE0	; the difference between ASCII '@' and '`'
HIST_ADDR	.FILL x3F00     ; histogram starting address
HIST_ENDADD     .FILL x3F1A     ; End of the hisogram address
ASCII_NL        .FILL x000A     ; ASCII New line character stored
ASCII_START     .FILL x3F1B     ; Start of storing the ASCII characters to PRINT, memory addresses
START_VALUE     .FILL x0040     ; First ASCII value @ is stored     
SPACE           .FILL x0020     ; Space hex value

HEX_ZERO        .FILL x0030     ; The ASCII of 0
HEX_A           .FILL x0041     ; The ASCII of A

STR_START	.FILL x4000	; string starting address

; for testing, you can use the lines below to include the string in this
; program...
; STR_START	.FILL STRING	; string starting address
; STRING		.STRINGZ "This is a test of the counting frequency code.  AbCd...WxYz."



	; the directive below tells the assembler that the program is done
	; (so do not write any code below it!)

	.END
