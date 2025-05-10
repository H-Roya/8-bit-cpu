module datapath (
    input  wire clk,
    input  wire reset,
    input  wire reg_write,
    input  wire mem_write,
    input  wire alu_src,
    input  wire pc_write,
    input  wire [2:0] alu_op,
    input  wire mem_to_reg,
    output wire [7:0] instruction_out,
    output wire [7:0] result_out
);

    wire [7:0] pc, instruction;
    wire [7:0] reg_data1, reg_data2, alu_result, mem_data, write_data;
    wire [7:0] alu_operand_b;

    wire [1:0] reg_dst  = instruction[3:2];  // Destination register
    wire [1:0] reg_src1 = instruction[3:2];  // Source A (ALU A)
    wire [1:0] reg_src2 = instruction[1:0];  // Source B (ALU B)

    assign instruction_out = instruction;

    register_file u_register_file (
        .clk(clk),
        .reset(reset),
        .write_enable(reg_write),
        .write_addr(reg_dst),
        .write_data(write_data),
        .read_addr1(reg_src1),
        .read_addr2(reg_src2),
        .read_data1(reg_data1),
        .read_data2(reg_data2),
        .pc_out(pc),
        .pc_write_enable(pc_write)
    );

    memory u_instr_memory (
        .clk(clk),
        .write_enable(1'b0),
        .address(pc),
        .write_data(8'b0),
        .read_data(instruction)
    );

    assign alu_operand_b = (alu_src) ? {4'b0000, instruction[3:0]} : reg_data2;

    alu u_alu (
        .a(reg_data1),
        .b(alu_operand_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero()
    );

    memory u_data_memory (
        .clk(clk),
        .write_enable(mem_write),
        .address(alu_result),
        .write_data(reg_data2),
        .read_data(mem_data)
    );

    assign write_data = (mem_to_reg) ? mem_data : alu_result;
    assign result_out = alu_result;

endmodule


