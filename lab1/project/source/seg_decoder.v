module seg_decoder (
    input [3:0] char,
    output [6:0] cathode
);
    reg [6:0] decoder;
    assign cathode = decoder;
    always @(*)  begin
        case (char)
		4'd0: decoder = 8'b1100_0000;
		4'd1: decoder = 8'b1111_1001;
		4'd2: decoder = 8'b1010_0100;
		4'd3: decoder = 8'b1011_0000;
		4'd4: decoder = 8'b1001_1001;
		4'd5: decoder = 8'b1001_0010;
		4'd6: decoder = 8'b1000_0010;
		4'd7: decoder = 8'b1111_1000;
		4'd8: decoder = 8'b1000_0000;
		4'd9: decoder = 8'b1001_0000;
		4'ha: decoder = 8'b1000_1000;
		4'hb: decoder = 8'b1000_0011;
		4'hc: decoder = 8'b1100_0110;
		4'hd: decoder = 8'b1010_0001;
		4'he: decoder = 8'b1000_0110;
		4'hf: decoder = 8'b1000_1110;
		default:decoder = 8'b1100_0000;
        endcase
    end
endmodule