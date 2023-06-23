`timescale 1ns / 1ps

module ALU(
    /*
        模块名称：ALU
        模块功能：32-bit ALU
        输入端口：
            a       第一操作数
            b       第二操作数
            op      选择信号
        输出端口：
            y       输出
    */

    input               [31:0]      a,
    input               [31:0]      b,
    input               [2:0]       op,
    
    output      reg     [31:0]      y
    );
    

    // add：010
    // sub：110
    // and：000
    // or： 001
    // slt：111
    always @ (*) begin
        case(op)
            3'b010: y = a + b;
            
            3'b110: y = a - b;

            3'b000: y = a & b;
            
            3'b001: y = a | b;
                     
            3'b111: y = a < b ? 1 : 0;
            
            default: y = 0;
        endcase
    end
      
endmodule