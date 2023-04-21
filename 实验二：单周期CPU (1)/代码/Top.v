`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 18:48:20
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 顶层模块
module Top(
    input clk,
    input rst,
    
    // Mux 的 sel 信号
    output RegDst,
    output ALUSrc,
    output MemtoReg,
    output Branch,
    output Jump,
    
    // 读写控制信号
    output MemRead,
    output MemWrite,
    output RegWrite,
    
    // ALU控制信号
    output [2:0] ALUControl,
    
    // 七段数码管显示
    output [7:0] an,
    output [6:0] seg
    );
    
    // 时钟分频
    wire clk_div;
    Clock_divide Clock_divede (.clk(clk), .clk_div(clk_div));
    
    // PC自增
    wire [31:0] next_instruction_addr;
    wire [31:0] curr_instruction_addr;
    wire instruction_en;
    PC PC (.clk(clk_div), .rst(rst), .cin(next_instruction_addr), .cout(curr_instruction_addr), .instruction_en(instruction_en));
    Adder PC_increment (.a(curr_instruction_addr), .b(32'h4), .c(next_instruction_addr));
    
    // 取指
    wire [31:0] instruction;
    blk_mem_gen_0 Instruction_memory (.clka(clk_div), .ena(instruction_en), .addra(curr_instruction_addr), .douta(instruction));
    
    //译码
    Controller Controller
    (
    .op(instruction[31:26]), .funct(instruction[5:0]), 
    .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .Jump(Jump),
    .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite),
    .ALUControl(ALUControl)
    );
    
    //七段数码管显示
    Digital_Tube Digital_Tube (.clk(clk), .rst(rst), .display(instruction), .an(an), .seg(seg));
    
endmodule
