`timescale 1ns / 1ps

module ALU(
    /*
        ģ�����ƣ�ALU
        ģ�鹦�ܣ�32-bit ALU
        ����˿ڣ�
            a       ��һ������
            b       �ڶ�������
            op      ѡ���ź�
        ����˿ڣ�
            y       ���
    */

    input               [31:0]      a,
    input               [31:0]      b,
    input               [2:0]       op,
    
    output      reg     [31:0]      y
    );
    

    // add��010
    // sub��110
    // and��000
    // or�� 001
    // slt��111
    always @ (*) begin
        case(op)
            3'b010: y = a + b;
            
            3'b110: y = a - b;

            3'b000: y = a & b;
            
            3'b001: y = a | b;
                     
            3'b111: y = a < b ? 1 : 0;
            
            default: y = 0;
        endcase
    end
      
endmodule