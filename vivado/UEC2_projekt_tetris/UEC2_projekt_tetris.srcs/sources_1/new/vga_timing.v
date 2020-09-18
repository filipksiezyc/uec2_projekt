`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////////////
// Company: AGH University of Science and Technology
// Engineer: Filip Ksiê¿yc & Justyna Rudnicka
// 
// Create Date: 08/16/2020 11:33:57 PM
// Design Name: 
// Module Name: vga_timing
// Project Name: TETRIS for BASYS3 designed in Verilog 
// Target Devices: Basys3
// Tool Versions: VIVADO 2017.3
// Description: This module generate basic signals used to generate graphic. 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vga_timing (
  input wire pclk,
  input wire reset,

  output wire [10:0] vcount,
  output wire vsync,
  output wire vblnk,
  output wire [10:0] hcount,
  output wire hsync,
  output wire hblnk

  );

reg [10:0] vcountinside=0; 
reg [10:0] hcountinside=0;
reg [10:0] vcountinside_nxt=0; 
reg [10:0] hcountinside_nxt=0;
reg currentvblnk=0;
reg currenthblnk=0;
reg currentvsync=0;
reg currenthsync=0;

always @(posedge pclk)begin
            hcountinside_nxt<=hcountinside+1;
            if(hcountinside==1344)begin
                hcountinside_nxt<=0;
                vcountinside_nxt<=vcountinside+1;
                if(vcountinside==806)begin
                    vcountinside_nxt<=0;
                    end
                end     
            end
 

always @* begin 
       if(reset)begin
            hcountinside<=0;
            vcountinside<=0;
            end
       else begin
            hcountinside<=hcountinside_nxt;
            vcountinside<=vcountinside_nxt;     
            end
end

assign hcount=hcountinside;
assign vcount=vcountinside;
assign vsync=((vcountinside>770)&&(vcountinside<777));
assign hsync=((hcountinside>1047)&&(hcountinside<1183));
assign vblnk=((vcountinside>767)&&(vcountinside<806));
assign hblnk=((hcountinside>1023)&&(hcountinside<1344));

endmodule