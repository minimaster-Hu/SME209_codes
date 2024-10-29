module ProgramCounter(
    input CLK,
    input Reset,
    input PCSrc,
    input [31:0] Result,
    
    output reg [31:0] PC,
    output [31:0] PC_Plus_4
); 

//fill your Verilog code here
wire[31:0] next_pc;
assign next_PC = PCSrc ? Result: PC_Plus_4;
assign PC_Plus_4=PC+3'd4;

always@(posedge CLK or negedge Reset)begin 
    if(!Reset)begin
        PC<=32'b0;
    end
    else PC<=next_pc;
end

endmodule
//finished