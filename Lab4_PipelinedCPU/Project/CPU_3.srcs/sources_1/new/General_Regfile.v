`timescale 1ns / 1ps

module General_Regfile(
	/*
		ģ�����ƣ�General_Regfile
		ģ�鹦�ܣ�MIPS �� 32 �� 32-bit ͨ�üĴ���
		����˿ڣ�
			clk				ʱ���ź�
			read_reg1 		���Ĵ����� 1
			read_reg2 		���Ĵ����� 2
			write_reg 		д�Ĵ�����
			write_data 		д����
			RegWrite 		д�����ź�
		����˿ڣ�
			read_data1 		�ӼĴ��� 1 �ж���������
			read_data2 		�ӼĴ��� 2 �ж���������
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


	// �Ĵ�����
	reg 		[31:0] 		rf[31:0];


	// д����
	always @ (negedge clk) begin  // �½��ش�����Ϊ�˴���ͬ PC��
		if (RegWrite) begin
			rf[write_reg] <= write_data;
		end
	end


	// ������
	assign read_data1 = (read_reg1 != 0) ? rf[read_reg1] : 0;
	assign read_data2 = (read_reg2 != 0) ? rf[read_reg2] : 0;

endmodule