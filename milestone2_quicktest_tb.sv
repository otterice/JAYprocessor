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
  //dut.rf1.core[0] = 8'b10000000;
  //dut.rf1.core[1] = 8'b00000101;

    //dut.rf1.core[2] = 8'b00011000;
	//#10 $display(dut.rf1.core[2]);
  //dut.rf1.core[3] = 8'b00000111;
    //dut.rf1.core[4] = 8'b00000001;


  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[0] = (dut.rf1.core[0]) == 8'b00000111;
  #10 error[1] = (dut.rf1.core[1]) == 8'b00000111;
  #10 $display("MEM 0",  dut.dm1.core[0]);
  #10 $display ("REG 2 ", dut.rf1.core[2]);
  #10 $display ("REG 1 ", dut.rf1.core[1]);
  $stop;
end    

endmodule