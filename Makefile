PROJ := uart_tb

ALL: ${PROJ}.v
	iverilog -o ${PROJ}.vvp ${PROJ}.v
	vvp ${PROJ}.vvp

clean:
	rm -rf *.vvp
	rm -rf *.vcd


.PHONY: clean
