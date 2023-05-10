`timescale 1ns / 1ps

//*********************************************************
//                ģ�����ƣ�ALU
//                ģ�鹦�ܣ�32λALU
//*********************************************************
module ALU(
    input [31:0] a,  //��һ������
    input [31:0] b,  //�ڶ�������
    input [2:0] op,  //ѡ����

    output reg [31:0] y,  //���
    output reg zero = 1'b0  //����Ƿ�Ϊ0������branch�����ж�
    );
    
    // ��������3λѡ����
    // add��010
    // sub��110
    // and��000
    // or�� 001
    // set on less than��111��slt�� 
    always @ (*) begin
        case(op)
            3'b010: y = a + b;
            
            3'b110: begin
                y = a - b;
                if (a - b == 0) zero = 1;
                else zero = 0;
            end

            3'b000: y = a & b;
            
            3'b001: y = a | b;
                     
            3'b111: begin
                if (a < b) y = 1;
                else y = 0;
            end
            
            default:
                y = 0;
        endcase
    end
      
endmodule