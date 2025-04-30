# fledgling_riscv
This is a simple RISC-V implementation written in SystemVerilog.

This is for learning processors.



## Features

- RV64I ISA of  [*The RISC-V Instruction Set Manual Volume I: Unprivileged ISA*](https://drive.google.com/file/d/1uviu1nH-tScFfgrovvFCrj7Omv8tFtkp/view?usp=drive_link) 
- 5-stage pipeline
- Single core



## To Do

- Implement the rest of RV64I instructions defined by RISC-V Instruction Set Manual
  - FENCE
  - FENCE_TSO
  - PAUSE
  - ECALL
  - EBREAK
- Implement Zicsr extension (for instructions above)
- Pass [riscv-tests](https://github.com/riscv-software-src/riscv-tests)

