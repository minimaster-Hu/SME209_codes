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
    instr_mem[1] = 32'hE3A00001;
    instr_mem[2] = 32'hE3A00020;
    instr_mem[3] = 32'hE3A00300;
    instr_mem[4] = 32'hE3A04000;
    instr_mem[5] = 32'hE3A00005;
    instr_mem[6] = 32'hE3A00060;
    instr_mem[7] = 32'hE3A00700;
    instr_mem[8] = 32'hE3B08000;
    instr_mem[9] = 32'hE86fffb49;
    instr_mem[10] = 32'h0e915bec;
    instr_mem[11] = 32'haee3a86d;
    instr_mem[12] = 32'hd89674f1;
    instr_mem[13] = 32'haeb02a69;
    instr_mem[14] = 32'h53045770;
    instr_mem[15] = 32'h679c810a;
    instr_mem[16] = 32'hd75b0ffa;
    instr_mem[17] = 32'h393b2e48;
    instr_mem[18] = 32'ha3bb0086;
    instr_mem[19] = 32'h5f0e28a0;
    instr_mem[20] = 32'h6edc0766;
    instr_mem[21] = 32'haa273c80;
    instr_mem[22] = 32'he102d64d;
    instr_mem[23] = 32'hcc8024b4;
    instr_mem[24] = 32'hf073bc0f;
    instr_mem[25] = 32'h9cd48177;
    instr_mem[26] = 32'h5deb71ff;
    instr_mem[27] = 32'h9a64c65a;
    instr_mem[28] = 32'h3fbbbdb1;
    instr_mem[29] = 32'h5b0d734c;
    instr_mem[30] = 32'h23d05a50;
    instr_mem[31] = 32'hb6c2956b;
    instr_mem[32] = 32'h09c5a6e5;
    instr_mem[33] = 32'he96d66e7;
    instr_mem[34] = 32'h469ccb38;
    instr_mem[35] = 32'h671141e5;
    instr_mem[36] = 32'hf0e6bf8b;
    instr_mem[37] = 32'h3f7bf0fe;
    instr_mem[38] = 32'h34c54460;
    instr_mem[39] = 32'hd137b394;
    instr_mem[40] = 32'h483d20a9;
    instr_mem[41] = 32'h242a2fad;
    instr_mem[42] = 32'hee06980d;
    instr_mem[43] = 32'hd2b9973d;
    instr_mem[44] = 32'hc047a155;
    instr_mem[45] = 32'h02197902;
    instr_mem[46] = 32'h579d454e;
    instr_mem[47] = 32'h31b96c9b;
    instr_mem[48] = 32'h38f9dd78;
    instr_mem[49] = 32'h72fae0d2;
    instr_mem[50] = 32'hb4819f7c;
    instr_mem[51] = 32'h3e9582a3;
    instr_mem[52] = 32'he73cd882;
    
    for(i=53;i<128;i=i+1)begin
        instr_mem[i]<=32'h0;
    end    
end
endmodule
