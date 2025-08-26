`timescale 1ns/1ps
module tb_counter;
  reg clk=0, rst_n=0;
  wire [7:0] q;
  counter #(8) dut (.clk(clk), .rst_n(rst_n), .q(q));
  always #5 clk = ~clk; // 100MHz

  initial begin
    $display("Start sim");
    rst_n = 0; repeat(3) @(posedge clk);
    rst_n = 1; repeat(50) @(posedge clk);
    $display("Final q = %0d", q);
    if (q < 50) begin
      $display("PASS"); $finish;
    end else begin
      $display("FAIL"); $fatal(1);
    end
  end
endmodule
