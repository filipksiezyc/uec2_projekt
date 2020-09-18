//////////////////////////////////////////////////////////////////////////////////
// Company: AGH University of Science and Technology
// Engineer: Filip Ksiê¿yc & Justyna Rudnicka
// 
// Create Date: ???
// Design Name: 
// Module Name: list_ch08_04_uart
// Project Name: TETRIS for BASYS3 designed in Verilog 
// Target Devices: Basys3
// Tool Versions: VIVADO 2017.3
// Description: This module is UART top module that recive date used by
// ingame logic that is sent due UART protocll from TERATERM terminal. 
// Data is introduced by keyboard.
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This module download link -> https://upel2.cel.agh.edu.pl/weaiib/mod/assign/view.php?id=23012 
//
//////////////////////////////////////////////////////////////////////////////////



module uart
   #( // Default setting:
      // 19,200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
      parameter DBIT = 8,     // # data bits
                SB_TICK = 16, // # ticks for stop bits, 16/24/32
                              // for 1/1.5/2 stop bits
                DVSR = 65000000/(16*9600),   // baud rate divisor
                              // DVSR = 50M/(16*baud rate)
                DVSR_BIT = 9, // # bits of DVSR
                FIFO_W = 1    // # addr bits of FIFO
                              // # words in FIFO=2^FIFO_W
   )
   (
    input wire clk, reset,
    input wire  rx, 
    output wire rx_empty, tx,
    output wire [7:0] r_data,
    output reg [7:0] code
   );

   // signal declaration
   wire tick, rx_done_tick, tx_done_tick;
   wire tx_empty, tx_fifo_not_empty;
   wire [7:0] tx_fifo_out, rx_data_out;
   wire [7:0] w_data;
   reg rd_uart, rd_uart_nxt;
   reg [7:0] code_nxt;
   assign w_data=0;

   //body
   mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit
      (.clk(clk), .reset(reset), .q(), .max_tick(tick));

   uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit
      (.clk(clk), .reset(reset), .rx(rx), .s_tick(tick),
       .rx_done_tick(rx_done_tick), .dout(rx_data_out));

   fifo #(.B(DBIT), .W(FIFO_W)) fifo_rx_unit
      (.clk(clk), .reset(reset), .rd(rd_uart),
       .wr(rx_done_tick), .w_data(rx_data_out),
       .empty(rx_empty), .full(), .r_data(r_data));

   fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit
      (.clk(clk), .reset(reset), .rd(tx_done_tick),
       .wr(wr_uart), .w_data(w_data), .empty(tx_empty),
       .full(tx_full), .r_data(tx_fifo_out));

   uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
      (.clk(clk), .reset(reset), .tx_start(tx_fifo_not_empty),
       .s_tick(tick), .din(tx_fifo_out),
       .tx_done_tick(tx_done_tick), .tx(tx));

   assign tx_fifo_not_empty = ~tx_empty;
   
   always @(*) begin
        if((~rx_empty)&&(rd_uart==0)) begin
            code_nxt=r_data;
            rd_uart_nxt=1;
        end
        else if (reset) begin
            code_nxt=0;
            rd_uart_nxt=0;
        end
        else begin
            code_nxt=code;
            rd_uart_nxt=0;
        end
   end

always @(posedge clk) begin
    rd_uart<=rd_uart_nxt;
    code<= code_nxt;
end

endmodule