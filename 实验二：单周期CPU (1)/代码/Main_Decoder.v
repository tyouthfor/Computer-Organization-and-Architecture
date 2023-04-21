`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 15:44:07
// Design Name: 
// Module Name: Main_Decoder
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

// һ������������
module Main_Decoder(
    input [5:0] op,  //op��6-bit opcode
    
    // Mux �� sel �ź�
    output RegDst,
    output ALUSrc,
    output MemtoReg,
    output Branch,
    output Jump,
    
    // ��д�����ź�
    output MemRead,
    output MemWrite,
    output RegWrite,
    
    // ALUOp
    output [1:0] ALUOp
    
    );
    
    // ��ָ�� opcode �ĺ궨��
    `define R_type ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0]  //000000
    `define lw     op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0]     //100011
    `define sw     op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0]      //101011
    `define beq    ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0]   //000100
    `define j      ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0]   //000010
    `define addi   ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0]   //001000
    
    // �����ź�
    assign RegDst = `R_type;
    assign ALUSrc = `lw | `sw | `addi;
    assign MemtoReg = `lw;
    assign Branch = `beq;
    assign Jump = `j;
    
    assign MemRead = `lw;
    assign MemWrite = `sw;
    assign RegWrite = `R_type | `lw | `addi;
    
    assign ALUOp[1] = `R_type;
    assign ALUOp[0] = `beq;
        
endmodule
