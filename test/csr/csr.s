.text   # code segment
main:   # program entry
    addi t0, x0, 0xaa
    addi t1, x0, 0x55
    addi t2, x0, -5
    csrrw a0, mcycle, t2        # mcycle => a0, t2 => mcycle
    csrrs a0, mcycle, t0        # mcycle => a0, t0 | mcycle => mcycle
    csrrc a0, mcycle, t0        # mcycle => a0, ~t0 & mcycle => mcycle
    csrrwi a0, mcycle, 0x1a        # mcycle => a0, 0x1a => mcycle
    csrrci a0, mcycle, 0x1a        # mcycle => a0, 0x05 & mcycle => mcycle
    csrrsi a0, mcycle, 0x1a        # mcycle => a0, 0x1a | mcycle => mcycle
.end    # end of program
