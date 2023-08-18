#!/bin/bash

DEFAULT_COLOR=$(tput sgr0)
INSTRUCTION=SLTIU

make project --no-print-directory NODE_SCRIPT=riscv_to_hex/asm PROJ=tests/tests_${INSTRUCTION}/instr_${INSTRUCTION}_tb ASM=tests/tests_${INSTRUCTION}/${INSTRUCTION} MEM=tests/tests_${INSTRUCTION}/${INSTRUCTION}

if [ $? -ne 0 ]; then
    echo -e "${DEFAULT_COLOR}\033[31mTest: ${INSTRUCTION} Failed!${DEFAULT_COLOR}"
    exit 1
else
    echo -e "${DEFAULT_COLOR}\033[32mTest: ${INSTRUCTION} Succeeded!${DEFAULT_COLOR}"
    make clean PROJ=tests/tests_${INSTRUCTION}/instr_${INSTRUCTION}_tb ASM=tests/tests_${INSTRUCTION}/instr_${INSTRUCTION}_asm MEM=tests/tests_${INSTRUCTION}/${INSTRUCTION} > /dev/null
    exit 0
fi

