module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output reg RegW, 
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg [2:0] RegSrc,
    output reg [1:0]ALUControl,
    output reg [1:0] FlagW,
    output reg NoWrite
    ); 
    
    reg ALUOp ; 
    reg Branch ;
    wire [1:0] op = Instr[27:26];
    wire[5:0] Funct;
    assign Funct[5:0] = Instr[25:20];

//main decoder
    always @(*) begin
        casex({op,Funct[5],Funct[0]})
            4'b000x: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0000xx1001; 
            4'b001x: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0001001x01;
            4'b01x0: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0x11010100;
            4'b01x0: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0x11010100;
            4'b01x1: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0101011x00;
            4'b10xx: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b1001100x10;
            default: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0000000000;
        endcase
    end

//ALU decoder
    always @(*) begin
        casex({ALUOp,Funct[4:0]})
            // Not DP
            7'b0xxxxx: {ALUControl,FlagW,NoWrite} = 5'b00000;
            // DP
            7'b1101000: {ALUControl,FlagW,NoWrite} = 5'b00000;
            7'b1101001: {ALUControl,FlagW,NoWrite} = 5'b00110;
            7'b1100100: {ALUControl,FlagW,NoWrite} = 5'b01000;
            7'b1100101: {ALUControl,FlagW,NoWrite} = 5'b01110;
            7'b1100000: {ALUControl,FlagW,NoWrite} = 5'b10000;
            7'b1100001: {ALUControl,FlagW,NoWrite} = 5'b10100;
            7'b1111000: {ALUControl,FlagW,NoWrite} = 5'b11000;
            7'b1111001: {ALUControl,FlagW,NoWrite} = 5'b11100;
            // CMP/CMN
            7'b1110101: {ALUControl,FlagW,NoWrite} = 5'b01111;
            7'b1110111: {ALUControl,FlagW,NoWrite} = 5'b00111;
            default:    {ALUControl,FlagW,NoWrite} = 5'b00000;
        endcase
    end
endmodule