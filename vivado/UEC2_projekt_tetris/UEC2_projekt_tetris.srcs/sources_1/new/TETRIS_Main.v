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
  input wire PS2Data,
  input wire PS2Clk,
  input wire clk,
  input wire btnC,
  
  output reg Vsync,
  output reg Hsync,
  
  output reg [3:0] vgaRed,
  output reg [3:0] vgaGreen,
  output reg [3:0] vgaBlue
  );

wire clk50MHz, clk65MHz, clk1Hz, clk05Hz, clk_rand;
wire [10:0] vcount;
wire [10:0] hcount;
wire vsync, hsync;
wire vblnk, hblnk;
wire locked;

IP_CLK_DIVIDER CLK_GENERATOR 
 (
    .pclk(clk),
    .reset(btnC),
 
    .locked(locked),
    .clk50MHz(clk50MHz),
    .clk65MHz(clk65MHz),
    .clk_rand(clk_rand)
 );

vga_timing vga_timing_source
(
  .pclk(clk65MHz),
  .reset(btnC),

  .vcount(vcount),
  .vsync(vsync),
  .vblnk(vblnk),
  .hcount(hcount),
  .hsync(hsync),
  .hblnk(hblnk)
  );

wire [3:0] Green_Out, Red_Out, Blue_Out;
wire [10:0] vcount_frame;
wire [10:0] hcount_frame;
wire vsync_frame, hsync_frame;
wire vblnk_frame, hblnk_frame;
wire [15:0] keycode;
wire KeyFlag;

GAME_FRAME FRAME_VIDEO_CONTROLL(
   .clk(clk65MHz),
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
    
PS2Receiver Keyboard_Receiver(
        .clk(clk50MHz),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        
        .keycode(keycode),
        .oflag(KeyFlag)
        );

clk1Hz clk1HZ_generator(
    .clk50MHz(clk50MHz),
    .reset(btnC),
    
    .clk1Hz(clk1Hz),
    .clk05Hz(clk05Hz)
    );
    
wire [2:0] random_block;    
    
falserandom_generator random_blocks(
        .clkrand(clk_rand),
        .reset(btnC),
        
        .rand(random_block)
        );
    

always @(posedge clk65MHz)begin
   Vsync<=vsync_frame;
   Hsync<=hsync_frame;
 
   vgaRed <= Red_Out;
   vgaGreen <= Green_Out;
   vgaBlue <= Blue_Out;
end

endmodule