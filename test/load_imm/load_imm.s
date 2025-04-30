.text   # code segment
main:   # program entry
    addi t0, x0, 1     # load the immediate 1 (address) into register t0 (x5)
    addi t1, x0, 1     # load the immediate 1 (address) into register t1 (x6)
    lui t2, 0x12345     # load upper immediate value 0x12345 << 12 (= 0x12345000) into register t2 (x7)
    auipc t3, 0x12345     # load upper immediate value 0x12345 << 12 + 0xC (= 0x1234500C) into register t3 (x28)
.end    # end of program

