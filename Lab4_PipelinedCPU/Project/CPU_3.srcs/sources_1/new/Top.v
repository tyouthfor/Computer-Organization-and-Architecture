`timescale 1ns / 1ps

module Top(
	/*
		ģ�����ƣ�Top
		ģ�鹦�ܣ�����ģ�飬���� MIPS ������ڴ�
		����˿ڣ�
			clk
			rst

		����˿ڣ�
			ALU_result				Data Memory �����룺ALU ������������Ŀ���ַ
			write_data_memory		Data Memory �����룺д���ڴ������
			MemWrite				Data Memory �����룺д�����ź�
			������Ϊ����˿���Ϊ�˷�����Ҫ��
	*/

	input 					clk,
	input 					rst,
	
	output 		[31:0] 		ALU_result,
	output 		[31:0] 		write_data_memory,
	output 					MemWrite
    );

	/*
		�ڴ� I/O �˿��ź�������
			curr_inst_addr			Instruction Memory �����룺PC
			inst_en					Instruction Memory �����룺PC ��ַ�Ƿ���Ч
			inst					Instruction Memory ����������ڴ��ж�����ָ��
	
			MemRead					Data Memory �����룺�������ź�
			����δ�õ�����Ϊ single-port-RAM �� ena �źŲ����Ƕ������źţ�����������ʹ���źţ�
			read_data_memory		Data Memory ����������ڴ��ж���������
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