// sample top level design
module top_level(
  input        clk, reset, //req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		  // from RegFile
              muxB, 
			  rslt,               // alu output
              immed,
			  mem_out;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
		sc_clr,
		sc_en,
		MemtoReg,
        MemWrite,
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_addrB;    // address pointers to reg_file
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .inB    (datB),
		 .reljump_en (relj),
		 .absjump_en (absj),
		 .target,
		 .prog_ctr          );
		 
	assign rd_addrB = mach_code[2:0]; // regB
  assign rd_addrA = mach_code[5:3]; // regA
  assign alu_cmd  = mach_code[8:6]; // 111

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (how_high),
         .target          );   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control ctl1(.instr(alu_cmd),
  .RegDst  (), 
  .Branch  (absj)  , 
  .MemWrite , 
  .ALUSrc   , 
  .RegWrite   ,     
  .MemtoReg,
  .ALUOp());
// 111001000

  reg_file #(.pw(3)) rf1(.dat_in(MemtoReg? mem_out : rslt),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
			  .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrA),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 

	assign immed = rd_addrB;
  assign muxB = ALUSrc? immed : datB;


  alu alu1(.alu_cmd(alu_cmd),
         .inA    (datA),
		 .inB    (muxB),
		 .sc_i   (sc),   // output from sc register
		 .rslt       ,
		 .sc_o   (sc_o), // input to sc register
		 .absj, 
		 .pari  );  
		 
	

  dat_mem dm1(.dat_in(datB)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (datA),
			 .immed (immed), 
             .dat_out(mem_out));
			 
			 
	

// registered flags from ALU
  always_ff @(posedge clk) begin

    //$display("mem_out ", mem_out, " datB ", datB);
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr > 710;
 
endmodule