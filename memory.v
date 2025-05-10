`timescale 1ns / 1ps

module memory (
    input  wire        clk,
    input  wire        write_enable,
    input  wire [7:0]  address,       // 8-bit address
    input  wire [7:0]  write_data,
    output reg  [7:0]  read_data
);

    // 256 x 8-bit memory
    reg [7:0] mem [0:255];

    // Initialize memory
    integer i;
    initial begin
        // Clear all memory
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 8'b0;
        
        // Test program
		  mem[0] = 8'h71; // LI R0, 1
		  mem[1] = 8'h75; // LI R1, 5
		  mem[2] = 8'h7A; // LI R2, 10
	          mem[3] = 8'h1A; // ADD R3, R1, R2
		  mem[4] = 8'h53; // LI R1, 0x75 
		  mem[5] = 8'h6F; // STORE R3 to mem[15]
    end

    // Write memory
    always @(posedge clk) begin
        if (write_enable) begin
            mem[address] <= write_data;
        end
    end

    // Read memory (asynchronous)
    always @(*) begin
        read_data = mem[address];
    end

endmodule
