`timescale 1ns / 1ps

module Flop_rc #(parameter WIDTH = 32)(
	/*
		模块名称：Flop_rc
		模块功能：带 rst、clear 的 D 触发器
		输入端口：
			clk 		时钟信号
			rst 		复位信号，rst = 0 时输出复位为 0
			clear 		清除信号，clear = 0 时输出清除为 0
			din 		输入
		输出端口：
			dout 		输出
	*/

	input 									clk,
	input 									rst,
	input 									clear,
	input 				[WIDTH - 1 : 0] 	din,

	output 		reg 	[WIDTH - 1 : 0] 	dout
	);


	always @ (posedge clk or negedge rst) begin
		if (!rst) 			dout <= 0;
		else if (!clear) 	dout <= 0;
		else 				dout <= din;
	end

endmodule