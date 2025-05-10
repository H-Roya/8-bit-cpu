`timescale 1ns / 1ps

module alu (
    input  wire [7:0] a,        // Operand A
    input  wire [7:0] b,        // Operand B
    input  wire [2:0] alu_op,   // Operation seç
    output reg  [7:0] result,   // ALU operation result
    output wire       zero      // Zero flag
);

    always @(*) begin
        case (alu_op)
            3'b000: result = a + b;       // ADD
            3'b001: result = a - b;       // SUB
            3'b010: result = a & b;       // AND
            3'b011: result = a | b;       // OR
            3'b100: result = ~a;          // NOT 
            3'b101: result = (a < b) ? 8'b00000001 : 8'b00000000; // Less than
            default: result = 8'b00000000;
        endcase
    end

    assign zero = (result == 8'b00000000);

endmodule
