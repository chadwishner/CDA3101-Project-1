.section .data

	prompt:
		.asciz "input a string: "
	stringread:
		.asciz "%s" 
	strbuffer: 
		.space 256


.text
.global main
	//print prompt
	mov x0, #1
	ldr x1, =prompt
	mov x2, #16
	mov x8, #0x40 //hex 40 for write  (decimal 64)
	svc #0 //do it!

	//save string
	ldr x0, =stringread
	ldr x1, =strbuffer
	bl scanf

	//calculate length
	ldr x3, =strbuffer

loop:
	ldrb w1, [x0, x4]
	CBZ w1, break 
	ADD x4, x4, 1
	bl loop

break:
	mov x0, #1
	ldr x1, =x4
	mov x2, #16
	mov x8, #0x40 //hex 40 for write  (decimal 64)
	svc #0 //do it!

//how do i print the value of x4, how do i then start the recurrsive check








/*
	mov x0, x4
	bl printf

//how do i print the value of x4, how do i then start the recurrsive check





//old shit

_start:	.global _start
		.global main
		b		main

main:	
	//Print the prompt
		mov x0, #1
		ldr x1, =prompt
		mov x2, #16
		mov x8, #0x40 //hex 40 for write  (decimal 64)
		svc #0 //do it!

	//Take in the input
		mov x0, #1
		ldr x0, = stringread
		ldr x1, =strbuffer
		mov x2, #256
		mov x8, #63
		svc #0 //do it!

	//Print out string length
		mov x0, #1
		ldr x1, =length
		mov x2, #256
		mov x8, #0x40 //hex 40 for write
		svc #0 //do it!

	//need to call recursive things?
		//TODO
	

	//end program
		b exit

base:
		//TODO
recurse:
		//TODO
end_rec:
		//TODO

exit:	
	//exit the program
		mov x8, #93 //why is this difference from reverse????
		mov x0, #42 //why is this different from reverse????
		svc #0

ret //what does this do?????

*/











/*
if (string.length = 1 || string.length = 0){
	return true
} else if (string.charat(0) != string.charat(string.length-1)){
	return false
} else {
	return function(string.substring(1, string.length-1))
}
*/