`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/02 15:47:13
// Design Name: 
// Module Name: Digital_Tube
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

//七段数码管显示模块
module Digital_Tube(
    input clk,
    input rst,
    input signed [31:0] display,
    output reg [7:0] an,
    output reg [6:0] seg
    );
    
    reg [20:0] cnt_dt;  //高三位用于分频
    
    always @ (posedge clk or negedge rst) begin
        if(!rst) begin
            cnt_dt <= 0;
        end
        else begin
            cnt_dt <= cnt_dt + 1'b1;
        end
    end
    
    
    reg [3:0] sel;  //选择输出
    
    always @ (*) begin
        if(!rst) begin
            an = 8'b1111_1111;
        end
        else begin
            case(cnt_dt[20:18])
                3'b000: begin an = 8'b0111_1111; sel = display[31:28]; end
                3'b001: begin an = 8'b1011_1111; sel = display[27:24]; end
                3'b010: begin an = 8'b1101_1111; sel = display[23:20]; end
                3'b011: begin an = 8'b1110_1111; sel = display[19:16]; end
                3'b100: begin an = 8'b1111_0111; sel = display[15:12]; end
                3'b101: begin an = 8'b1111_1011; sel = display[11:8]; end
                3'b110: begin an = 8'b1111_1101; sel = display[7:4]; end
                3'b111: begin an = 8'b1111_1110; sel = display[3:0]; end
            endcase
            
            case(sel)
                4'h0: seg = 7'b0000001;
                4'h1: seg = 7'b1001111;
                4'h2: seg = 7'b0010010;
                4'h3: seg = 7'b0000110;
                4'h4: seg = 7'b1001100;
                4'h5: seg = 7'b0100100;
                4'h6: seg = 7'b0100000;
                4'h7: seg = 7'b0001111;
                4'h8: seg = 7'b0000000;
                4'h9: seg = 7'b0001100;
                4'ha: seg = 7'b0001000;
                4'hb: seg = 7'b1100000;
                4'hc: seg = 7'b1110010;
                4'hd: seg = 7'b1000010;
                4'he: seg = 7'b0110000;
                4'hf: seg = 7'b0111000;
                default:seg = 7'b1111111;
            endcase
        end
        
    end
endmodule
