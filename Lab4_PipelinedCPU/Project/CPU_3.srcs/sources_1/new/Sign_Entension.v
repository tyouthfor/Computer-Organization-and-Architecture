`timescale 1ns / 1ps

module Sign_Extension(
	/*
		模块名称：Sign_Extension
		模块功能：将 16-bit 立即数符号扩展成 32-bit
		输入端口：
			x		输入
		输出端口：
			y		输出
	*/

	input 		[15:0] 		x,
	
	output 		[31:0] 		y
	);


	assign y = {{16{x[15]}}, x};

endmodule