#!/bin/bash

INSTRUCTIONS=$(grep -oE '^.*Yes$' ../README.md | awk '{print $1}')
TEST_DIR_NAME="tests/tests_"


for i in ${INSTRUCTIONS}; do
    TEST_DIR_INSTRUCTION=${TEST_DIR_NAME}$i
    #if [ -d ${TEST_DIR_INSTRUCTION} ]; then
     #  continue
    #else
     #   mkdir ${TEST_DIR_INSTRUCTION}
      #  touch ${TEST_DIR_INSTRUCTION}/${i}.asm
       # touch ${TEST_DIR_INSTRUCTION}/instr_${i}_tb.v
        cat tests/test_template.sh | sed "s/\PLACEHOLDER/${i}/g" > ${TEST_DIR_INSTRUCTION}/test.sh
        chmod +x ${TEST_DIR_INSTRUCTION}/test.sh


    #fi
done