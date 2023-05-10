`timescale 1ns / 1ps

//*********************************************************
//          ģ�����ƣ�PC
//          ģ�鹦�ܣ�Program Counterģ�飬D������
//*********************************************************
module PC(
    input clk,
    input rst,
    input [31:0] cin,  // cin����һ��ָ��ĵ�ַ

    output reg [31:0] cout = 32'h0 - 32'h4,   //cout����ǰָ��ĵ�ַ������Ϊʲô��ʼ��Ҫ-4������ȥ��������ͼ��
    output reg instruction_en = 1'b1  //instruction_en����ǰָ���ַ�Ƿ���Ч
    );
    
    // �������½��ش���������Ϊ���� Instruction Memory ��
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
