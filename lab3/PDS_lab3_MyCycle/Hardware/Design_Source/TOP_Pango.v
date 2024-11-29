`timescale 1ns / 1ps

// >>>>>>>>>>>>>>>>>>>>>>>>>>> ******* FOR SYNTHESIS ONLY. DO NOT SIMULATE THIS ******* <<<<<<<<<<<<<<<<<<<<<<<<<<<
module TOP 
#(
  parameter N_LEDs_OUT = 8,        // Number of LEDs displaying Result. LED(15 downto 15-N_LEDs_OUT+1). 16 by default
  parameter N_DIPs = 7,             // Number of DIPs. 16 by default
  parameter N_SEVEN_SEG_DIGITs = 8, // Number of digits on the 7-seg display.
  parameter CLK_DIV_BITS = 22        // Set this to 25 for a ~1Hz clock. 0 for a 50MHz clock. Should not exceed 25. 
  // There is no need to change it for simulation, as this entity/module should not be simulated
  // If this is set to less than 17, you might need a software delay loop between successive reads / writes to/from UART.
)
(
  input  [N_DIPs-1:0] DIP, 		 		// DIP switch inputs, used as a user definied memory address for checking memory content.
	output [N_LEDs_OUT-1:0] LED,   	// LED light display. Display the value of program counter.
  output [N_SEVEN_SEG_DIGITs-1:0] SevenSegAn, // 7 Seg anodes
  output [15:0] SevenSegCatHL,      // 7 Seg cathodes x2 = high part + low part
  input PAUSE_n,                    // Pause -> BTNU (Up push button)
  input RESET_n,                    // Reset -> BTND (Down push button)
  input CLK_undiv                 // 100MHz clock. Converted to a lower frequency using DIV_PROCESS before being fed to the Wrapper.
);
 
//----------------------------------------------------------------
// Wrapper signals
//----------------------------------------------------------------	
wire [31:0] SEVENSEGHEX; 		
wire CLK;	

wire  PAUSE = ~PAUSE_n;
wire  RESET = ~RESET_n;

//----------------------------------------------------------------
// Wrapper port map
//----------------------------------------------------------------
wire [15:0] LED_16bit;
Wrapper wrapper1(
  DIP,
  LED_16bit,
  SEVENSEGHEX,
  RESET,
  CLK
);

assign LED = LED_16bit[9:2];

//----------------------------------------------------------------
//-- Clock divider
//----------------------------------------------------------------
generate
  if (CLK_DIV_BITS == 0) begin
    assign CLK = CLK_undiv;
  end
  else begin   // Clock division
    reg [CLK_DIV_BITS:0] clk_counter;
    always @(posedge CLK_undiv or posedge RESET) begin
      if(RESET)
        clk_counter <= 'b0;
      else if(~PAUSE)
        clk_counter <= clk_counter + 1;
    end
    assign CLK = clk_counter[CLK_DIV_BITS];
  end
endgenerate

//----------------------------------------------------------------
//-- Seven Segment Display
//----------------------------------------------------------------
reg [7:0] enable = 8'b0000_0001;   // 8-bit signal to indicate which 7-segment unit is enabled (active HIGH)
reg [3:0] data_disp = 4'h0;        // display data_disp for each 7-segment unit, 0 to F, therefore 4 bits.
reg [16:0] count_fast;             // counter for slowering down 100MHz to 1kHz for 7-segments multiplexing
reg seven_seg_enable;              // 1-bit enable signal for 1kHz multiplexing speed of 7-segments
reg [6:0] cathode = 7'b111_1111;   // disable all cathode signals of 7-segments (active HIGH)

always @(posedge CLK_undiv or posedge RESET) begin
  if(RESET) begin
    count_fast <= 17'b0;
    seven_seg_enable <= 1'b0;
  end
  else begin
    count_fast <= count_fast+1;        // fast counter is enabled by the fundamental frequency 100MHz
    if(count_fast == 17'h1869F) begin  // counter should count from 0 to 99,999 for 1kHz
      seven_seg_enable <= 1'b1;        // set the enable flag signal 
      count_fast <= 17'b0;             // reset the counter
    end
    else seven_seg_enable <= 0;        // clear the enable flag signal if counter doesn't reach 99,999
  end
end

always @(posedge CLK_undiv or posedge RESET) begin
  if(RESET) begin
    enable <= 8'b00000001;
  end
  else begin
    if(seven_seg_enable) begin // when 7-segments are enabled, multiplexing eight 7-segment units on by one
      enable <= (enable == 8'h80)? 8'h01 : (enable << 1); //eight 7-segment units are turned on 1 by 1, with frequency 1kHz
    end
  end
end

assign SevenSegAn = ~enable;   // anode signal is active LOW

always @ (*) begin                       
  case (SevenSegAn)    // assigning the 32-bit data_disp to each 7-segment unit
      8'b11111110 : data_disp = SEVENSEGHEX[3:0];
      8'b11111101 : data_disp = SEVENSEGHEX[7:4];
      8'b11111011 : data_disp = SEVENSEGHEX[11:8];
      8'b11110111 : data_disp = SEVENSEGHEX[15:12];
      8'b11101111 : data_disp = SEVENSEGHEX[19:16];
      8'b11011111 : data_disp = SEVENSEGHEX[23:20];
      8'b10111111 : data_disp = SEVENSEGHEX[27:24];
      8'b01111111 : data_disp = SEVENSEGHEX[31:28];
      default : data_disp = 4'h0;
  endcase 
  case (data_disp) // based on 4-bit data_disp, turn on/off corresponding cathode signals
      4'h0 : cathode = 7'b1000000; 
      4'h1 : cathode = 7'b1111001;
      4'h2 : cathode = 7'b0100100;
      4'h3 : cathode = 7'b0110000;
      4'h4 : cathode = 7'b0011001;
      4'h5 : cathode = 7'b0010010;
      4'h6 : cathode = 7'b0000010;
      4'h7 : cathode = 7'b1111000;
      4'h8 : cathode = 7'b0000000;
      4'h9 : cathode = 7'b0010000;
      4'hA : cathode = 7'b0001000;
      4'hB : cathode = 7'b0000011;
      4'hC : cathode = 7'b1000110;
      4'hD : cathode = 7'b0100001;
      4'hE : cathode = 7'b0000110;
      4'hF : cathode = 7'b0001110;
   endcase
end 

assign SevenSegCatHL = ((&SevenSegAn[3:0]) == 1'b0) ? {8'hff, 1'b1, cathode} : {1'b1, cathode, 8'hff};


endmodule