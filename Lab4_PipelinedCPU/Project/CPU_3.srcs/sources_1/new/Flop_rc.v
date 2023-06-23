`timescale 1ns / 1ps

module Flop_rc #(parameter WIDTH = 32)(
	/*
		ģ�����ƣ�Flop_rc
		ģ�鹦�ܣ��� rst��clear �� D ������
		����˿ڣ�
			clk 		ʱ���ź�
			rst 		��λ�źţ�rst = 0 ʱ�����λΪ 0
			clear 		����źţ�clear = 0 ʱ������Ϊ 0
			din 		����
		����˿ڣ�
			dout 		���
	*/

	input 									clk,
	input 									rst,
	input 									clear,
	input 				[WIDTH - 1 : 0] 	din,

	output 		reg 	[WIDTH - 1 : 0] 	dout
	);


	always @ (posedge clk or negedge rst) begin
		if (!rst) 			dout <= 0;
		else if (!clear) 	dout <= 0;
		else 				dout <= din;
	end

endmodule