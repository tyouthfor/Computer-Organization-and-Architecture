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

//����ģ��
module Top(
    input signed [7:0] num,
    input [2:0] op,
    input clk,
    input rst,
    output [7:0] an,
    output [6:0] seg
    );
    
    //��num���з���λ��չ
    reg [23:0] leftmost;
    always @ (*) begin
        if(num[7] == 1'b0) leftmost = 0;
        else leftmost = -1;
    end
    
    //����ALUģ��
    wire signed [31:0] res;
    ALU ty1(.a(32'h01), .b({leftmost, num}), .op(op), .y(res));
    
    //�����߶��������ʾģ��
    Digital_Tube ty2(.clk(clk), .rst(rst), .display(res), .an(an), .seg(seg));
    
endmodule
