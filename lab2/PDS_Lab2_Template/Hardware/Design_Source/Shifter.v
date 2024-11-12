module Shifter(
    input [1:0] Sh,     //00-LSL//01-LSR//10-ASR//11-ROR
    input [4:0] Shamt5,
    input [31:0] ShIn,
    
    output reg [31:0] ShOut
    );
  
    wire [31:0]LSL,LSR,ASR,ROR;
    wire [31:0]LSL1,LSL2,LSL3,LSL4,LSL5;
    wire [31:0]LSR1,LSR2,LSR3,LSR4,LSR5;
    wire [31:0]ASR1,ASR2,ASR3,ASR4,ASR5;
    wire [31:0]ROR1,ROR2,ROR3,ROR4,ROR5;
    
    assign LSL1 = Shamt5[4] ? {ShIn[15:0],{16{1'b0}}} : ShIn;
    assign LSL2 = Shamt5[3] ? {LSL1[23:0],{8{1'b0}}} : LSL1;
    //11abcdef----cdef0000----ef000000----f0000000
    assign LSL3 = Shamt5[2] ? {LSL2[27:0],{4{1'b0}}} : LSL2;
    assign LSL4 = Shamt5[1] ? {LSL3[29:0],{2{1'b0}}} : LSL3;
    assign LSL5 = Shamt5[0] ? {LSL4[30:0],{1{1'b0}}} : LSL4;
    
    assign LSR1 = Shamt5[4] ? {{16{1'b0}},ShIn[31:16]} : ShIn;
    assign LSR2 = Shamt5[3] ? {{8{1'b0}},LSR1[31:8]} : LSR1;
    assign LSR3 = Shamt5[2] ? {{4{1'b0}},LSR2[31:4]} : LSR2;
    assign LSR4 = Shamt5[1] ? {{2{1'b0}},LSR3[29:2]} : LSR3;
    assign LSR5 = Shamt5[0] ? {{1{1'b0}},LSR4[30:1]} : LSR4;
    
    assign ASR1 = Shamt5[4] ? {{16{ShIn[31]}},ShIn[31:16]} : ShIn;
    assign ASR2 = Shamt5[3] ? {{8{ASR1[31]}},ASR1[31:8]} : ASR1;
    assign ASR3 = Shamt5[2] ? {{4{ASR2[31]}},ASR2[31:4]} : ASR2;
    assign ASR4 = Shamt5[1] ? {{2{ASR3[31]}},ASR3[31:2]} : ASR3;
    assign ASR5 = Shamt5[0] ? {{1{ASR4[31]}},ASR4[31:1]} : ASR4;
    
    assign ROR1 = Shamt5[4] ? {ShIn[15:0],ShIn[31:16]} : ShIn;
    assign ROR2 = Shamt5[3] ? {ROR1[7:0],ROR1[31:8]} : ROR1;
    assign ROR3 = Shamt5[2] ? {ROR2[3:0],ROR1[31:4]} : ROR2;
    assign ROR4 = Shamt5[1] ? {ROR3[1:0],ROR1[31:2]} : ROR3;
    assign ROR5 = Shamt5[0] ? {ROR4[0],ROR1[31:1]} : ROR4;
    
    always@(*)begin
        case(Sh)
            2'b00: ShOut = LSL5;
            2'b01: ShOut = LSR5;
            2'b10: ShOut = ASR5;
            2'b11: ShOut = ROR5;
            default: ShOut = 32'h0;
            endcase
    end
endmodule 
