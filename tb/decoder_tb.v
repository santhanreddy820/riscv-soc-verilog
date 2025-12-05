`timescale 1ns / 1ps

module decoder_tb;

    reg  [31:0] instr;
    wire [6:0]  opcode;
    wire [4:0]  rd, rs1, rs2;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [31:0] imm_i, imm_s, imm_b;

    decoder dut (
        .instr(instr),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_i(imm_i),
        .imm_s(imm_s),
        .imm_b(imm_b)
    );

    initial begin
        $display("==== DECODER SYNTAX TEST START ====");

        // Just put some dummy values for now
        instr = 32'h00000013;  // this is often NOP (ADDI x0,x0,0) in RV32I
        #10;
        $display("opcode=%b rd=%0d rs1=%0d rs2=%0d funct3=%b funct7=%b",
                 opcode, rd, rs1, rs2, funct3, funct7);
        $display("imm_i=%0d imm_s=%0d imm_b=%0d", imm_i, imm_s, imm_b);

        $display("==== DECODER SYNTAX TEST END ====");
        $finish;
    end

endmodule
