`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH University of Science and Technology
// Engineer: Filip Ksiê¿yc & Justyna Rudnicka
// 
// Create Date: 17.09.2020 13:02:24
// Design Name: 
// Module Name: uart_debouncer
// Project Name: TETRIS for BASYS3 designed in Verilog
// Target Devices: BASYS3
// Tool Versions: VIVADO 2017.3
// Description: This module is used with uart module to prevent bouncing effect.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// this module download link -> https://upel2.cel.agh.edu.pl/weaiib/mod/assign/view.php?id=23012 
//
//////////////////////////////////////////////////////////////////////////////////


module uart_debouncer(
    input wire clk,
    input wire reset,
    input wire rx_empty,
    input wire [7:0] r_data,
    output reg [7:0] key_out
    );
    
reg [7:0] key_out_nxt;

always @(*) begin
    if (rx_empty==0) begin
        key_out_nxt=r_data;
    end
    else if (reset) begin
        key_out_nxt=0;
    end
    else begin
        key_out_nxt=8'b0;
    end
end

always @(posedge clk) begin
    key_out<=key_out_nxt;
end

endmodule
