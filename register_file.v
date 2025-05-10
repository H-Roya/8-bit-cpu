`timescale 1ns / 1ps

module register_file (
    input  wire        clk,
    input  wire        reset,
    input  wire        write_enable,
    input  wire [1:0]  write_addr,
    input  wire [7:0]  write_data,
    input  wire [1:0]  read_addr1,
    input  wire [1:0]  read_addr2,
    output reg  [7:0]  read_data1,
    output reg  [7:0]  read_data2,
    output reg  [7:0]  pc_out,
    input  wire        pc_write_enable
);

    // 4 registers (R0-R3)
    reg [7:0] registers [0:3];
    
    // Program Counter
    reg [7:0] pc;

    // Initialize registers and PC (for simulation)
    integer i;
    initial begin
        pc = 0;
        for (i = 0; i < 4; i = i + 1)
            registers[i] = 0;
    end

    // Reset and register write handling
	 
	 always @(posedge clk or posedge reset) begin
	     if (reset) begin
	         pc <= 0;
	     end else begin
	         if (write_enable)
		     registers[write_addr] <= write_data;
		 if (pc_write_enable)
			 pc <= (pc < 8'h06) ? pc + 1: PC; 
		 end
	  end
	  
    // Register read (asynchronous)
    always @(*) begin
        read_data1 = registers[read_addr1];
        read_data2 = registers[read_addr2];
        pc_out = pc;
    end

    // Debugging: Monitor register changes
    always @(posedge clk) begin
        if (write_enable) 
            $display("[%t] REG WRITE: R%d = %h", $time, write_addr, write_data);
    end

endmodule
