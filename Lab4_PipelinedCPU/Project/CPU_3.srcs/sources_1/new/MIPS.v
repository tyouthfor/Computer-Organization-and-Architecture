`timescale 1ns / 1ps

module MIPS(
	/*
		模块名称：MIPS
		模块功能：MIPS 软核，连接数据通路与控制单元
		输入端口：
			clk						时钟信号
			rst						复位信号。1-正常工作，0-复位

			// 内存的输出
			inst_IF					Instruction Memory 的输出：从内存中读出的指令
			read_data_memory		Data Memory 的输出：从内存中读出的数据
		
		输出端口：
			// 内存的输入
			curr_inst_addr			Instruction Memory 的输入：PC 地址
			inst_en					Instruction Memory 的输入：PC 地址是否有效

			ALU_result				Data Memory 的输入：ALU 的运算结果，即内存地址
			write_data_memory		Data Memory 的输入：写入内存的数据
			MemWrite				Data Memory 的输入：写控制信号
			MemRead					Data Memory 的输入：读控制信号
	*/

	input clk,
	input rst,

	// 内存的输出
	input 		[31:0] 		inst_IF,
	input 		[31:0] 		read_data_memory,

	// 内存的输入
	output 		[31:0] 		curr_inst_addr,
	output 					inst_en,
	
	output 		[31:0] 		ALU_result,
	output 		[31:0] 		write_data_memory,
	output 					MemWrite,
	output 					MemRead
	);
	

	// Mux 的 sel 信号
	wire 					RegDst_EX;
	wire 					ALUSrc_EX;
	wire 					MemtoReg_EX;
	wire 					MemtoReg_MEM;
	wire 					MemtoReg_WB;
	wire 					Branch_ID;
	wire 					Jump_ID;
	wire 					PCSrc_ID;
	
	// 读写控制信号
	wire 					RegWrite_EX;
	wire 					RegWrite_MEM;
	wire 					RegWrite_WB;

	// ALU 控制信号
	wire 		[2:0] 		ALUControl_EX;

	// 其它
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

		// 内存的输出
		.inst_IF(inst_IF), .read_data_memory_MEM(read_data_memory),

		// ID 阶段需要的控制信号
		.PCSrc_ID(PCSrc_ID), .Jump_ID(Jump_ID),

		// EX 阶段需要的控制信号
		.RegDst_EX(RegDst_EX), .ALUSrc_EX(ALUSrc_EX), .ALUControl_EX(ALUControl_EX), 

		// WB 阶段需要的控制信号
		.MemtoReg_WB(MemtoReg_WB), .RegWrite_WB(RegWrite_WB),

		// 用于解决冒险的控制信号
		.Branch_ID(Branch_ID), 
		.RegWrite_EX(RegWrite_EX), .MemtoReg_EX(MemtoReg_EX),
		.MemtoReg_MEM(MemtoReg_MEM), .RegWrite_MEM(RegWrite_MEM), 

		// Instruction Memory 的输入
		.curr_inst_addr(curr_inst_addr), .inst_en(inst_en),

		// Controller 的输入
		.inst_ID(inst_ID), .Equal_ID(Equal_ID), .flush_EX(flush_EX),

		// Data Memory 的输入
		.ALU_result_MEM(ALU_result), .write_data_memory_MEM(write_data_memory), 
		.MemWrite_MEM(MemWrite), .MemRead_MEM(MemRead)
	);
	
endmodule
