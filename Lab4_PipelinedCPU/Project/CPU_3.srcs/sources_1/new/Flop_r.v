`timescale 1ns / 1ps

module Flop_r #(parameter WIDTH = 32)(
    /*
		ģ�����ƣ�Flop_r
		ģ�鹦�ܣ��� rst �� D ������
		����˿ڣ�
			clk         ʱ���ź�
			rst         ��λ�źš�1-����������0-�����λΪ 0
			din         ����
		����˿ڣ�
			dout        ���
	*/

    input                                   clk,
    input                                   rst,
    input               [WIDTH - 1 : 0]     din,

    output      reg     [WIDTH - 1 : 0]     dout
    );


    always @ (posedge clk or negedge rst) begin
        if (!rst)   dout <= 0;
        else        dout <= din;
    end

endmodule