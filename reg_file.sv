// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=3)(
  input[7:0] dat_in,
  
  input      clk,
  input      wr_en,           // write enable
  input MemtoReg, 
  input[2:0] wr_addr,          // write address pointer
              rd_addrA,          // read address pointers
              rd_addrB,

  output logic[7:0] datA_out, // read data
                    datB_out,
                    dedReg_out);

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];
  //assign dedReg_out = core[2]; 
   assign core[0] = 0;
   assign core[1] = 1;
  assign dedReg_out = core[2];
 
  
  initial begin 
  for (int i = 2; i < $size(core); i++) 
    core[i] = 0;
  end
  
always_ff @(posedge clk) begin
    
    //$display("ded", dedReg_out);
  end

// writes are sequential (clocked)
  always_ff @(posedge clk) begin
    if(MemtoReg)
        core[2] <= dat_in;
    else if(wr_en)                   // anything but stores or no ops
      core[wr_addr] <= dat_in;

  end
        

endmodule
/*
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
      xxxx_xxxx
*/