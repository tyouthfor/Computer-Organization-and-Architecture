`timescale 1ns / 1ps

//*********************************************************
//          模块名称：PC
//          模块功能：Program Counter模块，D触发器
//*********************************************************
module PC(
    input clk,
    input rst,
    input [31:0] cin,  // cin：下一条指令的地址

    output reg [31:0] cout = 32'h0 - 32'h4,   //cout：当前指令的地址（关于为什么初始化要-4，可以去看看仿真图）
    output reg instruction_en = 1'b1  //instruction_en：当前指令地址是否有效
    );
    
    // 这里是下降沿触发！！！为了与 Instruction Memory 错开
    always @ (negedge clk) begin
        if (!rst) begin
            cout <= 32'h0;
            instruction_en <= 1'b0;
        end
        else begin
            cout <= cin;
            instruction_en <= 1'b1;
        end
    end
    
endmodule
