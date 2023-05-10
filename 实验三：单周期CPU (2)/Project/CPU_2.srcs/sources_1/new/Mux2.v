`timescale 1ns / 1ps

//*********************************************************
//                ģ�����ƣ�Mux2
//                ģ�鹦�ܣ���ѡһ��·ѡ����
//*********************************************************
module Mux2 #(parameter DATA_WIDTH = 8)(
	input [DATA_WIDTH - 1 : 0] d0,
	input [DATA_WIDTH - 1 : 0] d1,
	input sel,
	
	output [DATA_WIDTH - 1 : 0] y
    );
	
	assign y = sel ? d1 : d0;

endmodule