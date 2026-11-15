module dac_reg #(parameter N = 8) (       // module = like a C function/struct; N = a    input			clk,  
  input 		 clk,
  input 		 rst_n,
  input			 we,
  input [N-1:0]		 d_in,
  output  reg [N-1:0]    dac_code
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			dac_code <= {N{1'b0}};
		else if (we)
			dac_code <= d_in;
		// otherwise nothing happens,so the old value stays
	end
endmodule
