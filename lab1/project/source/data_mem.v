module data_mem(
    input clk,
    input [6:0] data_addr,
    input rd_en,
    input rst_n,
    output reg [31:0] data_out
);

reg [31:0] data_mem [127:0];

always @(posedge clk or negedge rst_n)	begin
    if(!rst_n)begin
        data_out<=32'b0;  
    end
    else if(rd_en)begin
        data_out<=data_mem[data_addr];
    end
    else begin
        data_out<=data_out;
    end
end

integer i;
initial begin
			data_mem[0] = 32'h00000800; 
			data_mem[1] = 32'hABCD1234; 
			data_mem[2] = 32'h00000001; 
			data_mem[3] = 32'h00000010; 
			data_mem[4] = 32'h00000100; 
			data_mem[5] = 32'h00001000; 
			data_mem[6] = 32'h00010000; 
			data_mem[7] = 32'h00100000; 
			data_mem[8] = 32'h01000000; 
			data_mem[9] = 32'h10000000; 
			data_mem[10] = 32'h01000000; 
			data_mem[11] = 32'h00100000; 
			data_mem[12] = 32'h00010000; 
			data_mem[13] = 32'h00001000; 
			data_mem[14] = 32'h00000100; 
			data_mem[15] = 32'h00000010; 
			data_mem[16] = 32'h00000001; 
			data_mem[17] = 32'h00000002; 
			data_mem[18] = 32'h00000020; 
			data_mem[19] = 32'h00000200; 
			data_mem[20] = 32'h00002000; 
			data_mem[21] = 32'h00020000; 
			data_mem[22] = 32'h00200000; 
			data_mem[23] = 32'h02000000; 
			data_mem[24] = 32'h20000000; 
			data_mem[25] = 32'h02000000; 
			data_mem[26] = 32'h00200000; 
			data_mem[27] = 32'h00020000; 
			data_mem[28] = 32'h00002000; 
			data_mem[29] = 32'h00000200; 
			data_mem[30] = 32'h00000020; 
			data_mem[31] = 32'h00000002; 
			data_mem[32] = 32'h00000003; 
			data_mem[33] = 32'h00000030; 
			data_mem[34] = 32'h00000300; 
			data_mem[35] = 32'h00003000; 
			data_mem[36] = 32'h00030000; 
			data_mem[37] = 32'h00300000; 
			data_mem[38] = 32'h03000000; 
			data_mem[39] = 32'h30000000; 
			data_mem[40] = 32'h03000000; 
			data_mem[41] = 32'h00300000; 
			data_mem[42] = 32'h00030000; 
			data_mem[43] = 32'h00003000; 
			data_mem[44] = 32'h00000300; 
			data_mem[45] = 32'h00000030; 
			data_mem[46] = 32'h00000003; 
			data_mem[47] = 32'h00000004; 
			data_mem[48] = 32'h00000040; 
			data_mem[49] = 32'h00000400; 
			data_mem[50] = 32'h00004000; 
			data_mem[51] = 32'h00040000; 
			data_mem[52] = 32'h00400000; 
			data_mem[53] = 32'h04000000; 
			data_mem[54] = 32'h40000000; 
			data_mem[55] = 32'h04000000; 
			data_mem[56] = 32'h00400000; 
			data_mem[57] = 32'h00040000; 
			data_mem[58] = 32'h00004000; 
			data_mem[59] = 32'h00000400; 
			data_mem[60] = 32'h00000040; 
			data_mem[61] = 32'h00000004; 
			data_mem[62] = 32'h00000005; 
			data_mem[63] = 32'h00000050; 
			data_mem[64] = 32'h00000500; 
			data_mem[65] = 32'h00005000; 
			data_mem[66] = 32'h00050000; 
			data_mem[67] = 32'h00500000; 
			data_mem[68] = 32'h05000000; 
			data_mem[69] = 32'h50000000; 
			data_mem[70] = 32'h05000000; 
			data_mem[71] = 32'h00500000; 
			data_mem[72] = 32'h00050000; 
			data_mem[73] = 32'h00005000; 
			data_mem[74] = 32'h00000500; 
			data_mem[75] = 32'h00000050; 
			data_mem[76] = 32'h00000005; 
			data_mem[77] = 32'h00000006; 
			data_mem[78] = 32'h00000060; 
			data_mem[79] = 32'h00000600; 
			data_mem[80] = 32'h00006000; 
			data_mem[81] = 32'h00060000; 
			data_mem[82] = 32'h00600000; 
			data_mem[83] = 32'h06000000; 
			data_mem[84] = 32'h60000000; 
			data_mem[85] = 32'h06000000; 
			data_mem[86] = 32'h00600000; 
			data_mem[87] = 32'h00060000; 
			data_mem[88] = 32'h00006000; 
			data_mem[89] = 32'h00000600; 
			data_mem[90] = 32'h00000060; 
			data_mem[91] = 32'h00000006; 
			data_mem[92] = 32'h00000007; 
			data_mem[93] = 32'h00000070; 
			data_mem[94] = 32'h00000700; 
			data_mem[95] = 32'h00007000; 
			data_mem[96] = 32'h00070000; 
			data_mem[97] = 32'h00700000; 
			data_mem[98] = 32'h07000000; 
			data_mem[99] = 32'h70000000; 
			data_mem[100] = 32'h07000000; 
			data_mem[101] = 32'h00700000; 
			data_mem[102] = 32'h00070000; 
			data_mem[103] = 32'h00007000; 
			data_mem[104] = 32'h00000700; 
			data_mem[105] = 32'h00000070; 
			data_mem[106] = 32'h00000007; 
			data_mem[107] = 32'h00000008; 
			data_mem[108] = 32'h00000080; 
			data_mem[109] = 32'h00000800; 
			data_mem[110] = 32'h00008000; 
			data_mem[111] = 32'h00080000; 
			data_mem[112] = 32'h00800000; 
			data_mem[113] = 32'h08000000; 
			data_mem[114] = 32'h80000000; 
			data_mem[115] = 32'h08000000; 
			data_mem[116] = 32'h00800000; 
			data_mem[117] = 32'h00080000; 
			data_mem[118] = 32'h00008000; 
			data_mem[119] = 32'h00000800; 
			data_mem[120] = 32'h00000080; 
			data_mem[121] = 32'h00000008; 
			for(i = 122; i < 128; i = i+1) begin 
				data_mem[i] = 32'h0; 
			end
end

endmodule