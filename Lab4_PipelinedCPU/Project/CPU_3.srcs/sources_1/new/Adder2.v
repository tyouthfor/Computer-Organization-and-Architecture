`timescale 1ns / 1ps

module Adder2 #(parameter WIDTH = 32)(
    /*
        ģ�����ƣ�Adder2
        ģ�鹦�ܣ�������ӷ���
        ����˿ڣ�
            a       ��һ������
            b       �ڶ�������
        ����˿ڣ�
            c       ��
    */

    input       [WIDTH - 1 : 0]     a,
    input       [WIDTH - 1 : 0]     b,

    output      [WIDTH - 1 : 0]     c
    );


    assign c = a + b;

endmodule