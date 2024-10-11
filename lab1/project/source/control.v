`timescale 1ns / 1ps

module control(
    input clk,
    input rst_n,
    input pause,        // high when pressed down
    input speedup,      // high when pressed down
    input speeddown,    // high when pressed down
    output reg [1:0] status    //0 low speed; 1 mid speed; 2 high speed; 3 pause;
); 
// TODO    
reg [1:0] status_save;


//state_machine
always @(posedge clk or negedge rst_n) begin
        if(!rst_n)  begin
            status <= 2'd1;
            status_save <= 2'd1;
        end
    else begin
    case(status)
    2'd0:begin
        if(speedup)begin
        status<=2'd1;
        end
        else if(speeddown)begin
        status<=2'd0;
        end
        else if(pause)begin
        status<=2'd3;
        status_save<=2'd0;
        end
        else begin
        status<=status;
        status_save<=status_save;
        end
    end
    
    2'd1:begin
        if(speedup)begin
        status<=2'd2;
        end
        else if(speeddown)begin
        status<=2'd0;
        end
        else if(pause)begin
        status<=2'd3;
        status_save<=2'd1;
        end
        else begin
        status<=status;
        status_save<=status_save;
        end
    end

    2'd2:begin
        if(speedup)begin
        status<=2'd2;
        end
        else if(speeddown)begin
        status<=2'd1;
        end
        else if(pause)begin
        status<=2'd3;
        status_save<=2'd2;
        end
        else begin
        status<=status;
        status_save<=status_save;
        end
    end

    2'd3:begin
        if(pause)begin
        status<=status_save;
        end
        else begin
        status<=2'd3;
        status_save<=status_save;
        end
    end
    default:begin
        status <= 2'd1;
        status_save <= 2'd1;
    end
    endcase
    end
end


endmodule
