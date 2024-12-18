module ARM(
    input CLK,
    input Reset,
    input [31:0] Instr,
    input [31:0] ReadData,

    output MemWrite,
    output [31:0] PC,
    output [31:0] OpResult,
    output [31:0] WriteData
); 
    //PC
    wire PCSrc;
    wire [31:0] Result,ALUResult,MCycle_Result;
    wire [31:0] PC_Plus_4;
    wire MemtoReg;
    wire M_Start, Busy, M_Write;
    wire MCycleOp;

    assign OpResult = M_Write? MCycle_Result: ALUResult;
    assign Result = MemtoReg? ReadData: OpResult;

    ProgramCounter u_PC (
        .CLK(CLK),
        .Reset(Reset),
        .PCSrc(PCSrc),
        .Result(Result),
        .Busy(Busy),
        .PC(PC),
        .PC_Plus_4(PC_Plus_4)
    );

    //Control Unit
    wire [3:0] ALUFlags;
    wire [1:0] ALUControl;
    wire ALUSrc;
    wire [1:0] ImmSrc;
    wire RegWrite;
    wire [2:0] RegSrc;

    ControlUnit u_Control (
        .Instr(Instr),
        .ALUFlags(ALUFlags),
        .CLK(CLK),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .RegSrc(RegSrc),
        .ALUControl(ALUControl),
        .PCSrc(PCSrc),
        .M_Start(M_Start),
        .MCycleOp(MCycleOp),
        .M_Write(M_Write)
    );

    //Reg File
    wire [3:0] RA1, RA2, RA3;
    wire [31:0] R15;
    wire [31:0] RD1, RD2;
    assign RA1 = RegSrc[2]? Instr[11:8]: (RegSrc[0]? 4'd15: Instr[19:16]);
    assign RA2 = RegSrc[1]? Instr[15:12]: Instr[3:0];
    assign RA3 = RegSrc[2]? Instr[19:16]: Instr[15:12];
    assign R15 = PC_Plus_4 + 32'd4;
    assign WriteData = RD2;
    RegisterFile u_RegisterFile(
        .CLK(CLK),
        .WE3 (RegWrite),
        .A1(RA1),
        .A2(RA2),
        .A3(RA3),
        .WD3(Result),
        .R15(R15),
        .RD1(RD1),
        .RD2(RD2)
    );

    //Shifter
    wire [1:0] Sh;
    wire [4:0] Shamt5;
    wire [31:0] ShIn;
    wire [31:0] ShOut;
    assign Sh = Instr[6:5];
    assign Shamt5 = Instr[11:7];
    assign ShIn = RD2;

    Shifter Shifter1(
        .Sh(Sh),
        .Shamt5(Shamt5),
        .ShIn(ShIn),
        .ShOut(ShOut)
    );

    //extend
    wire [23:0] InstrImm;
    assign InstrImm = Instr[23:0];
    wire [31:0] ExtImm;

    Extend Extend1 (
        .ImmSrc(ImmSrc),
        .InstrImm(InstrImm),
        .ExtImm(ExtImm)
    );

    //ALU
    wire [31:0] Src_A, Src_B;
    assign Src_A = RD1;
    assign Src_B = ALUSrc? ExtImm: ShOut;

    ALU ALU1 (
        .Src_A(Src_A),
        .Src_B(Src_B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .ALUFlags(ALUFlags)
    );


    MCycle MCycle1 (
        .CLK(CLK),
        .RESET(Reset),
        .Start(M_Start),
        .MCycleOp(MCycleOp),
        .Operand1(RD1),
        .Operand2(RD2),
        .Result(MCycle_Result),
        .Busy(Busy)
    );
endmodule