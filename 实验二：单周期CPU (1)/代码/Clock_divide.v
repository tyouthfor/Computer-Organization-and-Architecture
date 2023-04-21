`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/19 17:51:49
// Design Name: 
// Module Name: Clock_divide
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

// ʱ�ӷ�Ƶ
module Clock_divide(
    input clk,
    output reg clk_div
    );

    parameter frequency = 100_000000;  //ϵͳʱ��Ƶ�ʣ�100Mhz����Ƶ��ʱ������Ϊ2s
    integer cnt;  //����
    
    always @ (posedge clk) begin
        if(cnt == frequency) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else cnt <= cnt + 1;
    end
    
endmodule
