module tb_data_mem(
);

reg   clk=0 ;
reg   rst_n=1 ;
reg   [6:0] data_addr=0;
reg   rd_en=0 ;
wire  [127:0]data_out;

initial
begin
    forever #50  clk=~clk;
end
data_mem u_data_mem(
    .clk(clk),
    .rst_n(rst_n),
    .data_addr(data_addr),
    .rd_en(rd_en),
    .data_out(data_out)

);
initial
begin
    #30 rd_en <= 1'b1;  data_addr <= 7'd5;
    #20 rd_en <= 1'd0;  data_addr <= 7'd10;
    #20 data_addr <= 7'd15;
    #20 rd_en <= 1'd1;  data_addr <= 7'd18;
    $finish;
end

endmodule