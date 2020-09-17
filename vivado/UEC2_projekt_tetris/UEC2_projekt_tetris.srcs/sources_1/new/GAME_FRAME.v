`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2020 02:23:40 PM
// Design Name: 
// Module Name: GAME_FRAME
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


module GAME_FRAME(
    input wire clk,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire hsync,
    input wire vsync,
    input wire hblnk,
    input wire vblnk,
    input wire reset,
    input wire [3:0] VGARed,
    input wire [3:0] VGAGreen,
    input wire [3:0] VGABlue,
    input wire [3:0] state,
    
    output reg [3:0] VGARed_out,
    output reg [3:0] VGAGreen_out,
    output reg [3:0] VGABlue_out,
    output reg [10:0] hcount_out,
    output reg [10:0] vcount_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg hblnk_out,
    output reg vblnk_out
    );

localparam TITLESCREEN=0,GAME_OVER=5;

reg [3:0] VGARed_nxt, VGAGreen_nxt, VGABlue_nxt;

always @* begin
    if(reset) begin
        VGARed_nxt = 0;
        VGAGreen_nxt = 0;
        VGABlue_nxt = 0;
        end
    else begin
        if(hblnk||vblnk)begin
            VGARed_nxt = 0;
            VGAGreen_nxt = 0;
            VGABlue_nxt = 0;
            end
        else begin
           if((hcount>63)&&(hcount<576))begin
               VGARed_nxt = VGARed;
               VGAGreen_nxt = VGAGreen;
               VGABlue_nxt = VGABlue;
               
               if(state==TITLESCREEN)begin
                    if((hcount>93&&hcount<154&&vcount>323&&vcount<345)||(hcount>113&&hcount<133&&vcount>343&&vcount<424))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=4'b1111;
                        VGABlue_nxt=0;
                    end
                    else if((hcount>164&&hcount<224&&vcount>323&vcount<343)||(hcount>164&&hcount<184&&vcount>323&&vcount<424)||(hcount>164&&hcount<224&&vcount>363&vcount<384)||(hcount>164&&hcount<224&&vcount>403&vcount<424))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=0;      
                    end
                    else if((hcount>244&&hcount<304&&vcount>323&&vcount<345)||(hcount>264&&hcount<284&&vcount>343&&vcount<423))begin
                        VGARed_nxt=0;
                        VGAGreen_nxt=4'b1111;
                        VGABlue_nxt=0;
                    end
                    else if((hcount>324&&hcount<344&&vcount>343&&vcount<423)||(hcount>324&&hcount<384&&vcount>323&&vcount<344)||(hcount>324&&hcount<384&&vcount>373&&vcount<393)||(hcount>363&&hcount<384&&vcount>343&&vcount<374)||(hcount>343&&hcount<384&&vcount>=(hcount+35)&&vcount<=(hcount+50)))begin
                        VGARed_nxt=0;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=4'b1111;
                    end
                    else if(hcount>404&&hcount<434&&vcount>323&&vcount<424)begin
                        VGARed_nxt=15;
                        VGAGreen_nxt=7;
                        VGABlue_nxt=0;    
                    end
                    else if((hcount>453&&hcount<474&&vcount>323&&vcount<374)||(hcount>453&&hcount<514&&vcount>323&&vcount<344)||(hcount>493&&hcount<514&&vcount>373&&vcount<424)||(hcount>453&&hcount<514&&vcount>403&&vcount<424)||(hcount>453&&hcount<514&&vcount>363&&vcount<384))begin
                       VGARed_nxt=0;
                       VGAGreen_nxt=4'b1111;
                       VGABlue_nxt=0; 
                    end
                    else begin
                        VGARed_nxt = 0;
                        VGAGreen_nxt = 0;
                        VGABlue_nxt = 0;
                        end
                    end
               else if(state==GAME_OVER)begin
                    if((hcount>163&&hcount<184&&vcount>223&vcount<324)||(hcount>183&&hcount<214&&vcount>303&&vcount<324)||(hcount>183&&hcount<214&&vcount>223&&vcount<244)||(hcount>203&&hcount<214&&vcount>283&&vcount<304)||(hcount>203&&hcount<214&&vcount>223&&vcount<264)||(hcount>193&&hcount<224&&vcount>283&&vcount<294))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=0;          
                    end
                    else if((hcount>243&&hcount<264&&vcount>223&&vcount<324)||(hcount>243&&hcount<304&&vcount>223&&vcount<244)||(hcount>244&&hcount<304&&vcount>263&&vcount<283)||(hcount>283&&hcount<304&&vcount>223&&vcount<324))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=0;
                    end
                    else if((hcount>323&&hcount<334&&vcount>223&&vcount<324)||(hcount>373&&hcount<384&&vcount>223&&vcount<324)||(hcount>333&&hcount<354&&vcount<=(hcount-100)&&vcount>=(hcount-110)||(hcount>353&&hcount<374&&vcount>=(597-hcount)&&vcount<=(606-hcount))))begin
                          VGARed_nxt=4'b1111;
                          VGAGreen_nxt=0;
                          VGABlue_nxt=0;  
                    end
                    else if((hcount>403 && hcount<464 && vcount>223&vcount<243)||(hcount>403&&hcount<424&&vcount>223&&vcount<324)||(hcount>403 && hcount<464&&vcount>263&vcount<284)||(hcount>403 && hcount<464&&vcount>303&vcount<324))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=0;      
                    end
                    else if((hcount>163&&hcount<184&&vcount>343&&vcount<444)||(hcount>203&&hcount<224&&vcount>344&&vcount<444)||(hcount>163&&hcount<224&vcount>343&&vcount<364)||(hcount>163&&hcount<224&&vcount>423&&vcount<444))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=0;
                    end
                    else if((hcount>233&&hcount<244&&vcount>343&&vcount<424)||(hcount>273&&hcount<284&&vcount>343&&vcount<424)||(hcount>233&&hcount<259&&vcount>=(((4*hcount)/3)+99)&&vcount<=(((4*hcount)/3)+109))||(hcount>258&&hcount<284&&vcount>=(787-((4*hcount)/3))&&vcount<=(797-((4*hcount)/3))))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=0;
                    end
                    else if((hcount>303 && hcount<364 && vcount>343&vcount<363)||(hcount>303&&hcount<324&&vcount>343&&vcount<444)||(hcount>303 && hcount<364&&vcount>383&vcount<404)||(hcount>303 && hcount<364&&vcount>423&&vcount<444))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=0;      
                    end
                    else if((hcount>383&&hcount<404&&vcount>343&&vcount<444)||(hcount>383&&hcount<444&&vcount>343&&vcount<364)||(hcount>383&&hcount<444&&vcount>383&&vcount<404)||(hcount>423&&hcount<444&&vcount>343&&vcount<404)||(hcount>403&&hcount<444&&vcount<=(hcount+10)&&vcount>=(hcount-5)&&vcount<444))begin
                        VGARed_nxt=4'b1111;
                        VGAGreen_nxt=0;
                        VGABlue_nxt=0;
                    end
                    else begin
                        VGARed_nxt = 0;
                        VGAGreen_nxt = 0;
                        VGABlue_nxt = 0;
                    end
               end     
               else begin
                   VGARed_nxt = VGARed;
                   VGAGreen_nxt = VGAGreen;
                   VGABlue_nxt = VGABlue;
               end
               end
           else begin
               VGARed_nxt = 8;
               VGAGreen_nxt = 8; 
               VGABlue_nxt = 8;
           end
        end
    end   
end

always @(posedge clk)begin
        VGARed_out <= VGARed_nxt;
        VGAGreen_out <= VGAGreen_nxt;
        VGABlue_out <= VGABlue_nxt;
        hcount_out <= hcount;
        vcount_out <= vcount;
        hsync_out <= hsync;
        vsync_out <= vsync;
        hblnk_out <= hblnk;
        vblnk_out <= vblnk;
end

endmodule
