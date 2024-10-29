module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output reg RegW, 
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg [2:0] RegSrc,
    output reg ALUControl,
    output reg [1:0] FlagW,
    output reg NoWrite
    ); 
    
    reg [1:0]ALUOp ; 
    reg Branch ;
    wire [1:0] op = Instr[27:26];
    wire[5:0] Funct;
    assign Funct[5:0] = Instr[25:20];

//main decoder
    always @(*) begin
        casex({op,Funct[5],Funct[3],Funct[0]})
            5'b000xx: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0000xx10011; 
            5'b001xx: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0001001x011;
            5'b01x10: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0x110101000;
            5'b01x00: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0x110101001;
            5'b01x11: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0101011x000;
            5'b01x01: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0101011x001;
            5'b10xxx: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b1001100x100;
            default:  {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b00000000000;
        endcase
    end

//ALU decoder
    always @(*) begin
        casex({ALUOp,Funct[4:0]})
            // Not DP
            6'b0xxxxx: {ALUControl,FlagW,NoWrite} = 5'b00000;
            // DP
            6'b101000: {ALUControl,FlagW,NoWrite} = 5'b00000;
            6'b101001: {ALUControl,FlagW,NoWrite} = 5'b00110;
            6'b100100: {ALUControl,FlagW,NoWrite} = 5'b01000;
            6'b100101: {ALUControl,FlagW,NoWrite} = 5'b01110;
            6'b100000: {ALUControl,FlagW,NoWrite} = 5'b10000;
            6'b100001: {ALUControl,FlagW,NoWrite} = 5'b10100;
            6'b111000: {ALUControl,FlagW,NoWrite} = 5'b11000;
            6'b111001: {ALUControl,FlagW,NoWrite} = 5'b11100;
            6'b110101: {ALUControl,FlagW,NoWrite} = 5'b01111;
            6'b110111: {ALUControl,FlagW,NoWrite} = 5'b00111;
            default:    {ALUControl,FlagW,NoWrite} = 5'b00000;
        endcase
    end
endmodule