`timescale 1ns / 1ps

//*********************************************************
//              ģ�����ƣ�Datapath
//              ģ�鹦�ܣ�������������ͨ·��Ԫ
//*********************************************************
module Datapath(
	input clk,
    input rst,

    // Mux �� sel �ź�
	input RegDst,
	input ALUSrc,
	input MemtoReg,
	input Branch,
	input Jump,
	
	// ��д�����ź�
	input RegWrite,

	// ALU�����ź�
	input [2:0] ALUControl,

    // Memory ��I/O�˿�
    output [31:0] curr_instruction_addr,  // Instruction Memory �����룺PC
    output instruction_en,                // Instruction Memory �����룺PC��ַ�Ƿ���Ч
    input [31:0] instruction,             // Instruction Memory ��������Ӵ洢���ж�����ָ��
	
    output [31:0] ALU_result,         // Data Memory �����룺ALU����������������Ŀ���ַ
	output [31:0] write_data_memory,  // Data Memory �����룺д��洢��������
    output MemWrite,                  // Data Memory �����룺д�����ź�
    output MemRead,                   // Data Memory �����룺�������ź�
    input [31:0] read_data_memory     // Data Memory ��������Ӵ洢���ж���������
    );
	
    //********************************************************************************
    //                                 1.PCģ��
    //********************************************************************************

    // (1).PC
    wire [31:0] next_instruction_addr;
    PC PC (.clk(clk), .rst(rst), .cin(next_instruction_addr), .cout(curr_instruction_addr), .instruction_en(instruction_en));

    // (2).PC����
    wire [31:0] PC_increment_addr;
    Adder2 #32 PC_increment (.a(curr_instruction_addr), .b(32'h4), .c(PC_increment_addr));
    
    //********************************************************************************
    //                               2.�Ĵ�����ģ��
    //********************************************************************************

    // (1).RegDst�źſ��Ƶ�ѡ������ѡ�� write register ����Դ
    wire [4:0] write_reg;
    Mux2 #5 write_reg_from (.d0(instruction[20:16]), .d1(instruction[15:11]), .sel(RegDst), .y(write_reg));

    // (2).�Ĵ�����
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
    //                                 3.ALUģ��
    //********************************************************************************

    // (1).��ָ���е���������������չ
    wire [31:0] se_const;
    Sign_Extension se (.x(instruction[15:0]), .y(se_const));

    // (2).ALUSrc�źſ��Ƶ�ѡ������ѡ��ALU�ĵڶ�����������Դ
    wire [31:0] second_operand;
    Mux2 #32 second_operand_from (.d0(read_data2_reg), .d1(se_const), .sel(ALUSrc), .y(second_operand));

    // (3).ALUģ��
    wire zero;
    ALU ALU (.a(read_data1_reg), .b(second_operand), .op(ALUControl), .y(ALU_result), .zero(zero));

    //********************************************************************************
    //                              4.WB��д�أ�ģ��
    //********************************************************************************

    // MemtoReg�źſ��Ƶ�ѡ������ѡ��д��Ĵ����ѵ����ݵ���Դ
    Mux2 #32 write_data_from (.d0(ALU_result), .d1(read_data_memory), .sel(MemtoReg), .y(write_data_reg));

    //********************************************************************************
    //                                5.Branchģ��
    //********************************************************************************

    // (1).��ָ���еĵ�ַ��������չ��������λ
    wire [31:0] relative_branch_addr;
    Shift_Left_2 #32 sl2_1 (.x(se_const), .y(relative_branch_addr));

    // (2).PC���Ѱַ
    wire [31:0] branch_addr;
    Adder2 #32 branch (.a(PC_increment_addr), .b(relative_branch_addr), .c(branch_addr));

    // (3).Branch & zero �źſ��Ƶ�ѡ������ѡ����һ��ָ���ַ����Դ
    wire [31:0] temp_addr;
    Mux2 #32 branch_or_PC_increment (.d0(PC_increment_addr), .d1(branch_addr), .sel(Branch & zero), .y(temp_addr));

    //********************************************************************************
    //                                6.Jumpģ��
    //********************************************************************************

    // (1).αֱ��Ѱַ
    wire [27:0] direct_jump_addr;
    Shift_Left_2 #28 sl2_2 (.x({2'b00, instruction[25:0]}), .y(direct_jump_addr));

    // (2).Jump�źſ��Ƶ�ѡ������ѡ����һ��ָ���ַ����Դ
    Mux2 #32 jump_or_other (.d0(temp_addr), .d1({PC_increment_addr[31:28], direct_jump_addr}), .sel(Jump), .y(next_instruction_addr));

endmodule
