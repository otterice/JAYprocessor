module milestone2_quicktest_tb();

bit clk, reset;
wire done;
logic error[2];

top_level dut(
  .clk,
  .reset,
  .done);
  


always begin
  #5 clk = 1;
  #5 clk = 0;
end

initial begin
  dut.rf1.core[4] = 8'b00011110;
  dut.rf1.core[2] = 8'b00000010;
  for (int i = 0; i < 8; i ++) begin
    #10 $display("reg", i, dut.rf1.core[i]);
  end

  #10 $display("mem 31", dut.dm1.core[31]);

  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);

  for (int i = 0; i < 8; i ++) begin
    #10 $display("reg", i, dut.rf1.core[i]);
  end
  #10 $display("mem 31", dut.dm1.core[31]);
  $stop;
end    

endmodule