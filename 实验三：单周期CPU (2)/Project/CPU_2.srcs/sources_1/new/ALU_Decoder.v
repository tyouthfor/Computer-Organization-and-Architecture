`timescale 1ns / 1ps

//*********************************************************
//                ģ�����ƣ�ALU_Decoder
//                ģ�鹦�ܣ���������������
//*********************************************************
module ALU_Decoder(
    input [1:0] ALUOp,
    input [5:0] funct,
    
    output [2:0] ALUControl
    );
    
    // ������ ALUOp �� funct �ĺ궨��
    `define ADD ALUOp[1] & ~ALUOp[0] & funct[5] & ~funct[4] & ~funct[3] & ~funct[2] & ~funct[1] & ~funct[0]
    `define SUB ALUOp[1] & ~ALUOp[0] & funct[5] & ~funct[4] & ~funct[3] & ~funct[2] & funct[1] & ~funct[0]
    `define AND ALUOp[1] & ~ALUOp[0] & funct[5] & ~funct[4] & ~funct[3] & funct[2] & ~funct[1] & ~funct[0]
    `define OR  ALUOp[1] & ~ALUOp[0] & funct[5] & ~funct[4] & ~funct[3] & funct[2] & ~funct[1] & funct[0]
    `define SLT ALUOp[1] & ~ALUOp[0] & funct[5] & ~funct[4] & funct[3] & ~funct[2] & funct[1] & ~funct[0]
    `define LW  ~ALUOp[1] & ~ALUOp[0]
    `define SW  ~ALUOp[1] & ~ALUOp[0]
    `define BEQ ~ALUOp[1] & ALUOp[0]
    `define ADDI ALUOp[1] & ALUOp[0]
     
    // ��������ALU�����ź�
    // add��010��add��lw/sw��addi��
    // sub��110��sub��beq��
    // and��000��and��
    // or�� 001��or��
    // set on less than��111��slt�� 
    assign ALUControl[2] = `SUB | `BEQ | `SLT;
    assign ALUControl[1] = `ADD | `LW | `SW | `ADDI | `SUB | `BEQ | `SLT;
    assign ALUControl[0] = `OR | `SLT;

endmodule