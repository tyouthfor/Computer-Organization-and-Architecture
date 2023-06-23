`timescale 1ns / 1ps

module Top(
	/*
		模块名称：Top
		模块功能：顶层模块，连接 MIPS 软核与内存
		输入端口：
			clk
			rst

		输出端口：
			ALU_result				Data Memory 的输入：ALU 的运算结果，即目标地址
			write_data_memory		Data Memory 的输入：写入内存的数据
			MemWrite				Data Memory 的输入：写控制信号
			（声明为输出端口是为了仿真需要）
	*/

	input 					clk,
	input 					rst,
	
	output 		[31:0] 		ALU_result,
	output 		[31:0] 		write_data_memory,
	output 					MemWrite
    );

	/*
		内存 I/O 端口信号声明：
			curr_inst_addr			Instruction Memory 的输入：PC
			inst_en					Instruction Memory 的输入：PC 地址是否有效
			inst					Instruction Memory 的输出：从内存中读出的指令
	
			MemRead					Data Memory 的输入：读控制信号
			（并未用到，因为 single-port-RAM 的 ena 信号并不是读控制信号，而是整个的使能信号）
			read_data_memory		Data Memory 的输出：从内存中读出的数据
	*/

	wire 		[31:0] 		curr_inst_addr;
	wire 					inst_en;
	wire 		[31:0] 		inst;
	
	wire 					MemRead;
	wire 		[31:0] 		read_data_memory;

	MIPS 					mips
	(
		.clk(clk), .rst(rst),

		// Instruction Memory
		.curr_inst_addr(curr_inst_addr), .inst_en(inst_en), 
		.inst_IF(inst),

		// Data Memory
		.ALU_result(ALU_result), .write_data_memory(write_data_memory), 
		.MemWrite(MemWrite), .MemRead(MemRead), 
		.read_data_memory(read_data_memory)
	);
	
	instruction_memory 		IM  // single-port-ROM
	(
		.clka(clk), .ena(inst_en), 
		.addra(curr_inst_addr), 
		.douta(inst)
	);
	
	data_memory 			DM  // single-port-RAM
	(
		.clka(clk), .ena(1'b1), .wea({4{MemWrite}}), 
		.addra(ALU_result), .dina(write_data_memory), 
		.douta(read_data_memory)
	);
	
endmodule