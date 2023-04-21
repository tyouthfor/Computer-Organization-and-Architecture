`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 16:56:50
// Design Name: 
// Module Name: ALU_Decoder
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

// 二级控制译码器
module ALU_Decoder(
    input [1:0] ALUOp,
    input [5:0] funct,
    output [2:0] ALUControl
    );
    
    // 控制信号
    // add：0010
    // sub：0110
    // and：0000
    // or： 0001
    // set on less than：0111
    assign ALUControl[2] = ALUOp[0] | (ALUOp[1] & funct[1]);
    assign ALUControl[1] = ~ALUOp[1] | ~funct[2];
    assign ALUControl[0] = ALUOp[1] | (funct[0] | funct[3]);
    
endmodule
