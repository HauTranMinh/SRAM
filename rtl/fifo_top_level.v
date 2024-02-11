module fifo_top_level #(parameter DSIZE = 32, parameter ASIZE = 8) // parameter to config the size of fifo DSIZE => Data size, ASIZE => address size
	(output [DSIZE - 1:0] 	rdata, // read data from fifo buffer
	 output			wfull, // fifo full signal
	 output			rempty,// fifo empty signal
	 input  [DSIZE - 1:0]   wdata, // write data to fifo buffer
	 input 			winc, wclk, wrst_n,
	 input 			rinc, rclk, rrst_n);

//======================Internal connect wire========================//
	wire [ASIZE - 1:0]	waddr, raddr;
	wire [ASIZE : 0] 	wptr, rptr, wq2_rptr, rq2_wptr;

//===================================================================//
//======================Synchronizer module==========================//
//===================================================================//

	sync_r2w	sync_r2w (.wq2_rptr(wq2_rptr),
				  .rptr(rptr),
				  .wclk(wclk),
				  .wrst_n(wrst_n));

	sync_w2r	sync_w2r (.rq2_wptr(rq2_wptr),
				  .wptr(wptr),
				  .rclk(rclk),
				  .rrst_n(rrst_n));

//===================================================================//
//======================internal modules wire========================//
//===================================================================//
	
	

endmodule
