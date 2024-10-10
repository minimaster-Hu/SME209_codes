module seg_decoder (
    input [3:0] char,
    output [6:0] cathode
);
    reg [6:0] decoder;
    assign cathode = decoder;
    always @(*)  begin
        case (char)
		4'd0: decoder = 7'b100_0000;
		4'd1: decoder = 7'b111_1001;
		4'd2: decoder = 7'b010_0100;
		4'd3: decoder = 7'b011_0000;
		4'd4: decoder = 7'b001_1001;
		4'd5: decoder = 7'b001_0010;
		4'd6: decoder = 7'b000_0010;
		4'd7: decoder = 7'b111_1000;
		4'd8: decoder = 7'b000_0000;
		4'd9: decoder = 7'b001_0000;
		4'ha: decoder = 7'b000_1000;
		4'hb: decoder = 7'b000_0011;
		4'hc: decoder = 7'b100_0110;
		4'hd: decoder = 7'b010_0001;
		4'he: decoder = 7'b000_0110;
		4'hf: decoder = 7'b000_1110;
		default:decoder = 7'b100_0000;
        endcase
    end
endmodule