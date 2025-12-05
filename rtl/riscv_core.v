`timescale 1ns / 1ps

module riscv_core (
    input  wire        clk,
    input  wire        rst,

    // Instruction memory interface
    output wire [31:0] instr_addr,
    input  wire [31:0] instr,

    // Data memory interface
    output wire [31:0] data_addr,
    output wire [31:0] data_wdata,
    input  wire [31:0] data_rdata,
    output wire        data_we,
    output wire        data_re
);

    // -------------------------
    // Program Counter (PC)
    // -------------------------
    reg [31:0] pc;
    wire [31:0] pc_next;

    // We'll update PC later using branch logic.
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'b0;      // start at address 0
        else
            pc <= pc_next;
    end

    assign instr_addr = pc;    // core asks for instruction at PC


    // -------------------------
    // Decoder outputs
    // -------------------------
    wire [6:0]  opcode;
    wire [4:0]  rd, rs1, rs2;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [31:0] imm_i, imm_s, imm_b;

    decoder u_dec (
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


    // -------------------------
    // Control unit outputs
    // -------------------------
    wire        reg_write;
    wire        mem_read;
    wire        mem_write;
    wire        branch;
    wire        mem_to_reg;
    wire        alu_src;
    wire [3:0]  alu_ctrl;

    control_unit u_ctrl (
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


    // -------------------------
    // Register File
    // -------------------------
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    reg  [31:0] write_back_data;

    reg_file u_rf (
        .clk(clk),
        .rst(rst),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .we(reg_write),
        .rd_addr(rd),
        .rd_data(write_back_data)
    );


    // -------------------------
    // ALU
    // -------------------------
    wire [31:0] alu_in_b;
    wire [31:0] alu_result;
    wire        alu_zero;

    // Opcodes (same as in control_unit, for immediate selection)
    localparam OPCODE_STORE = 7'b0100011;

    // Choose which immediate to use:
    //  - I-type (ADDI, LW) use imm_i
    //  - S-type (SW)       use imm_s
    wire [31:0] alu_imm;
    assign alu_imm = (opcode == OPCODE_STORE) ? imm_s : imm_i;

    // Second ALU operand: either register (rs2) or chosen immediate
    assign alu_in_b = (alu_src) ? alu_imm : rs2_data;


    alu u_alu (
        .op_a(rs1_data),
        .op_b(alu_in_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(alu_zero)
    );


    // -------------------------
    // Branch decision & PC update
    // -------------------------

    // For BEQ: take branch when branch=1 and alu_zero=1 (rs1 == rs2)
    wire take_branch = branch & alu_zero;

    // Next PC: either PC + 4 or PC + imm_b (branch target)
    assign pc_next = take_branch ? (pc + imm_b) : (pc + 32'd4);


    // -------------------------
    // Data memory interface
    // -------------------------
    assign data_addr  = alu_result;   // ALU result often used as address
    assign data_wdata = rs2_data;     // store rs2 to memory
    assign data_we    = mem_write;
    assign data_re    = mem_read;

    // Write-back selection to reg file
    always @* begin
        if (mem_to_reg)
            write_back_data = data_rdata;  // load from memory
        else
            write_back_data = alu_result;  // ALU result
    end

endmodule
