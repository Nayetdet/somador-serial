module serialadder(
  input logic a, b,
  input logic clock, reset,
  output logic s, cout
);
  logic cin;
  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      cin <= 0;
    end
    else begin
      cin <= cout;
    end
  end
  assign s = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
