// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero,      // NOR (output)
			   absj
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  zero = !rslt;
  pari = ^rslt;

  case(alu_cmd)
      /*begin
		rslt[7:1] = ina[6:0];
		rslt[0]   = sc_i;
		sc_o      = ina[7];
      end*/
    3'b010: begin
	if (inA == 0) 
		absj = 'b1;
	end 
    3'b011: // bitwise XOR
	  rslt = inA ^ inB;
	3'b100: begin // Rotate
		rslt = (inA << inB) | (inA >> (8-inB));
	end
	3'b101: // AND
		rslt = {inA & inB};
	3'b111: // add inA to rslt
	begin
		//$display("ina, inb", inA, " ", inB);

	  {sc_o,rslt} = inA + inB;
	  end

  endcase
  	  	  //$display("RSLT", rslt);

end
   
endmodule