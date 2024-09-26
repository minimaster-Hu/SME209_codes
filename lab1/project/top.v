`timescale 1ns / 1ps

module top
#
(
    parameter CLK_FREQ = 100_000_000
)
(
    input btn_p,                // pause button
    input btn_spdup,            // speed-up button
    input btn_spddn,            // speed-down button
    input clk,                  // input clk, fundamental frequency 100MHz (in Xilinx Board) 50MHZ (in Pango board)
    input rst_n ,  
    output [7:0] anode,         // anodes for 7-segment //anode Ñô¼« cathode Òõ¼«
    output [15:0] SevenSegCatHL,// 7 Seg cathodes x2 = high part + low part, with dp
    output [7:0] led            // output current addr by led 
);

wire [6:0] cathode;            // cathodes for 7-segment
wire dp;                       // dot point for 7-segment

assign SevenSegCatHL = ((&anode[3:0]) == 1'b0) ? {8'hff, dp, cathode} : {dp, cathode, 8'hff};

wire [1:0] status;
wire [7:0] addr;
assign led=addr;

wire[31:0] data;
wire[31:0] instr_out;
wire[31:0] data_out;
assign data=(addr[7])? instr_out:data_out;

control ctrl(
    .rst_n(rst_n),
    .clk(clk), 
    .pause(btn_p), 
    .speedup(btn_spdup), 
    .speeddown(btn_spddn), 
    .status(status)
);

Seven_Seg ss
(
    .rst_n(rst_n),
    .clk(clk), 
    .data(data), 
    .anode(anode), 
    .dp(dp), 
    .cathode(cathode)
);

// TODO - add others missing codes

instr_mem u_instr_mem(
    .clk(clk),
    .rst_n(rst_n),
    .instr_addr(addr[6:0]),
    .rd_en(addr[7]),
    .instr_out(instr_out)
);

data_mem u_data_mem(
    .clk(clk),
    .rst_n(rst_n),
    .data_addr(addr[6:0]),
    .rd_en(!addr[7]),
    .data_out(data_out)
);

endmodule
