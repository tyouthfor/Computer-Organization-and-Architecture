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

//带阻塞的四级流水线32-bit加法器,每一级进行8-bit加法运算
module Stallable_Pipeline_Adder(
    input clk,
    input [3:0] rst,   //流水线刷新信号：置0刷新
    input [3:0] stop,  //流水线暂停信号：置0暂停
    input [31:0] data1,  //第一操作数
    input [31:0] data2,  //第二操作数
    input cin,  //输入进位信号
    
    input valid_in,   //输入data1与data2是否有效，默认置1
    input out_allow,  //输出res是否可以接收数据，默认置1
    
    output [31:0] res,  //输出
    output cout,        //输出进位信号
    output valid_out    //输出res是否有效
    );
    
    //--------------------流水线各级信号声明，用于阻塞--------------------//
    
    reg pipe1_valid;      //当前pipe1_data是否有效，0表示本级流水线为空
    wire pipe1_allow_in;  //pipe1能否接收数据
    wire pipe1_ready_go;  //pipe1能否将数据传给下一级
    wire pipe1_to_pipe2_valid;  //pipe2将要接收的数据的有效性

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
    
    //--------------------流水线各级寄存器声明，用于存储操作数及运算结果--------------------//

    reg [7:0] pipe1_data_7to0;  //储存低8位运算结果
    reg [7:0] pipe1_data1_15to8;  //储存第一个操作数[15:8]位
    reg [7:0] pipe1_data2_15to8;  //储存第二个操作数[15:8]位
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
    
    //--------------------流水线实现--------------------//
    
    //第一级流水线
    assign pipe1_ready_go = stop[0];  //pipe1能否将数据传给下一级
    assign pipe1_allow_in = !pipe1_valid || pipe1_ready_go && pipe2_allow_in;  //pipe1能否接收数据：(1).pipe1能将当前有效数据传给pipe2 + pipe2能够接收。(2).pipe1为空 + pipe2能够接收。
    assign pipe1_to_pipe2_valid = pipe1_valid && pipe1_ready_go;  //pipe2将要接收的数据的有效性
    
    always @ (posedge clk) begin
        //清空流水线
        if(!rst[0]) begin
            pipe1_valid <= 1'b0;
        end
        
        //只要本级能够接收数据，就要更新本级的valid
        else if(pipe1_allow_in) begin
            pipe1_valid <= valid_in;
        end
        
        //如果将要接收的数据有效，且本级能够接收，则读入数据
        if(valid_in && pipe1_allow_in) begin
            {pipe1_c, pipe1_data_7to0} <= {1'b0, data1[7:0]} + {1'b0, data2[7:0]} + cin;
            {pipe1_data1_15to8, pipe1_data2_15to8} <= {data1[15:8], data2[15:8]};
            {pipe1_data1_23to16, pipe1_data2_23to16} <= {data1[23:16], data2[23:16]};
            {pipe1_data1_31to24, pipe1_data2_31to24} <= {data1[31:24], data2[31:24]};
        end
        
        //如果本级不能够接收数据，说明阻塞发生，本级valid保持不变
    end
    
    //第二级流水线
    assign pipe2_ready_go = stop[1];
    assign pipe2_allow_in = !pipe2_valid || pipe2_ready_go && pipe3_allow_in;
    assign pipe2_to_pipe3_valid = pipe2_valid && pipe2_ready_go;
    
    always @ (posedge clk) begin
        if(!rst[1]) begin
            pipe2_valid <= 1'b0;
        end
        
        else if(pipe2_allow_in) begin
            pipe2_valid <= pipe1_to_pipe2_valid;  //这里不用pipe1_valid的原因同上
        end  
        
        if(pipe1_to_pipe2_valid && pipe2_allow_in) begin  //Q：为什么条件不是pipe1_valid？A：有可能pipe1数据有效但无法传给pipe2
            pipe2_data_7to0 <= pipe1_data_7to0;
            {pipe2_c, pipe2_data_15to8} <= {1'b0, pipe1_data1_15to8} + {1'b0, pipe1_data2_15to8} + pipe1_c;
            {pipe2_data1_23to16, pipe2_data2_23to16} <= {pipe1_data1_23to16, pipe1_data2_23to16};
            {pipe2_data1_31to24, pipe2_data2_31to24} <= {pipe1_data1_31to24, pipe1_data2_31to24};
        end
    end
    
    //第三级流水线
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
    
    //第四级流水线
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
    
    //输出
    assign res = {pipe4_data_31to24, pipe4_data_23to16, pipe4_data_15to8, pipe4_data_7to0};
    assign cout = pipe4_c;
    
endmodule
