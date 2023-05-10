`timescale 1ns / 1ps

//*********************************************************
//            ģ�����ƣ�General_Regfile
//            ģ�鹦�ܣ�MIPS��32��32λͨ�üĴ���
//*********************************************************
module General_Regfile(
	input clk,
	input [4:0] read_reg1,    // ���Ĵ�����1
	input [4:0] read_reg2,    // ���Ĵ�����2
	input [4:0] write_reg,    // д�Ĵ�����
	input [31:0] write_data,  // д����
	input RegWrite,  		  // д�����ź�

	output [31:0] read_data1, // �ӼĴ�����1�ж���������
	output [31:0] read_data2  // �ӼĴ�����2�ж���������
    );

	reg [31:0] rf[31:0];  // �Ĵ�����

	// 1.д����
	always @ (posedge clk) begin
		if (RegWrite) begin
			rf[write_reg] <= write_data;
		end
	end

	// 2.������
	assign read_data1 = (read_reg1 != 0) ? rf[read_reg1] : 0;
	assign read_data2 = (read_reg2 != 0) ? rf[read_reg2] : 0;

endmodule
