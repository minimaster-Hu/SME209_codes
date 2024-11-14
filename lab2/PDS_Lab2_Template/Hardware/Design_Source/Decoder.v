module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output reg RegW, 
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg [1:0] RegSrc,
    output reg [1:0] ALUControl,
    output reg [1:0] FlagW,
    output reg NoWrite
    ); 
    
    reg [1:0] ALUOp; 
    reg Branch;

    wire [3:0] Rd;
    wire [1:0] op;
    wire [5:0] Funct;

    assign Rd = Instr[15:12];
    assign op = Instr[27:26];
    assign Funct = Instr[25:20];
//main decoder
    always @(*) begin
        casex({op,Funct[5],Funct[3],Funct[0]})
            // DP reg
            5'b00_0xx: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0000_xx100_11; 
            // DP imm
            5'b00_1xx: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0001_001x0_11;
            // STR posImm
            5'b01_x10: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0x11_01010_00;
            // STR negImm
            5'b01_x00: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0x11_01010_01;
            // LDR posImm
            5'b01_x11: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0101_011x0_00;
            // LDR negImm
            5'b01_x01: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0101_011x0_01;
            // Branch
            5'b10_xxx: {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b1001_100x1_00;

            default:  {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = 11'b0000_00000_00;
        endcase
    end

//ALU decoder
    always @(*) begin
        casex({ALUOp[1:0],Funct[4:0]})
            // Not DP
            7'b00xxxxx: {ALUControl,FlagW,NoWrite} = 5'b00_00_0;
            7'b01xxxxx: {ALUControl,FlagW,NoWrite} = 5'b01_00_0; 
            // DP
            7'b1101000: {ALUControl,FlagW,NoWrite} = 5'b00_00_0;
            7'b1101001: {ALUControl,FlagW,NoWrite} = 5'b00_11_0;
            7'b1100100: {ALUControl,FlagW,NoWrite} = 5'b01_00_0;
            7'b1100101: {ALUControl,FlagW,NoWrite} = 5'b01_11_0;
            7'b1100000: {ALUControl,FlagW,NoWrite} = 5'b10_00_0;
            7'b1100001: {ALUControl,FlagW,NoWrite} = 5'b10_10_0;
            7'b1111000: {ALUControl,FlagW,NoWrite} = 5'b11_00_0;
            7'b1111001: {ALUControl,FlagW,NoWrite} = 5'b11_10_0;
            // CMP/CMN
            7'b1110101: {ALUControl,FlagW,NoWrite} = 5'b01_11_1;
            7'b1110111: {ALUControl,FlagW,NoWrite} = 5'b00_11_1;
            default:    {ALUControl,FlagW,NoWrite} = 5'b00_00_0;
        endcase
    end

    assign PCS = ((Rd == 4'd15) & RegW) | Branch;
endmodule