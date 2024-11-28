module MCycle
  #(parameter width = 32) // 32位，用于ARMv3
   (
     input CLK,   // 连接到CPU时钟
     input RESET, // 连接到ARM处理器的复位信号
     input Start, // 多周期启用。控制单元在检测到MUL或DIV指令时会置位此信号
     input MCycleOp, // 多周期操作。0表示无符号乘法，1表示无符号除法，由控制单元生成
     input [width-1:0] Operand1, // 被乘数 / 被除数
     input [width-1:0] Operand2, // 乘数 / 除数 
     output [width-1:0] Result,  // 对于MUL，输出低32位结果；对于DIV，输出商
     output reg Busy // 当Start信号被置位时，立即置位该信号。当结果准备好时清除
   );

  // 状态定义：IDLE表示空闲状态，COMPUTING表示计算中
  localparam IDLE = 1'b0;
  localparam COMPUTING = 1'b1;
  
  reg state, n_state;  // 当前状态和下一个状态
  reg done;  // 计算完成标志

  // 状态机逻辑：根据当前状态和下一个状态切换
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
          Busy = 1'b1;  // 进入计算状态，设置Busy信号
        end else begin
          n_state = IDLE;
          Busy = 1'b0;  // 保持空闲状态，清除Busy信号
        end
      end
      COMPUTING: begin
        if (~done) begin
          n_state = COMPUTING;
          Busy = 1'b1;  // 计算未完成时，保持计算状态
        end else begin
          n_state = IDLE;
          Busy = 1'b0;  // 计算完成时，切换回空闲状态
        end
      end
    endcase
  end

  // 内部寄存器，用于计算
  reg sign = 0;  // 符号位，用于除法的符号调整
  reg [5:0] count = 0; // 用于记录计算周期数
  reg [2*width-1:0] temp_sum = 0; // 存储中间计算结果

  // 多周期计算，包括乘法和除法操作
  always @(posedge CLK or posedge RESET)
  begin
    if (RESET) begin
      count <= 0;
      temp_sum <= 0;
      done <= 0;
      sign <= 0;
    end else if (state == IDLE) begin
      // 如果进入计算状态，初始化寄存器
      if (n_state == COMPUTING) begin
        count <= 0;
        done <= 0;
        if (~MCycleOp) begin
          temp_sum <= {{width{1'b0}}, Operand1}; // 初始化乘法操作
        end else begin
          {sign, temp_sum} <= ({{width{1'b0}}, Operand1,1'b0}) - {1'b0, Operand2, {width{1'b0}}}; // 初始化除法操作
        end
      end
    end else if (n_state == COMPUTING) begin
      // 在计算状态时，执行乘法或除法操作

      if (~MCycleOp) begin // 乘法操作
        if (count == width - 1) begin
          done <= 1'b1; // 如果计算周期达到最大值，设置done为1，表示计算完成
          count <= 0;
        end else begin
          done <= 1'b0;
          count <= count + 1;
        end

        // 乘法的移位和加法逻辑
        if (temp_sum[0]) begin
          temp_sum <= {1'b0,temp_sum[2*width-1:1]} + {1'b0,Operand2, {(width-1){1'b0}}}; // 如果最低位为1，左移Operand2并加到temp_sum，然后右移
        end else begin
          temp_sum <= {1'b0,temp_sum[2*width-1:1]} ; // 如果最低位为0，只进行右移
        end
      end else begin // 除法操作
        if (count == width - 1) begin
          done <= 1'b1; // 如果计算周期达到最大值，设置done为1，表示计算完成
          count <= 0;
        end else begin
          done <= 1'b0;
          count <= count + 1;
        end

        // 除法逻辑，依据符号位调整余数
        if (~sign) begin // 如果余数为非负数
          {sign, temp_sum} <= ({temp_sum[2*width-1:0],1'b0}) - {1'b0, Operand2, {width{1'b0}}}; // 先将temp_sum左移一位，再减去除数
          temp_sum[0] <= 1'b1; // 设置余数的符号位为1，表示正余数
        end else begin // 如果余数为负数
          {sign,temp_sum} <= (({sign,temp_sum} + {1'b0,Operand2,{width{1'b0}}}) << 1) - {1'b0,Operand2,{width{1'b0}}};; // 调整为负余数
          temp_sum[0] <= 1'b0; // 设置余数的符号位为0，表示负余数
        end
      end
    end
  end

  // 输出结果：取temp_sum的低32位作为最终结果
  assign Result = temp_sum[width-1:0];

endmodule