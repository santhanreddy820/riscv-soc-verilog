`timescale 1ns / 1ps

// Simple synchronous data memory: 1 KB (256 x 32-bit words)
module data_mem (
    input  wire        clk,
    input  wire        we,        // write enable
    input  wire        re,        // read enable
    input  wire [31:0] addr,      // byte address
    input  wire [31:0] wdata,     // data to write
    output reg  [31:0] rdata      // data read
);

    reg [31:0] mem[0:255];        // 256 words

    // Convert byte address -> word index (assuming word-aligned access)
    wire [7:0] word_addr = addr[9:2];  // use bits [9:2]

    always @(posedge clk) begin
        if (we) begin
            mem[word_addr] <= wdata;
        end
        if (re) begin
            rdata <= mem[word_addr];
        end
    end

endmodule
