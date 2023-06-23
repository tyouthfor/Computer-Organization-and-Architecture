`timescale 1ns / 1ps

module Main_Decoder(
    /*
        ģ�����ƣ�Main_Decoder
        ģ�鹦�ܣ�һ������������
        ����˿ڣ�
            op              inst[31:26]
            
        ����˿ڣ�
            RegDst          ѡ��д�Ĵ����ŵ���Դ��0-Rt��1-Rd
            ALUSrc          ѡ�� ALU �ڶ�����������Դ��0-�Ĵ����ѣ�1-������
            MemtoReg        ѡ��д��Ĵ����ѵ�������Դ��0-ALU��1-�ڴ�
            Branch          ִ�� Branch ָ��ʱ�� 1
            Jump            ִ�� Jump ָ��ʱ�� 1
        
            MemRead         �ڴ�Ķ������ź�
            MemWrite        �ڴ��д�����ź�
            RegWrite        �Ĵ����ѵ�д�����ź�

            ALUOp           ���������������������ź�
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
    

    // ��ָ�� opcode �ĺ궨��
    `define     R_TYPE      ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0]  // 000000
    `define     LW          op[5]  & ~op[4] & ~op[3] & ~op[2] & op[1]  & op[0]   // 100011
    `define     SW          op[5]  & ~op[4] & op[3]  & ~op[2] & op[1]  & op[0]   // 101011
    `define     BEQ         ~op[5] & ~op[4] & ~op[3] & op[2]  & ~op[1] & ~op[0]  // 000100
    `define     J           ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1]  & ~op[0]  // 000010
    `define     ADDI        ~op[5] & ~op[4] & op[3]  & ~op[2] & ~op[1] & ~op[0]  // 001000
    

    // �����ź�
    assign RegDst   = `R_TYPE;
    assign ALUSrc   = `LW | `SW | `ADDI;
    assign MemtoReg = `LW;
    assign Branch   = `BEQ;
    assign Jump     = `J;
    
    assign MemRead  = `LW;
    assign MemWrite = `SW;
    assign RegWrite = `R_TYPE | `LW | `ADDI;
    

    // ALUOp
        // lw/sw�� 00
        // beq��   01
        // R_type��10
        // addi��  11
    assign ALUOp[1] = `R_TYPE | `ADDI;
    assign ALUOp[0] = `BEQ | `ADDI;
        
endmodule
