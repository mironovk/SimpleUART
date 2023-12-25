module uart_tx (
  input clk,
  input rst,
  input write_en,
  input [7:0] data,
  output logic q,
  output logic busy 
);

  localparam logic clk_mhz = 100; //  Частота тактового генератора ПЛИС
  localparam logic [$clog2(115200)-1:0] speed = 115200; // Частота передачи bit/s
  localparam logic [$clog2(868)-1:0] ticks_per_bit = 868; //  Для скорости передачи 115200 bit/s

  // localparam logic clk_mhz = 50;              //  Частота тактового генератора ПЛ�?С

  // // localparam logic speed = 9600;             // Частота передачи bit/s
  // // localparam logic ticks_per_bit = 5208;     //  Для скорости передачи 9600 bit/s
  // localparam logic [$clog2(115200)-1:0] speed = 115200;            // Частота передачи bit/s
  // localparam logic [$clog2(434)-1:0] ticks_per_bit = 434;       //  Для скорости передачи 115200 bit/s
  // localparam logic [$clog2(clk_mhz * 1000 * 1000 / speed)-1:0] ticks_per_bit = clk_mhz * 1000 * 1000 / speed; //  Для скорости передачи 115200 bit/s

  // localparam w_cnt = $clog2(ticks_per_bit);  //  Вычисление требуемой разрядности счетчика

  logic [$clog2(ticks_per_bit)-1:0] cnt;                   //  Счетчик для обеспечения заданной частоты 115200
  logic [3:0] data_cnt;
  logic [7:0] internal_data;


  //  States
  enum logic[3:0]
  {
    idle     = 4'd0,
    start    = 4'd1,
    tx_data  = 4'd2,
    stop     = 4'd3  
  }
  state, next_state;

  // State transition logic
  always_comb begin : state_transition_logic
    next_state = state;

    case (state)
      start   : if (cnt == ticks_per_bit) next_state = tx_data;
      tx_data : if ((data_cnt == 7) && (cnt == ticks_per_bit)) next_state = stop;
                else               next_state = tx_data;
      stop    : if (write_en) next_state = start;
                else if (cnt == ticks_per_bit) next_state = idle;
      idle    : if (write_en) next_state = start;
                else if (cnt == ticks_per_bit) next_state = idle;
    endcase
  end

  // Output logic
   always_comb begin : output_logic
    case (state)
      start   : begin q = '0; busy = '1; end
      tx_data : begin q = internal_data[data_cnt]; busy = '1; end
      stop    : begin q = '1; busy = '0; end
      idle    : begin q = '1; busy = '0; end
    endcase
  end

  always_ff @(posedge clk) begin : data_counter
    if (~rst) begin
      data_cnt <= '0;
    end else if (~ busy) begin
      internal_data <= data;
      // data_cnt <= '0;
    end else if ((state == start) || (state == stop)) begin
      data_cnt <= '0;
    end else if (cnt == ticks_per_bit) begin
      data_cnt <= data_cnt + 1'b1;
    end
  end
  
  // State update
  always_ff @ (posedge clk) begin : state_memory
    if (~rst) begin
      state <= idle;
    end 
    else begin // if (cnt == ticks_per_bit) 
      state <= next_state;
      // cnt <= '0;
    end
  end

  always_ff @(posedge clk) begin : speed_clk
    if (~rst || (cnt == ticks_per_bit) || (write_en == 1)) begin
      cnt <= '0;
    end
    else begin
      cnt <= cnt + 1'b1;      
    end
  end
endmodule