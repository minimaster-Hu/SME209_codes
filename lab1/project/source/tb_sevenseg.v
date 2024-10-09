module tb_sevenseg(
   );
reg   clk ;
reg   rst_n ;
reg   [31:0]  data;
reg   [1:0]  status;

wire  [7:0]  addr;
wire  [7:0]  anode ;
wire  [6:0]  cathode;
wire  dp;

initial
begin
    forever #50  clk=~clk;
end

Seven_Seg u_segment (
    .clk                     (clk),
    .rst_n                   (rst_n),
    .data                    (data),
    .status                  (status),
    .addr                    (addr),
    .anode                   (anode),
    .cathode                 (cathode),
    .dp                      (dp)
);

initial
begin
    #20 status = 2'd0; num = 4'hA;
    #400    num = 4'hF;
    #400    status = 2'd2; num = 4'h1;
    #100    status = 2'd3; num = 4'h2;
    $finish;
end

endmodule