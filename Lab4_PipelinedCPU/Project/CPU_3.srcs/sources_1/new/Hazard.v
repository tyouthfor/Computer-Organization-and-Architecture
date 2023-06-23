`timescale 1ns / 1ps

//*********************************************************
//                模块名称：Hazard
//                模块功能：冒险检测及处理
//*********************************************************
module Hazard(

    // IF 阶段

    // ID 阶段
    input [4:0] Rs_ID,
    input [4:0] Rt_ID,

    input Branch_ID,

    // EX 阶段
    input [4:0] Rs_EX,
    input [4:0] Rt_EX,
    input [4:0] write_reg_EX,

    input MemtoReg_EX,
    input RegWrite_EX,

    // MEM 阶段
    input [4:0] Rt_MEM,
    input [4:0] write_reg_MEM,

    input MemtoReg_MEM,
    input RegWrite_MEM,
    input MemWrite_MEM,

    // WB 阶段
    input [4:0] write_reg_WB,

    input RegWrite_WB,

    // 解决冒险的输出信号
    // 1.通过 Forwarding 解决 RAW 冒险
    output reg [1:0] Forward_fst_operand_EX,  // 控制 ALU 第一操作数来源的选择器的 sel 信号
    output reg [1:0] Forward_sec_operand_EX,  // 控制 ALU 第二操作数来源的选择器的 sel 信号

    output Forward_fst_operand_ID,  // 控制判断两数是否相等时（branch）的第一操作数来源的选择器的 sel 信号
    output Forward_sec_operand_ID,  // 控制判断两数是否相等时（branch）的第二操作数来源的选择器的 sel 信号

    output Forward_write_data_memory_MEM,  // 控制写入内存的数据来源的选择器的 sel 信号

    // 2.通过 Stall 解决 RAW 冒险
    output stall_IF,
    output stall_ID,
    output flush_EX
    );
	
    // 1.通过 Forwarding 解决 EX 阶段 ALU 操作数的 RAW 冒险
        // (1).From "ALU_result_MEM" at the end of EX stage（in MEM stage）
            // e.g 指令序列为 add，add
            // e.g 指令序列为 add，lw/sw
        // (2).From "write_data_reg_WB" at the end of MEM stage（in WB stage）
            // e.g 指令序列为 add，x，add
            // e.g 指令序列为 lw，x，add

    always @ (*) begin

        // 第一操作数
        if (Rs_EX != 0) begin

            // 读寄存器号 Rs_EX 等于写寄存器号 write_reg_MEM，且 RegWrite_MEM 信号为 1（第一种情况）
            if (Rs_EX == write_reg_MEM & RegWrite_MEM) begin
                Forward_fst_operand_EX = 2'b10;  // ALU_result_MEM
            end

            // 读寄存器号 Rs_EX 等于写寄存器号 write_reg_WB，且 RegWrite_WB 信号为 1（第二种情况）
            else if (Rs_EX == write_reg_WB & RegWrite_WB) begin
                Forward_fst_operand_EX = 2'b01;  // write_data_reg_WB
            end

            // 无冒险
            else begin
                Forward_fst_operand_EX = 2'b00;
            end
        end

        else begin
            Forward_fst_operand_EX = 2'b00;
        end

        // 第二操作数
        if (Rt_EX != 0) begin

            // 读寄存器号 Rt_EX 等于写寄存器号 write_reg_MEM，且 RegWrite_MEM 信号为 1（第一种情况）
            if (Rt_EX == write_reg_MEM & RegWrite_MEM) begin
                Forward_sec_operand_EX = 2'b10;  // ALU_result_MEM
            end

            // 读寄存器号 Rt_EX 等于写寄存器号 write_reg_WB，且 RegWrite_WB 信号为 1（第二种情况）
            else if (Rt_EX == write_reg_WB & RegWrite_WB) begin
                Forward_sec_operand_EX = 2'b01;  // write_data_reg_WB
            end

            // 无冒险
            else begin
                Forward_sec_operand_EX = 2'b00;
            end
        end

        else begin
            Forward_sec_operand_EX = 2'b00;
        end
    end


    // 2.通过 Stall 解决 EX 阶段 ALU 操作数的 RAW 冒险（在 ID 阶段检测）
        // e.g 指令序列为 lw, add
    
    // 读寄存器号 Rs_ID/Rt_ID 等于写寄存器号 Rt_EX ，且 MemtoReg_EX 信号为 1（lw）
    wire lw_stall_ID;
    assign lw_stall_ID = (Rs_ID == Rt_EX | Rt_ID == Rt_EX) & MemtoReg_EX;
    
    assign stall_IF = lw_stall_ID | branch_stall_ID;  // PC 阻塞
    assign stall_ID = stall_IF;  // IF/ID 级流水阻塞
    assign flush_EX = stall_ID;  // ID/EX 级流水冲刷


    // 3.通过 Forwarding 解决 ID 阶段判断两数是否相等时的 RAW 冒险
        // (1).From "ALU_result_MEM" at the end of EX state（in MEM stage）
            // e.g 指令序列为 add，x，beq
        // (2).没有从 WB 到 ID 的数据通路，因为本来 WB 就要写回寄存器堆的嘛
            // e.g 指令序列为 lw，x，x，beq 不会造成冒险

    // 读寄存器号 Rs_ID/Rt_ID 等于写寄存器号 write_reg_MEM，且 RegWrite_MEM 信号为 1
    assign Forward_fst_operand_ID = (Rs_ID != 0 & Rs_ID == write_reg_MEM & RegWrite_MEM);
    assign Forward_sec_operand_ID = (Rt_ID != 0 & Rt_ID == write_reg_MEM & RegWrite_MEM);


    // 4.通过 Stall 解决 ID 阶段判断两数是否相等时的 RAW 冒险（在 ID 阶段检测）
        // e.g 指令序列为 add，beq
        // e.g 指令序列为 lw，x，beq

    wire branch_stall_ID;
    assign branch_stall_ID = Branch_ID &  // Branch_ID 为 1

                            // 读寄存器号 Rs_ID/Rt_ID 等于写寄存器号 write_reg_EX，且 RegWrite_EX 信号为 1（第一种情况）
                            (RegWrite_EX & (write_reg_EX == Rs_ID | write_reg_EX == Rt_ID) |

                            // 读寄存器号 Rs_ID/Rt_ID 等于写寄存器号 write_reg_MEM，且 MemtoReg_MEM 信号为 1（第二种情况）
                            MemtoReg_MEM & (write_reg_MEM == Rs_ID | write_reg_MEM == Rt_ID));


    // 5.通过 Forwarding 解决 MEM 阶段写内存的 RAW 冒险
        // From "write_data_reg_WB" at the end of MEM stage（in WB stage）
        // e.g 指令序列为 add，sw
    
    // 写入内存的数据来源 Rt_MEM 等于写寄存器号 write_reg_WB，且 MemWrite_MEM 为 1
    assign Forward_write_data_memory_MEM = (Rt_MEM != 0 & Rt_MEM == write_reg_WB & MemWrite_MEM);

endmodule