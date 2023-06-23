`timescale 1ns / 1ps

module Flop_enr #(parameter WIDTH = 32)(
	/*
		ģ�����ƣ�Flop_enr
		ģ�鹦�ܣ��� en��rst �� D ������
		����˿ڣ�
			clk 		ʱ���ź�
			en 			ʹ���źš�1-����������0-������ֲ���
			rst 		��λ�źš�1-����������0-�����λΪ 0
			din 		����
		����˿ڣ�
			dout 		���
	*/

	input 									clk,
	input 									en,
    input 									rst,
	input 				[WIDTH - 1 : 0] 	din,

	output 		reg 	[WIDTH - 1 : 0] 	dout
    );


	always @ (posedge clk or negedge rst) begin
		if (!rst) 		dout <= 0;
		else if (en) 	dout <= din;
		else 			dout <= dout;
	end

endmodule