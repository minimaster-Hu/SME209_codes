module tb_instr_mem(
);
reg   clk=0 ;
reg   rst_n=1 ;
reg   [6:0] instr_addr=0;
reg   rd_en=0 ;
wire  [127:0]instr_out;

initial
begin
    forever #50  clk=~clk;
end
instr_mem u_instr_mem(
    .clk(clk),
    .rst_n(rst_n),
    .instr_addr(instr_addr),
    .rd_en(rd_en),
    .instr_out(instr_out)

);
initial
begin
    #30 rd_en <= 1'b1;  instr_addr <= 7'd5;
    #20 rd_en <= 1'd0;  instr_addr <= 7'd10;
    #20 instr_addr <= 7'd15;
    #20 rd_en <= 1'd1;  instr_addr <= 7'd18;
    $finish;
end

endmodule