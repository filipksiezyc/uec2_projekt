`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Filip Ksiê¿yc & Justyna Rudnicka
// 
// Create Date: 17.09.2020 18:05:03
// Design Name: 
// Module Name: clk2Hz
// Project Name: TETRIS for BASYS3 designed in Verilog 
// Target Devices: BASYS3
// Tool Versions: VIVADO 2017.3
// Description: This module generate two pulses every one second.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk2Hz(
    input wire clk65MHz,
    input wire reset,
    input wire game_reset,
    
    output wire clk2Hz
    );
    
reg [26:0] counter=0, counter05Hz=0;
reg clk_out=0, clk05Hz_out=0;

always @(posedge clk65MHz) begin
    if(reset||game_reset)begin
        clk_out<=0;
        counter<=0;
        end
    else begin
        if (counter==32499999) begin
            counter <= counter+1;
            clk_out<= 1;
        end
        else if(counter == 32500000)begin
            counter <= 0;
            clk_out<= 1;
            end
        else begin
            counter <= counter+1;
            clk_out<= 0;
            end
    end
end


assign clk2Hz=clk_out;    
    
endmodule
