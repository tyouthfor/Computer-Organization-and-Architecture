`timescale 1ns / 1ps

module ALU_Decoder(
    /*
        模块名称：ALU_Decoder
        模块功能：二级控制译码器
        输入端口：
            ALUOp           一级控制译码器的输出
            funct           inst[5:0]
        输出端口：
            ALUControl      ALU 的选择信号
    */

    input       [1:0]       ALUOp,
    input       [5:0]       funct,

    output      [2:0]       ALUControl
    );
    

    // 各指令 ALUOp 与 funct 的宏定义
    `define     ADD     ALUOp[1]  & ~ALUOp[0] & funct[5] & ~funct[4] & ~funct[3] & ~funct[2] & ~funct[1] & ~funct[0]
    `define     SUB     ALUOp[1]  & ~ALUOp[0] & funct[5] & ~funct[4] & ~funct[3] & ~funct[2] & funct[1]  & ~funct[0]
    `define     AND     ALUOp[1]  & ~ALUOp[0] & funct[5] & ~funct[4] & ~funct[3] & funct[2]  & ~funct[1] & ~funct[0]
    `define     OR      ALUOp[1]  & ~ALUOp[0] & funct[5] & ~funct[4] & ~funct[3] & funct[2]  & ~funct[1] & funct[0]
    `define     SLT     ALUOp[1]  & ~ALUOp[0] & funct[5] & ~funct[4] & funct[3]  & ~funct[2] & funct[1]  & ~funct[0]
    `define     LW      ~ALUOp[1] & ~ALUOp[0]
    `define     SW      ~ALUOp[1] & ~ALUOp[0]
    `define     BEQ     ~ALUOp[1] & ALUOp[0]
    `define     ADDI    ALUOp[1]  & ALUOp[0]


    // 各操作的 ALU 控制信号
        // add：010（add，lw/sw，addi）
        // sub：110（sub，beq）
        // and：000（and）
        // or： 001（or）
        // set on less than：111（slt） 
    assign ALUControl[2] = `SUB | `BEQ | `SLT;
    assign ALUControl[1] = `ADD | `LW  | `SW  | `ADDI | `SUB | `BEQ | `SLT;
    assign ALUControl[0] = `OR  | `SLT;

endmodule