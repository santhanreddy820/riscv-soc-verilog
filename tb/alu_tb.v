`timescale 1ns / 1ps

module alu_tb;

    reg  [31:0] op_a;
    reg  [31:0] op_b;
    reg  [3:0]  alu_ctrl;
    wire [31:0] result;
    wire        zero;

    // Instantiate DUT (Device Under Test)
    alu dut (
        .op_a(op_a),
        .op_b(op_b),
        .alu_ctrl(alu_ctrl),
        .result(result),
        .zero(zero)
    );

    initial begin
        $display("==== ALU TEST START ====");

        // Test 1: ADD 10 + 5 = 15
        op_a = 10; op_b = 5; alu_ctrl = 4'b0000; #10;
        $display("ADD: result=%0d (expected 15)", result);

        // Test 2: SUB 10 - 5 = 5
        op_a = 10; op_b = 5; alu_ctrl = 4'b0001; #10;
        $display("SUB: result=%0d (expected 5)", result);

        // Test 3: AND
        op_a = 32'h0F0F0F0F; op_b = 32'h00FF00FF; alu_ctrl = 4'b0010; #10;
        $display("AND: result=%h", result);

        // Test 4: OR
        alu_ctrl = 4'b0011; #10;
        $display("OR : result=%h", result);

        // Test 5: XOR same values → zero flag = 1
        op_a = 32'hAAAA5555; op_b = 32'hAAAA5555; alu_ctrl = 4'b0100; #10;
        $display("XOR: result=%h, zero=%b (expected zero=1)", result, zero);

        $display("==== ALU TEST END ====");
        $finish;
    end

endmodule
