.text   # code segment
main:   # program entry
    addi t0, x0, 1     # load the immediate 1 (address) into register t0 (x5)
    addiw t1, x0, 2     # load the immediate 2 (address) into register t1 (x6) 
    add t2, t0, t1     
    sub t2, t0, t1     

    addi t0, x0, 0x7ff     # load the immediate 0x7ff into register t0 (x5)
    addi t1, x0, 0x7ff     # load the immediate 0x7ff into register t0 (x5)
    xor t2, t0, t1
    and t2, t0, t1
    or t2, t0, t1
    add t1, x0, 1     # load the immediate 1 (address) into register t1 (x6) 
    sll t2, t0, t1     
    srl t2, t0, t1     
    sra t2, t0, t1     
    sllw t2, t0, t1     
    srlw t2, t0, t1     
    sraw t2, t0, t1     
.end    # end of program


