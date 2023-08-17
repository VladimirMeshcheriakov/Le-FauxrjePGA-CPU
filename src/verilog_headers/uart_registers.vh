// All UART associated regiters defined here


// Internal UART registers
/*
*   UDRR -> UART Data Register Receiver
*   UDRT -> UART Data Register Transmitter
*   USR -> UART Status Register: [RX_ready,TX_ready]
*   UCR -> UART Control  Register: [RX_enable, TX_enable] 
*   UBRR -> UART Baud Rate
*   UCSZ -> UART Character Size
*/

`define UBRR_addr 20
`define UCSZ_addr 21
`define UCR_addr 22
`define UDRT_addr 23
`define USR_addr 24
`define UDRR_addr 25