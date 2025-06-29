.text   # code segment
main:   # program entry
    addi t0, x0, 0xaa
    addi t1, x0, 0x55
    addi t2, x0, -5
    addi t3, x0, 1
    ecall
    add t4, x0, t0
    add t5, x0, t1
    add t6, x0, t2
.end    # end of program
