PROJ := verilog_sources/main_tb
ASM := assembly/code
MEM := mem

ALL: ${PROJ}.v
	node.exe ./riscv_to_hex/asm.js ./${ASM}.asm ./${MEM}.mem
	iverilog -o ${PROJ}.vvp ${PROJ}.v
	vvp ${PROJ}.vvp

clean:
	rm -rf *.vvp
	rm -rf *.vcd


.PHONY: clean