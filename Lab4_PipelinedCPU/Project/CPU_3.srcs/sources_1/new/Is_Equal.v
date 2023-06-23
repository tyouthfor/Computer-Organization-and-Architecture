`timescale 1ns / 1ps

module Is_Equal #(parameter WIDTH = 32)(
	/*
		模块名称：Is_Equal
		模块功能：判断两数是否相等
		输入端口：
			a		第一操作数
			b		第二操作数
		输出端口：
			y		两数相等时为 1，两数不等时为 0
	*/
	
	input 		[WIDTH - 1 : 0]		a,
	input 		[WIDTH - 1 : 0] 	b,

	output 							y
	);


	assign y = (a == b) ? 1 : 0;

endmodule