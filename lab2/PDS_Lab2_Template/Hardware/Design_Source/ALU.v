module ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
    input [1:0] ALUControl,

    output [31:0] ALUResult,
    output [3:0] ALUFlags
    );
    wire [31:0] Src_B_Inv;
    wire [31:0] Sum;
    wire Cout;
    wire [31:0] A_and_B, A_or_B; 
    wire N, Z, C, V;
    assign ALUFlags = {N,Z,C,V};

    assign Src_B_Inv = ALUControl[0]? ~Src_B: Src_B;
    assign {Cout,Sum} = Src_A + Src_B_Inv + ALUControl[0];

    assign A_and_B = Src_A & Src_B;
    assign A_or_B  = Src_A | Src_B;

    //control[1:0] 00:加法 01:减法 10:与 11：或
    assign ALUResult = ALUControl[1]? (ALUControl[0]? A_or_B: A_and_B): Sum;

    assign N = ALUResult[31];
    assign Z = ALUResult == 32'b0;
    assign C = Cout & (~ALUControl[1]);
    assign V = ~(Src_A[31]^Src_B[31]^ALUControl[0]) & (Src_A[31]^Sum[31]) & ~ALUControl[1]; 

    endmodule