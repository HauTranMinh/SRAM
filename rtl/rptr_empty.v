module rptr_empty #(parameter ADDRSIZE=8)
//===================I/O ports declare======================================//
	(output				 rempty, // this is reg
	 output		[ADDRSIZE - 1:0] raddr,	
	 output 	[ADDRSIZE    :0] rptr, // this is reg
	 input 		[ADDRSIZE    :0] rq2_wptr,
	 input 				 rinc, rclk, rrst_n);

//===================Internal connection declare===========================//
	
	reg rempty_reg;
	reg [ADDRSIZE : 0] rptr_reg;
	reg [ADDRSIZE : 0] rbin;
	wire [ADDRSIZE : 0] rgraynext, rbinnext;

//=========================================================================//
	assign rempty = rempty_reg;
	assign rptr = rptr_reg;

//=========================================================================//
//GRAYCODE pointer for read
	
	always @(posedge rclk or negedge wrst_n) begin
		if (!rrst_n) begin
			rbin <= 0;
			rptr_reg <= 9'b0000_0000_0;
		end
		else begin
			rbin <= rbinnext;
			rptr_reg <= rgraynext;
		end
	end
//=========================================================================//
//Memory to read address pointer
	assign raddr = rbin[ADDRSIZE-1:0];

	assign rbinnext = rbin + (rinc & ~rempty_reg);
	assign rgraynext = (rbinnext>>1) ^ rbinnext;

	assign rempty_val = (rgraynext == rq2_wptr);

	always @(posedge rclk or negedge rrst_n) begin
		if (~rrst_n) begin
			rempty_reg <= 1'b1; // reset mean clear the memory zone => there is nothing left.
		end
		else begin
			rempty_reg <= rempty_val;
		end
	end

endmodule
