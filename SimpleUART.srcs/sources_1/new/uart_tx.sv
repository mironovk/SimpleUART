module uart_tx (
  input clk,
  input rst,
  input write_en,
  input [7:0] data,
  output logic q = 1'b1,
  output logic busy = 1'b0 
);
  localparam logic clk_mhz = 50;              //  Частота тактового генератора ПЛ�?С

  // localparam logic speed = 9600;             // Частота передачи bit/s
  // localparam logic ticks_per_bit = 5208;     //  Для скорости передачи 9600 bit/s
  localparam logic [$clog2(115200)-1:0] speed = 115200;            // Частота передачи bit/s
  localparam logic [$clog2(434)-1:0] ticks_per_bit = 434;       //  Для скорости передачи 115200 bit/s
  // localparam logic [$clog2(clk_mhz * 1000 * 1000 / speed)-1:0] ticks_per_bit = clk_mhz * 1000 * 1000 / speed; //  Для скорости передачи 115200 bit/s

  // localparam w_cnt = $clog2(ticks_per_bit);  //  Вычисление требуемой разрядности счетчика

  logic [$clog2(ticks_per_bit)-1:0] cnt = '0;                   //  Счетчик для обеспечения заданной частоты 115200
  logic [2:0] data_cnt = '0;
  // logic bit_start = (cnt == ticks_per_bit);   // ticks_per_bit = 50 MHz / 115200 bit/s = 434
  // logic idle = (bit_num == 4'hF);

  // always_ff @(posedge clk) begin
  //   if (start && idle) begin
  //     cnt <= 13'b0;
  //   end 
  //   else if (bit_start) begin 
  //     cnt <= 13'b0;
  //   end
  //   else begin 
  //     cnt <= cnt + 13'b1;
  //   end

  // end

  // always_ff @(posedge clk) begin
  //   if (start && idle) begin
  //     bit_num <= 1'h0;
  //     q <= 1'b0;
  //   end
  //   else if (bit_start) begin
  //     case (bit_num)
  //       4'h0: begin bit_num <= 4'h1; q <= data[0]; end
  //       4'h1: begin bit_num <= 4'h2; q <= data[1]; end
  //       4'h2: begin bit_num <= 4'h3; q <= data[2]; end
  //       4'h3: begin bit_num <= 4'h4; q <= data[3]; end
  //       4'h4: begin bit_num <= 4'h5; q <= data[4]; end
  //       4'h5: begin bit_num <= 4'h6; q <= data[5]; end
  //       4'h6: begin bit_num <= 4'h7; q <= data[6]; end
  //       4'h7: begin bit_num <= 4'h8; q <= data[7]; end
  //       4'h8: begin bit_num <= 4'h9; q <= 1'b1; end
  //       default: begin bit_num <= 4'hF; end
  //     endcase
  //   end
  // end

  //   // States
  // enum logic[3:0]
  // {
  //    start    = 4'd0,
  //    tx_bit_1 = 4'd1,
  //    tx_bit_2 = 4'd2,
  //    tx_bit_3 = 4'd3,
  //    tx_bit_4 = 4'd4,
  //    tx_bit_5 = 4'd5,
  //    tx_bit_6 = 4'd6,
  //    tx_bit_7 = 4'd7,
  //    tx_bit_8 = 4'd8,
  //    stop     = 4'd9,
  //    idle     = 4'd10
  // }
  // state, new_state;

  //  States
  enum logic[1:0]
  {
    idle     = 4'd0,
    start    = 4'd1,
    tx_data  = 4'd2,
    stop     = 4'd3  
  }
  state, next_state;

  // State transition logic
  always_comb begin
    next_state = state;

    case (state)
      start   : next_state = tx_data;
      tx_data : if (data_cnt != 7) next_state = tx_data;
                else               next_state = stop;
      stop    : if (write_en) next_state = start;
                else          next_state = idle;
      idle    : if (write_en) next_state = start;
                else          next_state = idle;
    endcase
  end

  // Output logic
   always_comb begin : output_logic
    case (state)
      start   : begin q = '0; busy = '1; end
      tx_data : begin q = data[data_cnt]; end
      stop    : begin q = '1; busy = '0; end
      idle    : begin q = '1; busy = '0; end
    endcase
  end

  always_ff @(posedge clk) begin : data_counter
    if (rst) begin
      data_cnt <= '0;
    end
    else if (state == start) begin
      data_cnt <= '0;
    end else if (cnt == ticks_per_bit) begin
      data_cnt <= data_cnt + 1'b1;
    end
  end
  
  // State update
  always_ff @ (posedge clk) begin : state_memory
    if (rst) begin
      state <= idle;
    end 
    else if (cnt == ticks_per_bit) begin 
      state <= next_state;
      // cnt <= '0;
    end
  end

  always_ff @(posedge clk) begin
    if (rst || (cnt == ticks_per_bit)) begin
      cnt <= '0;
    end
    else begin
      cnt <= cnt + 1'b1;      
    end
  end
endmodule