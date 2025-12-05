`timescale 1ns / 1ps

// RISC-V RV32I instruction decoder + immediate generator
module decoder (
    input  wire [31:0] instr,

    // Basic fields
    output wire [6:0]  opcode,
    output wire [4:0]  rd,
    output wire [2:0]  funct3,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [6:0]  funct7,

    // Immediates (sign-extended)
    output reg  [31:0] imm_i,   // I-type (ADDI, LW, etc)
    output reg  [31:0] imm_s,   // S-type (SW)
    output reg  [31:0] imm_b    // B-type (BEQ)
);

    // Extract common fields
    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    // Immediate generation
    // All are sign-extended from MSB of their immediate field (bit 31 of instr)
    always @* begin
        // I-type: imm[11:0] = instr[31:20]
        imm_i = {{20{instr[31]}}, instr[31:20]};

        // S-type: imm[11:5] = instr[31:25], imm[4:0] = instr[11:7]
        imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};

        // B-type: imm[12|10:5|4:1|11|0] spread across bits
        // imm[12]   = instr[31]
        // imm[10:5] = instr[30:25]
        // imm[4:1]  = instr[11:8]
        // imm[11]   = instr[7]
        // imm[0]    = 0 (because branch offsets are multiples of 2)
        imm_b = {{19{instr[31]}},   // sign extension bit
                 instr[31],         // imm[12]
                 instr[7],          // imm[11]
                 instr[30:25],      // imm[10:5]
                 instr[11:8],       // imm[4:1]
                 1'b0};             // imm[0]
    end

endmodule
