`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/21 11:49:18
// Design Name: 
// Module Name: pipelined_CPU_sim
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


module pipelined_CPU_sim(

    );
    
    reg clk;
    reg rst;
    
    wire [31:0] ALU_result;  // dataadr
    wire [31:0] write_data_memory;  // writedata
    wire MemWrite;
    
    Top ty (.clk(clk), .rst(rst), .ALU_result(ALU_result), .write_data_memory(write_data_memory), .MemWrite(MemWrite));
    
    initial begin
        rst <= 0;
        #100;
        rst <= 1;
    end
    
    always begin
        clk <= 1;
        #100;
        clk <= 0;
        #100;
    end
    
    always @ (negedge clk) begin
        if (MemWrite) begin
            if (ALU_result === 84 & write_data_memory === 7) begin
                $display("Simulation succeeded");
                $stop;
            end
            else if (ALU_result !== 80) begin
                $display("Simulation Failed");
                $stop;
            end
        end
    end
    
endmodule
