`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2020 04:06:24 PM
// Design Name: 
// Module Name: draw_rect_char
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


module draw_rect_char
    #(parameter
     X_POSITION=0,
     Y_POSITION=0,
     X_WIDITH=0,
     Y_WIDITH=0
    )
    (
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [3:0] red_in,
    input wire [3:0] green_in,
    input wire [3:0] blue_in,
    input wire clk,
    input wire rst,
    input wire [7:0] char_pixels,

    output wire hblnk_out,
    output wire vblnk_out,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg [3:0] red_out,
    output reg [3:0] green_out,
    output reg [3:0] blue_out,
    output wire [7:0] char_xy,
    output wire [3:0] char_line
    );
    
    reg [10:0] hcount_1=0, vcount_1=0, hcount_2, vcount_2;
    reg [2:0] addr, addr_nxt;
    reg hsync_1=0, hblnk_1=0, vsync_1=0, vblnk_1=0, hsync_2, hblnk_2, vsync_2, vblnk_2;
    reg [3:0] red_out_nxt=0, green_out_nxt=0, blue_out_nxt=0;
    localparam COLOR=12'h000;

    
    always @(posedge clk, posedge rst)begin
          if(rst)begin
             hcount_1<=0;
             vcount_1<=0;
             vsync_1<=0;
             hsync_1<=0;
             vblnk_1<=0;
             hblnk_1<=0;
             end
          
          if(clk)begin
             hcount_1<=hcount_in;
             vcount_1<=vcount_in;
             vsync_1<=vsync_in;
             hsync_1<=hsync_in;
             vblnk_1<=vblnk_in;
             hblnk_1<=hblnk_in;
             end
      end  
      
      
       always @(posedge clk, posedge rst)begin
               if(rst)begin
                  hcount_2<=0;
                  vcount_2<=0;
                  vsync_2<=0;
                  hsync_2<=0;
                  vblnk_2<=0;
                  hblnk_2<=0;
                  end
               
               if(clk)begin
                  hcount_2<=hcount_1;
                  vcount_2<=vcount_1;
                  vsync_2<=vsync_1;
                  hsync_2<=hsync_1;
                  vblnk_2<=vblnk_1;
                  hblnk_2<=hblnk_1;
                  end
           end 
      
      always @* begin
            addr_nxt = (8 - ((hcount_in - X_POSITION) & 3'b111));
            end   
      
        
      always @* begin
             if(rst) {red_out_nxt,green_out_nxt,blue_out_nxt}<=0;
             
             if((hcount_in>(X_POSITION))&&(hcount_in<=(X_POSITION+X_WIDITH))&&(vcount_in>=Y_POSITION)&&(vcount_in<=(Y_POSITION+Y_WIDITH)))begin
                 if(char_pixels[addr])begin
                     {red_out_nxt,green_out_nxt,blue_out_nxt}<=COLOR;
                     end
                 else begin
                     red_out_nxt<=red_in;
                     green_out_nxt<=green_in;
                     blue_out_nxt<=blue_in;
                     end
                 end
              else begin
                    red_out_nxt<=red_in;
                    green_out_nxt<=green_in;
                    blue_out_nxt<=blue_in;
                    end     
              end    
      
      
      always @(posedge clk)begin
                if(rst)begin
                   hcount_out<=0;
                   vcount_out<=0;
                   vsync_out<=0;
                   hsync_out<=0;
                   {red_out,green_out,blue_out}<=0;
                   addr<=0;
                   end
                
                if(clk)begin
                   hcount_out<=hcount_2;
                   vcount_out<=vcount_2;
                   vsync_out<=vsync_2;
                   hsync_out<=hsync_2;
                   red_out<=red_out_nxt;
                   green_out<=green_out_nxt;
                   blue_out<=blue_out_nxt;
                   addr<=addr_nxt;
                   end
            end 

assign char_xy[3:0] = ((hcount_in - X_POSITION) >> 4'h3);
assign char_xy[7:4] = ((vcount_in - Y_POSITION) >> 4'h4);
assign char_line = ((vcount_in - Y_POSITION));
  
endmodule