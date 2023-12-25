module uart_top(
  input clk,
  input rst,
  // (* mark_debug = "true" *) input rx_top,
  // (* mark_debug = "true" *) output bit tx_top
  input rx_top,
  output bit tx_top
  );

  // (* mark_debug = "true" *) logic [7:0] recieved_data;
  logic [7:0] recieved_data;
  logic recieved_data_vld;
  logic data_vld;
  logic [1:0] data_vld_reg;

  // (* mark_debug = "true" *) logic tx_busy;
  logic tx_busy; 

  always_ff @(posedge clk) begin
    data_vld_reg <= {recieved_data_vld, data_vld_reg[1]};
    if ((data_vld_reg[1] == 1) && (data_vld_reg[0] == 0)) begin
      data_vld <= '1;
    end else begin
      data_vld <= '0;
    end
  end

  uart_rx reciever(.clk(clk), .rst(rst), .q(rx_top), .data(recieved_data), .ready(recieved_data_vld));

  uart_tx transmitter(.clk(clk), .rst(rst), .write_en(data_vld), .data(recieved_data), .q(tx_top), .busy(tx_busy));

    
endmodule
