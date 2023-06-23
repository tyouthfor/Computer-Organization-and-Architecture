`timescale 1ns / 1ps

//*********************************************************
//                ģ�����ƣ�Hazard
//                ģ�鹦�ܣ�ð�ռ�⼰����
//*********************************************************
module Hazard(

    // IF �׶�

    // ID �׶�
    input [4:0] Rs_ID,
    input [4:0] Rt_ID,

    input Branch_ID,

    // EX �׶�
    input [4:0] Rs_EX,
    input [4:0] Rt_EX,
    input [4:0] write_reg_EX,

    input MemtoReg_EX,
    input RegWrite_EX,

    // MEM �׶�
    input [4:0] Rt_MEM,
    input [4:0] write_reg_MEM,

    input MemtoReg_MEM,
    input RegWrite_MEM,
    input MemWrite_MEM,

    // WB �׶�
    input [4:0] write_reg_WB,

    input RegWrite_WB,

    // ���ð�յ�����ź�
    // 1.ͨ�� Forwarding ��� RAW ð��
    output reg [1:0] Forward_fst_operand_EX,  // ���� ALU ��һ��������Դ��ѡ������ sel �ź�
    output reg [1:0] Forward_sec_operand_EX,  // ���� ALU �ڶ���������Դ��ѡ������ sel �ź�

    output Forward_fst_operand_ID,  // �����ж������Ƿ����ʱ��branch���ĵ�һ��������Դ��ѡ������ sel �ź�
    output Forward_sec_operand_ID,  // �����ж������Ƿ����ʱ��branch���ĵڶ���������Դ��ѡ������ sel �ź�

    output Forward_write_data_memory_MEM,  // ����д���ڴ��������Դ��ѡ������ sel �ź�

    // 2.ͨ�� Stall ��� RAW ð��
    output stall_IF,
    output stall_ID,
    output flush_EX
    );
	
    // 1.ͨ�� Forwarding ��� EX �׶� ALU �������� RAW ð��
        // (1).From "ALU_result_MEM" at the end of EX stage��in MEM stage��
            // e.g ָ������Ϊ add��add
            // e.g ָ������Ϊ add��lw/sw
        // (2).From "write_data_reg_WB" at the end of MEM stage��in WB stage��
            // e.g ָ������Ϊ add��x��add
            // e.g ָ������Ϊ lw��x��add

    always @ (*) begin

        // ��һ������
        if (Rs_EX != 0) begin

            // ���Ĵ����� Rs_EX ����д�Ĵ����� write_reg_MEM���� RegWrite_MEM �ź�Ϊ 1����һ�������
            if (Rs_EX == write_reg_MEM & RegWrite_MEM) begin
                Forward_fst_operand_EX = 2'b10;  // ALU_result_MEM
            end

            // ���Ĵ����� Rs_EX ����д�Ĵ����� write_reg_WB���� RegWrite_WB �ź�Ϊ 1���ڶ��������
            else if (Rs_EX == write_reg_WB & RegWrite_WB) begin
                Forward_fst_operand_EX = 2'b01;  // write_data_reg_WB
            end

            // ��ð��
            else begin
                Forward_fst_operand_EX = 2'b00;
            end
        end

        else begin
            Forward_fst_operand_EX = 2'b00;
        end

        // �ڶ�������
        if (Rt_EX != 0) begin

            // ���Ĵ����� Rt_EX ����д�Ĵ����� write_reg_MEM���� RegWrite_MEM �ź�Ϊ 1����һ�������
            if (Rt_EX == write_reg_MEM & RegWrite_MEM) begin
                Forward_sec_operand_EX = 2'b10;  // ALU_result_MEM
            end

            // ���Ĵ����� Rt_EX ����д�Ĵ����� write_reg_WB���� RegWrite_WB �ź�Ϊ 1���ڶ��������
            else if (Rt_EX == write_reg_WB & RegWrite_WB) begin
                Forward_sec_operand_EX = 2'b01;  // write_data_reg_WB
            end

            // ��ð��
            else begin
                Forward_sec_operand_EX = 2'b00;
            end
        end

        else begin
            Forward_sec_operand_EX = 2'b00;
        end
    end


    // 2.ͨ�� Stall ��� EX �׶� ALU �������� RAW ð�գ��� ID �׶μ�⣩
        // e.g ָ������Ϊ lw, add
    
    // ���Ĵ����� Rs_ID/Rt_ID ����д�Ĵ����� Rt_EX ���� MemtoReg_EX �ź�Ϊ 1��lw��
    wire lw_stall_ID;
    assign lw_stall_ID = (Rs_ID == Rt_EX | Rt_ID == Rt_EX) & MemtoReg_EX;
    
    assign stall_IF = lw_stall_ID | branch_stall_ID;  // PC ����
    assign stall_ID = stall_IF;  // IF/ID ����ˮ����
    assign flush_EX = stall_ID;  // ID/EX ����ˮ��ˢ


    // 3.ͨ�� Forwarding ��� ID �׶��ж������Ƿ����ʱ�� RAW ð��
        // (1).From "ALU_result_MEM" at the end of EX state��in MEM stage��
            // e.g ָ������Ϊ add��x��beq
        // (2).û�д� WB �� ID ������ͨ·����Ϊ���� WB ��Ҫд�ؼĴ����ѵ���
            // e.g ָ������Ϊ lw��x��x��beq �������ð��

    // ���Ĵ����� Rs_ID/Rt_ID ����д�Ĵ����� write_reg_MEM���� RegWrite_MEM �ź�Ϊ 1
    assign Forward_fst_operand_ID = (Rs_ID != 0 & Rs_ID == write_reg_MEM & RegWrite_MEM);
    assign Forward_sec_operand_ID = (Rt_ID != 0 & Rt_ID == write_reg_MEM & RegWrite_MEM);


    // 4.ͨ�� Stall ��� ID �׶��ж������Ƿ����ʱ�� RAW ð�գ��� ID �׶μ�⣩
        // e.g ָ������Ϊ add��beq
        // e.g ָ������Ϊ lw��x��beq

    wire branch_stall_ID;
    assign branch_stall_ID = Branch_ID &  // Branch_ID Ϊ 1

                            // ���Ĵ����� Rs_ID/Rt_ID ����д�Ĵ����� write_reg_EX���� RegWrite_EX �ź�Ϊ 1����һ�������
                            (RegWrite_EX & (write_reg_EX == Rs_ID | write_reg_EX == Rt_ID) |

                            // ���Ĵ����� Rs_ID/Rt_ID ����д�Ĵ����� write_reg_MEM���� MemtoReg_MEM �ź�Ϊ 1���ڶ��������
                            MemtoReg_MEM & (write_reg_MEM == Rs_ID | write_reg_MEM == Rt_ID));


    // 5.ͨ�� Forwarding ��� MEM �׶�д�ڴ�� RAW ð��
        // From "write_data_reg_WB" at the end of MEM stage��in WB stage��
        // e.g ָ������Ϊ add��sw
    
    // д���ڴ��������Դ Rt_MEM ����д�Ĵ����� write_reg_WB���� MemWrite_MEM Ϊ 1
    assign Forward_write_data_memory_MEM = (Rt_MEM != 0 & Rt_MEM == write_reg_WB & MemWrite_MEM);

endmodule