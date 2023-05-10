`timescale 1ns / 1ps

//***************************************************
//              ģ�����ƣ�Adder
//              ģ�鹦�ܣ�������ӷ���
//***************************************************
module Adder2 #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH - 1 : 0] a,
    input [DATA_WIDTH - 1 : 0] b,
    
    output [DATA_WIDTH - 1 : 0] c
    );
    
    assign c = a + b;
    
endmodule