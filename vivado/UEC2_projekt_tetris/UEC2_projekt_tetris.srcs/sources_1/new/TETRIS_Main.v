`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2020 11:33:57 PM
// Design Name: 
// Module Name: TETRIS_Main
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


module TETRIS_Main (
  
  input wire clk,
  input wire btnC,
  
  output reg Vsync,
  output reg Hsync,
  
  output reg [3:0] vgaRed,
  output reg [3:0] vgaGreen,
  output reg [3:0] vgaBlue
  );

wire clk100MHz, clk65MHz;
wire [10:0] vcount=0;
wire [10:0] hcount=0;
wire vsync=0, hsync=0;
wire vblnk=0, hblnk=0;
wire locked;


IP_clk_generator CLK_divider
 (
  .reset(btnC),
  .pclk(clk),
  
  .locked(locked),
  .clk100MHz(clk100MHz),
  .clk65MHz(clk65MHz)
 );

vga_timing vga_timing_source
(
  .clk(clk65MHz),
  .reset(btnC),

  .vcount(vcount),
  .vsync(vsync),
  .vblnk(vblnk),
  .hcount(hcount),
  .hsync(hsync),
  .hblnk(hblnk)
  );

wire [3:0] Green_Out=0, Red_Out=0, Blue_Out=0;
wire [10:0] vcount_frame=0;
wire [10:0] hcount_frame=0;
wire vsync_frame=0, hsync_frame=0;
wire vblnk_frame=0, hblnk_frame=0;

GAME_FRAME FRAME_VIDEO_CONTROLL(
   .clk(clk),
   .hcount(hcount),
   .vcount(vcount),
   .hsync(hsync),
   .vsync(vsync),
   .hblnk(hblnk),
   .vblnk(vblnk),
   .reset(btnC),
   
   .VGARed(Red_Out),
   .VGAGreen(Green_Out),
   .VGABlue(Blue_Out),
   .hcount_out(hcount_frame),
   .vcount_out(vcount_frame),
   .hsync_out(hsync_frame),
   .vsync_out(vsync_frame),
   .hblnk_out(hblnk_frame),
   .vblnk_out(vblnk_frame)
    );

always @(posedge clk)begin
   Vsync<=vsync_frame;
   Hsync<=hsync_frame;
 
   vgaRed<=Red_Out;
   vgaGreen<=Green_Out;
   vgaBlue<=Blue_Out;
end

endmodule