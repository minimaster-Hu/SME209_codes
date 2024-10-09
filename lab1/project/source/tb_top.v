module tb_top(
);
parameter CLK_FREQ  = 400;

reg   btn_p=0 ;
reg   btn_spdup=0 ;
reg   btn_spddn=0 ;
reg   clk=0 ;
reg   rst_n=1 ;
wire  [7:0]  anode ;
wire  [15:0] SevenSegCatHL;
wire  [7:0]  led;

initial
begin
    forever #50  clk=~clk;
end

//initial
//begin
//    #20     btn_p = 1;
//    #1000    btn_p = 0;
//    #1000    btn_p = 1;
//    #100    btn_p = 0;
//    #1000   btn_spdup = 1;
//    #2000    btn_spdup = 0; btn_spddn = 1;
//    #2000   btn_spddn = 0;
//    #1000 
//    $finish;
//end

top #(
    .CLK_FREQ ( CLK_FREQ ))
u_top
(
    .btn_p(btn_p),
    .btn_spdup(btn_spdup),
    .btn_spddn(btn_spddn),
    .clk(clk),
    .rst_n(rst_n),
    .anode(anode),
    .SevenSegCatHL(SevenSegCatHL),
    .led(led)
);
endmodule