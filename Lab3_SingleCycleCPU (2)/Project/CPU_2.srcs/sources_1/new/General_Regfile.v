`timescale 1ns / 1ps

//*********************************************************
//            模块名称：General_Regfile
//            模块功能：MIPS的32个32位通用寄存器
//*********************************************************
module General_Regfile(
	input clk,
	input [4:0] read_reg1,    // 读寄存器号1
	input [4:0] read_reg2,    // 读寄存器号2
	input [4:0] write_reg,    // 写寄存器号
	input [31:0] write_data,  // 写数据
	input RegWrite,  		  // 写控制信号

	output [31:0] read_data1, // 从寄存器号1中读出的数据
	output [31:0] read_data2  // 从寄存器号2中读出的数据
    );

	reg [31:0] rf[31:0];  // 寄存器堆

	// 1.写数据
	always @ (posedge clk) begin
		if (RegWrite) begin
			rf[write_reg] <= write_data;
		end
	end

	// 2.读数据
	assign read_data1 = (read_reg1 != 0) ? rf[read_reg1] : 0;
	assign read_data2 = (read_reg2 != 0) ? rf[read_reg2] : 0;

endmodule
