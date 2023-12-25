`timescale 1ns / 1ps

module uart_tx_tb;
  logic clk = 1'b0;
  logic write_enable = '0;
  logic [7:0] uart_data = 8'hAB;
  logic reset = '0;
  
  int clk_period = 20;  // 20ns ~ 50MHz
  int package_length = clk_period * 434 * 10; 

  initial begin
    #10 reset = '1;
    #10 reset = '0;
    
    @(posedge clk)
    uart_data = 8'b0100_1100;
    @(posedge clk)
    write_enable = '1;
    @(posedge clk)
    write_enable = '0;
    // uart_data = 8'hFF;
    // #1000 write_enable = '1;

    #(package_length/2)
    uart_data = 8'h0A;
    @(posedge clk)
    write_enable = '1;
    @(posedge clk)
    write_enable = '0;
    
    
//    #1000 $finish;
  end

  always begin
    #10 clk = ~clk;
  end

  uart_tx uut(.clk(clk), .rst(reset), .write_en(write_enable), .data(uart_data));

endmodule
