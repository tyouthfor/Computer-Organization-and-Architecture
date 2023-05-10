`timescale 1ns / 1ps

//************************************************************************
//          ģ�����ƣ�Top
//          ģ�鹦�ܣ�����ģ�飬������MIPS����� Memory
//************************************************************************
module Top(
	input clk,
	input rst,
	
	output [31:0] ALU_result,
	output [31:0] write_data_memory,
	output MemWrite
    );

	// Memory ��I/O�˿�
	wire [31:0] curr_instruction_addr;  // Instruction Memory �����룺PC
	wire instruction_en;                // Instruction Memory �����룺PC��ַ�Ƿ���Ч
    wire [31:0] instruction;            // Instruction Memory ��������Ӵ洢���ж�����ָ��
	
//    wire [31:0] ALU_result;         // Data Memory �����룺ALU����������������Ŀ���ַ
//    wire [31:0] write_data_memory;  // Data Memory �����룺д��洢��������
//    wire MemWrite;                  // Data Memory �����룺д�����ź�
    wire MemRead;                   // Data Memory �����룺�������źţ���δ�õ�����Ϊ���˿�RAM IP�˵�ena�źŲ����Ƕ������źţ�����������ʹ���źţ�
    wire [31:0] read_data_memory;   // Data Memory ��������Ӵ洢���ж���������

    // MIPS ���
	MIPS MIPS 
	(
	.clk(clk), .rst(rst),
	.curr_instruction_addr(curr_instruction_addr), .instruction_en(instruction_en), .instruction(instruction),
	.ALU_result(ALU_result), .write_data_memory(write_data_memory), .MemWrite(MemWrite), .MemRead(MemRead), .read_data_memory(read_data_memory)
	);
	
	// Instruction Memory
	instruction_memory IM (.clka(clk), .ena(instruction_en), .addra(curr_instruction_addr), .douta(instruction));
	
	// Data Memory
	data_memory DM (.clka(clk), .ena(1'b1), .wea({4{MemWrite}}), .addra(ALU_result), .dina(write_data_memory), .douta(read_data_memory));
	
endmodule