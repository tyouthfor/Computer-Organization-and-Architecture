`timescale 1ns / 1ps

module PC(
    /*
        模块名称：PC
        模块功能：Program Counter，带 rst、en 的 D 触发器
        输入端口：
            clk         时钟信号
            rst         复位信号。1-正常工作，0-输出复位为 0
            en          使能信号。1-正常工作，0-输出保持不变
            cin         下一条要执行的指令的地址
        输出端口：
            cout        当前执行的指令的地址
            inst_en     当前指令地址是否有效。1-有效，0-无效
    */

    input                           clk,
    input                           rst,
    input                           en,
    input               [31:0]      cin,

    output      reg     [31:0]      cout        = 32'h0 - 32'h4,  // -4 是为了对冲掉开头的影响
    output      reg                 inst_en     = 1'b1
    );

    
    always @ (negedge clk) begin  // 下降沿触发是为了与 Instruction Memory 读指令错开
        if (!rst) begin
            cout <= 32'h0;
            inst_en <= 1'b0;
        end
        else if (en) begin
            cout <= cin;
            inst_en <= 1'b1;
        end
        else begin
            cout <= cout;
            inst_en <= inst_en;
        end
    end

endmodule