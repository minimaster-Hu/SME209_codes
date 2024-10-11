`timescale 1ns / 1ps

module control_tb();

reg clk=0;
reg rst_n=1;
reg pause;
reg speedup;
reg speeddown;
wire[1:0] status=2'd1; 

control ctrl1(
    .clk(clk),
    .rst_n(rst_n),
    .pause(pause),
    .speedup(speedup),
    .speeddown(speeddown),
    .status(status)

);

initial begin
    forever #50 clk=~clk;
end

initial begin
    pause = 0; speedup = 0; speeddown = 0;
    #1600 pause = 1;
    #3200 pause = 0;
    #500 speedup = 1;
    #1600 pause = 1;
    #1600 speedup = 0; pause = 0;
    #3200 $finish;
end
        
initial begin
    $dumpfile("testbench.wave");
    $dumpvars;
    $display("save to testbench.wave");
end 
    
endmodule
