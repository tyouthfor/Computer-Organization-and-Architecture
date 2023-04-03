`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/02 14:48:41
// Design Name: 
// Module Name: ALU
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

//32bit ALU
module ALU(
    input signed [31:0] a,  //��һ������
    input signed [31:0] b,  //�ڶ�������
    input [2:0] op,  //ѡ����
    output reg signed [31:0] y  //���
    );
    
    always @(*) begin
        case(op)
            3'b000: y = a + b;
            
            3'b001: y = a - b;
            
            3'b010: y = a & b;
            
            3'b011: y = a | b;
            
            3'b100: y = ~a;
            
            3'b101: begin
                if(a < b) y = 1;
                else y = 0;
            end
            
            default:
                y = 0;
        endcase
    end
    
    
    
endmodule
