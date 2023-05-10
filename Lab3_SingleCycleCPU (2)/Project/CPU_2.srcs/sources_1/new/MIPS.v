`timescale 1ns / 1ps

//*********************************************************
//      ģ�����ƣ�MIPS
//      ģ�鹦�ܣ�MIPS��ˣ�������Datapath��Controller
//*********************************************************
module MIPS(
	input clk,
	input rst,

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
	
	// Mux �� sel �ź�
	wire RegDst;
	wire ALUSrc;
	wire MemtoReg;
	wire Branch;
	wire Jump;
	
	// ��д�����ź�
	wire RegWrite;

	// ALU�����ź�
	wire [2:0] ALUControl;

    // Controller
	Controller Controller
	(
    .op(instruction[31:26]), .funct(instruction[5:0]),  // ���룺ָ��
    .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .Jump(Jump),  // �����Mux �� sel �ź�
    .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite),  // �������д�����ź�
    .ALUControl(ALUControl)  // �����ALU�����ź�
    );
	
	// Datapath
	Datapath Datapath
	(
	.clk(clk), .rst(rst),
	.RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .Jump(Jump),  // ���룺Mux �� sel �ź�
	.RegWrite(RegWrite),  // ���룺��д�����ź�
	.ALUControl(ALUControl),  // ���룺ALU�����ź�
	.curr_instruction_addr(curr_instruction_addr), .instruction_en(instruction_en), .instruction(instruction),  // Instruction Memory ��I/O�˿�
	.ALU_result(ALU_result), .write_data_memory(write_data_memory), .MemWrite(MemWrite), .MemRead(MemRead), .read_data_memory(read_data_memory)  // Data Memory ��I/O�˿�
	);
	
endmodule
