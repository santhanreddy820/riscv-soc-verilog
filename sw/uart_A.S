    .section .text
    .globl _start

_start:
    li   x1, 65          # x1 = ASCII 'A'
    li   x2, 0x80        # UART TX address (must match 0x80 in uart_sim)
    sw   x1, 0(x2)       # store x1 to [x2] -> UART prints 'A'

loop:
    j    loop            # infinite loop to avoid running into garbage
