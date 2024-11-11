module Shifter(
    input [1:0] Sh,
    input [4:0] Shamt5,
    input [31:0] ShIn,
    
    output reg [31:0] ShOut
    );

    wire[31:0] LSLA,LSLB,LSLC,LSLD,LSLOUT;
    assign LSLA=Shamt5[4]?{ShIn[15:0],{16{1'b0}}}: ShIn;
    assign LSLB=Shamt5[3]?{LSLA[23:0],{8{1'b0}}}: LSLA;
    assign LSLC=Shamt5[2]?{LSLB[27:0],{4{1'b0}}}: LSLB;
    assign LSLD=Shamt5[1]?{LSLC[29:0],{2{1'b0}}}: LSLC;
    assign LSLOUT=Shamt5[0]?{LSLD[30:0],{1{1'b0}}}: LSLD;


    wire[31:0] LSRA,LSRB,LSRC,LSRD,LSROUT;
    assign LSRA=Shamt5[4]?{{16{1'b0}},ShIn[31:16]}: ShIn;
    assign LSRB=Shamt5[3]?{{8{1'b0}},LSRA[31:8]}: LSRA;
    assign LSRC=Shamt5[2]?{{4{1'b0}},LSRB[31:4]}: LSRB;
    assign LSRD=Shamt5[1]?{{2{1'b0}},LSRC[31:2]}: LSRC;
    assign LSROUT=Shamt5[0]?{{1{1'b0}},LSRD[31:1]}: LSRD;


    wire[31:0] ASRA,ASRB,ASRC,ASRD,ASROUT;
    assign ASRA=Shamt5[4]?{{16{ShIn[31]}},ShIn[31:16]}: ShIn;
    assign ASRB=Shamt5[3]?{{8{ASRA[31]}},ASRA[31:16]}: ASRA;
    assign ASRC=Shamt5[2]?{{4{ASRB[31]}},ASRB[31:16]}: ASRB;
    assign ASRD=Shamt5[1]?{{2{ASRC[31]}},ASRC[31:16]}: ASRC;
    assign ASROUT=Shamt5[0]?{{{ASRD[31]}},ASRD[31:16]}: ASRD;


    wire[31:0] RORA,RORB,RORC,RORD,ROROUT;
    assign RORA=Shamt5[4]?{ShIn[15:0],ShIn[31:16]}: ShIn;
    assign RORB=Shamt5[3]?{RORA[15:0],RORA[31:16]}: RORA;
    assign RORC=Shamt5[2]?{RORB[15:0],RORB[31:16]}: RORB;
    assign RORD=Shamt5[1]?{RORC[15:0],RORC[31:16]}: RORC;
    assign ROROUT=Shamt5[0]?{RORD[15:0],RORD[31:16]}: RORD;

    always @(*) begin
        case (Sh)
            2'b00: ShOut[31:0] = LSLOUT[31:0];
            2'b01: ShOut[31:0] = LSROUT[31:0];
            2'b10: ShOut[31:0] = ASROUT[31:0];
            2'b11: ShOut[31:0] = ROROUT[31:0];
            default: ShOut = 32'h0;
        endcase
    end

endmodule 
