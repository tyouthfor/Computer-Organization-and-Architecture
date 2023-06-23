`timescale 1ns / 1ps

module Is_Equal #(parameter WIDTH = 32)(
	/*
		ģ�����ƣ�Is_Equal
		ģ�鹦�ܣ��ж������Ƿ����
		����˿ڣ�
			a		��һ������
			b		�ڶ�������
		����˿ڣ�
			y		�������ʱΪ 1����������ʱΪ 0
	*/
	
	input 		[WIDTH - 1 : 0]		a,
	input 		[WIDTH - 1 : 0] 	b,

	output 							y
	);


	assign y = (a == b) ? 1 : 0;

endmodule