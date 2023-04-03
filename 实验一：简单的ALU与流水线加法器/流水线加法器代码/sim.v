`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/02 23:45:53
// Design Name: 
// Module Name: sim
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


module sim(

    );
    
    reg clk = 1'b0;
    reg [3:0] rst = 4'b1111;
    reg [3:0] stop = 4'b1111;
    reg [31:0] data1 = 32'd1;
    reg [31:0] data2 = -5;
    reg cin = 1'b0;
    reg valid_in = 1'b1;
    reg out_allow = 1'b1;
    
    wire [31:0] res;
    wire cout;
    wire valid_out;
    
    Stallable_Pipeline_Adder ty(.clk(clk), .rst(rst), .stop(stop), .data1(data1), .data2(data2), .cin(cin), .valid_in(valid_in), .out_allow(out_allow), .res(res), .cout(cout), .valid_out(valid_out));
    
    initial begin
        forever #50 clk = ~clk;
    end
    
    initial begin
        forever #100 data2 = data2 + 1;
    end
    
    //测试流水线暂停
    initial begin
        #1000 stop[1] = 0;
        #200 stop[1] = 1;
    end
    
    //测试流水线刷新
    initial begin
        #1500 rst[2] = 0;
        #100 rst[2] =1 ;
    end
    
endmodule
