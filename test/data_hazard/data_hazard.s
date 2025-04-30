.text   # code segment
main:   # program entry
    addi t6, x0, 1     # load the immediate 1 (address) into register t6
    lw t0, 0(t6)  # load dmem[1] to t0 (register x5)
    lw t1, 1(t6)  # load dmem[2] to t1 (register x6)
    add t3, t0, t1  # t0(x5) + t1(x6) => t3(x28)
    add t4, t0, t1  # t0(x5) + t1(x6) => t4(x29)
    add t5, t0, t1  # t0(x5) + t1(x6) => t5(x30)
.end    # end of program
