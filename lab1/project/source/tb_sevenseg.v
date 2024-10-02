module tb_sevenseg(
   );
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [31:0]  data                           = 0 ;
reg   [1:0]  status                        = 0 ;

// segment_display Outputs
wire  [7:0]  addr                          ;
wire  [7:0]  anode                         ;
wire  [6:0]  cathode                       ;
wire  dp                                   ;

initial
begin
    forever #50  clk=~clk;
end

Seven_Seg u_segment (
    .clk                     ( clk            ),
    .rst_n                   ( rst_n          ),
    .data                    ( data          ),
    .status                  ( status ),
    .addr                    ( addr ),
    .anode                   ( anode ),
    .cathode                 ( cathode ),
    .dp                      ( dp )
);


endmodule