# RV32I RISC-V SoC in Verilog with UART

This project implements a **single-cycle 32-bit RISC-V (RV32I) processor core and a minimal SoC** in Verilog.  
The SoC executes real RISC-V programs compiled using the GNU RISC-V toolchain and demonstrates output via a **memory-mapped UART**.

## Features
- Single-cycle RV32I RISC-V CPU
- ALU, Register File, Decoder & Control Unit in Verilog
- Byte-addressed Instruction Memory
- Data Memory
- Memory-mapped UART at `0x00000080`
- Bare-metal RISC-V program execution
- Simulation with Icarus Verilog
- Synthesis using Xilinx Vivado (Artix-7)

## Project Structure
riscv_soc/
├── rtl/
├── tb/
├── sw/

## Simulation
```bash
iverilog -g2012 -o soc_sim rtl/*.v tb/soc_top_tb.v
vvp soc_sim
Software Build
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -T link.ld -o prog.elf uart_A.S
riscv-none-elf-objcopy -O verilog prog.elf program.hex

Demo

The default program prints character 'A' on UART using memory-mapped I/O.

Author

Dasari Santhan Reddy
B.Tech – ECE
