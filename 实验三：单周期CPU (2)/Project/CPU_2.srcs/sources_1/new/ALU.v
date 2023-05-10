`timescale 1ns / 1ps

//*********************************************************
//                模块名称：ALU
//                模块功能：32位ALU
//*********************************************************
module ALU(
    input [31:0] a,  //第一操作数
    input [31:0] b,  //第二操作数
    input [2:0] op,  //选择码

    output reg [31:0] y,  //结果
    output reg zero = 1'b0  //相减是否为0，用于branch条件判断
    );
    
    // 各操作的3位选择码
    // add：010
    // sub：110
    // and：000
    // or： 001
    // set on less than：111（slt） 
    always @ (*) begin
        case(op)
            3'b010: y = a + b;
            
            3'b110: begin
                y = a - b;
                if (a - b == 0) zero = 1;
                else zero = 0;
            end

            3'b000: y = a & b;
            
            3'b001: y = a | b;
                     
            3'b111: begin
                if (a < b) y = 1;
                else y = 0;
            end
            
            default:
                y = 0;
        endcase
    end
      
endmodule