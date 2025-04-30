.text   # code segment
main:   # program entry
    addi t6, x0, 2     # load the immediate 12 (address) into register t6
    lw t0, 0(t6)  # load word from memory address in t6 with 0 byte offset (addr = 2)
    lw t1, 4(t6)  # load word from memory address in t6 with 4 byte offset (addr = 6)
    lh t2, 6(t6)  # load sign-extended half from memory address in t6 with 6 byte offset (addr = 8)
    lb t3, 7(t6)  # load sign-extended byte from memory address in t6 with 7 byte offset (addr = 9)
    lhu t4, 8(t6)   # load zero-extended half from memory address in t6 with 8 byte offset (addr = 10)
    lbu t5, 10(t6)  # load zero-extended byte from memory address in t6 with 10 byte offset (addr = 12)
.end    # end of program
