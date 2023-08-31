PROJ ?= verilog_sources/main_tb
ASM ?= assembly/code
NODE_SCRIPT ?= riscv_to_hex/asm
TOOLCHAIN ?= riscv32-unknown-linux-gnu


# Broken because of README
INSTRUCTIONS=$(shell echo tests/tests_* | sed -e "s|tests/tests_||g")

ALL:  project

project: ${PROJ}.v ${ASM}.mem
	@iverilog -Wall -DMEM_FILE=\"${ASM}.mem\" -DVCD_FILE=\"${PROJ}.vcd\" -DCELL_NUMBERS=$(shell wc -l "${ASM}.mem" | awk '{ print $$1 * 4 }') -o ${PROJ}.vvp  ${PROJ}.v > /dev/null 
	@vvp ${PROJ}.vvp >/dev/null


%.mem: %.asm
ifeq ($(USE_NODE),)
	@echo using toolchain
	@${TOOLCHAIN}-as -o $*.o $<
	@${TOOLCHAIN}-ld -o $*.elf $*.o
	@${TOOLCHAIN}-objcopy -O binary --reverse-bytes=4 -j *.text $*.elf $*.bin
	@hexdump $*.bin -e '4/1 "%0.2x " "\n"' > $*.mem
	@rm $*.o $*.elf $*.bin
else
	@echo using node
	@node.exe --no-deprecation ./${NODE_SCRIPT}.js ./$< ./$@
endif



# Define a rule for each instruction
$(foreach INSTRUCTION,$(INSTRUCTIONS),$(eval \
    test_$(INSTRUCTION): tests/tests_$(INSTRUCTION)/$(INSTRUCTION).mem ; \
       @./tests/tests_$(INSTRUCTION)/test.sh \
))





test: $(addprefix test_,$(INSTRUCTIONS))

generate:
	@./tests/generator.sh

template:
	@./tests/templator.sh


clean:
	@rm -rf ${PROJ}.vvp
	@rm -rf ${PROJ}.vcd
	@rm -rf ${ASM}.mem


.PHONY: clean
