module uart_rx (
  input clk,
  input rst,
  input q,
  output logic [7:0] data,
  output logic ready
);
  localparam logic clk_mhz = 50;              //  Частота тактового генератора ПЛ�?С

  // localparam logic speed = 9600;             // Частота передачи bit/s
  // localparam logic ticks_per_bit = 5208;     //  Для скорости передачи 9600 bit/s
  localparam logic [$clog2(115200)-1:0] speed = 115200;            // Частота передачи bit/s
  localparam logic [$clog2(434)-1:0] ticks_per_bit = 434;       //  Для скорости передачи 115200 bit/s
  // localparam logic [$clog2(clk_mhz * 1000 * 1000 / speed)-1:0] ticks_per_bit = clk_mhz * 1000 * 1000 / speed; //  Для скорости передачи 115200 bit/s

  logic [$clog2(ticks_per_bit)-1:0] cnt = '0;      //  Счетчик для обеспечения заданной частоты 115200
  logic [3:0] data_cnt = '0;
  logic [7:0] data_reg = '0;

  logic [3:0] rx; // Регистр сдвига для детектирования перепада 1->0 (начало передачи)

  //  States
  enum logic[3:0]
  {
    idle     = 4'd0,
    start    = 4'd1,
    rx_data  = 4'd2,
    stop     = 4'd3  
  }
  state, next_state;

  // State transition logic
  always_comb begin : state_transition_logic
    next_state = state;

    case (state)
      start   : if (cnt == ticks_per_bit/2) next_state = rx_data;
      rx_data : if ((data_cnt == 7) && (cnt == ticks_per_bit)) next_state = stop;
                else               next_state = rx_data;
      stop    : if (cnt == ticks_per_bit) next_state = idle;
      idle    : if ((rx[0] == 1) && (rx[1] == 0)) next_state = start;
    endcase
  end

  // Output logic
   always_comb begin : output_logic
    case (state)
      start   : begin ready = '0; end
      // rx_data : begin q = internal_data[data_cnt]; end
      stop    : begin data = data_reg; ready = '1; end
      idle    : begin ready = '0; end
    endcase
  end

  always_ff @(posedge clk) begin : shift_register
    if ((state == rx_data) && (cnt == ticks_per_bit)) begin
      data_reg[7:0] <= {rx[0], data_reg[7:1]};
    end else if (cnt == ticks_per_bit) begin
      data_cnt <= data_cnt + 1'b1;
    end
  end

  always_ff @(posedge clk) begin : data_counter
    if (rst) begin
      data_cnt <= '0;
      rx <= '0;
      data <= '0;
    end else begin
      rx[3:0] <= {q, rx[3:1]};

      if (state == start) begin
        data_cnt <= '0;
      end else if (cnt == ticks_per_bit) begin
        data_cnt <= data_cnt + 1'b1;
      end
    end
  end
  
  // State update
  always_ff @ (posedge clk) begin : state_memory
    if (rst) begin
      state <= idle;
    end 
    else begin // if (cnt == ticks_per_bit) 
      state <= next_state;
      // cnt <= '0;
    end
  end

  always_ff @(posedge clk) begin : speed_clk
    if (rst || (cnt == ticks_per_bit)) begin
      cnt <= '0;
    end
    else begin
      cnt <= cnt + 1'b1;  
      if ((state == start) && (cnt == ticks_per_bit/2)) begin
        cnt <= 0;
      end    
    end
  end


endmodule