`timescale 1ns / 1ps

module riscv_core_tb;

    reg         clk;
    reg         rst;

    wire [31:0] instr_addr;
    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire        data_we;
    wire        data_re;

    wire [31:0] instr;
    wire [31:0] data_rdata;

    // -------------------------
    // Instantiate the core
    // -------------------------
    riscv_core dut (
        .clk(clk),
        .rst(rst),
        .instr_addr(instr_addr),
        .instr(instr),
        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_rdata(data_rdata),
        .data_we(data_we),
        .data_re(data_re)
    );

    // -------------------------
    // Instruction memory model
    // -------------------------
    reg [31:0] imem[0:255];   // 256 words = 1KB

    // PC is byte address; word index = bits [9:2]
    wire [7:0] instr_word_addr = instr_addr[9:2];
    assign instr = imem[instr_word_addr];

    // For now, no real data memory: always read 0
    assign data_rdata = 32'b0;

    // -------------------------
    // Clock generation
    // -------------------------
    initial clk = 0;
    always #5 clk = ~clk;   // 100 MHz clock (10 ns period)

    // -------------------------
    // Test sequence
    // -------------------------
    integer i;

    initial begin
        $display("==== RISC-V CORE TEST START ====");

        // Initialize instruction memory with NOPs (ADDI x0,x0,0 = 0x00000013)
        for (i = 0; i < 256; i = i + 1) begin
            imem[i] = 32'h00000013;   // NOP
        end

        // Apply reset
        rst = 1;
        #20;
        rst = 0;

        // Let the core run for some cycles
        for (i = 0; i < 10; i = i + 1) begin
            #10; // wait one clock period (pos+neg)
            $display("Cycle %0d: PC = 0x%08h, instr = 0x%08h, data_addr=0x%08h, data_we=%b, data_re=%b",
                     i, instr_addr, instr, data_addr, data_we, data_re);
        end

        $display("==== RISC-V CORE TEST END ====");
        $finish;
    end

endmodule
