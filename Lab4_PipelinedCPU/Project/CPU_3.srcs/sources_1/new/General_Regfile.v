`timescale 1ns / 1ps

module General_Regfile(
	/*
		模块名称：General_Regfile
		模块功能：MIPS 的 32 个 32-bit 通用寄存器
		输入端口：
			clk				时钟信号
			read_reg1 		读寄存器号 1
			read_reg2 		读寄存器号 2
			write_reg 		写寄存器号
			write_data 		写数据
			RegWrite 		写控制信号
		输出端口：
			read_data1 		从寄存器 1 中读出的数据
			read_data2 		从寄存器 2 中读出的数据
	*/

	input 					clk,
	input 		[4:0] 		read_reg1,
	input 		[4:0] 		read_reg2,
	input 		[4:0] 		write_reg,
	input 		[31:0] 		write_data,
	input 					RegWrite,

	output 		[31:0] 		read_data1,
	output 		[31:0] 		read_data2
	);


	// 寄存器堆
	reg 		[31:0] 		rf[31:0];

	// 写数据
	always @ (negedge clk) begin  // 下降沿触发是为了错开（同 PC）
		if (RegWrite) begin
			rf[write_reg] <= write_data;
		end
	end

	// 读数据
	assign read_data1 = (read_reg1 != 0) ? rf[read_reg1] : 0;
	assign read_data2 = (read_reg2 != 0) ? rf[read_reg2] : 0;

endmodule
