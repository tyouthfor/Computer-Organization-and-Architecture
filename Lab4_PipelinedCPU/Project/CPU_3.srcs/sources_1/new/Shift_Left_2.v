`timescale 1ns / 1ps

module Shift_Left_2 #(parameter WIDTH = 32)(
	/*
		模块名称：Shift_Left_2
		模块功能：左移 2 位
		输入端口：
			x		输入
		输出端口：
			y		输出
	*/

	input 		[WIDTH - 1 : 0] 	x,

	output 		[WIDTH - 1 : 0] 	y
	);
	

	assign y = {x[WIDTH - 3 : 0], 2'b00};

endmodule