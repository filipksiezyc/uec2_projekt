`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH University of Science and Technology
// Engineer: Filip Ksiê¿yc & Justyna Rudnicka
// 
// Create Date: 08/16/2020 11:33:57 PM
// Design Name: 
// Module Name: TETRIS_Main
// Project Name: TETRIS for BASYS3 designed in Verilog 
// Target Devices: Basys3
// Tool Versions: VIVADO 2017.3
// Description: This module is top module of TETRIS for BASYS3 project.  
// Input signals are: UART reciever (rx), reset button (btnC) and BASYS3 clock signal (100MHz) 
// Output signals are: UART transmiter, VGA connector outputs(horizontal and vertical synchronisation signals 
// and RGB wires) and 7 SEG outputs.
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
    .reset(1'b0),
 
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
wire hsync_char, vsync_char, vblnk_char, hblnk_char;
wire [10:0] vcount_char, hcount_char;

draw_rect_char 
#(
    .X_POSITION(700),
    .Y_POSITION(123),
    .X_WIDITH(128),
    .Y_WIDITH(256)
    )
game_instruction(
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
    
    .hcount_out(hcount_char),
    .vcount_out(vcount_char),
    .vblnk_out(vblnk_char),
    .hblnk_out(hblnk_char),
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


wire [3:0] red_out, green_out, blue_out;
wire [3:0] char_line_2;
wire [6:0] char_code_2;
wire [7:0] char_pixels_2,char_xy_2;
wire hsync_out, vsync_out, vblnk_out, hblnk_out;
wire [10:0] vcount_out, hcount_out;


draw_rect_char 
#(
    .X_POSITION(700),
    .Y_POSITION(405),
    .X_WIDITH(128),
    .Y_WIDITH(256)
    )
game_movement(
    .hcount_in(hcount_char),
    .vcount_in(vcount_char),
    .vblnk_in(vblnk_char),
    .hblnk_in(hblnk_char),
    .hsync_in(hsync_char),
    .vsync_in(vsync_char),
    .red_in(red_font),
    .green_in(green_font),
    .blue_in(blue_font),
    .clk(clk65MHz),
    .char_pixels(char_pixels_2),
    .rst(btnC),
    
    .hcount_out(hcount_out),
    .vcount_out(vcount_out),
    .vblnk_out(vblnk_out),
    .hblnk_out(hblnk_out),
    .red_out(red_out),
    .green_out(green_out),
    .blue_out(blue_out),
    .hsync_out(hsync_out),
    .vsync_out(vsync_out),
    .char_xy(char_xy_2),
    .char_line(char_line_2)
);

char_rom_16x16_move char_gen_move(
    .clk(clk65MHz),
    .char_xy(char_xy_2),

    .char_code(char_code_2)
);

font_rom font_gen_move(
    .clk(clk65MHz),
    .addr({char_code_2,char_line_2}),

    .char_line_pixels(char_pixels_2)
);


always @(posedge clk65MHz)begin
   Vsync<=vsync_out;
   Hsync<=hsync_out;
 
   vgaRed <= red_out;
   vgaGreen <= green_out;
   vgaBlue <= blue_out;
   seg<=seg_wire;
   an<=an_wire;
end


endmodule