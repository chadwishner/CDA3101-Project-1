

.global _start
.section .text

_start:

/* syscall write(int fd, const void *buf, size_t count) */
/* the three arguments will be put in registers x0, x1, x2*/
/*syscall number is put in register x8.  It tells system what function to call*/

/* syscall read(int fd, const void *buf, size_t count) */
/* the three arguments will be put in registers x0, x1, x2*/
/* the item read will be in the register x1*/
/* the return value is the number of bytes read */
/*syscall number is put in register x8.  It tells system what function to call*/


mov x0, #0
ldr x1, =readformat;
mov x2, #4  //read four characters
mov x8, #63 //  decimal 63 for read
svc #0 //do it!

//now x1 should have what was read



//what is written should be what was read

//x1 should still have what was read

ldr x9, [x1, #0] //x1 is actually an address, put the value at address x1 into x9
add x9, x9, #5  //add 5
str x9, [x1, #0]  //put that number into the address

ldr x10, [x1, #1]
add x10, x10, #5
str x10, [x1, #1]

//write it out
mov x8, #64
mov x0, #1
mov x2, #4
svc #0


//exit the program
mov x8, #93
mov x0, #42
svc #0

ret

.section .data


readformat:
    .asciz "%d"
