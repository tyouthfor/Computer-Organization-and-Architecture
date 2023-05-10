`timescale 1ns / 1ps

//*********************************************************
//              模块名称：Datapath
//              模块功能：处理器的数据通路单元
//*********************************************************
module Datapath(
    input clk,
    input rst,

    // Mux 的 sel 信号
    input RegDst,
    input ALUSrc,
    input MemtoReg,
    input Branch,
    input Jump,

    // 读写控制信号
    input RegWrite,

    // ALU控制信号
    input [2:0] ALUControl,

    // Memory 的I/O端口
    output [31:0] curr_instruction_addr,  // Instruction Memory 的输入：PC
    output instruction_en,                // Instruction Memory 的输入：PC地址是否有效
    input [31:0] instruction,             // Instruction Memory 的输出：从存储器中读出的指令
	
    output [31:0] ALU_result,         // Data Memory 的输入：ALU的运算结果，可能是目标地址
    output [31:0] write_data_memory,  // Data Memory 的输入：写入存储器的数据
    output MemWrite,                  // Data Memory 的输入：写控制信号
    output MemRead,                   // Data Memory 的输入：读控制信号
    input [31:0] read_data_memory     // Data Memory 的输出：从存储器中读出的数据
    );
	
    //********************************************************************************
    //                                 1.PC模块
    //********************************************************************************

    // (1).PC
    wire [31:0] next_instruction_addr;
    PC PC (.clk(clk), .rst(rst), .cin(next_instruction_addr), .cout(curr_instruction_addr), .instruction_en(instruction_en));

    // (2).PC自增
    wire [31:0] PC_increment_addr;
    Adder2 #32 PC_increment (.a(curr_instruction_addr), .b(32'h4), .c(PC_increment_addr));
    
    //********************************************************************************
    //                               2.寄存器堆模块
    //********************************************************************************

    // (1).RegDst信号控制的选择器，选择 write register 的来源
    wire [4:0] write_reg;
    Mux2 #5 write_reg_from (.d0(instruction[20:16]), .d1(instruction[15:11]), .sel(RegDst), .y(write_reg));

    // (2).寄存器堆
    wire [31:0] write_data_reg;
    wire [31:0] read_data1_reg;
    wire [31:0] read_data2_reg;
    General_Regfile rf
    (
    .clk(clk),
    .read_reg1(instruction[25:21]), .read_reg2(instruction[20:16]), .write_reg(write_reg), .write_data(write_data_reg),
    .RegWrite(RegWrite),
    .read_data1(read_data1_reg), .read_data2(read_data2_reg)
    );
    assign write_data_memory = read_data2_reg;

    //********************************************************************************
    //                                 3.ALU模块
    //********************************************************************************

    // (1).对指令中的立即数作符号扩展
    wire [31:0] se_const;
    Sign_Extension se (.x(instruction[15:0]), .y(se_const));

    // (2).ALUSrc信号控制的选择器，选择ALU的第二操作数的来源
    wire [31:0] second_operand;
    Mux2 #32 second_operand_from (.d0(read_data2_reg), .d1(se_const), .sel(ALUSrc), .y(second_operand));

    // (3).ALU模块
    wire zero;
    ALU ALU (.a(read_data1_reg), .b(second_operand), .op(ALUControl), .y(ALU_result), .zero(zero));

    //********************************************************************************
    //                              4.WB（写回）模块
    //********************************************************************************

    // MemtoReg信号控制的选择器，选择写入寄存器堆的数据的来源
    Mux2 #32 write_data_from (.d0(ALU_result), .d1(read_data_memory), .sel(MemtoReg), .y(write_data_reg));

    //********************************************************************************
    //                                5.Branch模块
    //********************************************************************************

    // (1).对指令中的地址作符号扩展后左移两位
    wire [31:0] relative_branch_addr;
    Shift_Left_2 #32 sl2_1 (.x(se_const), .y(relative_branch_addr));

    // (2).PC相对寻址
    wire [31:0] branch_addr;
    Adder2 #32 branch (.a(PC_increment_addr), .b(relative_branch_addr), .c(branch_addr));

    // (3).Branch & zero 信号控制的选择器，选择下一条指令地址的来源
    wire [31:0] temp_addr;
    Mux2 #32 branch_or_PC_increment (.d0(PC_increment_addr), .d1(branch_addr), .sel(Branch & zero), .y(temp_addr));

    //********************************************************************************
    //                                6.Jump模块
    //********************************************************************************

    // (1).伪直接寻址
    wire [27:0] direct_jump_addr;
    Shift_Left_2 #28 sl2_2 (.x({2'b00, instruction[25:0]}), .y(direct_jump_addr));

    // (2).Jump信号控制的选择器，选择下一条指令地址的来源
    Mux2 #32 jump_or_other (.d0(temp_addr), .d1({PC_increment_addr[31:28], direct_jump_addr}), .sel(Jump), .y(next_instruction_addr));

endmodule
