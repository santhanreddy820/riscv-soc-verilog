`timescale 1ns / 1ps

// Control unit for a small RV32I subset
module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,

    output reg        reg_write,  // write to register file?
    output reg        mem_read,   // read from data memory?
    output reg        mem_write,  // write to data memory?
    output reg        branch,     // is this a branch?
    output reg        mem_to_reg, // WB: 1 = from memory, 0 = from ALU
    output reg        alu_src,    // 0 = rs2, 1 = immediate
    output reg  [3:0] alu_ctrl    // selects ALU operation
);

    // Opcodes (RV32I)
    localparam OPCODE_RTYPE = 7'b0110011; // ADD, SUB, AND, OR, XOR
    localparam OPCODE_ITYPE = 7'b0010011; // ADDI
    localparam OPCODE_LOAD  = 7'b0000011; // LW
    localparam OPCODE_STORE = 7'b0100011; // SW
    localparam OPCODE_BRANCH= 7'b1100011; // BEQ

    always @* begin
        // Default values (NOP)
        reg_write = 0;
        mem_read  = 0;
        mem_write = 0;
        branch    = 0;
        mem_to_reg= 0;
        alu_src   = 0;
        alu_ctrl  = 4'b0000; // default ADD

        case (opcode)
            OPCODE_RTYPE: begin
                // R-type uses rs1 & rs2, writes back ALU result
                reg_write = 1;
                alu_src   = 0;  // second ALU operand = rs2
                mem_to_reg= 0;  // write back ALU result

                // Determine ALU op from funct7+funct3
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_ctrl = 4'b0000; // ADD
                    {7'b0100000, 3'b000}: alu_ctrl = 4'b0001; // SUB
                    {7'b0000000, 3'b111}: alu_ctrl = 4'b0010; // AND
                    {7'b0000000, 3'b110}: alu_ctrl = 4'b0011; // OR
                    {7'b0000000, 3'b100}: alu_ctrl = 4'b0100; // XOR
                    default: alu_ctrl = 4'b0000;  // default ADD
                endcase
            end

            OPCODE_ITYPE: begin
                // e.g., ADDI
                reg_write = 1;
                alu_src   = 1;  // use immediate as second operand
                mem_to_reg= 0;  // write back ALU result
                alu_ctrl  = 4'b0000; // ADD
            end

            OPCODE_LOAD: begin
                // LW: rd = Mem[rs1 + imm]
                reg_write = 1;
                mem_read  = 1;
                mem_to_reg= 1;  // write back from memory
                alu_src   = 1;  // base + offset
                alu_ctrl  = 4'b0000; // ADD
            end

            OPCODE_STORE: begin
                // SW: Mem[rs1 + imm] = rs2
                mem_write = 1;
                alu_src   = 1;  // base + offset
                alu_ctrl  = 4'b0000; // ADD
            end

            OPCODE_BRANCH: begin
                // BEQ: if (rs1 == rs2) PC = PC + imm
                branch   = 1;
                alu_src  = 0;      // use rs1, rs2
                alu_ctrl = 4'b0001; // SUB (check zero)
            end

            default: begin
                // All control signals remain 0 (NOP)
            end
        endcase
    end

endmodule
