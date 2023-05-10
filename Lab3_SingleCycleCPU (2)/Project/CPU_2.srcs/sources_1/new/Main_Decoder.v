`timescale 1ns / 1ps

//*********************************************************
//                模块名称：Main_Decoder
//                模块功能：一级控制译码器
//*********************************************************
module Main_Decoder(
    input [5:0] op,
    
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
    
    // ALUOp
    output [1:0] ALUOp
    
    );
    
    // 各指令 opcode 的宏定义
    `define R_type ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0]  //000000
    `define lw     op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0]     //100011
    `define sw     op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0]      //101011
    `define beq    ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0]   //000100
    `define j      ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0]   //000010
    `define addi   ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0]   //001000
    
    // 控制信号
    assign RegDst = `R_type;
    assign ALUSrc = `lw | `sw | `addi;
    assign MemtoReg = `lw;
    assign Branch = `beq;
    assign Jump = `j;
    
    assign MemRead = `lw;
    assign MemWrite = `sw;
    assign RegWrite = `R_type | `lw | `addi;
    
    // 各指令的 ALUOp
    // lw/sw： 00
    // beq：   01
    // R_type：10
    // addi：  11
    assign ALUOp[1] = `R_type | `addi;
    assign ALUOp[0] = `beq | `addi;
        
endmodule
