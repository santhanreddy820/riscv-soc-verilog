`timescale 1ns / 1ps

module alu (
    input  wire [31:0] op_a,      // operand A
    input  wire [31:0] op_b,      // operand B
    input  wire [3:0]  alu_ctrl,  // selects operation
    output reg  [31:0] result,    // operation result
    output wire        zero       // flag: 1 when result == 0
);

    always @* begin
        case (alu_ctrl)
            4'b0000: result = op_a + op_b;  // ADD
            4'b0001: result = op_a - op_b;  // SUB
            4'b0010: result = op_a & op_b;  // AND
            4'b0011: result = op_a | op_b;  // OR
            4'b0100: result = op_a ^ op_b;  // XOR
            default: result = 32'b0;        // default 0
        endcase
    end

    // zero flag
    assign zero = (result == 32'b0);

endmodule
