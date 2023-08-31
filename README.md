# FPGA-Implemented RISC-V32I Processor in Verilog

![Project Banner](img/fauxrjePGA_banner.jpg)

Welcome to the Le Fauxrje's first project. It aims to provide a comprehensive and fully functional implementation of a RISC-V32I processor using the Verilog hardware description language. The source files have been tested on an [Arty-S7](https://digilent.com/reference/programmable-logic/arty-s7/start) FPGA and future releases will be tested on other modules.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The main aim of this project, was to get familiar with a CPU architecture in general, as well as master the Verilog HDL. Please feel free to criticize and give any form of feedback! The project will be regularly updated, and improvements will be listed in the versions changelog. 

## Features

- **RISC-V32I Compliant:** The processor adheres to the RISC-V RV32I instruction set. Further extensions of the RISC-V ISA will be implemented
- **Modular Design:** The processor's components are organized into separate modules, providing ease of understanding. Header files define values used in different modules, as well as I/O addresses (UART)
- **Pipelined Architecture:** A pipelined design is currently under conception, because of the nature of the current implementation it might be unreasonable to implement.
- **Memory Hierarchy:** The processor will include caches in future releases
- **Interrupt Support:** The processor provides mechanisms for handling interrupts, enabling it to interact with external devices and respond to asynchronous events. Like for example UART.

## Getting Started
As of the current version, there is no proper build/deployment system for Xilinx IDE to actually test the implementation. So just git cloning the project and compiling with `cd src && make project` will compile the code of src/assembly/code.asm and you will be able to launch gtkWave to verify your results.


## Contributing

Contributions to this project are more than welcome! If you'd like to contribute, please make a PR and we will review it ASAP.

## License

This project is licensed under the [MIT License](LICENSE).
