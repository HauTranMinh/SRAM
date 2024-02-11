module sync_w2r #parameter(ADDWSIZE = 8)
	(output reg 	[ADDWSIZE : 0] wq2_wptr;
	 input 		[ADDWSIZE : 0] wptr;
	 input			       rclk, rrst_n);

	 reg [ADDWSIZE : 0] wq1_wptr;
	
	 always @(posedge rclk or negedge rrst_n) begin
		if(!rrst_n) begin
			wq1_wptr <= 8'h00;
			wq2_wptr <= 8'h00;
		end
		else begin
			wq1_wptr <= wq2_wptr;
			wq2_wptr <= wptr;
		end
	 end


endmodule
