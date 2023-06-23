`timescale 1ns / 1ps

module Datapath(
    /*
        ģ�����ƣ�Datapath
        ģ�鹦�ܣ���ˮ�� MIPS ������������ͨ·
        ����˿ڣ�
            clk                         ʱ���ź�
            rst                         ��λ�źš�1-����������0-��λ

            // �ڴ�����
            inst_IF                     Instruction Memory ����������ڴ��ж�����ָ��
            read_data_memory_MEM        Data Memory ����������ڴ��ж���������
            
            // ID �׶���Ҫ�Ŀ����ź�
            PCSrc_ID                    Controller �������ѡ����һ��ָ���ַ��0-PC ������1-Branch ��תĿ���ַ
            Jump_ID                     Controller �������ѡ����һ��ָ���ַ��0-����Ľ����1-Jump ��תĿ���ַ

            // EX �׶���Ҫ�Ŀ����ź�
            RegDst_EX,                  Controller �������ѡ��д�Ĵ����ŵ���Դ��0-Rt_EX��1-Rd_EX
            ALUSrc_EX,                  Controller �������ѡ�� ALU �ڶ�����������Դ��0-�Ĵ����ѣ�1-������
            ALUControl_EX,              Controller �������ALU ��ѡ���ź�

            // WB �׶���Ҫ�Ŀ����ź�
            MemtoReg_WB,                Controller �������ѡ��д��Ĵ����ѵ�������Դ��0-ALU��1-�ڴ�
            RegWrite_WB                 Controller ��������Ĵ����ѵ�д�����ź�

            // ���ڽ��ð�յĿ����ź�
            Branch_ID
            RegWrite_EX,
            MemtoReg_EX,
            MemtoReg_MEM,
            RegWrite_MEM,

        ����˿ڣ�
            curr_inst_addr              Instruction Memory �����룺PC ��ַ
            inst_en                     Instruction Memory �����룺PC ��ַ�Ƿ���Ч

            inst_ID                     Controller �����룺��ǰִ�е�ָ��
            Equal_ID                    Controller �����룺�������ʱ�� 1������ȷ�� PCSrc
            flush_EX                    Controller �����룺ID/EX ����ˮ��ˢ�ź�

            ALU_result_MEM              Data Memory �����룺ALU �������������ڴ��ַ
            write_data_memory_MEM       Data Memory �����룺д���ڴ������
            MemWrite_MEM                Data Memory �����룺д�����ź�
            MemRead_MEM                 Data Memory �����룺�������ź�
    */

	input                   clk,
    input                   rst,

    // �ڴ�����
    input       [31:0]      inst_IF,
    input       [31:0]      read_data_memory_MEM,

    // ID �׶���Ҫ�Ŀ����ź�
    input                   PCSrc_ID,
    input                   Jump_ID,

    // EX �׶���Ҫ�Ŀ����ź�
    input                   RegDst_EX,
	input                   ALUSrc_EX,
    input       [2:0]       ALUControl_EX,

    // WB �׶���Ҫ�Ŀ����ź�
	input                   MemtoReg_WB,
	input                   RegWrite_WB,

    // ���ڽ��ð�յĿ����ź�
    input                   Branch_ID, 
    input                   MemtoReg_EX,
    input                   RegWrite_EX,
    input                   MemtoReg_MEM,
    input                   RegWrite_MEM,

    // Instruction Memory ������
    output      [31:0]      curr_inst_addr,
    output                  inst_en,

    // Controller ������
    output      [31:0]      inst_ID,
    output                  Equal_ID,
    output                  flush_EX,

    // Data Memory ������
    output      [31:0]      ALU_result_MEM,
	output      [31:0]      write_data_memory_MEM,
    output                  MemWrite_MEM,
    output                  MemRead_MEM
    );


    /*
        ð����ؿ����ź�������
            stall_IF                            PC �����ź�
            stall_ID                            IF/ID ����ˮ�����ź�
            Forward_fst_operand_EX              ���� ALU ��һ��������Դ��ѡ������ sel �ź�
            Forward_sec_operand_EX              ���� ALU �ڶ���������Դ��ѡ������ sel �ź�
            Forward_fst_operand_ID              ���� Is_Equal ��һ��������Դ��ѡ������ sel �ź�
            Forward_sec_operand_ID              ���� Is_Equal �ڶ���������Դ��ѡ������ sel �ź�
            Forward_write_data_memory_MEM       ����д�ڴ�������Դ��ѡ������ sel �ź�
    */

    // ��ˮ�����ź�
    wire                    stall_IF;
    wire                    stall_ID;

    // ��� ALU ����ð�յĿ����ź�
    wire        [1:0]       Forward_fst_operand_EX;
    wire        [1:0]       Forward_sec_operand_EX;

    // ��� Is_Equal ����ð�յĿ����ź�
    wire                    Forward_fst_operand_ID;
    wire                    Forward_sec_operand_ID;

    // ���д�ڴ�����ð�յĿ����ź�
    wire                    Forward_write_data_memory_MEM;


    /*
        IF �׶��ź�������
            // PC ��������
            next_inst_addr          PC �����룺��һ��ִ��ָ��ĵ�ַ
            PC_incre_addr_IF        PC ������ַ

            // ��ˮ
            PC_incre_addr_ID        
    */

    // PC ��������
    wire        [31:0]      next_inst_addr;
    wire        [31:0]      PC_incre_addr_IF;

    // IF/ID ����ˮ
    wire        [31:0]      PC_incre_addr_ID;

    PC                      pc
    (
        .clk(clk), .rst(rst), .en(~stall_IF), 
        .cin(next_inst_addr), .cout(curr_inst_addr), .inst_en(inst_en)
    );

    Adder2      #32         PC_incre
    (
        .a(curr_inst_addr), .b(32'h4), .c(PC_incre_addr_IF)
    );

    Flop_enr    #32         inst_IF_reg
    (
        .clk(clk), .rst(rst), .en(~stall_ID), 
        .din(inst_IF), .dout(inst_ID)
    );

    Flop_enr    #32         PC_incre_addr_IF_reg
    (
        .clk(clk), .rst(rst), .en(~stall_ID), 
        .din(PC_incre_addr_IF), .dout(PC_incre_addr_ID)
    );


    /*
        ID �׶��ź�������
            // ָ�����
            Rs_ID                       
            Rt_ID                       
            Rd_ID                       

            // �Ĵ����ѵ��������
            write_reg_WB                д�Ĵ�����
            write_data_reg_WB           д��Ĵ����ѵ�����
            read_data1_reg_ID           �� Rs ����������
            read_data2_reg_ID           �� Rt ����������

            // ������չ
            se_const_ID                 ������չ���������

            // ��֧��ת
            relative_branch_addr        Branch ָ�������ֵ�ַ
            branch_addr                 Branch ָ���Ŀ����ת��ַ
            temp_addr                   PC_incre_addr_ID �� branch_addr
            jump_addr                   Jump ָ���Ŀ����ת��ַ

            // �ж������Ƿ����
            is_equal_fst_operand        ��һ������
            is_equal_sec_operand        �ڶ�������

            // ��ˮ
            Rs_EX
            Rt_EX
            Rd_EX
            read_data1_reg_EX
            read_data2_reg_EX
            se_const_EX
    */
    
    // ָ�����
    wire        [4:0]       Rs_ID;
    wire        [4:0]       Rt_ID;
    wire        [4:0]       Rd_ID;

    // �Ĵ����ѵ��������
    wire        [4:0]       write_reg_WB;
    wire        [31:0]      write_data_reg_WB;
    wire        [31:0]      read_data1_reg_ID;
    wire        [31:0]      read_data2_reg_ID;

    // ������չ
    wire        [31:0]      se_const_ID;

    // ��֧��ת
    wire        [31:0]      relative_branch_addr;
    wire        [31:0]      branch_addr;
    wire        [31:0]      temp_addr;
    wire        [31:0]      jump_addr;

    // �ж������Ƿ����
    wire        [31:0]      is_equal_fst_operand;
    wire        [31:0]      is_equal_sec_operand;

    // ID/EX ����ˮ
    wire        [4:0]       Rs_EX;
    wire        [4:0]       Rt_EX;
    wire        [4:0]       Rd_EX;
    wire        [31:0]      read_data1_reg_EX;
    wire        [31:0]      read_data2_reg_EX;
    wire        [31:0]      se_const_EX;

    assign Rs_ID = inst_ID[25:21];
    assign Rt_ID = inst_ID[20:16];
    assign Rd_ID = inst_ID[15:11];
    assign jump_addr = {PC_incre_addr_ID[31:28], inst_ID[25:0], 2'b00};

    General_Regfile             rf
    (
        .clk(clk),
        .read_reg1(Rs_ID), .read_reg2(Rt_ID), 
        .write_reg(write_reg_WB), .write_data(write_data_reg_WB), .RegWrite(RegWrite_WB),
        .read_data1(read_data1_reg_ID), .read_data2(read_data2_reg_ID)
    );

    Sign_Extension              se 
    (
        .x(inst_ID[15:0]), .y(se_const_ID)
    );

    Shift_Left_2    #32         sl2
    (
        .x(se_const_ID), .y(relative_branch_addr)
    );

    Adder2          #32         cal_branch_addr
    (
        .a(PC_incre_addr_ID - 32'h4), .b(relative_branch_addr), .c(branch_addr)  // -4 ��Ϊ�˶Գ����ͷ��Ӱ��
    );

    Mux2            #32         branch_or_PC_increment 
    (
        .d0(PC_incre_addr_ID), .d1(branch_addr), 
        .sel(PCSrc_ID), 
        .y(temp_addr)
    );

    Mux2            #32         jump_or_other 
    (
        .d0(temp_addr), .d1(jump_addr), 
        .sel(Jump_ID), 
        .y(next_inst_addr)
    );

    Mux2            #32         Forward_fst_operand_from_ID 
    (
        .d0(read_data1_reg_ID), .d1(ALU_result_MEM), 
        .sel(Forward_fst_operand_ID), 
        .y(is_equal_fst_operand)
    );

    Mux2            #32         Forward_sec_operand_from_ID 
    (
        .d0(read_data2_reg_ID), .d1(ALU_result_MEM), 
        .sel(Forward_sec_operand_ID), 
        .y(is_equal_sec_operand)
    );
    
    Is_Equal        #32         ie 
    (
        .a(is_equal_fst_operand), .b(is_equal_sec_operand), .y(Equal_ID)
    );

    Flop_rc         #5          Rs_ID_reg 
    (
        .clk(clk), .rst(rst), .clear(~flush_EX), 
        .din(Rs_ID), .dout(Rs_EX)
    );

    Flop_rc         #5          Rt_ID_reg 
    (
        .clk(clk), .rst(rst), .clear(~flush_EX), 
        .din(Rt_ID), .dout(Rt_EX)
    );

    Flop_rc         #5          Rd_ID_reg 
    (
        .clk(clk), .rst(rst), .clear(~flush_EX), 
        .din(Rd_ID), .dout(Rd_EX)
    );

    Flop_rc         #32         read_data1_reg_ID_reg 
    (
        .clk(clk), .rst(rst), .clear(~flush_EX), 
        .din(read_data1_reg_ID), .dout(read_data1_reg_EX)
    );

    Flop_rc         #32         read_data2_reg_ID_reg 
    (
        .clk(clk), .rst(rst), .clear(~flush_EX), 
        .din(read_data2_reg_ID), .dout(read_data2_reg_EX)
    );

    Flop_rc         #32         se_const_ID_reg 
    (
        .clk(clk), .rst(rst), .clear(~flush_EX), 
        .din(se_const_ID), .dout(se_const_EX)
    );


    /*
        EX �׶��ź�������
            // д�Ĵ�����
            write_reg_EX                        д�Ĵ�����

            // ALU ���������
            ALU_fst_operand                     ALU ��һ������
            temp_operand                        ȷ�� ALU �ڶ����������м���
            ALU_sec_operand                     ALU �ڶ�������
            ALU_result_EX                       ALU ������

            // д�ڴ�����
            write_data_memory_from_reg_EX       �� Rt ������Ҫд���ڴ������
            
            // ��ˮ
            write_reg_MEM
            write_data_memory_from_reg_MEM
            Rt_MEM
    */

    // д�Ĵ�����
    wire        [4:0]       write_reg_EX;

    // ALU ���������
    wire        [31:0]      ALU_fst_operand;
    wire        [31:0]      temp_operand;
    wire        [31:0]      ALU_sec_operand;
    wire        [31:0]      ALU_result_EX;

    // д�ڴ�����
    wire        [31:0]      write_data_memory_from_reg_EX;

    // EX/MEM ����ˮ
    wire        [4:0]       write_reg_MEM;
    wire        [31:0]      write_data_memory_from_reg_MEM;
    wire        [4:0]       Rt_MEM;

    assign write_data_memory_from_reg_EX = read_data2_reg_EX;

    Mux2        #5          write_reg_from 
    (
        .d0(Rt_EX), .d1(Rd_EX), 
        .sel(RegDst_EX), 
        .y(write_reg_EX)
    );
    
    Mux3        #32         Forward_fst_operand_from_EX 
    (
        .d0(read_data1_reg_EX), .d1(write_data_reg_WB), .d2(ALU_result_MEM), 
        .sel(Forward_fst_operand_EX), 
        .y(ALU_fst_operand)
    );

    Mux3        #32         Forward_sec_operand_from_EX 
    (
        .d0(read_data2_reg_EX), .d1(write_data_reg_WB), .d2(ALU_result_MEM), 
        .sel(Forward_sec_operand_EX), 
        .y(temp_operand)
    );

    Mux2        #32         second_operand_from 
    (
        .d0(temp_operand), .d1(se_const_EX), 
        .sel(ALUSrc_EX), 
        .y(ALU_sec_operand)
    );

    ALU                     alu 
    (
        .a(ALU_fst_operand), .b(ALU_sec_operand), 
        .op(ALUControl_EX), 
        .y(ALU_result_EX)
    );

    Flop_r      #32         ALU_result_EX_reg 
    (
        .clk(clk), .rst(rst), 
        .din(ALU_result_EX), .dout(ALU_result_MEM)
    );

    Flop_r      #5          write_reg_EX_reg 
    (
        .clk(clk), .rst(rst), 
        .din(write_reg_EX), .dout(write_reg_MEM)
    );

    Flop_r      #32         write_data_memory_from_reg_EX_reg 
    (
        .clk(clk), .rst(rst), 
        .din(write_data_memory_from_reg_EX), .dout(write_data_memory_from_reg_MEM)
    );

    Flop_r      #5          Rt_EX_reg 
    (
        .clk(clk), .rst(rst), 
        .din(Rt_EX), .dout(Rt_MEM)
    );


    /*
        MEM �׶��ź�������
            // ��ˮ
            ALU_result_WB
            read_data_memory_WB
    */

    // MEM/WB ����ˮ
    wire        [31:0]      ALU_result_WB;
    wire        [31:0]      read_data_memory_WB;

    Mux2        #32         write_data_memory_from 
    (
        .d0(write_data_memory_from_reg_MEM), .d1(write_data_reg_WB), 
        .sel(Forward_write_data_memory_MEM), 
        .y(write_data_memory_MEM)
    );

    Flop_r      #32         ALU_result_MEM_reg 
    (
        .clk(clk), .rst(rst), 
        .din(ALU_result_MEM), .dout(ALU_result_WB)
    );

    Flop_r      #32         read_data_memory_MEM_reg 
    (
        .clk(clk), .rst(rst), 
        .din(read_data_memory_MEM), .dout(read_data_memory_WB)
    );

    Flop_r      #5          write_reg_MEM_reg 
    (
        .clk(clk), .rst(rst), 
        .din(write_reg_MEM), .dout(write_reg_WB)
    );


    // WB �׶�
    Mux2        #32         write_data_reg_from 
    (
        .d0(ALU_result_WB), .d1(read_data_memory_WB), 
        .sel(MemtoReg_WB), 
        .y(write_data_reg_WB)
    );


    // ð�ռ�⼰����
    Hazard                  hzd 
    (
        // IF �׶�
        .stall_IF(stall_IF),

        // ID �׶�
        .stall_ID(stall_ID), 
        .Rs_ID(Rs_ID), .Rt_ID(Rt_ID), 
        .Branch_ID(Branch_ID),
        .Forward_fst_operand_ID(Forward_fst_operand_ID), .Forward_sec_operand_ID(Forward_sec_operand_ID),

        // EX �׶�
        .flush_EX(flush_EX), 
        .Rs_EX(Rs_EX), .Rt_EX(Rt_EX), 
        .write_reg_EX(write_reg_EX), 
        .RegWrite_EX(RegWrite_EX), .MemtoReg_EX(MemtoReg_EX),
        .Forward_fst_operand_EX(Forward_fst_operand_EX), .Forward_sec_operand_EX(Forward_sec_operand_EX),

        // MEM �׶�
        .Rt_MEM(Rt_MEM), 
        .write_reg_MEM(write_reg_MEM), 
        .RegWrite_MEM(RegWrite_MEM), .MemtoReg_MEM(MemtoReg_MEM), .MemWrite_MEM(MemWrite_MEM), 
        .Forward_write_data_memory_MEM(Forward_write_data_memory_MEM), 
        
        // WB �׶�
        .write_reg_WB(write_reg_WB), 
        .RegWrite_WB(RegWrite_WB)
    );

endmodule