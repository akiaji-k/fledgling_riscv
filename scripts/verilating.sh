#!/bin/bash

# early return if $1 is empty
# early return if an extension of $1 is not '.sv'
if [ -z "$1" ] || [[ $1 != *.sv ]]; then
    echo ".sv file is expected as an argument[0]."
    exit 1
fi

# early return if $2 is empty
# early return if an $2 is not directory
if [ -z "$2" ] || [ ! -d "$2" ]; then
    echo "hdl directory is expected as an argument[1]."
    exit 1
fi

# file names
tb_file=$(basename "$1")
tb_file_dir="./$(dirname "$1")"
tb_module=${tb_file%.sv}
out_dir="$tb_file_dir/obj_dir/"
hdl_file_dir=$2
bin_file="V$tb_module"

#echo "tb_file_dir '$tb_file_dir', tb_file '$tb_file', hdl_file_dir '$hdl_file_dir', fst_file '$fst_file'"

# simulation
#verilator --binary -j 0 -Wall --trace-fst --trace-params --trace-structs --trace-underscore --assert $tb_file
#verilator --binary $tb_file -j 0 -Wall -I$hdl_file_dir -I$tb_file_dir --Mdir $out_dir --trace-fst --trace-params --trace-structs --trace-underscore --assert --top-module $tb_module
#$out_dir$bin_file

verilator --binary $tb_file -j 0 -Wall -I$hdl_file_dir -I$tb_file_dir --Mdir $out_dir --trace-fst --trace-params --trace-structs --trace-underscore --assert --top-module $tb_module && $out_dir$bin_file

