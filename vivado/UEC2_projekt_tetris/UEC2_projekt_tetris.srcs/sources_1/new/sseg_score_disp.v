`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2020 15:56:13
// Design Name: 
// Module Name: sseg_score_disp
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


module sseg_score_disp(
    input wire clk,
    input wire [4:0] score1,//jednosci
    input wire [4:0] score2,//dziesiatki
    input wire [4:0] score3,//setki
    input wire [4:0] score4,//tysiace
    
    output reg [6:0] seg,
    output reg [3:0] an
    
    );

reg [18:0] counter;
reg sseg_clk;

always @ (posedge clk) begin
    if (counter==130000) begin
        counter<=0;
        sseg_clk<=1;
    end
    else begin
        counter<=counter+1;
        sseg_clk<=0;
    end
end

task display_number;
    input [4:0] number;
    begin
        case (number)
            1: seg <= 7'b1111001;
            2: seg <= 7'b0100100;
            3: seg <= 7'b0110000;
            4: seg <= 7'b0011001;
            5: seg <= 7'b0010010;
            6: seg <= 7'b0000010;
            7: seg <= 7'b1111000;
            8: seg <= 7'b0000000;
            9: seg <= 7'b0010000;
            default: seg <= 7'b1000000;
        endcase
    end
endtask

reg [1:0] digit=0;

always @(posedge sseg_clk) begin
    digit<=digit+1;
    if (digit==0) begin
        an<=4'b0111;
        display_number(score4);
    end
    else if (digit==1) begin
        an<=4'b1011;
        display_number(score3);
    end
    else if (digit==2) begin
        an<=4'b1101;
        display_number(score2);
    end
    else begin
        an<=4'b1110;
        display_number(score1);
    end
end

endmodule
