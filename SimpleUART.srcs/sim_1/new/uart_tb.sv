`timescale 1ns / 1ps

module uart_tb;
  logic clk = 1'b0;
  logic write_enable = '0;
  logic [7:0] uart_data = 8'hAB;
  logic reset = '0;
  
  initial begin
    #10 reset = '1;
    #10 reset = '0;
    #100 write_enable = '1;
    #500 write_enable = '0;
    #1000 write_enable = '1;
    uart_data = 8'hCF;
    
//    #1000 $finish;
  end

  always begin
    #10 clk = ~clk;
  end

  uart_tx uut(.clk(clk), .rst(reset), .write_en(write_enable), .data(uart_data));

endmodule
