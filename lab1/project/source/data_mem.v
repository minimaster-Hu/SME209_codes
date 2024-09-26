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
    data_mem[0] = 32'hE3A00000;
    data_mem[1] = 32'hE3A00001;
    data_mem[2] = 32'hE3A00020;
    data_mem[3] = 32'hE3A00300;
    data_mem[4] = 32'hE3A04000;
    data_mem[5] = 32'hE3A00005;
    data_mem[6] = 32'hE3A00060;
    data_mem[7] = 32'hE3A00700;
    data_mem[8] = 32'hE3B08000;
    data_mem[9] = 32'h2d2d34fa;
    data_mem[10] = 32'h9f923ef4;
    data_mem[11] = 32'h8ae834d2;
    data_mem[12] = 32'h34339827;
    data_mem[13] = 32'hfef5d252;
    data_mem[14] = 32'h46322d26;
    data_mem[15] = 32'h94f9cd5c;
    data_mem[16] = 32'hd75b0ffa;
    data_mem[17] = 32'h393b2e48;
    data_mem[18] = 32'ha3bb0086;
    data_mem[19] = 32'h5f0e28a0;
    data_mem[20] = 32'h6edc0766;
    data_mem[21] = 32'haa273c80;
    data_mem[22] = 32'he102d64d;
    data_mem[23] = 32'hcc8024b4;
    data_mem[24] = 32'hf073bc0f;
    data_mem[25] = 32'h9cd48177;
    data_mem[26] = 32'hb7816df1;
    data_mem[27] = 32'h9a64c65a;
    data_mem[28] = 32'h2378be20;
    data_mem[29] = 32'h5b0d734c;
    data_mem[30] = 32'h23d05a50;
    data_mem[31] = 32'hb6c2956b;
    data_mem[32] = 32'h09c5a6e5;
    data_mem[33] = 32'he96d66e7;
    data_mem[34] = 32'h469ccb38;
    data_mem[35] = 32'h83da014b;
    data_mem[36] = 32'hf0e6bf8b;
    data_mem[37] = 32'h901e2bc6;
    data_mem[38] = 32'h34c54460;
    data_mem[39] = 32'hd137b394;
    data_mem[40] = 32'h483d20a9;
    data_mem[41] = 32'h7706506d;
    data_mem[42] = 32'hee06980d;
    data_mem[43] = 32'h64750e03;
    data_mem[44] = 32'hc047a155;
    data_mem[45] = 32'h02197902;
    data_mem[46] = 32'h579d454e;
    data_mem[47] = 32'hd11d8b2f;
    data_mem[48] = 32'h86612f3c;
    data_mem[49] = 32'h6217c714;
    data_mem[50] = 32'hb4819f7c;
    data_mem[51] = 32'h4b6d4457;
    data_mem[52] = 32'he73cd882;
    data_mem[53] = 32'h51386d0e;
    data_mem[54] = 32'h2443eca9;
    data_mem[55] = 32'h59fc4e7c;
    data_mem[56] = 32'h72685db4;
    data_mem[57] = 32'hf038400f;
    data_mem[58] = 32'h6b58861f;
    data_mem[59] = 32'h79dbfa60;
    data_mem[60] = 32'h7c234e17;
    data_mem[61] = 32'hbb26cd96;
    data_mem[62] = 32'hc61ad9ce;
    data_mem[63] = 32'h9aa4f91d;
    data_mem[64] = 32'h6610f87a;
    data_mem[65] = 32'h4fff03f0;
    data_mem[66] = 32'hca909fd1;
    data_mem[67] = 32'h17fe4505;

    for(i=68;i<128;i=i+1)begin
        data_mem[i]<=32'h0;
    end    
end
endmodule