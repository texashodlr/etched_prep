`timescale 1ns/1ps
module tb_counter (
  input  wire        clk,
  input  wire        rst_n,
  output wire [7:0]  q
);
  // DUT
  counter #(8) dut (
    .clk  (clk),
    .rst_n(rst_n),
    .q    (q)
  );
endmodule