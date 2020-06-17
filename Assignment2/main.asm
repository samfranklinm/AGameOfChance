INCLUDE asmlib.inc			
.data	

	;PROMPTS AND MESSAGES
	welcomeMsg BYTE "Welcome to the Dice Guess Game. It only costs $1.00 to play!", 0
	continuePrompt BYTE "Would you like to continue? (Y/N): ", 0
	nextRollPrompt BYTE "Please enter your guess for the next roll. It'll only cost you $1.00 to play. If you guess correctly, I will pay you $10.00: ", 0
	diceRollMsg BYTE "Rolling the dice. . . .", 0
	winMsg BYTE "Winner! You guessed correct!", 0
	loseMsg BYTE "You lost. The dice rolled: ", 0
	bankBalanceMsg BYTE "Your bank balance is now $", 0
	zeroBalanceMsg BYTE "You do not have enough to play the game anymore.", 0
	endGameMsg BYTE "Thanks for playing. Play again soon!",0
	
	;VARIABLES
	dice DWORD 0
	guessCost DWORD 1
	balance DWORD 10
	


.code

main PROC

	mov EDX, OFFSET welcomeMsg					;welcome user to the game
	call writeLine
	endl

CONTINUELOOP:									;A loop to keep asking the user if they want to continue until stated otherwise
	endl
	mov EDX, OFFSET continuePrompt
	call writeString
	call readChar								;store the user decision and do a check below
	endl

	.IF al == 'y' || al == 'Y'					;if the user wants to continue
		.IF balance == 0						;check to see if the balance is 0, if it is, 
			mov EDX, OFFSET zeroBalanceMsg		
			call writeLine
			jmp ENDGAME							;then exit. 
		.ENDIF
		mov ECX, 1								;if balance is enough, generate a random number using ECX register
		mov EAX, 0								;set EAX to 0 (for randomization per asmlib custom library)
		call randSeed							;seed random number generator with time of day clock
						
		mov EDX, OFFSET nextRollPrompt			;ask user for a guess of what the dice will roll
		call writeString
		call readInt							;stored the guess (value) in EAX
		endl
		mov dice, EAX							;copy the value over to the variable "dice"
		mov EAX, 6								;set randomization upper-bound range
		call randRange							;call randRange to generate a random number between 0 - 6
		inc EAX									;increment EAX so the RNG generates between 1 - 6 (like a dice)
		mov EDX, OFFSET diceRollMsg			
		call writeLine
		.IF dice == EAX							;if the dice rolls the same as the user guess
			mov EDX, OFFSET winMsg				;display a "win" message
			call writeString
			endl
			mov EAX, balance					;mov balance into EAX
			add EAX, 10							;and add $10 (prize amount) to it
			mov balance, EAX					;update the balance variable
			mov EDX, OFFSET bankBalanceMsg		;display the balance to the user
			call writeString
			call writeInt
			endl
			jmp CONTINUELOOP					;prompt user to continue or not
		.ELSE
			mov EDX, OFFSET loseMsg				;same as above if the guess was NOT correct
			call writeString
			call writeInt
			endl
			mov EAX, balance
			sub EAX, guessCost					;subtract $1 from the current balance
			mov balance, EAX
			mov EDX, OFFSET bankBalanceMsg
			call writeString
			call writeInt
			endl
			jmp CONTINUELOOP
		.ENDIF
	.ELSE
		jmp ENDGAME								;if the user doesn't want to continue
	.ENDIF


ENDGAME:										;display the end game messages
	mov EDX, OFFSET bankBalanceMsg				;starting off with the balance
	call writeString
	mov EAX, balance
	call writeInt
	endl
	mov EDX, OFFSET endGameMsg					;thank the user for playing the game
	call writeLine
	endl	
	exit										;end game.
    
main ENDP 
END main