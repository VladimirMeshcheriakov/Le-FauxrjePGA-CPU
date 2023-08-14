PROJ := cpu_uart_top_tb
ASM := code
MEM := mem

ALL: ${PROJ}.v
	node.exe ./riscv_to_hex/asm.js ./${ASM}.asm ./${MEM}.mem
	iverilog -o ${PROJ}.vvp ${PROJ}.v
	vvp ${PROJ}.vvp

clean:
	rm -rf *.vvp
	rm -rf *.vcd


.PHONY: clean
