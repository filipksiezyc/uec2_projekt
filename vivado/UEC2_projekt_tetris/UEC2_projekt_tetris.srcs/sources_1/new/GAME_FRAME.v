`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2020 02:23:40 PM
// Design Name: 
// Module Name: GAME_FRAME
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


module GAME_FRAME(
    input wire clk,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire reset,
    
    output reg [3:0] VGARed,
    output reg [3:0] VGAGreen,
    output reg [3:0] VGABlue,
    output reg [10:0] hcount_out,
    output reg [10:0] vcount_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out
    );

reg [3:0] VGARed_nxt=0, VGAGreen_nxt=0, VGABlue_nxt=0;

always @* begin
    if(reset) begin
        VGARed_nxt = 0;
        VGAGreen_nxt = 0;
        VGAGreen_nxt = 0;
        end
    else begin
        if((hblnk||vblnk)||((vcount>63)&&(hcount>63)&&(hcount<959)))begin
            VGARed_nxt = 0;
            VGAGreen_nxt = 0;
            VGAGreen_nxt = 0;
            end
        else begin
            if(((hcount>=0)&&(hcount<64)) || ((hcount>959)&&(hcount<1024))||((vcount>=0)&&(vcount<64)))begin
                VGARed_nxt = 3'h8;
                VGAGreen_nxt = 3'h8;
                VGAGreen_nxt = 3'h8;
                end
            end
        end
end

always @(posedge clk)begin
        VGARed <= VGARed_nxt;
        VGAGreen <= VGAGreen_nxt ;
        VGABlue <= VGABlue_nxt;
        hcount_out <= hcount;
        vcount_out <= vcount;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
end

endmodule
