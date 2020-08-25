`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2020 08:49:57 PM
// Design Name: 
// Module Name: ingame_graphic
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


module ingame_graphic(
    input wire pclk,
    input wire reset,
    input wire [3:0] VGARed,
    input wire [3:0] VGABlue,
    input wire [3:0] VGAGreen,
    input wire hsync,
    input wire vsync,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire [3:0] xpos,
    input wire [3:0] ypos,
    input wire [3:0] block_code,
    input wire [1:0] block_orient,
    
    output reg [3:0] VGARed_out,
    output reg [3:0] VGABlue_out,
    output reg [3:0] VGAGreen_out,
    output reg hsync_out,
    output reg vsync_out 
    );
    
reg [3:0] VGARed_nxt=0, VGAGreen_nxt=0,VGABlue_nxt=0;
reg hsync_nxt=0, vsync_nxt=0;
    
always @* begin
    case(block_code)
        0: if(block_orient==0)begin
                if((hcount>300&&hcount<600)&&(vcount>300&&vcount<600))begin
                    VGARed_nxt=4'b1001;
                    VGABlue_nxt=4'b0010;
                    VGAGreen_nxt=4'b0011;
                    end
                 else begin
                    VGARed_nxt = VGARed;
                    VGABlue_nxt = VGAGreen;
                    VGAGreen_nxt = VGABlue;
                    end
                 end
            else begin
                    VGARed_nxt = VGARed;   
                    VGABlue_nxt = VGAGreen;
                    VGAGreen_nxt = VGABlue;
                    end
    default : begin
           VGARed_nxt = VGARed;   
           VGABlue_nxt = VGAGreen;
           VGAGreen_nxt = VGABlue;
           end
   endcase
end  
    
endmodule
