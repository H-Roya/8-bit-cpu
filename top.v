module top (
    input  wire clk,
    input  wire reset,
    output wire [3:0] led_out          // LSB shows the last 4 bits
);

    wire [7:0] result_debug;
    wire [7:0] instruction;

    wire reg_write, mem_write, alu_src, pc_write, mem_to_reg;
    wire [2:0] alu_op;

    datapath u_datapath (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .pc_write(pc_write),
        .alu_op(alu_op),
        .mem_to_reg(mem_to_reg),
        .instruction_out(instruction),
        .result_out(result_debug)
    );

    control u_control (
        .instruction(instruction),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .pc_write(pc_write),
        .alu_op(alu_op),
        .mem_to_reg(mem_to_reg)
    );

    assign led_out = result_debug[3:0]; 
endmodule
