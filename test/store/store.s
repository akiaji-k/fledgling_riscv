.text   # code segment
main:   # program entry
    addi t0, x0, 10     # load the immediate value 10 into register t0
    addi t6, x0, 5     # load the immediate value 5 into register t6
    sw t0, 2(t6)  # store word from t0 to memory address in t6 with 2 byte offset (5+2=7)
    sh t0, 4(t6)  # store half from t0 to memory address in t6 with 4 byte offset (5+4=9) 
    sb t0, 6(t6)  # store byte from t0 to memory address in t6 with 6 byte offset (5+6=11)
    sd t0, 0(t6)  # store double-word from t0 to memory address in t6 with 0 byte offset (5+0=5)
.end    # end of program

