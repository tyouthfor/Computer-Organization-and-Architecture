`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/02 15:17:38
// Design Name: 
// Module Name: ALU_sim
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


module ALU_sim(
    
    );
    reg signed [31:0] a = 32'd1;
    reg signed [31:0] b = -1;
    reg [2:0] op = 3'b000;
    wire signed [31:0] y;
    
    ALU ty(.a(a), .b(b), .op(op), .y(y));
    
    initial begin
        forever #100 op = op + 1'b1;
    end
    
endmodule
