`timescale 1ns/1ps
module counter #(parameter W=8) (
  input  wire        clk,
  input  wire        rst_n,
  output reg  [W-1:0] q
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) q <= {W{1'b0}};
    else        q <= q + 1'b1;
  end
endmodule