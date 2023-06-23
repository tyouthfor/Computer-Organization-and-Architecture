`timescale  1ns / 1ps

module Mux2 # (parameter WIDTH = 32)(
	/*
		模块名称：Mux2
		模块功能：二选一多路选择器
		输入端口：
			d0		输入-0
			d1		输入-1
			sel		选择信号
		输出端口：
			y		输出
	*/
	
	input 		[WIDTH - 1 : 0] 	d0,
	input 		[WIDTH - 1 : 0] 	d1,
	input 							sel,

	output 		[WIDTH - 1 : 0] 	y
	);


	assign y = sel ? d1 : d0;

endmodule