`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2020 08:58:23 PM
// Design Name: 
// Module Name: vga_timing
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


module vga_timing(
    input wire clk,
    input wire reset,
    
    output reg [10:0] hcount,
    output reg [10:0] vcount,
    output reg hsync,
    output reg vsync,
    output reg hblnk,
    output reg vblnk
    );

reg [10:0] hcount_nxt=0, vcount_nxt=0;
reg hsync_nxt=0, vsync_nxt=0, hblnk_nxt=0, vblnk_nxt=0;
    
//PIXEL COUNTER
always @* begin
    if(reset) begin
        hcount_nxt = 0;
        vcount_nxt =0;
        hsync_nxt = 0;
        hblnk_nxt = 0;
        vsync_nxt = 0;
        vblnk_nxt = 0;
        end
    else begin
        if(hcount_nxt == 1344) begin
            hcount_nxt = 0; 
            if(vcount_nxt == 806) begin
                vcount_nxt = 0;
                end
            else begin
                vcount_nxt = vcount_nxt + 1;
                end
            end
        else begin       
            hcount_nxt = hcount_nxt + 1;
            end 
    end
        if(hcount>1023)begin
                hblnk_nxt = 1;
                if((hcount>1047)&&(hcount<1185))begin
                    hsync_nxt = 1;
                    end
                else begin
                    hsync_nxt = 0;
                    end
                end
            else begin
                hblnk_nxt = 0;
                end 
            if(vcount>767)begin
                        vblnk_nxt = 1;
                        if((vcount>770)&&(hcount<777))begin
                            vsync_nxt = 1;
                            end
                        else begin
                            vsync_nxt = 0;
                            end
                        end
                    else begin
                        vblnk_nxt = 0;
                        end 
end



    
always @(posedge clk) begin
        vcount <= vcount_nxt;
        hcount <= hcount_nxt;
        hblnk <= hblnk_nxt;
        vblnk <= vblnk_nxt;
        hsync <= hsync_nxt;
        vsync <= vsync_nxt;
end     
    
endmodule
