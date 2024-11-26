//����flag�仯
module CondLogic(
    input CLK,
    input PCS,//���������Դ
    input RegW,//�Ĵ���д��ʹ��
    input MemW,//�ڴ�д��ʹ��
    input [1:0] FlagW,//��־λд�����,��λ��ʾALUFlags saved
    input [3:0] Cond,//������
    input [3:0] ALUFlags,//ALU��־λ
    input NoWrite,
    input M_W,
    output PCSrc,//���������Դѡ��
    output RegWrite,//�Ĵ���д���ź�
    output MemWrite,//�ڴ�д���ź�
    output M_Write
    ); 
    
    reg CondEx ;//ִ������
    reg N = 0, Z = 0, C = 0, V = 0 ;
    //��־λ�Ĵ�������
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

    //���
    assign PCSrc = PCS & CondEx;
    assign RegWrite = RegW & CondEx & ~NoWrite;
    assign MemWrite = MemW & CondEx;
    assign M_Write = M_W & CondEx;
endmodule