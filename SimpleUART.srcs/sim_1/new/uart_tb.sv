`timescale 1ns / 1ps

module uart_tb;
  logic clk = 1'b0;
  logic bit_clk = 1'b0;
  // logic write_enable = '0;
  logic [7:0] uart_data = 8'hAB;
  logic reset = '0;
  bit rx;
  bit tx = 1;

  int clk_period = 20;  // 20ns ~ 50MHz
  int package_length = clk_period * 434 * 10; 
  int bit_length = clk_period * 434;

  initial begin
    #10 reset = '1;
    #10 reset = '0;
    
    @(posedge clk)
    uart_data = 8'b0111_0101;
    @(posedge clk)
    // write_enable = '1;
    // @(posedge clk)
    // write_enable = '0;
    // // uart_data = 8'hFF;
    // // #1000 write_enable = '1;

    // #(package_length/2)
    // uart_data = 8'h0A;
    // @(posedge clk)
    // write_enable = '1;
    // @(posedge clk)
    // write_enable = '0;
    #10 reset = '1;
    #10 reset = '0;

    for (int i = 0; i < 10; i++) begin
      // #(posedge bit_clk);
      // #(bit_length);
      if(i == 0) begin
        tx = 0;
      end else if(i == 9) begin
        tx = 1;
      end else begin
        tx = uart_data[i-1];
      end
      #(bit_length);
    end

    #(package_length)
    // #(bit_length);
    @(posedge clk)
    uart_data = 8'b1011_1001;
    @(posedge clk)
    for (int i = 0; i < 10; i++) begin
      // #(posedge bit_clk);
      // #(bit_length);
      if(i == 0) begin
        tx = 0;
      end else if(i == 9) begin
        tx = 1;
      end else begin
        tx = uart_data[i-1];
      end
      #(bit_length);
      // $display(tx);
    end
    
  //  #150000 $finish;
  end

  always begin
    #(clk_period/2) clk = ~clk;
  end

  always begin
    #(bit_length/2) bit_clk = ~bit_clk;
  end

  uart_top uut(.clk(clk), .rst(reset), .rx(tx), .tx(rx));
//  uart_top test_uut();

endmodule
