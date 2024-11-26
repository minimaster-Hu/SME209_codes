//控制flag变化
module CondLogic(
    input CLK,
    input PCS,//程序计数器源
    input RegW,//寄存器写入使能
    input MemW,//内存写入使能
    input [1:0] FlagW,//标志位写入控制,高位表示ALUFlags saved
    input [3:0] Cond,//条件码
    input [3:0] ALUFlags,//ALU标志位
    input NoWrite,
    input M_W,
    output PCSrc,//程序计数器源选择
    output RegWrite,//寄存器写入信号
    output MemWrite,//内存写入信号
    output M_Write
    ); 
    
    reg CondEx ;//执行条件
    reg N = 0, Z = 0, C = 0, V = 0 ;
    //标志位寄存器更新
    always@(posedge CLK)begin
        if(FlagW[1] & CondEx)begin
            {N,Z} <= ALUFlags[3:2];
        end
        else begin
            {N,Z} <= {N,Z};
        end
    end
    
    always@(posedge CLK)begin
        if(FlagW[0] & CondEx)begin
            {C,V} <= ALUFlags[1:0];
        end    
        else begin
            {C,V} <= {C,V};
        end
    end 
 
   always @(*) begin
        case(Cond)
            4'b0000: CondEx = Z;
            4'b0001: CondEx = ~Z;
            4'b0010: CondEx = C;
            4'b0011: CondEx = ~C;
            4'b0100: CondEx = N;
            4'b0101: CondEx = ~N;
            4'b0110: CondEx = V;
            4'b0111: CondEx = ~V;
            4'b1000: CondEx = C & ~Z;
            4'b1001: CondEx = ~C | Z;
            4'b1010: CondEx = ~(N ^ V);
            4'b1011: CondEx = N ^ V;
            4'b1100: CondEx = ~Z & ~(N ^ V);
            4'b1101: CondEx = Z | (N ^ V);
            4'b1110: CondEx = 1'b1;
            default: CondEx = 1'b0;
        endcase
    end

    //输出
    assign PCSrc = PCS & CondEx;
    assign RegWrite = RegW & CondEx & ~NoWrite;
    assign MemWrite = MemW & CondEx;
    assign M_Write = M_W & CondEx;
endmodule