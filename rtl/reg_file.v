`timescale 1ns / 1ps

module reg_file (
    input  wire        clk,
    input  wire        rst,

    // Read addresses
    input  wire [4:0]  rs1_addr,
    input  wire [4:0]  rs2_addr,

    // Read data
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,

    // Write port
    input  wire        we,        // write enable
    input  wire [4:0]  rd_addr,   // destination register
    input  wire [31:0] rd_data    // data to write
);

    reg [31:0] regs[0:31];
    integer i;

    // Synchronous write + reset
    always @(posedge clk) begin
        if (rst) begin
            // reset all 32 registers to 0
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (we && (rd_addr != 5'd0)) begin
            // x0 (reg[0]) is always 0, so skip writes to 0
            regs[rd_addr] <= rd_data;
        end
    end

    // Asynchronous reads
    assign rs1_data = (rs1_addr == 5'd0) ? 32'b0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'b0 : regs[rs2_addr];

endmodule
