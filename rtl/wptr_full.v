module wptr_full #(parameter ADDRSIZE=8)
//===================I/O ports declare======================================//
	(output 				wfull,
	 output		[ADDRSIZE - 1:0]	waddr,
	 output 	[ADDRSIZE : 0]	 	wptr,
	 input		[ADDRSIZE : 0] 		wq2_rptr,
	 input					winc, wclk, wrst_n);

//===================Internal connection declare===========================//

	reg wfull_reg;
	reg [ADDRSIZE : 0] wptr_reg;
	reg [ADDRSIZE : 0] wbin;
	wire [ADDRSIZE : 0] wgraynext, wbinnext;

//=========================================================================//
	assign wfull = wfull_reg;
	assign wptr = wptr_reg; 

//=========================================================================//
//GRAYCODE pointer

	always @(posedge wclk or negedge wrst_n) begin
		if(!wrst_n) begin
			wbin <= 0; // bin length ???
			wptr_reg <= 9'b0000_0000_0;
		end
		else begin
			wbin <= wbinnext;
			wptr_reg <= wgraynext;
		end	
	end
	
//=========================================================================//
//Memory to write address pointerv
	assign waddr = wbin[ADDRSIZE-1:0];

	assign wbinnext = wbin + (winc & ~wfull);
	assign wgraynext = (wbinnext >> 1) ^ wbinnext;



	assign wfull_val = (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZR-1],wq2_rptr[ADDRSIZE - 2:0]});

	always @(posedge wclk or negedge wrst_n) begin
		if(!wrst_n) begin
			wfull_reg <= 1'b0;
		end	
		else begin
			wfull_reg <= wfull_val;
		end
	end




endmodule
