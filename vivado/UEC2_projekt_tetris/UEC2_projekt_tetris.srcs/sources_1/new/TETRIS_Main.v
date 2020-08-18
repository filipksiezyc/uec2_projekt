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

  always @(posedge clk)
  begin
    // Just pass these through.
    Hsync <= hsync;
    Vsync <= vsync;
    // During blanking, make it it black.
    if (vblnk || hblnk) {vgaRed,vgaGreen,vgaBlue} <= 12'h0_0_0; 
    else
    begin
      // Active display, top edge, make a yellow line.
      if (vcount == 0) {vgaRed,vgaGreen,vgaBlue} <= 12'hf_f_0;
      // Active display, bottom edge, make a red line.
      else if (vcount == 767) {vgaRed,vgaGreen,vgaBlue} <= 12'hf_0_0;
      // Active display, left edge, make a green line.
      else if (hcount == 0) {vgaRed,vgaGreen,vgaBlue} <= 12'h0_f_0;
      // Active display, right edge, make a blue line.
      else if (hcount == 1023) {vgaRed,vgaGreen,vgaBlue} <= 12'h0_0_f;
      // Active display, interior, fill with gray.
      // You will replace this with your own test.
      else {vgaRed,vgaGreen,vgaBlue} <= 12'h8_8_8;    
    end
  end



endmodule