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
    input wire clk1Hz,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire [15:0] keycode,
    input wire oflag,
    
    output reg [3:0] VGARed_out,
    output reg [3:0] VGAGreen_out,
    output reg [3:0] VGABlue_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg [10:0] hcount_out,
    output reg [10:0] vcount_out
    );

localparam TITLESCREEN=0, GAMEPLAY=1, MOV_LEFT=2, MOV_RIGHT=3, ROT_LEFT=4,
ROT_RIGHT=5, FALL_SLOW=6, FALL_FAST=7, CLEAR_ROW=8,GAME_OVER=9,

A_BUTTON=16'h1C, W_BUTTON=16'h1D, S_BUTTON=16'h1B, D_BUTTON=16'h23,
SPACE_BUTTON=16'h29, ENTER_BUTTON=16'h5A,

LEFT_EDGE=2, GAME_WIDTH=16, SCREEN_WIDTH=32,GAME_HEIGHT=24, ERROR_BLOCK=11'b11111111111;
 
reg [3:0] state=0; 
reg [3:0] state_nxt=0;
 //entire board, divided into 32x32 pixel squares. Every "1" means there is an immovable block          
reg [((SCREEN_WIDTH*GAME_HEIGHT)-1):0] board=0;

reg [2:0] blk_code;
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
    .hblnk_out(hblnk_nxt),
    .vblnk_out(vblnk_nxt) 
);

wire [5:0] test_x_pos, test_y_pos;
wire [1:0] test_rotation;
wire [10:0] test_blk1, test_blk2, test_blk3, test_blk4;
wire [3:0] test_width, test_height;

//the next two modules generate test parameters to check if
//user's movement is executable
test_move show_me_your_moves(
    .pclk(pclk),
    .clk1Hz(clk1Hz),
    .reset(reset),
    .keycode(keycode),
    .xpos(x_pos),
    .ypos(y_pos),
    .rotation(rotation),

    .test_x(test_x_pos),
    .test_y(test_y_pos),
    .test_rot(test_rotation)
);

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

//function to check if the test piece intersects with the fallen pieces
function check_if_intersects;
    input wire [10:0] blk1;
    input wire [10:0] blk2;
    input wire [10:0] blk3;
    input wire [10:0] blk4;
    begin
    check_if_intersects=board[blk1]||board[blk2]||board[blk3]||board[blk4];
    end    
endfunction
wire test_intersection=check_if_intersects(test_blk1,test_blk2,test_blk3,test_blk4);

reg [5:0] x_pos_nxt=0, y_pos_nxt=0;
reg [1:0] rotation_nxt=0;
reg [767:0] board_nxt=0;
reg [2:0] blk_code_nxt=0;

//all tasks are executed in the combinative part of the module, hence the "="

task move_left;
    begin
        if(x_pos>LEFT_EDGE && !test_intersection)begin
            x_pos_nxt=x_pos-1;
        end
        else begin
            x_pos_nxt=x_pos;
        end
    end
endtask

task move_right;
    begin
        if((x_pos+width)<(GAME_WIDTH+LEFT_EDGE-1) && !test_intersection)begin
            x_pos_nxt=x_pos+1;
        end
        else begin
            x_pos_nxt=x_pos;
        end
    end
endtask

task rotate_left;
    begin
        if(LEFT_EDGE<=(x_pos+test_width)<(LEFT_EDGE+GAME_WIDTH) &&
        0<=(y_pos+test_height)<GAME_HEIGHT && !test_intersection) begin
            rotation_nxt=rotation-1;
        end
        else begin
            rotation_nxt=rotation;
        end
    end
endtask

task rotate_right;
    begin
        if(LEFT_EDGE<=(x_pos+test_width)<(LEFT_EDGE+GAME_WIDTH) &&
        0<=(y_pos+test_height)<GAME_HEIGHT && !test_intersection) begin
            rotation_nxt=rotation+1;
        end
        else begin
            rotation_nxt=rotation;
        end
    end
endtask

task immobilize;
    begin
        board_nxt[blk1]=1;
        board_nxt[blk2]=1;
        board_nxt[blk3]=1;
        board_nxt[blk4]=1;
    end
endtask

task new_piece;
    begin
        blk_code_nxt=random;
        x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
        y_pos_nxt=0;
        rotation_nxt=0;
    end
endtask

task drop;
    begin
        if((height+y_pos)<(GAME_HEIGHT-1) && !test_intersection) begin
            y_pos_nxt=y_pos+1;
        end
        else begin
            immobilize();
            new_piece();
        end
    end
endtask

task drop_faster;
    begin
        if((height+y_pos)<(GAME_HEIGHT-2) && !test_intersection) begin
            y_pos_nxt=y_pos+2;
        end
        else begin
            y_pos_nxt=y_pos;
        end
    end
endtask

reg [5:0] row_to_clear;
reg [5:0] row_to_clear_nxt=0;
task remove_row;
    begin
        state_nxt=CLEAR_ROW;
        row_to_clear_nxt=row_to_check;
    end
endtask

task start_game;
    begin
        state_nxt=GAMEPLAY;
        board_nxt=0;
        new_piece();
    end
endtask

initial begin
    state_nxt=TITLESCREEN;
    board_nxt=0;
    blk_code_nxt=0;
    y_pos_nxt=0;
    x_pos_nxt=(LEFT_EDGE+(GAME_WIDTH/2));
end

//this wire turns to 1 when current position intersects with inactive blocks
//and the moving piece is still at the top of the board
wire game_over= y_pos==0 && check_if_intersects(blk1,blk2,blk3,blk4);

always @(*) begin
    if (reset) begin
        state_nxt=TITLESCREEN;
        board_nxt=0;
        blk_code_nxt=0;
    end
    else if (pclk) begin
        if((state==TITLESCREEN||state==GAME_OVER)&&ENTER_BUTTON)begin
            start_game();
        end
        else if (game_over)begin
            state_nxt=TITLESCREEN;
            immobilize();
            blk_code_nxt=0;
        end
        else if (state==GAMEPLAY) begin
            if (clk1Hz)begin
                drop();
            end
            else if (ready_to_remove) begin
                remove_row();
            end
            else begin
                case (keycode)
                    A_BUTTON: begin
                        move_left();
                    end
                    D_BUTTON: begin
                        move_right();
                    end
                    W_BUTTON: begin
                        rotate_left();
                    end
                    S_BUTTON: begin
                        rotate_right();
                    end
                    SPACE_BUTTON: begin
                        drop_faster();
                    end
                    default: ;
                endcase
            end
        end
        else if (state==CLEAR_ROW) begin
            if (row_to_clear==0) begin
                board_nxt[LEFT_EDGE +:GAME_WIDTH]<=0;
                state_nxt=GAMEPLAY;
            end
            else begin
                board_nxt[((row_to_clear*SCREEN_WIDTH)+LEFT_EDGE) +:GAME_WIDTH]=board[(((row_to_clear-1)*SCREEN_WIDTH)+LEFT_EDGE) +:GAME_WIDTH];
                row_to_clear_nxt=row_to_clear-1;
            end
        end
    end
    else begin
    end
end

always @(posedge pclk)begin
    VGARed_out<=VGARed;
    VGAGreen_out<=VGAGreen;
    VGABlue_out<=VGABlue;
    hsync_out<=hsync_nxt;
    vsync_out<=vsync_nxt;
    hblnk_out<=hblnk_nxt;
    vblnk_out<=vblnk_nxt;
    hcount_out<=hcount;
    vcount_out<=vcount;
    state<=state_nxt;
    
    y_pos<=y_pos_nxt;
    x_pos<=x_pos_nxt;
    board<=board_nxt;
    row_to_clear<=row_to_clear_nxt;
    blk_code<=blk_code_nxt;
    rotation<=rotation_nxt;
end

endmodule
