`timescale 1ns / 1ps

module reg_file_tb;

    reg         clk;
    reg         rst;

    reg  [4:0]  rs1_addr, rs2_addr;
    wire [31:0] rs1_data, rs2_data;

    reg         we;
    reg  [4:0]  rd_addr;
    reg  [31:0] rd_data;

    // DUT
    reg_file dut (
        .clk(clk),
        .rst(rst),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .we(we),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

    // Clock: 10 ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("==== REGFILE TEST START ====");

        // Initial state
        rst = 1;
        we  = 0;
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        rd_addr  = 5'd0;
        rd_data  = 32'd0;
        #20;    // wait 20 ns

        // Release reset
        rst = 0;

        // Write x1 = 10
        we      = 1;
        rd_addr = 5'd1;
        rd_data = 32'd10;
        #10;    // one clock edge

        // Write x2 = 20
        rd_addr = 5'd2;
        rd_data = 32'd20;
        #10;

        // Disable write
        we = 0;

        // Read x1, x2
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;
        #10;
        $display("x1=%0d (expected 10), x2=%0d (expected 20)", rs1_data, rs2_data);

        // Read x0, must always be 0
        rs1_addr = 5'd0;
        #10;
        $display("x0=%0d (expected 0)", rs1_data);

        $display("==== REGFILE TEST END ====");
        $finish;
    end

endmodule
