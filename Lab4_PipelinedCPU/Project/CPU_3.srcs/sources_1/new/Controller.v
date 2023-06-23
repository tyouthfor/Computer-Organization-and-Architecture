`timescale 1ns / 1ps

module Controller(
    /*
        模块名称：Controller
        模块功能：流水线 MIPS 处理器的控制单元
        输入端口：
            clk                 时钟信号
            rst                 复位信号。1-正常工作，0-复位
            op                  inst[31:26]
            funct               inst[5:0]
            Equal_ID            两数相等时置 1，用于确定 PCSrc
            flush_EX            ID/EX 级流水冲刷信号

        输出端口：
            // ID 阶段输出的控制信号
            Branch_ID
            Jump_ID
            PCSrc_ID

            // EX 阶段输出的控制信号
            RegDst_EX
            ALUSrc_EX
            MemtoReg_EX
            RegWrite_EX
            ALUControl_EX

            // MEM 阶段输出的控制信号
            MemtoReg_MEM
            MemRead_MEM
            MemWrite_MEM
            RegWrite_MEM

            // WB 阶段输出的控制信号
            MemtoReg_WB
            RegWrite_WB
    */

    input                   clk, 
    input                   rst,
    input       [5:0]       op,
    input       [5:0]       funct,
    input                   Equal_ID,
    input                   flush_EX,

    // ID 阶段输出的控制信号
    output                  Branch_ID,
    output                  Jump_ID,
    output                  PCSrc_ID,
    
    // EX 阶段输出的控制信号
    output                  RegDst_EX, 
    output                  ALUSrc_EX,
    output                  MemtoReg_EX,
    output                  RegWrite_EX,
    output      [2:0]       ALUControl_EX,

    // MEM 阶段输出的控制信号
    output                  MemtoReg_MEM,
    output                  MemRead_MEM,
    output                  MemWrite_MEM,
    output                  RegWrite_MEM,

    // WB 阶段输出的控制信号
    output                  MemtoReg_WB,
    output                  RegWrite_WB
    );


    // Controller 产生的并未输出的控制信号
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
