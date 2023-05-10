`timescale 1ns / 1ps

//************************************************************************
//          模块名称：Top
//          模块功能：顶层模块，连接了MIPS软核与 Memory
//************************************************************************
module Top(
    input clk,
    input rst,
	
    output [31:0] ALU_result,
    output [31:0] write_data_memory,
    output MemWrite
    );

    // Memory 的I/O端口
    wire [31:0] curr_instruction_addr;  // Instruction Memory 的输入：PC
    wire instruction_en;                // Instruction Memory 的输入：PC地址是否有效
    wire [31:0] instruction;            // Instruction Memory 的输出：从存储器中读出的指令
	
//    wire [31:0] ALU_result;         // Data Memory 的输入：ALU的运算结果，可能是目标地址
//    wire [31:0] write_data_memory;  // Data Memory 的输入：写入存储器的数据
//    wire MemWrite;                  // Data Memory 的输入：写控制信号
    wire MemRead;                   // Data Memory 的输入：读控制信号（并未用到，因为单端口RAM IP核的ena信号并不是读控制信号，而是整个的使能信号）
    wire [31:0] read_data_memory;   // Data Memory 的输出：从存储器中读出的数据

    // MIPS 软核
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
