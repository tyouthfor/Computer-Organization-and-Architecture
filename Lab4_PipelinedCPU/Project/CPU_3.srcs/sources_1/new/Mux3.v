`timescale 1ns / 1ps

module Mux3 #(parameter WIDTH = 32)(
	/*
		ģ�����ƣ�Mux3
		ģ�鹦�ܣ���ѡһ��·ѡ����
		����˿ڣ�
			d0		����-00
			d1		����-01
			d2		����-10
			sel		ѡ���ź�
		����˿ڣ�
			y		���
	*/

	input 		[WIDTH - 1 : 0] 	d0,
	input 		[WIDTH - 1 : 0] 	d1,
	input 		[WIDTH - 1 : 0] 	d2,
	input 		[1:0] 				sel,
	
	output 		[WIDTH - 1 : 0] 	y
	);


	assign y = (sel == 2'b00) ? d0 : 
			   (sel == 2'b01) ? d1 :
			   (sel == 2'b10) ? d2 : 0;

endmodule