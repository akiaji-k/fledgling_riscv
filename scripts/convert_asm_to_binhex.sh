#!/bin/bash
asm_file=$1

# early return if $1 is empty
if [ -z "$1" ]; then
    echo "asm file is expected as an argument."
    exit 1
fi

# early return if an extension of $1 is not '.s'
if [[ $1 != *.s ]]; then
    echo ".s file is expected as an argument."
    exit 1
fi

# file names
object_file="${asm_file%.s}.o"
bin_file="${asm_file%.s}.bin"
xxd_bin_file="${asm_file%.s}_0b.mem"
xxd_hex_file="${asm_file%.s}_0x.mem"

# avoid to use compressed instructions
#riscv64-unknown-linux-gnu-gcc -c $1
#riscv64-unknown-linux-gnu-gcc -march=rv64i -mabi=lp64 -c $1
riscv64-unknown-linux-gnu-gcc -march=rv64i_zicsr -mabi=lp64 -c $1

# show
riscv64-unknown-linux-gnu-objdump -d $object_file -M no-aliases

# file out
riscv64-unknown-linux-gnu-objcopy -O binary $object_file $bin_file
xxd -p -c 1 $bin_file > $xxd_hex_file
xxd -b -c 1 $bin_file | awk '{print $2}' > $xxd_bin_file


echo "Converted from '$1' to binary and hex files."

