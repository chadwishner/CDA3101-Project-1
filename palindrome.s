.section .data

	prompt:
		.asciz "input a string: "
    nope:
        .asciz "N"
    yup:
        .asciz "Y"
	stringread:
		.asciz "%s" 
	strbuffer: 
		.space 256
	lengthformat:
		.asciz "%d"
    flush:          
        .asciz "\n"
    outformat:     
        .asciz "%c" 

.text
.global main

main:
	//print prompt
	MOV x0, #1
	LDR x1, =prompt
	MOV x2, #16
	MOV x8, #0x40 //hex 40 for write  (decimal 64)
	SVC #0 //do it!

    //save string
	LDR x0, =stringread
	LDR x1, =strbuffer
	bl scanf

	//calculate length
    MOV x10, #0

loop:
    //save input string into x11
    LDR x11, =strbuffer
    //get character at x10 in x11 and store it in w11
    LDRB w11, [x11, x10]
	//if w11 is zero, we have reached the end of the string and break
    CBZ w11, break 
	//else increment x10
    ADD x10, x10, #1
	b loop
    
break:
    //temporarily store the length in the stack so that the printf doesn't mess with it
    stp x30, x10, [sp, #-16]!

    //print out length
    LDR x0, =lengthformat
	MOV x1, x10
	bl printf

    //flush it
    LDR x0, =flush
    bl printf

    //load the length back and into x0 so we can reverse the string
    ldp x30, x0, [sp], #16

    //create an index variable that start from the beginning of the input string
    mov x20, #0

    //subtract 1 from the length to have the proper index
    sub x0, x0, #1 
    ldr x1, =strbuffer
    
    //create an index variable that start from the beginning of the reverse string
    mov x2, #0

    //call the reverse function
    bl reverse

    //if we get back here, then the input is a palindrome so get ready to print 'Y'
    bl ispalin

reverse:    
    //x0 is length-1
    //x1 is memory location where the input string is
    //x2 is the reverse string's index

    //if the current index is less the the end index, we must go deeper in the recurrsive call  
    subs x3, x2, x0

    //If we haven't reached the last index, recurse
    b.lt recurse

base:               
    //store the string (x1) in the stack so that we don't loose it
    stp x30, x1, [sp, #-16]!
    
    //Load the correct character of x1 at x2 into w1 for comparison
    ldrb w1, [x1, x2]   //we may not need this

    //load the length back and into x1 so we can reverse the string
    ldp x30, x1, [sp], #16

    //Load the correct character of x1 at x2 into w5 for comparison
    ldrb w5, [x1, x2] 
 
    //Load the correct character of x1 at x2 into w12 for comparison
    ldrb w12, [x1, x20]

    //compare w5 and w12 which are the characters of the reversed and input length respectively
    CMP w5, w12
    //if the characters are not equal, then we need to break out and print 'N'
    b.ne notpalin
    //else we need to increment x20 (the input string's index)
    add x20, x20, #1

    //Go back and start executing at the return
    //address that we stored 
    br x30

recurse:    
    //First we store the frame pointer(x29) and link register(x30)
    sub sp, sp, #16
    str x29, [sp, #0]
    str x30, [sp, #8]

    //Move our frame pointer
    add x29, sp, #8

    //Make room for the index on the stack
    sub sp, sp, #16

    //Store it with respect to the frame pointer
    str x2, [x29, #-16]

    add x2, x2, #1 

    //Branch and link to original function. 
    bl reverse

end_rec:    
    ldr x2, [x29, #-16]

    //store the string (x1) in the stack so that we don't loose it
    stp x30, x1, [sp, #-16]!
    
    //load the correct character of x1 at x2 into w1 for comparison
    ldrb w1, [x1, x2] //we may not need this
    
    //load the length back and into x1 so we can reverse the string
    ldp x30, x1, [sp], #16

    //Load the correct character of x1 at x2 into w5 for comparison
    ldrb w5, [x1, x2]
    
    //Load the correct character of x1 at x2 into w12 for comparison
    ldrb w12, [x1, x20]

    //compare w5 and w12 which are the characters of the reversed and input length respectively
    CMP w5, w12
    //if the characters are not equal, then we need to break out and print 'N'
    b.ne notpalin
    //else we need to increment x20 (the input string's index)
    add x20, x20, #1

    //Clear off stack space used to hold index
    add sp, sp, #16

    //Load in fp and lr
    ldr x29, [sp, #0]
    ldr x30, [sp, #8]
            
    //Clear off the stack space used to hold fp and lr
    add sp, sp, #16

    //Return to correct location in execution
    br x30

notpalin:
    //print 'N' if it is not a palindrome
    LDR x0, =stringread
	LDR x1, =nope
	bl printf

    //flush it
    LDR x0, =flush
    bl printf
    b exit

ispalin:
    //print 'Y' if it is a palindrome
    LDR x0, =stringread
	LDR x1, =yup
	bl printf

    //flush it
    LDR x0, =flush
    bl printf
    b exit

exit:
    mov x0, #0
    mov x8, #93
    svc #0
