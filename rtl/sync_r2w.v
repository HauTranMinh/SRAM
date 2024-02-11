module sync_r2w #parameter(ADDRSIZE = 8)
	(output	reg 	[ADDRSIZE : 0]	 wq2_rptr;
	 input 		[ADDRSIZE : 0]	 rptr;
	 input				 wclk, wrst_n);

	reg [ADDRSIZE : 0] wq1_rptr;

	always @(posedge wclk or negedge wrst_n) begin
		if(!wrst_n) begin
			wq1_rptr <= 8'h00;
			wq2_rptr <= 8'h00;
		end
		else begin
			wq1_rptr <= wq2_rptr;
			wq2_rptr <= rptr;
		end
	end


endmodule
