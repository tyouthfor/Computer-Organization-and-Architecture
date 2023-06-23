`timescale 1ns / 1ps

module Main_Decoder(
    /*
        模块名称：Main_Decoder
        模块功能：一级控制译码器
        输入端口：
            op              inst[31:26]
            
        输出端口：
            RegDst          选择写寄存器号的来源。0-Rt，1-Rd
            ALUSrc          选择 ALU 第二操作数的来源。0-寄存器堆，1-立即数
            MemtoReg        选择写入寄存器堆的数据来源。0-ALU，1-内存
            Branch          执行 Branch 指令时置 1
            Jump            执行 Jump 指令时置 1
        
            MemRead         内存的读控制信号
            MemWrite        内存的写控制信号
            RegWrite        寄存器堆的写控制信号

            ALUOp           给到二级控制译码器的信号
    */

    input       [5:0]       op,

    output                  RegDst,
    output                  ALUSrc,
    output                  MemtoReg,
    output                  Branch,
    output                  Jump,
    output                  MemRead,
    output                  MemWrite,
    output                  RegWrite,
    output      [1:0]       ALUOp
    );
    

    // 各指令 opcode 的宏定义
    `define     R_TYPE      ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0]  // 000000
    `define     LW          op[5]  & ~op[4] & ~op[3] & ~op[2] & op[1]  & op[0]   // 100011
    `define     SW          op[5]  & ~op[4] & op[3]  & ~op[2] & op[1]  & op[0]   // 101011
    `define     BEQ         ~op[5] & ~op[4] & ~op[3] & op[2]  & ~op[1] & ~op[0]  // 000100
    `define     J           ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1]  & ~op[0]  // 000010
    `define     ADDI        ~op[5] & ~op[4] & op[3]  & ~op[2] & ~op[1] & ~op[0]  // 001000
    

    // 控制信号
    assign RegDst   = `R_TYPE;
    assign ALUSrc   = `LW | `SW | `ADDI;
    assign MemtoReg = `LW;
    assign Branch   = `BEQ;
    assign Jump     = `J;
    
    assign MemRead  = `LW;
    assign MemWrite = `SW;
    assign RegWrite = `R_TYPE | `LW | `ADDI;
    

    // ALUOp
        // lw/sw： 00
        // beq：   01
        // R_type：10
        // addi：  11
    assign ALUOp[1] = `R_TYPE | `ADDI;
    assign ALUOp[0] = `BEQ | `ADDI;
        
endmodule
