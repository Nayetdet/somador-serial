module tb_serialadder;
  logic a, b;
  logic clock, reset;
  logic s, cout;

  localparam N = 8; // Quantidade de casos teste
  logic [4:0] testvectors [N-1:0];
  logic tmp_a, tmp_b, cin, expected_s, expected_cout;

  serialadder dut(a, b, clock, reset, s, cout);
  always #5 clock = ~clock;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, a, b, clock, reset, s, cout);
    $readmemb("testvectors.txt", testvectors, 0, N-1);

    clock = 1; reset = 0; a = 0; b = 0; cin = 0;
    reset = 1; @(posedge clock); reset = 0;

    for (int i = 0; i < N; i++) begin
      {tmp_a, tmp_b, cin, expected_s, expected_cout} = testvectors[i];
      if (cin) begin
        // Faz com que o carry que vai para a soma seguinte seja 1
        a = 1; b = 1; @(posedge clock);
      end
      a = tmp_a; b = tmp_b; @(posedge clock);
      assert((s === expected_s) && (cout === expected_cout));
        else $error(
          "Erro no %0do caso: s=%b expected_s=%b | cout=%b expected_cout=%b",
          i + 1, s, expected_s, cout, expected_cout
        );
      reset = 1; @(posedge clock); reset = 0;
    end
    $finish;
  end
endmodule;
