`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: AGH University of Science and Technology
// Engineer: Filip Ksi�yc & Justyna Rudnicka
// 
// Create Date: 04/14/2020 04:06:24 PM
// Design Name: 
// Module Name: char_rom_16x16_move
// Project Name: TETRIS for BASYS3 designed in Verilog 
// Target Devices: Basys3
// Tool Versions: VIVADO 2017.3 
/// Description: This module generate codes used to read chars from font ROM.
// and generate game instruction. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module char_rom_16x16_move
	(
		input wire clk,
		input wire [7:0] char_xy,
		output reg [6:0] char_code
	);

	reg [6:0] data;

	always @(posedge clk)
		char_code <= data;

	always @*
	begin
		case (char_xy)

			8'h00: data = 7'b1010011; //S
			8'h01: data = 7'b1010100; //T
			8'h02: data = 7'b1000101; //E
			8'h03: data = 7'b1010010; //R
			8'h04: data = 7'b1001111; //O
			8'h05: data = 7'b1010111; //W
			8'h06: data = 7'b1000001; //A
			8'h07: data = 7'b1001110; //N
			8'h08: data = 7'b1001001; //I
			8'h09: data = 7'b1000101; //E
			8'h0a: data = 7'b0111010; //:
			8'h0b: data = 7'b0100000; // 
			8'h0c: data = 7'b0100000; // 
			8'h0d: data = 7'b0100000; // 
			8'h0e: data = 7'b0100000; // 
			8'h0f: data = 7'b0100000; // 
			8'h10: data = 7'b1000101; //E
			8'h11: data = 7'b1001110; //N
			8'h12: data = 7'b1010100; //T
			8'h13: data = 7'b1000101; //E
			8'h14: data = 7'b1010010; //R
			8'h15: data = 7'b0101101; //-
			8'h16: data = 7'b1110101; //u
			8'h17: data = 7'b1111010; //z
			8'h18: data = 7'b1111001; //y
			8'h19: data = 7'b1100011; //c
			8'h1a: data = 7'b1101001; //i
			8'h1b: data = 7'b1100101; //e
			8'h1c: data = 7'b0100000; // 
			8'h1d: data = 7'b1101110; //n
			8'h1e: data = 7'b1100001; //a
			8'h1f: data = 7'b0100000; // 
			8'h20: data = 7'b1100101; //e
			8'h21: data = 7'b1101011; //k
			8'h22: data = 7'b1110010; //r
			8'h23: data = 7'b1100001; //a
			8'h24: data = 7'b1101110; //n
			8'h25: data = 7'b1101001; //i
			8'h26: data = 7'b1100101; //e
			8'h27: data = 7'b0100000; // 
			8'h28: data = 7'b1110100; //t
			8'h29: data = 7'b1111001; //y
			8'h2a: data = 7'b1110100; //t
			8'h2b: data = 7'b1110101; //u
			8'h2c: data = 7'b1101100; //l
			8'h2d: data = 7'b1101111; //o
			8'h2e: data = 7'b1110111; //w
			8'h2f: data = 7'b1111001; //y
			8'h30: data = 7'b1101101; //m
			8'h31: data = 7'b0100000; // 
			8'h32: data = 7'b1101100; //l
			8'h33: data = 7'b1110101; //u
			8'h34: data = 7'b1100010; //b
			8'h35: data = 7'b0100000; // 
			8'h36: data = 7'b1101011; //k
			8'h37: data = 7'b1101111; //o
			8'h38: data = 7'b1101110; //n
			8'h39: data = 7'b1100011; //c
			8'h3a: data = 7'b1101111; //o
			8'h3b: data = 7'b1110111; //w
			8'h3c: data = 7'b1111001; //y
			8'h3d: data = 7'b1101101; //m
			8'h3e: data = 7'b0100000; // 
			8'h3f: data = 7'b1110010; //r
			8'h40: data = 7'b1101111; //o
			8'h41: data = 7'b1111010; //z
			8'h42: data = 7'b1110000; //p
			8'h43: data = 7'b1101111; //o
			8'h44: data = 7'b1100011; //c
			8'h45: data = 7'b1111010; //z
			8'h46: data = 7'b1111001; //y
			8'h47: data = 7'b1101110; //n
			8'h48: data = 7'b1100001; //a
			8'h49: data = 7'b0100000; // 
			8'h4a: data = 7'b1101110; //n
			8'h4b: data = 7'b1101111; //o
			8'h4c: data = 7'b1110111; //w
			8'h4d: data = 7'b1100001; //a
			8'h4e: data = 7'b0100000; // 
			8'h4f: data = 7'b1100111; //g
			8'h50: data = 7'b1110010; //r
			8'h51: data = 7'b1100101; //e
			8'h52: data = 7'b0100000; // 
			8'h53: data = 7'b1010111; //W
			8'h54: data = 7'b0101101; //-
			8'h55: data = 7'b1110010; //r
			8'h56: data = 7'b1101111; //o
			8'h57: data = 7'b1110100; //t
			8'h58: data = 7'b1100001; //a
			8'h59: data = 7'b1100011; //c
			8'h5a: data = 7'b1101010; //j
			8'h5b: data = 7'b1100001; //a
			8'h5c: data = 7'b0100000; // 
			8'h5d: data = 7'b1101011; //k
			8'h5e: data = 7'b1101100; //l
			8'h5f: data = 7'b1101111; //o
			8'h60: data = 7'b1100011; //c
			8'h61: data = 7'b1101011; //k
			8'h62: data = 7'b1100001; //a
			8'h63: data = 7'b0100000; // 
			8'h64: data = 7'b1110111; //w
			8'h65: data = 7'b0100000; // 
			8'h66: data = 7'b1110000; //p
			8'h67: data = 7'b1110010; //r
			8'h68: data = 7'b1100001; //a
			8'h69: data = 7'b1110111; //w
			8'h6a: data = 7'b1101111; //o
			8'h6b: data = 7'b0100000; // 
			8'h6c: data = 7'b1010011; //S
			8'h6d: data = 7'b0101101; //-
			8'h6e: data = 7'b1110010; //r
			8'h6f: data = 7'b1101111; //o
			8'h70: data = 7'b1110100; //t
			8'h71: data = 7'b1100001; //a
			8'h72: data = 7'b1100011; //c
			8'h73: data = 7'b1101010; //j
			8'h74: data = 7'b1100001; //a
			8'h75: data = 7'b0100000; // 
			8'h76: data = 7'b1101011; //k
			8'h77: data = 7'b1101100; //l
			8'h78: data = 7'b1101111; //o
			8'h79: data = 7'b1100011; //c
			8'h7a: data = 7'b1101011; //k
			8'h7b: data = 7'b1100001; //a
			8'h7c: data = 7'b0100000; // 
			8'h7d: data = 7'b1110111; //w
			8'h7e: data = 7'b0100000; // 
			8'h7f: data = 7'b1101100; //l
			8'h80: data = 7'b1100101; //e
			8'h81: data = 7'b1110111; //w
			8'h82: data = 7'b1101111; //o
			8'h83: data = 7'b0100000; // 
			8'h84: data = 7'b1000001; //A
			8'h85: data = 7'b0101101; //-
			8'h86: data = 7'b1110000; //p
			8'h87: data = 7'b1110010; //r
			8'h88: data = 7'b1111010; //z
			8'h89: data = 7'b1100101; //e
			8'h8a: data = 7'b1110011; //s
			8'h8b: data = 7'b1110101; //u
			8'h8c: data = 7'b1101110; //n
			8'h8d: data = 7'b1101001; //i
			8'h8e: data = 7'b1100101; //e
			8'h8f: data = 7'b1100011; //c
			8'h90: data = 7'b1101001; //i
			8'h91: data = 7'b1100101; //e
			8'h92: data = 7'b0100000; // 
			8'h93: data = 7'b1101011; //k
			8'h94: data = 7'b1101100; //l
			8'h95: data = 7'b1101111; //o
			8'h96: data = 7'b1100011; //c
			8'h97: data = 7'b1101011; //k
			8'h98: data = 7'b1100001; //a
			8'h99: data = 7'b0100000; // 
			8'h9a: data = 7'b1110111; //w
			8'h9b: data = 7'b0100000; // 
			8'h9c: data = 7'b1101100; //l
			8'h9d: data = 7'b1100101; //e
			8'h9e: data = 7'b1110111; //w
			8'h9f: data = 7'b1101111; //o
			8'ha0: data = 7'b0100000; // 
			8'ha1: data = 7'b1000100; //D
			8'ha2: data = 7'b0101101; //-
			8'ha3: data = 7'b1110000; //p
			8'ha4: data = 7'b1110010; //r
			8'ha5: data = 7'b1111010; //z
			8'ha6: data = 7'b1100101; //e
			8'ha7: data = 7'b1110011; //s
			8'ha8: data = 7'b1110101; //u
			8'ha9: data = 7'b1101110; //n
			8'haa: data = 7'b1101001; //i
			8'hab: data = 7'b1100101; //e
			8'hac: data = 7'b1100011; //c
			8'had: data = 7'b1101001; //i
			8'hae: data = 7'b1100101; //e
			8'haf: data = 7'b0100000; // 
			8'hb0: data = 7'b1101011; //k
			8'hb1: data = 7'b1101100; //l
			8'hb2: data = 7'b1101111; //o
			8'hb3: data = 7'b1100011; //c
			8'hb4: data = 7'b1101011; //k
			8'hb5: data = 7'b1100001; //a
			8'hb6: data = 7'b0100000; // 
			8'hb7: data = 7'b1110111; //w
			8'hb8: data = 7'b0100000; // 
			8'hb9: data = 7'b1110000; //p
			8'hba: data = 7'b1110010; //r
			8'hbb: data = 7'b1100001; //a
			8'hbc: data = 7'b1110111; //w
			8'hbd: data = 7'b1101111; //o
			8'hbe: data = 7'b0100000; // 
			8'hbf: data = 7'b1010011; //S
			8'hc0: data = 7'b1010000; //P
			8'hc1: data = 7'b1000001; //A
			8'hc2: data = 7'b1000011; //C
			8'hc3: data = 7'b1001010; //J
			8'hc4: data = 7'b1000001; //A
			8'hc5: data = 7'b0101101; //-
			8'hc6: data = 7'b1110111; //w
			8'hc7: data = 7'b1111001; //y
			8'hc8: data = 7'b1101101; //m
			8'hc9: data = 7'b1110101; //u
			8'hca: data = 7'b1110011; //s
			8'hcb: data = 7'b1111010; //z
			8'hcc: data = 7'b1100101; //e
			8'hcd: data = 7'b1101110; //n
			8'hce: data = 7'b1101001; //i
			8'hcf: data = 7'b1100101; //e
			8'hd0: data = 7'b0100000; // 
			8'hd1: data = 7'b1110011; //s
			8'hd2: data = 7'b1110000; //p
			8'hd3: data = 7'b1100001; //a
			8'hd4: data = 7'b1100100; //d
			8'hd5: data = 7'b1101110; //n
			8'hd6: data = 7'b1101001; //i
			8'hd7: data = 7'b1100101; //e
			8'hd8: data = 7'b1100011; //c
			8'hd9: data = 7'b1101001; //i
			8'hda: data = 7'b1100001; //a
			8'hdb: data = 7'b0100000; // 
			8'hdc: data = 7'b1101011; //k
			8'hdd: data = 7'b1101100; //l
			8'hde: data = 7'b1101111; //o
			8'hdf: data = 7'b1100011; //c
			8'he0: data = 7'b1101011; //k
			8'he1: data = 7'b1100001; //a
			8'he2: data = 7'b0100000; // 
			8'he3: data = 7'b1110111; //w
			8'he4: data = 7'b0100000; // 
			8'he5: data = 7'b1100100; //d
			8'he6: data = 7'b1101111; //o
			8'he7: data = 7'b1101100; //l
			8'he8: data = 7'b0000000; //PUSTY ZNAK
			8'he9: data = 7'b0000000; //PUSTY ZNAK
			8'hea: data = 7'b0000000; //PUSTY ZNAK
			8'heb: data = 7'b0000000; //PUSTY ZNAK
			8'hec: data = 7'b0000000; //PUSTY ZNAK
			8'hed: data = 7'b0000000; //PUSTY ZNAK
			8'hee: data = 7'b0000000; //PUSTY ZNAK
			8'hef: data = 7'b0000000; //PUSTY ZNAK
			8'hf0: data = 7'b0000000; //PUSTY ZNAK
			8'hf1: data = 7'b0000000; //PUSTY ZNAK
			8'hf2: data = 7'b0000000; //PUSTY ZNAK
			8'hf3: data = 7'b0000000; //PUSTY ZNAK
			8'hf4: data = 7'b0000000; //PUSTY ZNAK
			8'hf5: data = 7'b0000000; //PUSTY ZNAK
			8'hf6: data = 7'b0000000; //PUSTY ZNAK
			8'hf7: data = 7'b0000000; //PUSTY ZNAK
			8'hf8: data = 7'b0000000; //PUSTY ZNAK
			8'hf9: data = 7'b0000000; //PUSTY ZNAK
			8'hfa: data = 7'b0000000; //PUSTY ZNAK
			8'hfb: data = 7'b0000000; //PUSTY ZNAK
			8'hfc: data = 7'b0000000; //PUSTY ZNAK
			8'hfd: data = 7'b0000000; //PUSTY ZNAK
			8'hfe: data = 7'b0000000; //PUSTY ZNAK
			8'hff: data = 7'b0000000; //PUSTY ZNAK

		endcase
	end
endmodule
