`timescale 1ns / 1ps

module Adder2 #(parameter WIDTH = 32)(
    /*
        模块名称：Adder2
        模块功能：两输入加法器
        输入端口：
            a       第一操作数
            b       第二操作数
        输出端口：
            c       和
    */

    input       [WIDTH - 1 : 0]     a,
    input       [WIDTH - 1 : 0]     b,

    output      [WIDTH - 1 : 0]     c
    );


    assign c = a + b;

endmodule