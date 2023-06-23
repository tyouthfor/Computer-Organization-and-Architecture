`timescale 1ns / 1ps

module MIPS(
	/*
		ģ�����ƣ�MIPS
		ģ�鹦�ܣ�MIPS ��ˣ���������ͨ·����Ƶ�Ԫ
		����˿ڣ�
			clk						ʱ���ź�
			rst						��λ�źš�1-����������0-��λ

			// �ڴ�����
			inst_IF					Instruction Memory ����������ڴ��ж�����ָ��
			read_data_memory		Data Memory ����������ڴ��ж���������
		
		����˿ڣ�
			// �ڴ������
			curr_inst_addr			Instruction Memory �����룺PC ��ַ
			inst_en					Instruction Memory �����룺PC ��ַ�Ƿ���Ч

			ALU_result				Data Memory �����룺ALU �������������ڴ��ַ
			write_data_memory		Data Memory �����룺д���ڴ������
			MemWrite				Data Memory �����룺д�����ź�
			MemRead					Data Memory �����룺�������ź�
	*/

	input clk,
	input rst,

	// �ڴ�����
	input 		[31:0] 		inst_IF,
	input 		[31:0] 		read_data_memory,

	// �ڴ������
	output 		[31:0] 		curr_inst_addr,
	output 					inst_en,
	
	output 		[31:0] 		ALU_result,
	output 		[31:0] 		write_data_memory,
	output 					MemWrite,
	output 					MemRead
	);
	

	// Mux �� sel �ź�
	wire 					RegDst_EX;
	wire 					ALUSrc_EX;
	wire 					MemtoReg_EX;
	wire 					MemtoReg_MEM;
	wire 					MemtoReg_WB;
	wire 					Branch_ID;
	wire 					Jump_ID;
	wire 					PCSrc_ID;
	
	// ��д�����ź�
	wire 					RegWrite_EX;
	wire 					RegWrite_MEM;
	wire 					RegWrite_WB;

	// ALU �����ź�
	wire 		[2:0] 		ALUControl_EX;

	// ����
	wire 					Equal_ID;
	wire 					flush_EX;
	wire 		[31:0] 		inst_ID;


	Controller 				ctr
	(
		.clk(clk), .rst(rst),
		.op(inst_ID[31:26]), .funct(inst_ID[5:0]), .Equal_ID(Equal_ID), .flush_EX(flush_EX), 
		
		.Branch_ID(Branch_ID), .Jump_ID(Jump_ID), .PCSrc_ID(PCSrc_ID),

		.RegDst_EX(RegDst_EX), .ALUSrc_EX(ALUSrc_EX), .MemtoReg_EX(MemtoReg_EX),
		.RegWrite_EX(RegWrite_EX), 
		.ALUControl_EX(ALUControl_EX), 

		.MemtoReg_MEM(MemtoReg_MEM), 
		.MemRead_MEM(MemRead), .MemWrite_MEM(MemWrite), .RegWrite_MEM(RegWrite_MEM),

		.MemtoReg_WB(MemtoReg_WB), .RegWrite_WB(RegWrite_WB)
    );
	
	Datapath 				dp
	(
		.clk(clk), .rst(rst),

		// �ڴ�����
		.inst_IF(inst_IF), .read_data_memory_MEM(read_data_memory),

		// ID �׶���Ҫ�Ŀ����ź�
		.PCSrc_ID(PCSrc_ID), .Jump_ID(Jump_ID),

		// EX �׶���Ҫ�Ŀ����ź�
		.RegDst_EX(RegDst_EX), .ALUSrc_EX(ALUSrc_EX), .ALUControl_EX(ALUControl_EX), 

		// WB �׶���Ҫ�Ŀ����ź�
		.MemtoReg_WB(MemtoReg_WB), .RegWrite_WB(RegWrite_WB),

		// ���ڽ��ð�յĿ����ź�
		.Branch_ID(Branch_ID), 
		.RegWrite_EX(RegWrite_EX), .MemtoReg_EX(MemtoReg_EX),
		.MemtoReg_MEM(MemtoReg_MEM), .RegWrite_MEM(RegWrite_MEM), 

		// Instruction Memory ������
		.curr_inst_addr(curr_inst_addr), .inst_en(inst_en),

		// Controller ������
		.inst_ID(inst_ID), .Equal_ID(Equal_ID), .flush_EX(flush_EX),

		// Data Memory ������
		.ALU_result_MEM(ALU_result), .write_data_memory_MEM(write_data_memory), 
		.MemWrite_MEM(MemWrite), .MemRead_MEM(MemRead)
	);
	
endmodule
