`timescale 1ns / 1ps

module data_mem_tb;

    reg         clk;
    reg         we, re;
    reg  [31:0] addr;
    reg  [31:0] wdata;
    wire [31:0] rdata;

    data_mem dut (
        .clk(clk),
        .we(we),
        .re(re),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata)
    );

    initial clk = 0;
    always #5 clk = ~clk;   // 100 MHz clock

    initial begin
        $display("==== DATA MEM TEST START ====");

        we = 0; re = 0; addr = 0; wdata = 0;
        #10;

        // Write 0xDEADBEEF to address 0x00000000
        addr  = 32'h00000000;
        wdata = 32'hDEADBEEF;
        we    = 1; re = 0;
        #10;

        // Stop write, then read back
        we = 0;
        re = 1;
        #10;
        $display("Read @0x00000000 = 0x%08h (expected 0xDEADBEEF)", rdata);

        // Another write at address 0x00000010
        re = 0;
        addr  = 32'h00000010;
        wdata = 32'hCAFEBABE;
        we    = 1;
        #10;

        // Read it
        we = 0;
        re = 1;
        #10;
        $display("Read @0x00000010 = 0x%08h (expected 0xCAFEBABE)", rdata);

        $display("==== DATA MEM TEST END ====");
        $finish;
    end

endmodule
