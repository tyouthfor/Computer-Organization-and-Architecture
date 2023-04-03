`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/02 20:30:52
// Design Name: 
// Module Name: Stallable_Pipeline_Adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//���������ļ���ˮ��32-bit�ӷ���,ÿһ������8-bit�ӷ�����
module Stallable_Pipeline_Adder(
    input clk,
    input [3:0] rst,   //��ˮ��ˢ���źţ���0ˢ��
    input [3:0] stop,  //��ˮ����ͣ�źţ���0��ͣ
    input [31:0] data1,  //��һ������
    input [31:0] data2,  //�ڶ�������
    input cin,  //�����λ�ź�
    
    input valid_in,   //����data1��data2�Ƿ���Ч��Ĭ����1
    input out_allow,  //���res�Ƿ���Խ������ݣ�Ĭ����1
    
    output [31:0] res,  //���
    output cout,        //�����λ�ź�
    output valid_out    //���res�Ƿ���Ч
    );
    
    //--------------------��ˮ�߸����ź���������������--------------------//
    
    reg pipe1_valid;      //��ǰpipe1_data�Ƿ���Ч��0��ʾ������ˮ��Ϊ��
    wire pipe1_allow_in;  //pipe1�ܷ��������
    wire pipe1_ready_go;  //pipe1�ܷ����ݴ�����һ��
    wire pipe1_to_pipe2_valid;  //pipe2��Ҫ���յ����ݵ���Ч��

    reg pipe2_valid;      
    wire pipe2_allow_in;
    wire pipe2_ready_go;
    wire pipe2_to_pipe3_valid;

    reg pipe3_valid;
    wire pipe3_allow_in;
    wire pipe3_ready_go;
    wire pipe3_to_pipe4_valid;

    reg pipe4_valid;
    wire pipe4_allow_in;
    wire pipe4_ready_go;
    
    //--------------------��ˮ�߸����Ĵ������������ڴ洢������--------------------//

    reg [7:0] pipe1_data_7to0;  //�����8λ������
    reg [7:0] pipe1_data1_15to8;  //�����һ��������[15:8]λ
    reg [7:0] pipe1_data2_15to8;  //����ڶ���������[15:8]λ
    reg [7:0] pipe1_data1_23to16;
    reg [7:0] pipe1_data2_23to16;
    reg [7:0] pipe1_data1_31to24;
    reg [7:0] pipe1_data2_31to24;
    reg pipe1_c;
    
    reg [7:0] pipe2_data_7to0;
    reg [7:0] pipe2_data_15to8;
    reg [7:0] pipe2_data1_23to16;
    reg [7:0] pipe2_data2_23to16;
    reg [7:0] pipe2_data1_31to24;
    reg [7:0] pipe2_data2_31to24;
    reg pipe2_c;
    
    reg [7:0] pipe3_data_7to0;
    reg [7:0] pipe3_data_15to8;
    reg [7:0] pipe3_data_23to16;
    reg [7:0] pipe3_data1_31to24;
    reg [7:0] pipe3_data2_31to24;
    reg pipe3_c;
    
    reg [7:0] pipe4_data_7to0;
    reg [7:0] pipe4_data_15to8;
    reg [7:0] pipe4_data_23to16;
    reg [7:0] pipe4_data_31to24;
    reg pipe4_c;
    
    //--------------------��ˮ��ʵ��--------------------//
    
    //��һ����ˮ��
    assign pipe1_ready_go = stop[0];  //pipe1�ܷ����ݴ�����һ��
    assign pipe1_allow_in = !pipe1_valid || pipe1_ready_go && pipe2_allow_in;  //pipe1�ܷ�������ݣ�(1).pipe1�ܽ���ǰ��Ч���ݴ���pipe2 + pipe2�ܹ����ա�(2).pipe1Ϊ�� + pipe2�ܹ����ա�
    assign pipe1_to_pipe2_valid = pipe1_valid && pipe1_ready_go;  //pipe2��Ҫ���յ����ݵ���Ч��
    
    always @ (posedge clk) begin
        //�����ˮ��
        if(!rst[0]) begin
            pipe1_valid <= 1'b0;
        end
        
        //ֻҪ�����ܹ��������ݣ���Ҫ���±�����valid
        else if(pipe1_allow_in) begin
            pipe1_valid <= valid_in;
        end
        
        //�����Ҫ���յ�������Ч���ұ����ܹ����գ����������
        if(valid_in && pipe1_allow_in) begin
            {pipe1_c, pipe1_data_7to0} <= {1'b0, data1[7:0]} + {1'b0, data2[7:0]} + cin;
            {pipe1_data1_15to8, pipe1_data2_15to8} <= {data1[15:8], data2[15:8]};
            {pipe1_data1_23to16, pipe1_data2_23to16} <= {data1[23:16], data2[23:16]};
            {pipe1_data1_31to24, pipe1_data2_31to24} <= {data1[31:24], data2[31:24]};
        end
        
        //����������ܹ��������ݣ�˵����������������valid���ֲ���
    end
    
    //�ڶ�����ˮ��
    assign pipe2_ready_go = stop[1];
    assign pipe2_allow_in = !pipe2_valid || pipe2_ready_go && pipe3_allow_in;
    assign pipe2_to_pipe3_valid = pipe2_valid && pipe2_ready_go;
    
    always @ (posedge clk) begin
        if(!rst[1]) begin
            pipe2_valid <= 1'b0;
        end
        
        else if(pipe2_allow_in) begin
            pipe2_valid <= pipe1_to_pipe2_valid;  //���ﲻ��pipe1_valid��ԭ��ͬ��
        end  
        
        if(pipe1_to_pipe2_valid && pipe2_allow_in) begin  //Q��Ϊʲô��������pipe1_valid��A���п���pipe1������Ч���޷�����pipe2
            pipe2_data_7to0 <= pipe1_data_7to0;
            {pipe2_c, pipe2_data_15to8} <= {1'b0, pipe1_data1_15to8} + {1'b0, pipe1_data2_15to8} + pipe1_c;
            {pipe2_data1_23to16, pipe2_data2_23to16} <= {pipe1_data1_23to16, pipe1_data2_23to16};
            {pipe2_data1_31to24, pipe2_data2_31to24} <= {pipe1_data1_31to24, pipe1_data2_31to24};
        end
    end
    
    //��������ˮ��
    assign pipe3_ready_go = stop[2];
    assign pipe3_allow_in = !pipe3_valid || pipe3_ready_go && pipe4_allow_in;
    assign pipe3_to_pipe4_valid = pipe3_valid && pipe3_ready_go;
    
    always @ (posedge clk) begin
        if(!rst[2]) begin
            pipe3_valid <= 1'b0;
        end
        
        else if(pipe3_allow_in) begin
            pipe3_valid <= pipe2_to_pipe3_valid;
        end
        
        if(pipe2_to_pipe3_valid && pipe3_allow_in) begin
            pipe3_data_7to0 <= pipe2_data_7to0;
            pipe3_data_15to8 <= pipe2_data_15to8;
            {pipe3_c, pipe3_data_23to16} <= {1'b0, pipe2_data1_23to16} + {1'b0, pipe2_data2_23to16} + pipe2_c;
            {pipe3_data1_31to24, pipe3_data2_31to24} <= {pipe2_data1_31to24, pipe2_data2_31to24};
        end
    end
    
    //���ļ���ˮ��
    assign pipe4_ready_go = stop[3];
    assign pipe4_allow_in = !pipe4_valid || pipe4_ready_go && out_allow;
    assign valid_out = pipe4_valid && pipe4_ready_go;
    
    always @ (posedge clk) begin
        if(!rst[3]) begin
            pipe4_valid <= 1'b0;
        end
        
        else if(pipe4_allow_in) begin
            pipe4_valid <= pipe3_to_pipe4_valid;
        end  
        
        if(pipe3_to_pipe4_valid && pipe4_allow_in) begin
            pipe4_data_7to0 <= pipe3_data_7to0;
            pipe4_data_15to8 <= pipe3_data_15to8;
            pipe4_data_23to16 <= pipe3_data_23to16;
            {pipe4_c, pipe4_data_31to24} <= {1'b0, pipe3_data1_31to24} + {1'b0, pipe3_data2_31to24} + pipe3_c;
        end
    end
    
    //���
    assign res = {pipe4_data_31to24, pipe4_data_23to16, pipe4_data_15to8, pipe4_data_7to0};
    assign cout = pipe4_c;
    
endmodule
