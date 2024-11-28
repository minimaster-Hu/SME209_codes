module MCycle
  #(parameter width = 32) // 32λ������ARMv3
   (
     input CLK,   // ���ӵ�CPUʱ��
     input RESET, // ���ӵ�ARM�������ĸ�λ�ź�
     input Start, // ���������á����Ƶ�Ԫ�ڼ�⵽MUL��DIVָ��ʱ����λ���ź�
     input MCycleOp, // �����ڲ�����0��ʾ�޷��ų˷���1��ʾ�޷��ų������ɿ��Ƶ�Ԫ����
     input [width-1:0] Operand1, // ������ / ������
     input [width-1:0] Operand2, // ���� / ���� 
     output [width-1:0] Result,  // ����MUL�������32λ���������DIV�������
     output reg Busy // ��Start�źű���λʱ��������λ���źš������׼����ʱ���
   );

  // ״̬���壺IDLE��ʾ����״̬��COMPUTING��ʾ������
  localparam IDLE = 1'b0;
  localparam COMPUTING = 1'b1;
  
  reg state, n_state;  // ��ǰ״̬����һ��״̬
  reg done;  // ������ɱ�־

  // ״̬���߼������ݵ�ǰ״̬����һ��״̬�л�
  always @(posedge CLK or posedge RESET)
  begin
    if (RESET)
      state <= IDLE;
    else
      state <= n_state;
  end

  always @(*)
  begin
    case(state)
      IDLE: begin
        if (Start) begin
          n_state = COMPUTING;
          Busy = 1'b1;  // �������״̬������Busy�ź�
        end else begin
          n_state = IDLE;
          Busy = 1'b0;  // ���ֿ���״̬�����Busy�ź�
        end
      end
      COMPUTING: begin
        if (~done) begin
          n_state = COMPUTING;
          Busy = 1'b1;  // ����δ���ʱ�����ּ���״̬
        end else begin
          n_state = IDLE;
          Busy = 1'b0;  // �������ʱ���л��ؿ���״̬
        end
      end
    endcase
  end

  // �ڲ��Ĵ��������ڼ���
  reg sign = 0;  // ����λ�����ڳ����ķ��ŵ���
  reg [5:0] count = 0; // ���ڼ�¼����������
  reg [2*width-1:0] temp_sum = 0; // �洢�м������

  // �����ڼ��㣬�����˷��ͳ�������
  always @(posedge CLK or posedge RESET)
  begin
    if (RESET) begin
      count <= 0;
      temp_sum <= 0;
      done <= 0;
      sign <= 0;
    end else if (state == IDLE) begin
      // ����������״̬����ʼ���Ĵ���
      if (n_state == COMPUTING) begin
        count <= 0;
        done <= 0;
        if (~MCycleOp) begin
          temp_sum <= {{width{1'b0}}, Operand1}; // ��ʼ���˷�����
        end else begin
          {sign, temp_sum} <= ({{width{1'b0}}, Operand1,1'b0}) - {1'b0, Operand2, {width{1'b0}}}; // ��ʼ����������
        end
      end
    end else if (n_state == COMPUTING) begin
      // �ڼ���״̬ʱ��ִ�г˷����������

      if (~MCycleOp) begin // �˷�����
        if (count == width - 1) begin
          done <= 1'b1; // ����������ڴﵽ���ֵ������doneΪ1����ʾ�������
          count <= 0;
        end else begin
          done <= 1'b0;
          count <= count + 1;
        end

        // �˷�����λ�ͼӷ��߼�
        if (temp_sum[0]) begin
          temp_sum <= {1'b0,temp_sum[2*width-1:1]} + {1'b0,Operand2, {(width-1){1'b0}}}; // ������λΪ1������Operand2���ӵ�temp_sum��Ȼ������
        end else begin
          temp_sum <= {1'b0,temp_sum[2*width-1:1]} ; // ������λΪ0��ֻ��������
        end
      end else begin // ��������
        if (count == width - 1) begin
          done <= 1'b1; // ����������ڴﵽ���ֵ������doneΪ1����ʾ�������
          count <= 0;
        end else begin
          done <= 1'b0;
          count <= count + 1;
        end

        // �����߼������ݷ���λ��������
        if (~sign) begin // �������Ϊ�Ǹ���
          {sign, temp_sum} <= ({temp_sum[2*width-1:0],1'b0}) - {1'b0, Operand2, {width{1'b0}}}; // �Ƚ�temp_sum����һλ���ټ�ȥ����
          temp_sum[0] <= 1'b1; // ���������ķ���λΪ1����ʾ������
        end else begin // �������Ϊ����
          {sign,temp_sum} <= (({sign,temp_sum} + {1'b0,Operand2,{width{1'b0}}}) << 1) - {1'b0,Operand2,{width{1'b0}}};; // ����Ϊ������
          temp_sum[0] <= 1'b0; // ���������ķ���λΪ0����ʾ������
        end
      end
    end
  end

  // ��������ȡtemp_sum�ĵ�32λ��Ϊ���ս��
  assign Result = temp_sum[width-1:0];

endmodule