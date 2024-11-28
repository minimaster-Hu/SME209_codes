module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output reg RegW, 
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg [2:0] RegSrc,
    output reg [1:0] ALUControl,
    output reg [1:0] FlagW,
    output reg NoWrite,
    output reg M_Start,
    output reg MCycleOp,
    output reg M_W
    ); 
    
    reg [1:0] ALUOp; 
    reg [1:0] MCOp;
    reg Branch;

    wire [3:0] Rd;
    wire [1:0] op;
    wire [5:0] Funct;

    assign Rd = Instr[15:12];
    assign op = Instr[27:26];
    assign Funct = Instr[25:20];
    wire [1:0] M_Instr;// 00: NONE , 01: MULTIPLY, 10: DIVIDE
    assign     M_Instr[0] = (Instr[25:21] == 5'b00000  && Instr[7:4] == 4'b1001) ? 1'b1 : 1'b0;
    assign     M_Instr[1] = (Instr[25:20] == 6'b111111 && Instr[7:4] == 4'b1111) ? 1'b1 : 1'b0;
//main decoder
    always @(*) begin
        casex ({op, M_Instr, Funct[5], Funct[3], Funct[0]})
            // DP reg
            7'b00_00_0xx: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_0_0_0_xx_1_000_11_00;
            // DP imm
            7'b00_00_1xx: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_0_0_1_00_1_0x0_11_00;
            // STR posImm
            7'b01_00_x10: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_x_1_1_01_0_010_00_00;
            // STR negImm
            7'b01_00_x00: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_x_1_1_01_0_010_01_00;
            // LDR posImm
            7'b01_00_x11: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_1_0_1_01_1_0x0_00_00;
            // LDR negImm
            7'b01_00_x01: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_1_0_1_01_1_0x0_01_00;
            // Branch
            7'b10_00_xxx: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b1_0_0_1_10_0_0x1_00_00;
            // M_Instr MUL
            7'b00_01_xxx: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_0_0_x_xx_1_10x_00_01;
            // M_Instr DIV
            7'b01_10_xxx: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_0_0_x_xx_1_10x_00_10;
            // Default case
            default: 
                {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp, MCOp} = 14'b0_0_0_0_00_0_000_00_00;
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

    always@(*)begin
        if(MCOp==2'b01)begin
            M_Start=1'b1;
            MCycleOp=1'b0;
            M_W=1'b1;
        end
        else if(MCOp==2'b10)begin
            M_Start=1'b1;
            MCycleOp=1'b1;
            M_W=1'b1;
        end
        else {M_Start,MCycleOp,M_W} = 3'b000;
    end

    assign PCS = ((Rd == 4'd15) & RegW) | Branch;
endmodule