`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2020 09:09:47 PM
// Design Name: 
// Module Name: game_logic_unit
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


module game_logic_unit(
    input wire pclk,
    input wire reset,
    input wire random,
    input wire clk1Hz,
    input wire clk05Hz,
    input wire [3:0] VGARed,
    input wire [3:0] VGAGreen,
    input wire [3:0] VGABlue,
    input wire hsync,
    input wire vsync,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire [15:0] keycode,
    input wire oflag,
    
    output reg [3:0] VGARed_out,
    output reg [3:0] VGAGreen_out,
    output reg [3:0] VGABlue_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [3:0] xpos,
    output reg [3:0] ypos,
    output reg [3:0] block_code,
    output reg [1:0] block_orient,
    output reg [10:0] hcount_out,
    output reg [10:0] vcount_out
    );

reg [3:0] state = 0;

localparam TITLESCREEN=0,
           IDLE=1,
           MOV_LEFT=2,
           MOV_RIGHT=3,
           ROT_LEFT=4,
           ROT_RIGHT=5,
           FALL_SLOW=6,
           FALL_FAST=7,
           GAME_OVER=8;
    
endmodule
