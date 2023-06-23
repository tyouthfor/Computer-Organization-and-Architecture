`timescale 1ns / 1ps

module Shift_Left_2 #(parameter WIDTH = 32)(
	/*
		ģ�����ƣ�Shift_Left_2
		ģ�鹦�ܣ����� 2 λ
		����˿ڣ�
			x		����
		����˿ڣ�
			y		���
	*/

	input 		[WIDTH - 1 : 0] 	x,

	output 		[WIDTH - 1 : 0] 	y
	);
	

	assign y = {x[WIDTH - 3 : 0], 2'b00};

endmodule