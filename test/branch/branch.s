.text   # code segment
main:   # program entry
    addi t0, x0, 2     # load the immediate 2 (address) into register t0 (x5)
#    addi t1, x0, 3     # load the immediate 3 (address) into register t1 (x6)
    addi t1, x0, 2     # load the immediate 2 (address) into register t1 (x6)
    beq t0, t1, target       # set target to PC if t0 == t1
#    bne t0, t1, 0       # add 0 to PC if t0 != t1
#    blt t0, t1, 0       # add 0 to PC if t0 < t1
#    bge t0, t1, 0       # add 0 to PC if t0 >= t1
#    bltu t0, t1, 0       # add 0 to PC if t0 < t1 (unsigned extension)
#    bgeu t0, t1, 0       # add 0 to PC if t0 >= t1 (unsigned extension)

    # 実行してはいけない命令
    addi t2, x0, 1     # load the immediate 1 (address) into register t2 (x7)
    addi t2, x0, 2     # load the immediate 2 (address) into register t2 (x7)
    addi t2, x0, 3     # load the immediate 3 (address) into register t2 (x7)
    addi t3, x0, 1     # load the immediate 1 (address) into register t3 (x28)
    addi t3, x0, 2     # load the immediate 2 (address) into register t3 (x28)
    addi t3, x0, 3     # load the immediate 3 (address) into register t3 (x28)

target:
    # 実行されるべき命令
    addi t4, x0, 4     # load the immediate 4 (address) into register t4 (x29)
    addi t5, x0, 5     # load the immediate 5 (address) into register t5 (x30)
    addi t6, x0, 6     # load the immediate 6 (address) into register t6 (x31)
.end    # end of program

