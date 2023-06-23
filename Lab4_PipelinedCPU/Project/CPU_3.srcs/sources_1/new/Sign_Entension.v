`timescale 1ns / 1ps

module Sign_Extension(
	/*
		ģ�����ƣ�Sign_Extension
		ģ�鹦�ܣ��� 16-bit ������������չ�� 32-bit
		����˿ڣ�
			x		����
		����˿ڣ�
			y		���
	*/

	input 		[15:0] 		x,
	
	output 		[31:0] 		y
	);


	assign y = {{16{x[15]}}, x};

endmodule