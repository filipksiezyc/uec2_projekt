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
    input wire [2:0] random,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire [7:0] keycode,
 
    output reg [3:0] state_ctr,
    output reg [3:0] VGARed_out,
    output reg [3:0] VGAGreen_out,
    output reg [3:0] VGABlue_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg [10:0] hcount_out,
    output reg [10:0] vcount_out,
    output reg [4:0] score1,
    output reg [4:0] score2,
    output reg [4:0] score3,
    output reg [4:0] score4
    );
 
localparam TITLESCREEN=0, GAMEPLAY=1, BUFFER=2, TEST_COLLISION=3, CLEAR_ROW=4,GAME_OVER=5,

A_BUTTON=8'h61, W_BUTTON=8'h77, S_BUTTON=8'h73, D_BUTTON=8'h64,
SPACE_BUTTON=8'h20, ENTER_BUTTON=8'h0D,
 
LEFT_EDGE=2, GAME_WIDTH=16, SCREEN_WIDTH=32,GAME_HEIGHT=24, ERROR_BLOCK=11'b11111111111;

 integer i;
 integer j;
 integer k;
 integer l;
 integer m;

wire clk1Hz, clk2Hz;
reg game_reset=0, game_reset_nxt=0;

clk1Hz clk1HZ_generator(
    .clk65MHz(pclk),
    .reset(reset),
    .game_reset(game_reset),
    
    .clk1Hz(clk1Hz)
    );
    
clk2Hz clk2HZ_generator(
        .clk65MHz(pclk),
        .reset(reset),
        .game_reset(game_reset),
        
        .clk2Hz(clk2Hz)
        );
 
reg [3:0] state=TITLESCREEN; 
reg [3:0] state_nxt=TITLESCREEN;
 //entire board, divided into 32x32 pixel squares. Every "1" means there is an immovable block          
reg [((SCREEN_WIDTH*GAME_HEIGHT)-1):0] board=0, board_nxt=0;
 
reg [3:0] blk_code=0;
reg [5:0] x_pos=(LEFT_EDGE+(GAME_WIDTH/2)), y_pos=0;
reg [1:0] rotation=0;
wire [10:0] blk1, blk2, blk3, blk4;
wire [3:0] width, height;
 
//this module keeps track of the current moving piece
generate_piece current_piece(
    .pclk(pclk),
    .reset(reset),
    .block_code(blk_code),
    .xpos(x_pos),
    .ypos(y_pos),
    .rotation(rotation),
 
    .blk1(blk1),
    .blk2(blk2),
    .blk3(blk3),
    .blk4(blk4),
    .width(width),
    .height(height)
);
 

wire [10:0] vcount_nxt, hcount_nxt; 
wire [3:0] VGARed, VGAGreen, VGABlue;
wire hsync_nxt, vsync_nxt;
wire hblnk_nxt, vblnk_nxt;
 
//this module sends over data needed to display the current moving piece
//as well as the fallen pieces
ingame_graphic ingame_graphics(
    .pclk(pclk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .hblnk(hblnk),
    .vblnk(vblnk),
    .hcount(hcount),
    .vcount(vcount),
    .block1(blk1),
    .block2(blk2),
    .block3(blk3),
    .block4(blk4),
    .board(board),
    .block_code(blk_code),
 
    .VGARed_out(VGARed),
    .VGABlue_out(VGABlue),
    .VGAGreen_out(VGAGreen),
    .hsync_out(hsync_nxt),
    .vsync_out(vsync_nxt),
    .hcount_out(hcount_nxt),
    .vcount_out(vcount_nxt),
    .hblnk_out(hblnk_nxt),
    .vblnk_out(vblnk_nxt) 
);
 
 
reg [5:0] test_x_pos=(LEFT_EDGE+(GAME_WIDTH/2)), test_y_pos=0;
reg [1:0] test_rotation=0;
reg [5:0] test_x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2)), test_y_pos_nxt=0;
reg [1:0] test_rotation_nxt=0;
wire [10:0] test_blk1, test_blk2, test_blk3, test_blk4;
wire [3:0] test_width, test_height;
 
 
generate_piece test_piece(
    .pclk(pclk),
    .reset(reset),
    .block_code(blk_code),
    .xpos(test_x_pos),
    .ypos(test_y_pos),
    .rotation(test_rotation),
 
    .blk1(test_blk1),
    .blk2(test_blk2),
    .blk3(test_blk3),
    .blk4(test_blk4),
    .width(test_width),
    .height(test_height)
);
 
 //function to check if the test piece intersects with the fallen pieces
function check_if_intersects;
    input wire [10:0] block1;
    input wire [10:0] block2;
    input wire [10:0] block3;
    input wire [10:0] block4;
    begin
    check_if_intersects=(board[block1]||board[block2]||board[block3]||board[block4]);
    end    
endfunction
 
wire [5:0] row_to_check;
wire ready_to_remove;
//this module tests whether there is a row to be removed

clear_row clear_row(
    .pclk(pclk),
    .reset(reset),
    .board(board),
 
    .row(row_to_check),
    .ready(ready_to_remove)
);
 
reg [5:0] x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2)), y_pos_nxt=0;
reg [1:0] rotation_nxt=0;
reg [2:0] blk_code_nxt=0;
 
reg [5:0] row_to_clear=0;
reg [5:0] row_to_clear_nxt=0;

reg [7:0] keycode_used=0, keycode_nxt=0;
 
 
//this wire turns to 1 when current position intersects with inactive blocks
//and the moving piece is still at the top of the board
wire intersects_now=check_if_intersects(blk1,blk2,blk3,blk4); 
wire test_intersection=check_if_intersects(test_blk1,test_blk2,test_blk3,test_blk4);

 
 reg [4:0] score1_nxt=0;
 reg [4:0] score2_nxt=0;
 reg [4:0] score3_nxt=0;
 reg [4:0] score4_nxt=0;
 
always @(*) begin
     if (reset) begin
         y_pos_nxt=0;
         x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
         board_nxt=0;
         blk_code_nxt=0;
         rotation_nxt=0;
         row_to_clear_nxt=0;
         game_reset_nxt=0;
         state_nxt=TITLESCREEN;
         test_y_pos_nxt=0;
         test_x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
         test_rotation_nxt=0;
         keycode_nxt=0;
         score1_nxt=0;
         score2_nxt=0;
         score3_nxt=0;
         score4_nxt=0;
     end
     else begin
         case(state) 
             TITLESCREEN:begin
                case(keycode) 
                     ENTER_BUTTON:begin
                         board_nxt=0;
                         blk_code_nxt=(random+1);
                         x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                         y_pos_nxt=0;
                         rotation_nxt=0;
                         row_to_clear_nxt=0;
                         state_nxt=GAMEPLAY;
                         game_reset_nxt=1;
                         test_y_pos_nxt=y_pos;
                         test_x_pos_nxt=x_pos;
                         test_rotation_nxt=rotation;
                         keycode_nxt=0;
                         score1_nxt=0;
                         score2_nxt=0;
                         score3_nxt=0;
                         score4_nxt=0;
                     end
                     default: begin
                         if((y_pos==0) && intersects_now && pclk ) begin
                             blk_code_nxt=0;
                             rotation_nxt=rotation;
                             row_to_clear_nxt=row_to_clear;
                             game_reset_nxt=0;
                             for (m=0; m<=767; m=m+1) begin
                                 if (m==blk1) begin
                                     board_nxt[blk1]=1;
                                 end
                                 else if (m==blk2) begin
                                     board_nxt[blk2]=1;
                                 end
                                 else if (m==blk3) begin
                                     board_nxt[blk3]=1;
                                 end
                                 else if (m==blk4) begin
                                     board_nxt[blk4]=1;
                                 end
                                 else begin
                                     board_nxt[m]=board[m];
                                 end
                             end
                             y_pos_nxt=y_pos;
                             x_pos_nxt=x_pos;
                             state_nxt=GAME_OVER;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=0;
                             score2_nxt=0;
                             score3_nxt=0;
                             score4_nxt=0;
                         end
                         else begin
                             state_nxt=TITLESCREEN;
                             row_to_clear_nxt=row_to_clear;
                             x_pos_nxt=x_pos;
                             y_pos_nxt=y_pos;
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             board_nxt=board;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=0;
                             score2_nxt=0;
                             score3_nxt=0;
                             score4_nxt=0;
                         end
                     end
                 endcase
             end
             
             GAMEPLAY:begin
                case (keycode)
                    A_BUTTON: begin
                         y_pos_nxt=y_pos;
                         x_pos_nxt=x_pos;
                         rotation_nxt=rotation;
                         blk_code_nxt=blk_code;
                         board_nxt=board;
                         state_nxt=BUFFER;
                         row_to_clear_nxt=row_to_clear;
                         game_reset_nxt=0;
                         test_y_pos_nxt=y_pos;
                         test_x_pos_nxt=x_pos-1;
                         test_rotation_nxt=rotation;
                         keycode_nxt=keycode;
                         score1_nxt=score1;
                         score2_nxt=score2;
                         score3_nxt=score3;
                         score4_nxt=score4;
                     end
                     D_BUTTON: begin
                         y_pos_nxt=y_pos;
                         x_pos_nxt=x_pos;
                         rotation_nxt=rotation;
                         blk_code_nxt=blk_code;
                         board_nxt=board;
                         state_nxt=BUFFER;
                         row_to_clear_nxt=row_to_clear;
                         game_reset_nxt=0;
                         test_y_pos_nxt=y_pos;
                         test_x_pos_nxt=x_pos+1;
                         test_rotation_nxt=rotation;
                         keycode_nxt=keycode;
                         score1_nxt=score1;
                         score2_nxt=score2;
                         score3_nxt=score3;
                         score4_nxt=score4;
                     end
                     W_BUTTON: begin
                         y_pos_nxt=y_pos;
                         x_pos_nxt=x_pos;
                         rotation_nxt=rotation;
                         blk_code_nxt=blk_code;
                         board_nxt=board;
                         state_nxt=BUFFER;
                         row_to_clear_nxt=row_to_clear;
                         game_reset_nxt=0;
                         test_y_pos_nxt=y_pos;
                         test_x_pos_nxt=x_pos;
                         test_rotation_nxt=rotation-1;
                         keycode_nxt=keycode;
                         score1_nxt=score1;
                         score2_nxt=score2;
                         score3_nxt=score3;
                         score4_nxt=score4;
                     end
                     S_BUTTON: begin
                         y_pos_nxt=y_pos;
                         x_pos_nxt=x_pos;
                         rotation_nxt=rotation;
                         blk_code_nxt=blk_code;
                         board_nxt=board;
                         state_nxt=BUFFER;
                         row_to_clear_nxt=row_to_clear;
                         game_reset_nxt=0;
                         test_y_pos_nxt=y_pos;
                         test_x_pos_nxt=x_pos;
                         test_rotation_nxt=rotation+1;
                         keycode_nxt=keycode;
                         score1_nxt=score1;
                         score2_nxt=score2;
                         score3_nxt=score3;
                         score4_nxt=score4;
                     end
                     SPACE_BUTTON: begin
                         y_pos_nxt=y_pos;
                         x_pos_nxt=x_pos;
                         rotation_nxt=rotation;
                         blk_code_nxt=blk_code;
                         board_nxt=board;
                         state_nxt=BUFFER;
                         row_to_clear_nxt=row_to_clear;
                         game_reset_nxt=0;
                         test_y_pos_nxt=y_pos+2;
                         test_x_pos_nxt=x_pos;
                         test_rotation_nxt=rotation;
                         keycode_nxt=keycode;
                         score1_nxt=score1;
                         score2_nxt=score2;
                         score3_nxt=score3;
                         score4_nxt=score4;
                     end
                     default: begin
                         if ((((score2==0) && (score3==0) && (score4==0))&&clk1Hz)) begin
                             y_pos_nxt=y_pos;
                             x_pos_nxt=x_pos;
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             board_nxt=board;
                             state_nxt=BUFFER;
                             row_to_clear_nxt=row_to_clear;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos+1;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=keycode_used;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else if (((score2!=0) || (score3!=0) || (score4!=0))&&clk2Hz) begin
                             y_pos_nxt=y_pos;
                             x_pos_nxt=x_pos;
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             board_nxt=board;
                             state_nxt=BUFFER;
                             row_to_clear_nxt=row_to_clear;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos+1;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=8'h01;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else if (ready_to_remove) begin
                             row_to_clear_nxt=row_to_check;
                             state_nxt=CLEAR_ROW;
                             y_pos_nxt=y_pos;
                             x_pos_nxt=x_pos;
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             board_nxt=board;
                             game_reset_nxt=0;
                             test_y_pos_nxt=test_y_pos;
                             test_x_pos_nxt=test_x_pos;
                             test_rotation_nxt=test_rotation;
                             keycode_nxt=0;
                             if(score1==9) begin
                                if(score2==9)begin
                                    if(score3==9)begin
                                        if(score4!=9) begin
                                            score4_nxt=score4+1;
                                            score3_nxt=0;
                                            score2_nxt=0;
                                            score1_nxt=0;
                                        end
                                        else begin
                                            score4_nxt=score4;
                                            score3_nxt=score3;
                                            score2_nxt=score2;
                                            score1_nxt=score1;
                                        end
                                    end
                                    else begin
                                        score4_nxt=score4;
                                        score3_nxt=score3+1;
                                        score2_nxt=0;
                                        score1_nxt=0;
                                    end
                                end
                                else begin
                                    score4_nxt=score4;
                                    score3_nxt=score3;
                                    score2_nxt=score2+1;
                                    score1_nxt=0;
                                end
                             end
                             else begin
                                score4_nxt=score4;
                                score3_nxt=score3;
                                score2_nxt=score2;
                                score1_nxt=score1+1;
                             end
                         end
                         else if((y_pos==0) && intersects_now && pclk ) begin
                             blk_code_nxt=0;
                             rotation_nxt=rotation;
                             row_to_clear_nxt=row_to_clear;
                             game_reset_nxt=0;
                             for (m=0; m<=767; m=m+1) begin
                                 if (m==blk1) begin
                                     board_nxt[blk1]=1;
                                 end
                                 else if (m==blk2) begin
                                     board_nxt[blk2]=1;
                                 end
                                 else if (m==blk3) begin
                                     board_nxt[blk3]=1;
                                 end
                                 else if (m==blk4) begin
                                     board_nxt[blk4]=1;
                                 end
                                 else begin
                                     board_nxt[m]=board[m];
                                 end
                             end
                             y_pos_nxt=y_pos;
                             x_pos_nxt=x_pos;
                             state_nxt=GAME_OVER;
                             test_y_pos_nxt=test_y_pos;
                             test_x_pos_nxt=test_x_pos;
                             test_rotation_nxt=test_rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else begin
                             row_to_clear_nxt=row_to_clear;
                             x_pos_nxt=x_pos;
                             y_pos_nxt=y_pos;
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             board_nxt=board;
                             state_nxt=GAMEPLAY;
                             game_reset_nxt=0;
                             test_y_pos_nxt=test_y_pos;
                             test_x_pos_nxt=test_x_pos;
                             test_rotation_nxt=test_rotation;
                             keycode_nxt=keycode;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                     end
                 endcase
             end
             
             BUFFER: begin
                row_to_clear_nxt=row_to_clear;   
                 x_pos_nxt=x_pos;                 
                 y_pos_nxt=y_pos;                 
                 rotation_nxt=rotation;           
                 blk_code_nxt=blk_code;           
                 board_nxt=board;                 
                 state_nxt=TEST_COLLISION;              
                 game_reset_nxt=0;                
                 test_y_pos_nxt=test_y_pos;       
                 test_x_pos_nxt=test_x_pos;       
                 test_rotation_nxt=test_rotation; 
                 keycode_nxt=keycode_used;             
                 score1_nxt=score1;               
                 score2_nxt=score2;               
                 score3_nxt=score3;               
                 score4_nxt=score4;               
             end
     
             TEST_COLLISION: begin
                case (keycode_used)
                    A_BUTTON: begin
                         if((x_pos==LEFT_EDGE) || test_intersection )begin
                             x_pos_nxt=x_pos;
                             blk_code_nxt=blk_code;
                             y_pos_nxt=y_pos;
                             board_nxt=board;
                             rotation_nxt=rotation;
                             row_to_clear_nxt=row_to_clear;
                             state_nxt=GAMEPLAY;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else begin
                             x_pos_nxt=x_pos-1;
                             blk_code_nxt=blk_code;
                             y_pos_nxt=y_pos;
                             board_nxt=board;
                             rotation_nxt=rotation;
                             row_to_clear_nxt=row_to_clear;
                             state_nxt=GAMEPLAY;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos-1;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                     end
                     D_BUTTON: begin
                         if( (!test_intersection) && ((x_pos+width)<(GAME_WIDTH+LEFT_EDGE)) )begin
                            x_pos_nxt=x_pos+1;
                            blk_code_nxt=blk_code;
                            y_pos_nxt=y_pos;
                            board_nxt=board;
                            rotation_nxt=rotation;
                            row_to_clear_nxt=row_to_clear;
                            state_nxt=GAMEPLAY;
                            game_reset_nxt=0;
                            test_y_pos_nxt=y_pos;
                            test_x_pos_nxt=x_pos+1;
                            test_rotation_nxt=rotation;
                            keycode_nxt=0;
                            score1_nxt=score1;
                            score2_nxt=score2;
                            score3_nxt=score3;
                            score4_nxt=score4;
                         end
                         else begin
                             x_pos_nxt=x_pos;
                             blk_code_nxt=blk_code;
                             y_pos_nxt=y_pos;
                             board_nxt=board;
                             rotation_nxt=rotation;
                             row_to_clear_nxt=row_to_clear;
                             state_nxt=GAMEPLAY;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                     end
                     W_BUTTON: begin
                         if((LEFT_EDGE<=(x_pos+test_width)<(LEFT_EDGE+GAME_WIDTH)) &&
                         ((y_pos+test_height)<GAME_HEIGHT) && (!test_intersection) ) begin
                             rotation_nxt=rotation-1;
                             blk_code_nxt=blk_code;
                             y_pos_nxt=y_pos;
                             board_nxt=board;
                             x_pos_nxt=x_pos;
                             row_to_clear_nxt=row_to_clear;
                             state_nxt=GAMEPLAY;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation-1;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else begin
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             y_pos_nxt=y_pos;
                             board_nxt=board;
                             x_pos_nxt=x_pos;
                             row_to_clear_nxt=row_to_clear;
                             state_nxt=GAMEPLAY;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end 
                     end
                     S_BUTTON: begin
                         if((LEFT_EDGE<=(x_pos+test_width)<(LEFT_EDGE+GAME_WIDTH)) &&
                         ((y_pos+test_height)<GAME_HEIGHT) && (!test_intersection) ) begin
                             rotation_nxt=rotation+1;
                             blk_code_nxt=blk_code;
                             y_pos_nxt=y_pos;
                             board_nxt=board;
                             x_pos_nxt=x_pos;
                             row_to_clear_nxt=row_to_clear;
                             state_nxt=GAMEPLAY;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation+1;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else begin
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             y_pos_nxt=y_pos;
                             board_nxt=board;
                             x_pos_nxt=x_pos;
                             row_to_clear_nxt=row_to_clear;
                             state_nxt=GAMEPLAY;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                     end
                     SPACE_BUTTON: begin
                         if(((height+y_pos)<(GAME_HEIGHT-1)) && (!test_intersection) ) begin
                             y_pos_nxt=y_pos+2;
                             x_pos_nxt=x_pos;
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             board_nxt=board;
                             state_nxt=GAMEPLAY;
                             row_to_clear_nxt=row_to_clear;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos+2;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else if((height+y_pos)<(GAME_HEIGHT)&& (!check_if_intersects(blk1+32,blk2+32,blk3+32,blk4+32)) ) begin
                             board_nxt=board;
                             y_pos_nxt=y_pos+1;
                             x_pos_nxt=x_pos;
                             rotation_nxt=rotation;
                             blk_code_nxt=blk_code;
                             game_reset_nxt=0;
                             row_to_clear_nxt=row_to_clear;
                             state_nxt=GAMEPLAY;
                             test_y_pos_nxt=y_pos+1;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else if((y_pos==0) && ((intersects_now)||(test_intersection))) begin
                             y_pos_nxt=y_pos;
                             x_pos_nxt=x_pos;
                             rotation_nxt=rotation;
                             blk_code_nxt=0;
                             board_nxt=0;
                             state_nxt=GAME_OVER;
                             row_to_clear_nxt=row_to_clear;
                             game_reset_nxt=0;
                             test_y_pos_nxt=y_pos+1;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else begin
                             blk_code_nxt=(random+1);
                             rotation_nxt=0;
                             game_reset_nxt=1;
                             row_to_clear_nxt=row_to_clear;
                             for (j=0; j<=767; j=j+1) begin
                                 if (j==blk1) begin
                                     board_nxt[blk1]=1;
                                 end
                                 else if (j==blk2) begin
                                     board_nxt[blk2]=1;
                                 end
                                 else if (j==blk3) begin
                                     board_nxt[blk3]=1;
                                 end
                                 else if (j==blk4) begin
                                     board_nxt[blk4]=1;
                                 end
                                 else begin
                                     board_nxt[j]=board[j];
                                 end
                             end
                             state_nxt=GAMEPLAY;
                             x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                             y_pos_nxt=0;
                             test_y_pos_nxt=0;
                             test_x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                             test_rotation_nxt=0;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                      end
                     8'h01: begin
                            if(((height+y_pos)<(GAME_HEIGHT)) && (!test_intersection) ) begin
                                y_pos_nxt=y_pos+1;
                                x_pos_nxt=x_pos;
                                rotation_nxt=rotation;
                                blk_code_nxt=blk_code;
                                board_nxt=board;
                                state_nxt=GAMEPLAY;
                                row_to_clear_nxt=row_to_clear;
                                game_reset_nxt=0;
                                test_y_pos_nxt=y_pos+1;
                                test_x_pos_nxt=x_pos;
                                test_rotation_nxt=rotation;
                                keycode_nxt=0;
                                score1_nxt=score1;
                                score2_nxt=score2;
                                score3_nxt=score3;
                                score4_nxt=score4;
                            end
                            else begin
                                for (j=0; j<=767; j=j+1) begin
                                    if (j==blk1) begin
                                        board_nxt[blk1]=1;
                                    end
                                    else if (j==blk2) begin
                                    board_nxt[blk2]=1;
                                    end
                                    else if (j==blk3) begin
                                        board_nxt[blk3]=1;
                                    end
                                    else if (j==blk4) begin
                                        board_nxt[blk4]=1;
                                    end
                                    else begin
                                        board_nxt[j]=board[j];
                                    end
                                end  
                                blk_code_nxt=(random+1);
                                x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                                y_pos_nxt=0;
                                rotation_nxt=0;
                                game_reset_nxt=1;
                                row_to_clear_nxt=row_to_clear;                
                                state_nxt=GAMEPLAY;
                                test_y_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                                test_x_pos_nxt=0;
                                test_rotation_nxt=0;
                                keycode_nxt=0;
                                score1_nxt=score1;
                                score2_nxt=score2;
                                score3_nxt=score3;
                                score4_nxt=score4;
                            end
                      end
             default: begin
                      if (((score2==0) && (score3==0) && (score4==0))&&clk1Hz)begin
                             if(((height+y_pos)<(GAME_HEIGHT)) && (!test_intersection) ) begin
                                 y_pos_nxt=y_pos+1;
                                 x_pos_nxt=x_pos;
                                 rotation_nxt=rotation;
                                 blk_code_nxt=blk_code;
                                 board_nxt=board;
                                 state_nxt=GAMEPLAY;
                                 row_to_clear_nxt=row_to_clear;
                                 game_reset_nxt=0;
                                 test_y_pos_nxt=y_pos+1;
                                 test_x_pos_nxt=x_pos;
                                 test_rotation_nxt=rotation;
                                 keycode_nxt=0;
                                 score1_nxt=score1;
                                 score2_nxt=score2;
                                 score3_nxt=score3;
                                 score4_nxt=score4;
                             end
                             else begin
                                 for (j=0; j<=767; j=j+1) begin
                                     if (j==blk1) begin
                                         board_nxt[blk1]=1;
                                     end
                                     else if (j==blk2) begin
                                     board_nxt[blk2]=1;
                                     end
                                     else if (j==blk3) begin
                                         board_nxt[blk3]=1;
                                     end
                                     else if (j==blk4) begin
                                         board_nxt[blk4]=1;
                                     end
                                     else begin
                                         board_nxt[j]=board[j];
                                     end
                                 end  
                                 blk_code_nxt=(random+1);
                                 x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                                 y_pos_nxt=0;
                                 rotation_nxt=0;
                                 game_reset_nxt=1;
                                 row_to_clear_nxt=row_to_clear;                
                                 state_nxt=GAMEPLAY;
                                 test_y_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                                 test_x_pos_nxt=0;
                                 test_rotation_nxt=0;
                                 keycode_nxt=0;
                                 score1_nxt=score1;
                                 score2_nxt=score2;
                                 score3_nxt=score3;
                                 score4_nxt=score4;
                             end
                         end
                         else if((y_pos==0) && intersects_now && pclk ) begin
                             blk_code_nxt=0;
                             rotation_nxt=rotation;
                             row_to_clear_nxt=row_to_clear;
                             game_reset_nxt=0;
                             for (m=0; m<=767; m=m+1) begin
                                 if (m==blk1) begin
                                     board_nxt[blk1]=1;
                                 end
                                 else if (m==blk2) begin
                                     board_nxt[blk2]=1;
                                 end
                                 else if (m==blk3) begin
                                     board_nxt[blk3]=1;
                                 end
                                 else if (m==blk4) begin
                                     board_nxt[blk4]=1;
                                 end
                                 else begin
                                     board_nxt[m]=board[m];
                                 end
                             end
                             y_pos_nxt=y_pos;
                             x_pos_nxt=x_pos;
                             state_nxt=GAME_OVER;
                             test_y_pos_nxt=y_pos;
                             test_x_pos_nxt=x_pos;
                             test_rotation_nxt=rotation;
                             keycode_nxt=0;
                             score1_nxt=score1;
                             score2_nxt=score2;
                             score3_nxt=score3;
                             score4_nxt=score4;
                         end
                         else begin
                                     row_to_clear_nxt=row_to_clear;
                                     x_pos_nxt=x_pos;
                                     y_pos_nxt=y_pos;
                                     rotation_nxt=rotation;
                                     blk_code_nxt=blk_code;
                                     board_nxt=board;
                                     state_nxt=TEST_COLLISION;
                                     game_reset_nxt=0;
                                     test_y_pos_nxt=test_y_pos;
                                     test_x_pos_nxt=test_x_pos;
                                     test_rotation_nxt=test_rotation;
                                     keycode_nxt=keycode_used;
                                     score1_nxt=score1;
                                     score2_nxt=score2;
                                     score3_nxt=score3;
                                     score4_nxt=score4;
                                 end
                             end
              endcase
             end
             
             CLEAR_ROW: begin
                 if (row_to_clear==0) begin
                     row_to_clear_nxt=row_to_clear;
                     rotation_nxt=rotation;
                     blk_code_nxt=blk_code;
                     game_reset_nxt=0;
                     for (l=0; l<=767; l=l+1) begin
                         if (l>=LEFT_EDGE && l<(LEFT_EDGE+GAME_WIDTH)) begin
                             board_nxt[l]=0;
                         end
                         else begin
                             board_nxt[l]=board[l];
                         end
                     end
                     x_pos_nxt=x_pos;
                     y_pos_nxt=y_pos;
                     state_nxt=GAMEPLAY;
                     test_y_pos_nxt=y_pos;
                     test_x_pos_nxt=x_pos;
                     test_rotation_nxt=rotation;
                     keycode_nxt=0;
                     score1_nxt=score1;
                     score2_nxt=score2;
                     score3_nxt=score3;
                     score4_nxt=score4;
                 end
                 else begin
                     row_to_clear_nxt=row_to_clear-1;
                     rotation_nxt=rotation;
                     blk_code_nxt=blk_code;
                     game_reset_nxt=0;
                     for(k=0;k<=767;k=k+1) begin
                         if (k>=((row_to_clear*SCREEN_WIDTH)+LEFT_EDGE) &&
                         k<(((row_to_clear*SCREEN_WIDTH)+LEFT_EDGE)+GAME_WIDTH)) begin
                             board_nxt[k]=board[k-SCREEN_WIDTH];
                         end
                         else begin
                             board_nxt[k]=board[k];
                         end
                     end
                     state_nxt=CLEAR_ROW;
                     x_pos_nxt=x_pos;
                     y_pos_nxt=y_pos;
                     test_y_pos_nxt=y_pos;
                     test_x_pos_nxt=x_pos;
                     test_rotation_nxt=rotation;
                     keycode_nxt=0;
                     score1_nxt=score1;
                     score2_nxt=score2;
                     score3_nxt=score3;
                     score4_nxt=score4;
                 end
            end
              
            GAME_OVER: begin
                case(keycode_used[7:0])
                     ENTER_BUTTON: begin
                         board_nxt=0;
                         blk_code_nxt=(random+1);
                         x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                         y_pos_nxt=0;
                         rotation_nxt=0;
                         row_to_clear_nxt=0;
                         state_nxt=GAMEPLAY;
                         game_reset_nxt=1;
                         test_y_pos_nxt=y_pos;
                         test_x_pos_nxt=x_pos;
                         test_rotation_nxt=rotation;
                         keycode_nxt=0;
                         score1_nxt=0;
                         score2_nxt=0;
                         score3_nxt=0;
                         score4_nxt=0;
                     end
                     default: begin
                         state_nxt=GAME_OVER;
                         row_to_clear_nxt=row_to_clear;
                         x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                         y_pos_nxt=0;
                         rotation_nxt=0;
                         blk_code_nxt=0;
                         board_nxt=board;
                         game_reset_nxt=0;
                         test_y_pos_nxt=0;
                         test_x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
                         test_rotation_nxt=0;
                         keycode_nxt=keycode;
                         score1_nxt=score1;
                         score2_nxt=score2;
                         score3_nxt=score3;
                         score4_nxt=score4;
                     end
                endcase
            end
            default: begin
                state_nxt=state;
                row_to_clear_nxt=row_to_clear;
                x_pos_nxt=x_pos;
                y_pos_nxt=y_pos;
                rotation_nxt=rotation;
                blk_code_nxt=blk_code;
                board_nxt=board;
                game_reset_nxt=0;
                test_y_pos_nxt=y_pos;
                test_x_pos_nxt=x_pos;
                test_rotation_nxt=rotation;
                keycode_nxt=keycode;
                score1_nxt=score1;
                score2_nxt=score2;
                score3_nxt=score3;
                score4_nxt=score4;
             end
         endcase
     end
 end
 
 
 
 always @(posedge pclk)begin
         hcount_out<=hcount_nxt;
         vcount_out<=vcount_nxt;
         VGARed_out<=VGARed;
         VGAGreen_out<=VGAGreen;
         VGABlue_out<=VGABlue;
         hsync_out<=hsync_nxt;
         vsync_out<=vsync_nxt;
         hblnk_out<=hblnk_nxt;
         vblnk_out<=vblnk_nxt;
         state<=state_nxt;
         game_reset<=game_reset_nxt;
  
         state_ctr<=state_nxt;
         y_pos<=y_pos_nxt;
         x_pos<=x_pos_nxt;
         board<=board_nxt;
         row_to_clear<=row_to_clear_nxt;
         blk_code<=blk_code_nxt;
         rotation<=rotation_nxt;
         test_x_pos<=test_x_pos_nxt;
         test_y_pos<=test_y_pos_nxt;
         test_rotation<=test_rotation_nxt;
         keycode_used<=keycode_nxt;
         score1<=score1_nxt;
         score2<=score2_nxt;
         score3<=score3_nxt;
         score4<=score4_nxt;
 end
   
endmodule