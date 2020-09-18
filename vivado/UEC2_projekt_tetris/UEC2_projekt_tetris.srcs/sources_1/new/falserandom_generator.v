`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Filip Ksiê¿yc & Justyna Rudnicka
// 
// Create Date: 08/24/2020 08:38:27 PM
// Design Name: 
// Module Name: falserandom_generator
// Project Name: TETRIS for BASYS3 designed in Verilog 
// Target Devices: BASYS3
// Tool Versions: VIVADO 2017.3
// Description: This module is basicly counter that works with clock 
// different to clock used to controll all other modules. Including  
// non-constant piece falling time we can provide pseudo-random number
// generation.
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module falserandom_generator(
    input wire clkrand,
    input wire reset,
    
    output wire [2:0] rand
    );
    
reg [2:0] rand_count;
    
always@(posedge clkrand)begin
    if(reset)begin
        rand_count<=0;  
        end
    else begin
        if(rand_count==6)begin
            rand_count<=0;
            end
        else begin
            rand_count<=rand_count+1;
            end
        end
    end

assign rand = rand_count;
    
endmodule
