`timescale 1ns / 1ps

//***************************************************
//              模块名称：Adder
//              模块功能：两输入加法器
//***************************************************
module Adder2 #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH - 1 : 0] a,
    input [DATA_WIDTH - 1 : 0] b,
    
    output [DATA_WIDTH - 1 : 0] c
    );
    
    assign c = a + b;
    
endmodule