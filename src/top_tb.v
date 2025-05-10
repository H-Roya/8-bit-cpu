`timescale 1ns / 1ps

module top_tb();

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [3:0] led_out;
    wire [7:0] result_debug;
    wire [7:0] instruction;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk(clk),
        .reset(reset),
        .led_out(led_out)
    );
    
    // Assign internal signals for monitoring
    assign result_debug = uut.result_debug;
    assign instruction = uut.instruction;

    // Clock generator (50MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns period = 50MHz
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        reset = 1;
        
        // Dump waveform file (for debugging)
        $dumpfile("cpu_waveform.vcd");
        $dumpvars(0, top_tb);
        
        // Wait 100ns for global reset to finish
        #100;
        reset = 0;
        
        // Display header
        $display("Time\tPC\tInstr\tLEDs\tRegWrite\tALUOp");
        $display("--------------------------------------------------");
        
        // Run for enough clock cycles to execute all instructions
        #800; // 40 cycles * 20ns
        
        // Final check
        if (led_out == 4'b1111)
            $display("\nTEST PASSED - Final LED output: %b (expected 1111)", led_out);
        else
            $display("\nTEST FAILED - Final LED output: %b (expected 1111)", led_out);
        
        $finish;
    end

    // Monitor important signals at each clock positive edge
    always @(posedge clk) begin
        if (!reset) begin // Only monitor after reset
            $display("%4t\t%h\t%h\t%b\t%b\t%h", 
                     $time,
                     uut.u_datapath.pc,
                     instruction,
                     led_out,
                     uut.reg_write,
                     uut.alu_op);
				
				$display("REGS: R0=%h R1=%h R2=%h R3=%h",
                     uut.u_datapath.u_register_file.registers[0],
							uut.u_datapath.u_register_file.registers[1],
							uut.u_datapath.u_register_file.registers[2],
							uut.u_datapath.u_register_file.registers[3]);
        end
    end

endmodule