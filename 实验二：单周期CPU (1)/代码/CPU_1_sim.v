`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/19 15:35:05
// Design Name: 
// Module Name: CPU_1_sim
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

// 注意仿真时时钟别分频
module CPU_1_sim(
    
    );
    
    reg clk = 1'b0;
    reg rst = 1'b1;
    
    wire RegDst;
    wire ALUSrc;
    wire MemtoReg;
    wire Branch;
    wire Jump;
    
    wire MemRead;
    wire MemWrite;
    wire RegWrite;
    
    wire [2:0] ALUControl;
    
    wire [7:0] an;
    wire [6:0] seg;
    
    Top ty 
    (
    .clk(clk), .rst(rst),
    .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch), .Jump(Jump),
    .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite),
    .ALUControl(ALUControl),
    .an(an), .seg(seg)
    );
    
    initial begin
        forever #100 clk = ~clk;
    end
    
endmodule
