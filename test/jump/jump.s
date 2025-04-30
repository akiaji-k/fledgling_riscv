.text   # code segment
main:   # program entry
    addi t0, x0, 1     # load the immediate 1 (address) into register t0 (x5)
    addi t1, x0, 1     # load the immediate 1 (address) into register t1 (x6)
    jal ra, jal_target       # save address in  register ra (x1) and jump to label jal_target

    addi t0, x0, 2     # load the immediate 2 (address) into register t0 (x5)
    addi t1, x0, 2     # load the immediate 2 (address) into register t1 (x6)

    jalr t6, 2(t0) # jump to the address in register t0 + immediate value 38 and return to the next instruction

    addi t2, x0, 1     # load the immediate 1 (address) into register t2 (x7)
    addi t2, x0, 2     # load the immediate 2 (address) into register t2 (x7)
    addi t2, x0, 3     # load the immediate 3 (address) into register t2 (x7)
    addi t3, x0, 1     # load the immediate 1 (address) into register t3 (x28)
    addi t3, x0, 2     # load the immediate 2 (address) into register t3 (x28)
    addi t3, x0, 3     # load the immediate 3 (address) into register t3 (x28)

jal_target:
    addi t4, x0, 4     # load the immediate 4 (address) into register t4 (x29)
    addi t5, x0, 5     # load the immediate 5 (address) into register t5 (x30)
    addi t6, x0, 6     # load the immediate 6 (address) into register t6 (x31)
    jalr ra, 0(ra) # jump to the address in register ra and return to the next instruction
.end    # end of program

