#!/bin/bash

DEFAULT_COLOR=$(tput sgr0)
INSTRUCTION=BGE
PATH_TO_TEST_DIR=tests/tests_${INSTRUCTION}

make project --no-print-directory NODE_SCRIPT=riscv_to_hex/asm PROJ=${PATH_TO_TEST_DIR}/instr_${INSTRUCTION}_tb ASM=${PATH_TO_TEST_DIR}/${INSTRUCTION} MEM=${PATH_TO_TEST_DIR}/${INSTRUCTION}

if [ $? -ne 0 ]; then
    echo -e "${DEFAULT_COLOR}\033[31mTest: ${INSTRUCTION} Failed!${DEFAULT_COLOR}"
    gtkwave "./${PATH_TO_TEST_DIR}/instr_${INSTRUCTION}_tb.vcd"
    exit 1
else
    echo -e "${DEFAULT_COLOR}\033[32mTest: ${INSTRUCTION} Succeeded!${DEFAULT_COLOR}"
    make clean PROJ=${PATH_TO_TEST_DIR}/instr_${INSTRUCTION}_tb ASM=${PATH_TO_TEST_DIR}/instr_${INSTRUCTION}_asm MEM=${PATH_TO_TEST_DIR}/${INSTRUCTION} > /dev/null
    exit 0
fi

