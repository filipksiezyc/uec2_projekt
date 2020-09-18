//////////////////////////////////////////////////////////////////////////////////
// Company: AGH University of Science and Technology
// Engineer: Filip Ksiê¿yc & Justyna Rudnicka
// 
// Create Date: ???
// Design Name: 
// Module Name: list_ch04_11_mod_m_counter
// Project Name: TETRIS for BASYS3 designed in Verilog 
// Target Devices: Basys3
// Tool Versions: VIVADO 2017.3
// Description: This module is used in UART module to count incoming 
// bits.
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module download link -> https://upel2.cel.agh.edu.pl/weaiib/mod/assign/view.php?id=23012 
//
//////////////////////////////////////////////////////////////////////////////////


module mod_m_counter
   #(
    parameter N=4, // number of bits in counter
              M=10 // mod-M
   )
   (
    input wire clk, reset,
    output wire max_tick,
    output wire [N-1:0] q
   );

   //signal declaration
   reg [N-1:0] r_reg;
   wire [N-1:0] r_next;

   // body
   // register
   always @(posedge clk, posedge reset)
      if (reset)
         r_reg <= 0;
      else
         r_reg <= r_next;

   // next-state logic
   assign r_next = (r_reg==(M-1)) ? 0 : r_reg + 1;
   // output logic
   assign q = r_reg;
   assign max_tick = (r_reg==(M-1)) ? 1'b1 : 1'b0;

endmodule