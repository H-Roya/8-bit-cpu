`timescale 1ns / 1ps

module control (
    input  wire [7:0] instruction,   // 8-bit instruction
    output reg        reg_write,
    output reg        mem_write,
    output reg        alu_src,       // 0: register, 1: immediate
    output reg        pc_write,
    output reg [2:0]  alu_op,
    output reg        mem_to_reg     // 0: ALU result, 1: memory load
);

    // Instruction fields
    wire [3:0] opcode;
    wire [3:0] operand;

    assign opcode  = instruction[7:4];
    assign operand = instruction[3:0];

    always @(*) begin
        // Default values
        reg_write  = 0;
        mem_write  = 0;
        alu_src    = 0;
        pc_write   = 1;
        alu_op     = 3'b000;
        mem_to_reg = 0;

        case (opcode)
            4'b0000: begin
                // NOP
                pc_write = 1;
                // No ALU or register effects
            end
            4'b0001: begin
                // ADD
                reg_write = 1;
                alu_op = 3'b000; // ADD
            end
            4'b0010: begin
                // SUB
                reg_write = 1;
                alu_op = 3'b001; // SUB
            end
            4'b0011: begin
                // AND
                reg_write = 1;
                alu_op = 3'b010; // AND
            end
            4'b0100: begin
                // OR
                reg_write = 1;
                alu_op = 3'b011; // OR
            end
            4'b0101: begin
                // LOAD (from memory into register)
                reg_write = 1;
                mem_to_reg = 1;
                alu_op = 3'b000; // Address = reg + offset
            end
            4'b0110: begin
                // STORE (register to memory)
                mem_write = 1;
                alu_op = 3'b000; // Address = reg + offset
            end
            4'b0111: begin
                // LOAD IMMEDIATE (immediate value to register)
                reg_write = 1;
                alu_src = 1;      // Use immediate
                alu_op = 3'b000;  // Pass-through (ADD with 0)
            end
            4'b1000: begin
                // JUMP
                pc_write = 1;
                reg_write = 0;
                // No ALU operation needed
            end
            4'b1001: begin
                // LESS THAN
                reg_write = 1;
                alu_op = 3'b101; // LESS THAN
            end
            4'b1010: begin
                // NOT (unary)
                reg_write = 1;
                alu_op = 3'b100; // NOT
            end
            default: begin
                // Unknown opcode – treat as NOP
                pc_write = 1;
            end
        endcase
    end

    always @(*) begin
        $display("CTRL: op=%b alu_op=%b reg_write=%b", opcode, alu_op, reg_write);
    end

endmodule
