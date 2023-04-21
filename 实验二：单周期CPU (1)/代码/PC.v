`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 15:26:35
// Design Name: 
// Module Name: PC
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

// Program Counter
module PC(
    input clk,
    input rst,
    input [31:0] cin,  // cin����һ��ָ��ĵ�ַ
    output reg [31:0] cout = 32'h0,  //cout����ǰָ��ĵ�ַ
    output reg instruction_en = 1'b1  //instruction_en����ǰָ���ַ�Ƿ���Ч
    );
    
    always @ (posedge clk) begin
        if(!rst) begin
            cout <= 32'h0;
            instruction_en <= 1'b0;
        end
        else begin
            cout <= cin;
            instruction_en <= 1'b1;
        end
    end
    
endmodule
