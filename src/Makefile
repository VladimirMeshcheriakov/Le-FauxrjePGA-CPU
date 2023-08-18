PROJ ?= verilog_sources/main_tb
ASM ?= assembly/code
MEM ?= mem
NODE_SCRIPT ?= riscv_to_hex/asm

INSTRUCTIONS=$(shell grep -oE '^.*Yes$$' ../README.md | awk '{print $$1}')

ALL: node project

project: ${PROJ}.v
	@iverilog -Wall -DMEM_FILE=\"${MEM}.mem\" -DVCD_FILE=\"${PROJ}.vcd\" -DCELL_NUMBERS=$(shell wc -l "${MEM}.mem" | awk '{ print $$1 * 4 }') -o ${PROJ}.vvp  ${PROJ}.v > /dev/null
	@vvp ${PROJ}.vvp > /dev/null

node: 
	@echo fetching... 
	@node.exe --no-deprecation ./${NODE_SCRIPT}.js ./${ASM}.asm ./${MEM}.mem

# Define a rule for each instruction
$(foreach INSTRUCTION,$(INSTRUCTIONS),$(eval \
    test_$(INSTRUCTION): tests/tests_$(INSTRUCTION)/$(INSTRUCTION).mem ; \
       @./tests/tests_$(INSTRUCTION)/test.sh \
))


%.mem: %.asm
	@echo fetching test...
	@node.exe --no-deprecation ./${NODE_SCRIPT}.js ./$< ./$@


test: $(addprefix test_,$(INSTRUCTIONS))

generate:
	@./tests/generator.sh

template:
	@./tests/templator.sh


clean:
	@rm -rf ${PROJ}.vvp
	@rm -rf ${PROJ}.vcd


.PHONY: clean
