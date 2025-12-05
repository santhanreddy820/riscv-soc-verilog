`timescale 1ns / 1ps

module control_unit_tb;

    reg  [6:0] opcode;
    reg  [2:0] funct3;
    reg  [6:0] funct7;

    wire       reg_write;
    wire       mem_read;
    wire       mem_write;
    wire       branch;
    wire       mem_to_reg;
    wire       alu_src;
    wire [3:0] alu_ctrl;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .alu_ctrl(alu_ctrl)
    );

    initial begin
        $display("==== CONTROL UNIT TEST START ====");

        // Simulate an R-type ADD instruction:
        // opcode = 0110011, funct3 = 000, funct7 = 0000000
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        $display("R-type ADD: reg_write=%b (1), mem_read=%b (0), mem_write=%b (0), branch=%b (0), alu_src=%b (0), mem_to_reg=%b (0), alu_ctrl=%b (0000)",
                 reg_write, mem_read, mem_write, branch, alu_src, mem_to_reg, alu_ctrl);

        $display("==== CONTROL UNIT TEST END ====");
        $finish;
    end

endmodule
