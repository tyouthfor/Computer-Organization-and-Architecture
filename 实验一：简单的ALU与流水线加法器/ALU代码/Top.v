`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/02 16:15:57
// Design Name: 
// Module Name: Top
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

//顶层模块
module Top(
    input signed [7:0] num,
    input [2:0] op,
    input clk,
    input rst,
    output [7:0] an,
    output [6:0] seg
    );
    
    //对num进行符号位扩展
    reg [23:0] leftmost;
    always @ (*) begin
        if(num[7] == 1'b0) leftmost = 0;
        else leftmost = -1;
    end
    
    //调用ALU模块
    wire signed [31:0] res;
    ALU ty1(.a(32'h01), .b({leftmost, num}), .op(op), .y(res));
    
    //调用七段数码管显示模块
    Digital_Tube ty2(.clk(clk), .rst(rst), .display(res), .an(an), .seg(seg));
    
endmodule
