`timescale 1ns / 1ps

module Mux3 #(parameter WIDTH = 32)(
	/*
		模块名称：Mux3
		模块功能：三选一多路选择器
		输入端口：
			d0		输入-00
			d1		输入-01
			d2		输入-10
			sel		选择信号
		输出端口：
			y		输出
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