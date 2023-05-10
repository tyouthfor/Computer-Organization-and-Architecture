`timescale 1ns / 1ps

//*********************************************************
//                ģ�����ƣ�Controller
//                ģ�鹦�ܣ��������Ŀ��Ƶ�Ԫ
//*********************************************************
module Controller(
    input [5:0] op,
    input [5:0] funct,
    
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
    
    // ALU�����ź�
    output [2:0] ALUControl
    );
    
    wire [1:0] ALUOp;
    Main_Decoder ty1 (.op(op), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .Jump(Jump), .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), .ALUOp(ALUOp));
    ALU_Decoder ty2 (.funct(funct), .ALUOp(ALUOp), .ALUControl(ALUControl));
    
endmodule