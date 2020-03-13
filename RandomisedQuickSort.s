@This the arm assembly code for Randomised QuickSort that uses an LFSR with polynomial equation x^16 + x^5 + x^3 + x^2 + 1 to generate a random array and random pivot.

.equ SWI_Exit, 0x11
.equ SWI_MeAlloc, 0x12	
        .text    
    
    
    mov r1, #0b100000                                   @ Giving the initial value to the LFSR (you can chose any random value)                                  
    mov r0, #4000                                       @ Alloting a memory of 4000 bytes and storing the starting address in register r0                                
    swi SWI_MeAlloc
    mov r9, r0                                          @ Copying value of r0 in r9
    add r9, r9, #996                                    @ Getting the final value of the address for equallity check
    str r1, [r0]                                        @ Storing the first value of the array

    
    Loop:   
                                            
            mov r2, r1                                  @ Copying value of r1 in register r2
            mov r3, #1                                  @ Intitialisng register r3 with 1
        
            and r4, r2, r3                              @ Extracting the rightmost bit(16)
            
            mov r5, r2, lsr#11                          @ Shifting the elements to the right so that we can extract it 
            and r6, r5, r3                              @ Extracting the rightmost element (5)

            mov r5, r2, lsr#13                          @ Shifting the elements to the right so that we can extract it
            and r7, r5, r3                              @ Extracting the rightmost element (3)

            mov r5, r2, lsr#14                          @ Shifting the elements to the right so that we can extract it
            and r8, r5, r3                              @ Extracting the rightmost element (2)

            eor r7, r8, r7                              @   
            eor r7, r7, r6                              @ Taking Xor of the required values
            eor r7, r7, r4                              @  

            mov r1, r1, lsr#1
            mov r7, r7, lsl#15                      
            eor r1, r1, r7                              @ Inserting the values
            
            add r0, r0, #4                              @ Incrementing the address to the next storage location
            str r1, [r0]                                @ Storing the new number generated in the available address

      cmp r0, r9                                        @ Register r0 is also working as a loop counter; This loop inserts 1000 elements in the LFSR
      bne Loop                                          @ Branch on not equality

      sub r0, r0, #996                                  @ Getting the initial value of the starting index




QuickSort:                                              @ Quick Sort Function 
        stmfd sp!,{r0,r9,lr}                      
        cmp r0, r9                                      @ Comparing whether the starting and ending index are same or not
        bge out_of_recurssion                           @ If same then go out of the recurssion                               
        bl Partition                                    @ Else got to the partition label
        ldmfd sp!,{r0,r9,lr}
        stmfd sp!,{r0,r9,lr}
        sub r9, r4, #4
        bl QuickSort                                    @ Recurssive call
        ldmfd sp!,{r0,r9,lr}
        stmfd sp!,{r0,r9,lr}
        add r0, r4, #4
        bl QuickSort                                    @ Recurssive call
        ldmfd sp!,{r0,r9,lr}
        bx lr


b end_of_partion

Partition:    
        stmfd sp!,{r0,lr}
        bl generateRandomPivot
        ldmfd sp!,{r0,lr}
        ldr r3, [r9]                                    @ pivot element
        sub r4, r0, #4                                  @ i pointer (from our conventional code)
        mov r5, r0                                      @ j pointer (from our conventional code)
        loop:
                ldr r6, [r5]                            @ value of a[j]
                cmp r6, r3                              @ comparing a[j] and pivot
                bge skip                                @ if pivot is smaller
                
                add r4, r4, #4                          @ i++
                ldr r8, [r4]                            @ swapping               
                str r6, [r4]                            @
                str r8, [r5]                            @

                
        skip:    
                add r5, r5, #4
                cmp r5, r9                              @ loop conditions
                bne loop
                
                add r4, r4, #4
                ldr r1, [r4]                             @ swapping pivot and a[i+1] element
                str r1, [r9]
                str r3, [r4]
                bx lr

end_of_partion:



b end_generateRandomPivot 
generateRandomPivot:
           
            mov r1, #0b1000
            mov r2, r1                                  @ Copying value of r1 in register r2
            mov r3, #1                                  @ Intitialisng register r3 with 1
        
            and r4, r2, r3                              @ Extracting the rightmost bit(16)
            
            mov r5, r2, lsr#11                          @ Shifting the elements to the right so that we can extract it 
            and r6, r5, r3                              @ Extracting the rightmost element (5)

            mov r5, r2, lsr#13                          @ Shifting the elements to the right so that we can extract it
            and r7, r5, r3                              @ Extracting the rightmost element (3)

            mov r5, r2, lsr#14                          @ Shifting the elements to the right so that we can extract it
            and r8, r5, r3                              @ Extracting the rightmost element (2)

            eor r7, r8, r7                              @   
            eor r7, r7, r6                              @ Taking Xor of the required values
            eor r7, r7, r4                              @  

            mov r1, r1, lsr#1
            mov r7, r7, lsl#15                      
            eor r1, r1, r7    

            sub r5, r9, r0
            and r2, r2, r5
            add r2, r2, r0                              @ Generating the ranodom pivot
            ldr r5, [r2]
            ldr r4, [r9]
            str r4, [r2]
            str r5, [r9]

end_generateRandomPivot:


out_of_recurssion: bx lr

swi SWI_Exit














