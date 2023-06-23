`timescale  1ns / 1ps

module Mux2 # (parameter WIDTH = 32)(
	/*
		ģ�����ƣ�Mux2
		ģ�鹦�ܣ���ѡһ��·ѡ����
		����˿ڣ�
			d0		����-0
			d1		����-1
			sel		ѡ���ź�
		����˿ڣ�
			y		���
	*/
	
	input 		[WIDTH - 1 : 0] 	d0,
	input 		[WIDTH - 1 : 0] 	d1,
	input 							sel,

	output 		[WIDTH - 1 : 0] 	y
	);


	assign y = sel ? d1 : d0;

endmodule