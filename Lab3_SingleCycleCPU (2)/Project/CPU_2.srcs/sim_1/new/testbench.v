`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:54:42
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench();
	reg clk = 1'b1;
	reg rst = 1'b1;

	wire[31:0] writedata,dataadr;
	wire memwrite;
    Top top (.clk(clk), .rst(rst), .ALU_result(dataadr), .write_data_memory(writedata), .MemWrite(memwrite));

    initial begin
        forever #100 clk = ~clk;
    end

//	initial begin 
//		rst <= 1;
//		#200;
//		rst <= 0;
//	end

//	always begin
//		clk <= 1;
//		#10;
//		clk <= 0;
//		#10;

//	end

	always @(negedge clk) begin
		if(memwrite) begin
			/* code */
			if(dataadr === 80 & writedata === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end 
			else if(dataadr !== 80) begin
				/* code */
				$display("Simulation Failed");
				$stop;
			end
		end
	end
	
endmodule
