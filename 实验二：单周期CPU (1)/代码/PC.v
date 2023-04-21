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
    input [31:0] cin,  // cin：下一条指令的地址
    output reg [31:0] cout = 32'h0,  //cout：当前指令的地址
    output reg instruction_en = 1'b1  //instruction_en：当前指令地址是否有效
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
