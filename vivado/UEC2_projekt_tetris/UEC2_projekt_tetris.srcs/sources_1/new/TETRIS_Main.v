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
  
  input wire rx,
  output wire tx,
  
  output reg Vsync,
  output reg Hsync,
  
  output reg [3:0] vgaRed,
  output reg [3:0] vgaGreen,
  output reg [3:0] vgaBlue,
  output reg [6:0] seg,
  output reg [3:0] an
  );

wire clk65MHz, clk_rand;
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

wire [3:0] Green_to_main, Red_to_main, Blue_to_main;
wire [10:0] vcount_to_main;
wire [10:0] hcount_to_main;
wire vsync_to_main, hsync_to_main;
wire vblnk_to_main, hblnk_to_main;

wire [3:0] Green_Out, Red_Out, Blue_Out;
wire [10:0] vcount_frame;
wire [10:0] hcount_frame;
wire vsync_frame, hsync_frame;
wire vblnk_frame, hblnk_frame;
wire [3:0] state_fr;

GAME_FRAME FRAME_VIDEO_CONTROLL(
   .clk(clk65MHz),
   .hcount(hcount_to_main),
   .vcount(vcount_to_main),
   .hsync(hsync_to_main),
   .vsync(vsync_to_main),
   .hblnk(hblnk_to_main),
   .vblnk(vblnk_to_main),
   .reset(btnC),
   .VGARed(Red_to_main),
   .VGAGreen(Green_to_main),
   .VGABlue(Blue_to_main),
   .state(state_fr),
   
   .VGARed_out(Red_Out),
   .VGAGreen_out(Green_Out),
   .VGABlue_out(Blue_Out),
   .hcount_out(hcount_frame),
   .vcount_out(vcount_frame),
   .hsync_out(hsync_frame),
   .vsync_out(vsync_frame),
   .hblnk_out(hblnk_frame),
   .vblnk_out(vblnk_frame)
    );

    
wire [2:0] random_block;    
    
falserandom_generator random_blocks(
        .clkrand(clk_rand),
        .reset(btnC),
        
        .rand(random_block)
        );

wire [7:0] r_data, keycode, code;
wire rx_empty;

uart uart(
    .clk(clk65MHz),
    .reset(btnC),
    .rx(rx),
    .tx(tx),
    .r_data(r_data),
    .code(code),
    .rx_empty(rx_empty)
);

uart_debouncer uart_debouncer(
    .clk(clk65MHz),
    .r_data(r_data),
    .rx_empty(rx_empty),
    .key_out(keycode)
);

wire [4:0] score1_seg, score2_seg, score3_seg, score4_seg;
wire [6:0] seg_wire;
wire [3:0] an_wire;
 
game_logic_unit tetris_logic(
    .pclk(clk65MHz),
    .reset(btnC),
    .random(random_block),
    .hsync(hsync),
    .vsync(vsync),
    .hblnk(hblnk),
    .vblnk(vblnk),
    .hcount(hcount),
    .vcount(vcount),
    .keycode(keycode),

    .state_ctr(state_fr),
    .hcount_out(hcount_to_main),
    .vcount_out(vcount_to_main),
    .VGARed_out(Red_to_main),
    .VGAGreen_out(Green_to_main),
    .VGABlue_out(Blue_to_main),
    .hsync_out(hsync_to_main),
    .vsync_out(vsync_to_main),
    .hblnk_out(hblnk_to_main),
    .vblnk_out(vblnk_to_main),
    .score1(score1_seg),
    .score2(score2_seg),
    .score3(score3_seg),
    .score4(score4_seg)
);

sseg_score_disp score_manager(
    .clk(clk65MHz),
    .score1(score1_seg),//jednosci
    .score2(score2_seg),//dziesiatki
    .score3(score3_seg),//setki
    .score4(score4_seg),//tysiace
    
    .seg(seg_wire),
    .an(an_wire)
);

wire [3:0] red_font, green_font, blue_font;
wire [3:0] char_line;
wire [6:0] char_code;
wire [7:0] char_pixels,char_xy;
wire hsync_char, vsync_char;

draw_rect_char 
#(
    .X_POSITION(700),
    .Y_POSITION(223),
    .X_WIDITH(128),
    .Y_WIDITH(256)
    )
my_char(
    .hcount_in(hcount_frame),
    .vcount_in(vcount_frame),
    .vblnk_in(vblnk_frame),
    .hblnk_in(hblnk_frame),
    .hsync_in(hsync_frame),
    .vsync_in(vsync_frame),
    .red_in(Red_Out),
    .green_in(Green_Out),
    .blue_in(Blue_Out),
    .clk(clk65MHz),
    .char_pixels(char_pixels),
    .rst(btnC),
    
    .red_out(red_font),
    .green_out(green_font),
    .blue_out(blue_font),
    .hsync_out(hsync_char),
    .vsync_out(vsync_char),
    .char_xy(char_xy),
    .char_line(char_line)
);

char_rom_16x16 char_gen(
    .clk(clk65MHz),
    .char_xy(char_xy),

    .char_code(char_code)
);

font_rom font_gen(
    .clk(clk65MHz),
    .addr({char_code,char_line}),

    .char_line_pixels(char_pixels)
); 



always @(posedge clk65MHz)begin
   Vsync<=vsync_char;
   Hsync<=hsync_char;
 
   vgaRed <= red_font;
   vgaGreen <= green_font;
   vgaBlue <= blue_font;
   seg<=seg_wire;
   an<=an_wire;
end


endmodule