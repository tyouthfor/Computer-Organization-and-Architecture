`timescale 1ns / 1ps

module Flop_enr #(parameter WIDTH = 32)(
	/*
		模块名称：Flop_enr
		模块功能：带 en、rst 的 D 触发器
		输入端口：
			clk 		时钟信号
			en 			使能信号。1-正常工作，0-输出保持不变
			rst 		复位信号。1-正常工作，0-输出复位为 0
			din 		输入
		输出端口：
			dout 		输出
	*/

	input 									clk,
	input 									en,
    input 									rst,
	input 				[WIDTH - 1 : 0] 	din,

	output 		reg 	[WIDTH - 1 : 0] 	dout
    );


	always @ (posedge clk or negedge rst) begin
		if (!rst) 		dout <= 0;
		else if (en) 	dout <= din;
		else 			dout <= dout;
	end

endmodule