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
    //print out length
    stp x30, x10, [sp, #-16]!
    LDR x0, =lengthformat
	MOV x1, x10
	bl printf

    //flush it
    LDR x0, =flush
    bl printf
    ldp x30, x0, [sp], #16

//added all of the shit below from reverse    
    //ldr x0, =lengthformat
    //mov x0, #256 //not sure if we are allowed to do 256
    mov x20, #0 //added this for checking if it is a palin

    sub x0, x0, #1 
    ldr x1, =strbuffer
    mov x2, #0

    bl reverse

    bl ispalin
    //ldr x0, =flush
    // bl printf
    
    //b exit

reverse:    
    #In reverse we want to maintain
    #x0 is length-1
    #x1 is memory location where string is
    #x2 is index

    subs x3, x2, x0

    #If we haven't reached the last index, recurse
    b.lt recurse

base:       
    #We've reached the end of the string. Print!
    //ldr x0, =outformat
        
    #We need to keep x1 around because that's the string address!
    #Also bl will overwrite return address, so store that too
    stp x30, x1, [sp, #-16]!
    ldrb w1, [x1, x2]
    //bl printf
    ldp x30, x1, [sp], #16

   //added this v
    //check if equal to corresponding character
    ldrb w5, [x1, x2] //x2 is index
    //ldr x1, =strbuffer
    //sub x4, lengthformat, x2 //where the fuck is length
    ldrb w12, [x1, x20] //2 is index

    CMP w5, w12
    b.ne notpalin
    add x20, x20, #1
    //added this ^


    #Go back and start executing at the return
    #address that we stored 
    br x30

recurse:    
    #First we store the frame pointer(x29) and 
    #link register(x30)
    sub sp, sp, #16
    str x29, [sp, #0]
    str x30, [sp, #8]

    #Move our frame pointer
    add x29, sp, #8

    #Make room for the index on the stack
    sub sp, sp, #16

    #Store it with respect to the frame pointer
    str x2, [x29, #-16]

    add x2, x2, #1 

    #Branch and link to original function. 
    bl reverse

    #Back from other recursion, so load in our index
end_rec:    
    ldr x2, [x29, #-16]

    #Print the char!
    stp x30, x1, [sp, #-16]!
    //ldr x0, =outformat
    ldrb w1, [x1, x2] //2 is index
    //bl printf
    ldp x30, x1, [sp], #16

    //added this v
    //check if equal to corresponding character
    ldrb w5, [x1, x2] //x2 is index
    //ldr x1, =strbuffer
    //sub x4, lengthformat, x2 //where the fuck is length
    ldrb w12, [x1, x20] //2 is index

    CMP w5, w12
    b.ne notpalin
    add x20, x20, #1
    //added this ^

    #Clear off stack space used to hold index
    add sp, sp, #16

    #Load in fp and lr
    ldr x29, [sp, #0]
    ldr x30, [sp, #8]
            
    #Clear off the stack space used to hold fp and lr
    add sp, sp, #16

    #Return to correct location in execution
    br x30

notpalin:
    LDR x0, =stringread
	LDR x1, =nope
	bl printf

    //flush it
    LDR x0, =flush
    bl printf
    b exit

ispalin:
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
