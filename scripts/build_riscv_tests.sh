#!/bin/bash
# copy from https://github.com/riscv-software-src/riscv-tests
git clone https://github.com/riscv/riscv-tests
cd riscv-tests
git submodule update --init --recursive
autoconf
./configure --prefix=$RISCV/target
make
make install

