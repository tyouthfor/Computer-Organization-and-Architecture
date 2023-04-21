`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 15:35:02
// Design Name: 
// Module Name: Adder
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

// 2输入加法器
module Adder
#(parameter DATA_WIDTH = 32)  // 默认执行32-bit加法
    (
    input [DATA_WIDTH - 1 : 0] a,
    input [DATA_WIDTH - 1 : 0] b,
    output [DATA_WIDTH - 1 : 0] c
    );
    
    assign c = a + b;
    
endmodule
