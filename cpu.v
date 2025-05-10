module cpu (
	input clk,
	input reset, 
	output [7:0] out
);

	wire [7:0] instruction;
	wire [7:0] data;
	wire [7:0] alu_result;
	wire [7:0] program_counter;
	
	control control_unit (
		.clk(clk),
		.reset(reset),
		.instruction(instruction)
	);
	
	datapath data_path (
		.clk(clk),
		.reset(reset),
		.instruction(instruction),
		.alu_result(alu_result),
		.out(data)
	);
	
	assign program_counter = program_counter + 1;
	
	assign out = data;
endmodule