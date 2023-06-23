`timescale 1ns / 1ps

module PC(
    /*
        ģ�����ƣ�PC
        ģ�鹦�ܣ�Program Counter���� rst��en �� D ������
        ����˿ڣ�
            clk         ʱ���ź�
            rst         ��λ�źš�1-����������0-�����λΪ 0
            en          ʹ���źš�1-����������0-������ֲ���
            cin         ��һ��Ҫִ�е�ָ��ĵ�ַ
        ����˿ڣ�
            cout        ��ǰִ�е�ָ��ĵ�ַ
            inst_en     ��ǰָ���ַ�Ƿ���Ч��1-��Ч��0-��Ч
    */

    input                           clk,
    input                           rst,
    input                           en,
    input               [31:0]      cin,

    output      reg     [31:0]      cout        = 32'h0 - 32'h4,  // -4 ��Ϊ�˶Գ����ͷ��Ӱ��
    output      reg                 inst_en     = 1'b1
    );

    
    always @ (negedge clk) begin  // �½��ش�����Ϊ���� Instruction Memory ��ָ���
        if (!rst) begin
            cout <= 32'h0;
            inst_en <= 1'b0;
        end
        else if (en) begin
            cout <= cin;
            inst_en <= 1'b1;
        end
        else begin
            cout <= cout;
            inst_en <= inst_en;
        end
    end

endmodule