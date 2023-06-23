`timescale 1ns / 1ps

module Datapath(
    /*
        模块名称：Datapath
        模块功能：流水线 MIPS 处理器的数据通路
        输入端口：
            clk                         时钟信号
            rst                         复位信号。1-正常工作，0-复位

            // 内存的输出
            inst_IF                     Instruction Memory 的输出：从内存中读出的指令
            read_data_memory_MEM        Data Memory 的输出：从内存中读出的数据
            
            // ID 阶段需要的控制信号
            PCSrc_ID                    Controller 的输出：选择下一条指令地址。0-PC 自增，1-Branch 跳转目标地址
            Jump_ID                     Controller 的输出：选择下一条指令地址。0-上面的结果，1-Jump 跳转目标地址

            // EX 阶段需要的控制信号
            RegDst_EX,                  Controller 的输出：选择写寄存器号的来源。0-Rt_EX，1-Rd_EX
            ALUSrc_EX,                  Controller 的输出：选择 ALU 第二操作数的来源。0-寄存器堆，1-立即数
            ALUControl_EX,              Controller 的输出：ALU 的选择信号

            // WB 阶段需要的控制信号
            MemtoReg_WB,                Controller 的输出：选择写入寄存器堆的数据来源。0-ALU，1-内存
            RegWrite_WB                 Controller 的输出：寄存器堆的写控制信号

            // 用于解决冒险的控制信号
            Branch_ID
            RegWrite_EX,
            MemtoReg_EX,
            MemtoReg_MEM,
            RegWrite_MEM,

        输出端口：
            curr_inst_addr              Instruction Memory 的输入：PC 地址
            inst_en                     Instruction Memory 的输入：PC 地址是否有效

            inst_ID                     Controller 的输入：当前执行的指令
            Equal_ID                    Controller 的输入：两数相等时置 1，用于确定 PCSrc
            flush_EX                    Controller 的输入：ID/EX 级流水冲刷信号

            ALU_result_MEM              Data Memory 的输入：ALU 的运算结果，即内存地址
            write_data_memory_MEM       Data Memory 的输入：写入内存的数据
            MemWrite_MEM                Data Memory 的输入：写控制信号
            MemRead_MEM                 Data Memory 的输入：读控制信号
    */

	input                   clk,
    input                   rst,

    // 内存的输出
    input       [31:0]      inst_IF,
    input       [31:0]      read_data_memory_MEM,

    // ID 阶段需要的控制信号
    input                   PCSrc_ID,
    input                   Jump_ID,

    // EX 阶段需要的控制信号
    input                   RegDst_EX,
	input                   ALUSrc_EX,
    input       [2:0]       ALUControl_EX,

    // WB 阶段需要的控制信号
	input                   MemtoReg_WB,
	input                   RegWrite_WB,

    // 用于解决冒险的控制信号
    input                   Branch_ID, 
    input                   MemtoReg_EX,
    input                   RegWrite_EX,
    input                   MemtoReg_MEM,
    input                   RegWrite_MEM,

    // Instruction Memory 的输入
    output      [31:0]      curr_inst_addr,
    output                  inst_en,

    // Controller 的输入
    output      [31:0]      inst_ID,
    output                  Equal_ID,
    output                  flush_EX,

    // Data Memory 的输入
    output      [31:0]      ALU_result_MEM,
	output      [31:0]      write_data_memory_MEM,
    output                  MemWrite_MEM,
    output                  MemRead_MEM
    );


    /*
        冒险相关控制信号声明：
            stall_IF                            PC 阻塞信号
            stall_ID                            IF/ID 级流水阻塞信号
            Forward_fst_operand_EX              控制 ALU 第一操作数来源的选择器的 sel 信号
            Forward_sec_operand_EX              控制 ALU 第二操作数来源的选择器的 sel 信号
            Forward_fst_operand_ID              控制 Is_Equal 第一操作数来源的选择器的 sel 信号
            Forward_sec_operand_ID              控制 Is_Equal 第二操作数来源的选择器的 sel 信号
            Forward_write_data_memory_MEM       控制写内存数据来源的选择器的 sel 信号
    */

    // 流水阻塞信号
    wire                    stall_IF;
    wire                    stall_ID;

    // 解决 ALU 数据冒险的控制信号
    wire        [1:0]       Forward_fst_operand_EX;
    wire        [1:0]       Forward_sec_operand_EX;

    // 解决 Is_Equal 数据冒险的控制信号
    wire                    Forward_fst_operand_ID;
    wire                    Forward_sec_operand_ID;

    // 解决写内存数据冒险的控制信号
    wire                    Forward_write_data_memory_MEM;


    /*
        IF 阶段信号声明：
            // PC 及其自增
            next_inst_addr          PC 的输入：下一条执行指令的地址
            PC_incre_addr_IF        PC 自增地址

            // 流水
            PC_incre_addr_ID        
    */

    // PC 及其自增
    wire        [31:0]      next_inst_addr;
    wire        [31:0]      PC_incre_addr_IF;

    // IF/ID 级流水
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
        ID 阶段信号声明：
            // 指令解码
            Rs_ID                       
            Rt_ID                       
            Rd_ID                       

            // 寄存器堆的输入输出
            write_reg_WB                写寄存器号
            write_data_reg_WB           写入寄存器堆的数据
            read_data1_reg_ID           从 Rs 读出的数据
            read_data2_reg_ID           从 Rt 读出的数据

            // 符号扩展
            se_const_ID                 符号扩展后的立即数

            // 分支跳转
            relative_branch_addr        Branch 指令的相对字地址
            branch_addr                 Branch 指令的目标跳转地址
            temp_addr                   PC_incre_addr_ID 或 branch_addr
            jump_addr                   Jump 指令的目标跳转地址

            // 判断两数是否相等
            is_equal_fst_operand        第一操作数
            is_equal_sec_operand        第二操作数

            // 流水
            Rs_EX
            Rt_EX
            Rd_EX
            read_data1_reg_EX
            read_data2_reg_EX
            se_const_EX
    */
    
    // 指令解码
    wire        [4:0]       Rs_ID;
    wire        [4:0]       Rt_ID;
    wire        [4:0]       Rd_ID;

    // 寄存器堆的输入输出
    wire        [4:0]       write_reg_WB;
    wire        [31:0]      write_data_reg_WB;
    wire        [31:0]      read_data1_reg_ID;
    wire        [31:0]      read_data2_reg_ID;

    // 符号扩展
    wire        [31:0]      se_const_ID;

    // 分支跳转
    wire        [31:0]      relative_branch_addr;
    wire        [31:0]      branch_addr;
    wire        [31:0]      temp_addr;
    wire        [31:0]      jump_addr;

    // 判断两数是否相等
    wire        [31:0]      is_equal_fst_operand;
    wire        [31:0]      is_equal_sec_operand;

    // ID/EX 级流水
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
        .a(PC_incre_addr_ID - 32'h4), .b(relative_branch_addr), .c(branch_addr)  // -4 是为了对冲掉开头的影响
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
        EX 阶段信号声明：
            // 写寄存器号
            write_reg_EX                        写寄存器号

            // ALU 的输入输出
            ALU_fst_operand                     ALU 第一操作数
            temp_operand                        确定 ALU 第二操作数的中间结果
            ALU_sec_operand                     ALU 第二操作数
            ALU_result_EX                       ALU 运算结果

            // 写内存数据
            write_data_memory_from_reg_EX       从 Rt 读出的要写入内存的数据
            
            // 流水
            write_reg_MEM
            write_data_memory_from_reg_MEM
            Rt_MEM
    */

    // 写寄存器号
    wire        [4:0]       write_reg_EX;

    // ALU 的输入输出
    wire        [31:0]      ALU_fst_operand;
    wire        [31:0]      temp_operand;
    wire        [31:0]      ALU_sec_operand;
    wire        [31:0]      ALU_result_EX;

    // 写内存数据
    wire        [31:0]      write_data_memory_from_reg_EX;

    // EX/MEM 级流水
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
        MEM 阶段信号声明：
            // 流水
            ALU_result_WB
            read_data_memory_WB
    */

    // MEM/WB 级流水
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


    // WB 阶段
    Mux2        #32         write_data_reg_from 
    (
        .d0(ALU_result_WB), .d1(read_data_memory_WB), 
        .sel(MemtoReg_WB), 
        .y(write_data_reg_WB)
    );


    // 冒险检测及处理
    Hazard                  hzd 
    (
        // IF 阶段
        .stall_IF(stall_IF),

        // ID 阶段
        .stall_ID(stall_ID), 
        .Rs_ID(Rs_ID), .Rt_ID(Rt_ID), 
        .Branch_ID(Branch_ID),
        .Forward_fst_operand_ID(Forward_fst_operand_ID), .Forward_sec_operand_ID(Forward_sec_operand_ID),

        // EX 阶段
        .flush_EX(flush_EX), 
        .Rs_EX(Rs_EX), .Rt_EX(Rt_EX), 
        .write_reg_EX(write_reg_EX), 
        .RegWrite_EX(RegWrite_EX), .MemtoReg_EX(MemtoReg_EX),
        .Forward_fst_operand_EX(Forward_fst_operand_EX), .Forward_sec_operand_EX(Forward_sec_operand_EX),

        // MEM 阶段
        .Rt_MEM(Rt_MEM), 
        .write_reg_MEM(write_reg_MEM), 
        .RegWrite_MEM(RegWrite_MEM), .MemtoReg_MEM(MemtoReg_MEM), .MemWrite_MEM(MemWrite_MEM), 
        .Forward_write_data_memory_MEM(Forward_write_data_memory_MEM), 
        
        // WB 阶段
        .write_reg_WB(write_reg_WB), 
        .RegWrite_WB(RegWrite_WB)
    );

endmodule