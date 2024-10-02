`timescale 1ns / 1ps

module Seven_Seg
#(
    parameter CLK_FREQ = 28'd100_000_000
)
(
    input rst_n,    
    input clk,              // fundamental frequency 100MHz (in Xilinx Board) 50MHZ (in Pango board)
    input [1:0] status, 
    input [31:0] data,      // 32-bit MEM contents willing to display on 7-segments
    output [7:0] addr,
    output [7:0] anode,     // anodes for 7-segments    //anode 阳极 cathode 阴极
    output          dp,     // dot point for 7-segments
    output [6:0] cathode    // cathodes for 7-segments
);
   
localparam  QUARTER_JUMP = CLK_FREQ / 4 - 1;    //0.25s
localparam  ANODE_JUMP = CLK_FREQ / 1000 - 1;    //1ms
// TODO
assign dp=1'd1;
reg [3:0] num;

seg_decoder uu_seg_decoder(
.char(num),
.cathode(cathode)  
    );

//anode_scan
    reg [7:0] anode_reg;
    assign anode=anode_reg;
    reg [$clog2(ANODE_JUMP)-1:0] anode_cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)  begin
            anode_reg <= 8'b1111_1110;
            anode_cnt <= 'd0;
        end
        else if(anode_cnt == ANODE_JUMP)   begin
            anode_reg <= {anode[6:0], anode[7]};
            anode_cnt <= 'd0;
        end
        else begin
            anode_cnt <= anode_cnt+1'd1;
        end
    end
//set num
always @(*) begin
    case(anode)
        8'b1111_1110:   num = data[3:0];
        8'b1111_1101:   num = data[7:4];
        8'b1111_1011:   num = data[11:8];
        8'b1111_0111:   num = data[15:12];
        8'b1110_1111:   num = data[19:16];
        8'b1101_1111:   num = data[23:20];
        8'b1011_1111:   num = data[27:24];
        8'b0111_1111:   num = data[31:28];
    endcase
end

reg valid;
reg [3:0] counter;
reg [3:0] count_limit;

always @(*) begin
        case (status)
            2'b00: count_limit = 4'd15; // low speed    16个时钟周期步进一次
            2'b01: count_limit = 4'd3;  // mid speed    4个时钟周期步进一次
            2'b10: count_limit = 4'd0;  // high speed   1个时钟周期步进一次
        endcase
end

// counter
always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid <= 1'b0;
            counter <= 4'd0;
        end
        else if (status == 2'b11) begin    //pause
            valid <= 1'b0;
            counter <= 4'd0;
        end
        else if (counter==count_limit && status!=2'b11) begin
            valid <= 1'b1;   
            counter <= 4'd0; 
        end
        else begin
            valid <= 1'b0;   
            counter <= counter + 1'd1; 
        end
end

//addr_scaner
reg[24:0] clk_counter;
reg[7:0] addr_counter;
assign addr = addr_counter;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        clk_counter<=25'b0;
        addr_counter<=8'b0;   
    end
    else if(clk_counter==QUARTER_JUMP/2) begin
        clk_counter<=25'b0;
        addr_counter<=addr_counter+1'd1;
    end
    else begin
        clk_counter<=clk_counter+valid;
        addr_counter<=addr_counter;
    end
end


endmodule
