`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2020 01:58:00 PM
// Design Name: 
// Module Name: clk1Hz
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


module clk1Hz(
    input wire clk50MHz,
    input wire reset,
    
    output wire clk1Hz
    );
    
reg [26:0] counter=0;
reg clk_out=0;

always @(posedge clk50MHz) begin
    if(reset)begin
        clk_out<=0;
        counter<=0;
        end
    else begin
        if(counter == 50000000)begin
            counter <= 0;
            clk_out<= (~(clk_out));
            end
        else begin
            counter <= counter+1;
            end
    end
end

assign clk1Hz=clk_out;    
    
endmodule
