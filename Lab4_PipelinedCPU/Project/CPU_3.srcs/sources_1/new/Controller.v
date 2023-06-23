`timescale 1ns / 1ps

module Controller(
    /*
        ģ�����ƣ�Controller
        ģ�鹦�ܣ���ˮ�� MIPS �������Ŀ��Ƶ�Ԫ
        ����˿ڣ�
            clk                 ʱ���ź�
            rst                 ��λ�źš�1-����������0-��λ
            op                  inst[31:26]
            funct               inst[5:0]
            Equal_ID            �������ʱ�� 1������ȷ�� PCSrc
            flush_EX            ID/EX ����ˮ��ˢ�ź�

        ����˿ڣ�
            // ID �׶�����Ŀ����ź�
            Branch_ID
            Jump_ID
            PCSrc_ID

            // EX �׶�����Ŀ����ź�
            RegDst_EX
            ALUSrc_EX
            MemtoReg_EX
            RegWrite_EX
            ALUControl_EX

            // MEM �׶�����Ŀ����ź�
            MemtoReg_MEM
            MemRead_MEM
            MemWrite_MEM
            RegWrite_MEM

            // WB �׶�����Ŀ����ź�
            MemtoReg_WB
            RegWrite_WB
    */

    input                   clk, 
    input                   rst,
    input       [5:0]       op,
    input       [5:0]       funct,
    input                   Equal_ID,
    input                   flush_EX,

    // ID �׶�����Ŀ����ź�
    output                  Branch_ID,
    output                  Jump_ID,
    output                  PCSrc_ID,
    
    // EX �׶�����Ŀ����ź�
    output                  RegDst_EX, 
    output                  ALUSrc_EX,
    output                  MemtoReg_EX,
    output                  RegWrite_EX,
    output      [2:0]       ALUControl_EX,

    // MEM �׶�����Ŀ����ź�
    output                  MemtoReg_MEM,
    output                  MemRead_MEM,
    output                  MemWrite_MEM,
    output                  RegWrite_MEM,

    // WB �׶�����Ŀ����ź�
    output                  MemtoReg_WB,
    output                  RegWrite_WB
    );


    // Controller �����Ĳ�δ����Ŀ����ź�
    wire                    RegDst_ID;
    wire                    ALUSrc_ID;
    wire                    MemtoReg_ID;
    wire                    MemRead_ID;
    wire                    MemWrite_ID;
    wire                    RegWrite_ID;
    wire        [2:0]       ALUControl_ID;
    
    wire                    MemRead_EX;
    wire                    MemWrite_EX;

    wire        [1:0]       ALUOp;

    assign PCSrc_ID = Branch_ID & Equal_ID;

    Main_Decoder            md 
    (
        .op(op), 
        .RegDst(RegDst_ID), .ALUSrc(ALUSrc_ID), .MemtoReg(MemtoReg_ID), 
        .Branch(Branch_ID), .Jump(Jump_ID), 
        .MemRead(MemRead_ID), .MemWrite(MemWrite_ID), .RegWrite(RegWrite_ID), 
        .ALUOp(ALUOp)
    );

    ALU_Decoder             alud 
    (
        .funct(funct), .ALUOp(ALUOp), 
        .ALUControl(ALUControl_ID)
    );
    
    Flop_rc     #9          ID_EX_reg
    (
        .clk(clk), .rst(rst), .clear(~flush_EX),
        .din({RegDst_ID, ALUSrc_ID, MemtoReg_ID, MemRead_ID, MemWrite_ID, RegWrite_ID, ALUControl_ID}),
        .dout({RegDst_EX, ALUSrc_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX, RegWrite_EX, ALUControl_EX})
    );

    Flop_r      #4          EX_MEM_reg
    (
        .clk(clk), .rst(rst),
        .din({MemtoReg_EX, MemRead_EX, MemWrite_EX, RegWrite_EX}),
        .dout({MemtoReg_MEM, MemRead_MEM, MemWrite_MEM, RegWrite_MEM})
    );

    Flop_r      #2          MEM_WB_reg
    (
        .clk(clk), .rst(rst),
        .din({MemtoReg_MEM, RegWrite_MEM}),
        .dout({MemtoReg_WB, RegWrite_WB})
    );

endmodule