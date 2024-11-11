module ControlUnit(
    input [31:0] Instr,
    input [3:0] ALUFlags,
    input CLK,

    output MemtoReg,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [1:0] RegSrc,
    output [1:0] ALUControl,	
    output PCSrc
    ); 
    
    wire [3:0] Cond;
    wire PCS, RegW, MemW,NoWrite;
    wire [1:0] FlagW;

    assign Cond=Instr[31:28];


    CondLogic CondLogic1(
     .CLK(CLK),
     .PCS(PCS),
     .RegW(RegW),
     .MemW(MemW),
     .FlagW(FlagW),
     .Cond(Cond),
     .ALUFlags(ALUFlags),
     .NoWrite(NoWrite),

     .PCSrc(PCSrc),
     .RegWrite(RegWrite),
     .MemWrite(MemWrite)
    );

    Decoder Decoder1(
     .Instr(Instr),
     
     .PCS(PCS),
     .RegW(RegW),
     .MemW(MemW),
     .MemtoReg(MemtoReg),
     .ALUSrc(ALUSrc),
     .ImmSrc(ImmSrc),
     .RegSrc(RegSrc),
     
//     NoWrite,
     .ALUControl(ALUControl),
     .FlagW(FlagW),
     .NoWrite(NoWrite)
    );
endmodule