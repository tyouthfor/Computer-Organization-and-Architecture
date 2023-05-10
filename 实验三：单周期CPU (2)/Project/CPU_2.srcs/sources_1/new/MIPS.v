`timescale 1ns / 1ps

//*********************************************************
//      模块名称：MIPS
//      模块功能：MIPS软核，连接了Datapath、Controller
//*********************************************************
module MIPS(
	input clk,
	input rst,

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
	
	// Mux 的 sel 信号
	wire RegDst;
	wire ALUSrc;
	wire MemtoReg;
	wire Branch;
	wire Jump;
	
	// 读写控制信号
	wire RegWrite;

	// ALU控制信号
	wire [2:0] ALUControl;

    // Controller
	Controller Controller
	(
    .op(instruction[31:26]), .funct(instruction[5:0]),  // 输入：指令
    .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .Jump(Jump),  // 输出：Mux 的 sel 信号
    .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite),  // 输出：读写控制信号
    .ALUControl(ALUControl)  // 输出：ALU控制信号
    );
	
	// Datapath
	Datapath Datapath
	(
	.clk(clk), .rst(rst),
	.RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .Jump(Jump),  // 输入：Mux 的 sel 信号
	.RegWrite(RegWrite),  // 输入：读写控制信号
	.ALUControl(ALUControl),  // 输入：ALU控制信号
	.curr_instruction_addr(curr_instruction_addr), .instruction_en(instruction_en), .instruction(instruction),  // Instruction Memory 的I/O端口
	.ALU_result(ALU_result), .write_data_memory(write_data_memory), .MemWrite(MemWrite), .MemRead(MemRead), .read_data_memory(read_data_memory)  // Data Memory 的I/O端口
	);
	
endmodule
