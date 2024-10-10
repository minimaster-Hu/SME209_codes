`timescale 1ns / 1ps

module instr_mem(
    input clk,
    input [6:0] instr_addr,
    input rd_en,
    input rst_n,
    output reg [31:0] instr_out
);

// TODO  
reg [31:0] instr_mem [127:0];

always @(posedge clk or negedge rst_n)	begin
    if(!rst_n)begin
        instr_out<=32'b0;  
    end
    else if(rd_en)begin
        instr_out<=instr_mem[instr_addr];
    end
    else begin
        instr_out<=instr_out;
    end
end

integer i;
initial begin
			instr_mem[0] = 32'hE3A00000; 
			instr_mem[1] = 32'hE1A0100F; 
			instr_mem[2] = 32'hE0800001; 
			instr_mem[3] = 32'hE2511001; 
			instr_mem[4] = 32'h1AFFFFFC; 
			instr_mem[5] = 32'hE59F01E8; 
			instr_mem[6] = 32'hE58F57E0; 
			instr_mem[7] = 32'hE59F57DC; 
			instr_mem[8] = 32'hE59F21D8; 
			instr_mem[9] = 32'hE5820000; 
			instr_mem[10] = 32'hE5820004; 
			instr_mem[11] = 32'hE0800001; 
			instr_mem[12] = 32'hE2511001; 
			instr_mem[13] = 32'h1AFFFFFC; 
			instr_mem[14] = 32'hE59F01C4; 
			instr_mem[15] = 32'hE58F57BC; 
			instr_mem[16] = 32'hE59F57B8; 
			instr_mem[17] = 32'hE59F21B4; 
			instr_mem[18] = 32'hE5820000; 
			instr_mem[19] = 32'hE5820004; 
			instr_mem[20] = 32'hE0800001; 
			instr_mem[21] = 32'hE2511001; 
			instr_mem[22] = 32'h1AFFFFFC; 
			instr_mem[23] = 32'hE59F01A0; 
			instr_mem[24] = 32'hE58F5798; 
			instr_mem[25] = 32'hE59F5794; 
			instr_mem[26] = 32'hE59F2190; 
			instr_mem[27] = 32'hE5820000; 
			instr_mem[28] = 32'hE5820004; 
			instr_mem[29] = 32'hE0800001; 
			instr_mem[30] = 32'hE2511001; 
			instr_mem[31] = 32'h1AFFFFFC; 
			instr_mem[32] = 32'hE59F017C; 
			instr_mem[33] = 32'hE58F5774; 
			instr_mem[34] = 32'hE59F5770; 
			instr_mem[35] = 32'hE59F216C; 
			instr_mem[36] = 32'hE5820000; 
			instr_mem[37] = 32'hE5820004; 
			instr_mem[38] = 32'hE0800001; 
			instr_mem[39] = 32'hE2511001; 
			instr_mem[40] = 32'h1AFFFFFC; 
			instr_mem[41] = 32'hE59F0158; 
			instr_mem[42] = 32'hE58F5750; 
			instr_mem[43] = 32'hE59F574C; 
			instr_mem[44] = 32'hE59F2148; 
			instr_mem[45] = 32'hE5820000; 
			instr_mem[46] = 32'hE5820004; 
			instr_mem[47] = 32'hEAFFFFFE; 
			for(i = 48; i < 128; i = i+1) begin 
				instr_mem[i] = 32'h0; 
			end
end

endmodule
