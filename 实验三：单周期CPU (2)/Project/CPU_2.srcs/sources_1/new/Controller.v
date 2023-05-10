`timescale 1ns / 1ps

//*********************************************************
//                模块名称：Controller
//                模块功能：处理器的控制单元
//*********************************************************
module Controller(
    input [5:0] op,
    input [5:0] funct,
    
    // Mux 的 sel 信号
    output RegDst,
    output ALUSrc,
    output MemtoReg,
    output Branch,
    output Jump,
    
    // 读写控制信号
    output MemRead,
    output MemWrite,
    output RegWrite,
    
    // ALU控制信号
    output [2:0] ALUControl
    );
    
    wire [1:0] ALUOp;
    Main_Decoder ty1 (.op(op), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .Jump(Jump), .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), .ALUOp(ALUOp));
    ALU_Decoder ty2 (.funct(funct), .ALUOp(ALUOp), .ALUControl(ALUControl));
    
endmodule