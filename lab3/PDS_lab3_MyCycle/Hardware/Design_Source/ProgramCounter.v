module ProgramCounter(
    input CLK,
    input Reset,
    input PCSrc,
    input [31:0] Result,
    input Busy,
    
    output [31:0] PC,
    output [31:0] PC_Plus_4
); 
    reg [31:0] current_PC;
    assign PC = current_PC;
    //fill your Verilog code here
    wire[31:0] next_PC;
    assign next_PC = PCSrc ? Result: PC_Plus_4;
    assign PC_Plus_4=current_PC+32'd4;

    always@(posedge CLK or posedge Reset)begin 
        if(Reset)begin
            current_PC<=32'd0;
        end
        else if (!Busy) begin
            current_PC <= next_PC;
        end
        else current_PC<=current_PC;
    end

endmodule
//finished