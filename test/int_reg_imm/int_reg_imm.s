.text   # code segment
main:   # program entry
    addi t0, x0, 1     # load the immediate 1 (address) into register t0 (x5)
    addiw t1, x0, 0x2     # load the immediate 2 (address) into register t1 (x6) 
    slti t1, x0, 0x2     # set less than immediate (signed) 2 into register t1 (x6)
    sltiu t1, x0, 0x2     # set less than immediate (unsigned) 2 into register t1 (x6)

    addi t0, x0, 0x7ff     # load the immediate 0x7ff into register t0 (x5)
    xori t1, t0, 0x7ff     # (t0 ~ 0x7ff) into register t1 (x6)
    andi t1, t0, 0x7ff     # (t0 & 0x7ff) into register t1 (x6)
    ori t1, t0, 0x7aa     # (t0 | 0x7ff) into register t1 (x6)
    slli t1, t0, 1     # shift t0 left logical immediate value 1 into register t1 (x6)
    srli t1, t0, 1     # shift t0 right logical immediate value 1 into register t1 (x6)
    srai t1, t0, 1     # shift t0 right logical immediate value 1 into register t1 (x6)
    slliw t1, t0, 1     # shift t0 left logical immediate value 1 into register t1 (x6)
    srliw t1, t0, 1     # shift t0 right logical immediate value 1 into register t1 (x6)
    sraiw t1, t0, 1     # shift t0 right logical immediate value 1 into register t1 (x6)
.end    # end of program


