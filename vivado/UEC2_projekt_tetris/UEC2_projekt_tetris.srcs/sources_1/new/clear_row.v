`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH University of Science and Technology
// Engineer: Filip Ksiê¿yc & Justyna Rudnicka
// 
// Create Date: 01.09.2020 19:19:37
// Design Name: 
// Module Name: clear_row
// Project Name: TETRIS for BASYS3 designed in Verilog 
// Target Devices: Basys3
// Tool Versions: VIVADO 2017.3
// Description: This module delete rows filled by fallen pieces and moves 
// next rows to fill void.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clear_row(
    input wire pclk,
    input wire reset,
    input wire [767:0] board,
    
    output reg [5:0] row,
    output wire ready
    );
    
reg [5:0] row_nxt=0;
localparam GAME_HEIGHT=24, GAME_WIDTH=16, SCREEN_WIDTH=32, LEFT_EDGE=2;
        
always @(*) begin
    if (reset||row==GAME_HEIGHT-1) begin
                row_nxt=0;
            end
            else begin
                row_nxt=row+1;
            end
        end

always @(posedge pclk)begin
    row<=row_nxt;
    end     
        
assign ready=&board[((row*SCREEN_WIDTH)+LEFT_EDGE) +: GAME_WIDTH];


endmodule    
