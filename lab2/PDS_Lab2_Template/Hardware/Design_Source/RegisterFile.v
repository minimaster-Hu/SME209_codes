module RegisterFile(
    input CLK,
    input WE3,
    input [3:0] A1,
    input [3:0] A2,
    input [3:0] A3,
    input [31:0] WD3,
    input [31:0] R15,

    output [31:0] RD1,
    output [31:0] RD2
    );
    
    // declare RegBank
    reg [31:0] RegBank[0:14] ;

    wire [31:0] R0 = RegBank[0];
    wire [31:0] R1 = RegBank[1];
    wire [31:0] R2 = RegBank[2];
    wire [31:0] R3 = RegBank[3];
    wire [31:0] R4 = RegBank[4];
    wire [31:0] R5 = RegBank[5];
    wire [31:0] R6 = RegBank[6];
    wire [31:0] R7 = RegBank[7];
    wire [31:0] R8 = RegBank[8];
    wire [31:0] R9 = RegBank[9];
    wire [31:0] R10 = RegBank[10];
    wire [31:0] R11 = RegBank[11];
    wire [31:0] R12 = RegBank[12];
    wire [31:0] R13 = RegBank[13];
    wire [31:0] R14 = RegBank[14];
 
    
endmodule