`timescale 1ns / 1ps

//*********************************************************
//                ģ�����ƣ�Main_Decoder
//                ģ�鹦�ܣ�һ������������
//*********************************************************
module Main_Decoder(
    input [5:0] op,
    
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
    
    // ��ָ��� ALUOp
    // lw/sw�� 00
    // beq��   01
    // R_type��10
    // addi��  11
    assign ALUOp[1] = `R_type | `addi;
    assign ALUOp[0] = `beq | `addi;
        
endmodule
