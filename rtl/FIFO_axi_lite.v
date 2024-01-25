module FIFO_axi_lite(
	// Global signal for all axi 4 lite interfaces
	input ACLK,
	input ARESET_N,

	// Write address channel for axi 4 lite interfaces
	input AWVALID,
	input [31:0] AWADDR, // write address signal
	input [2:0] AWPROT,  // protection types for write channel
	output AWREADY,

	// Write data channel for axi 4 lite interfaces
	input WVALID,
	input [31:0] WDATA, // write data signal
	input [3:0] WSTRB,  // write strobs => 4 strobs
	output WREADY,

	// Write response channel for axi 4 lite interfaces
	output BVALID,
	input BREADY,
	output [1:0] BRESP, // write response => docs table A3-4 pages 54

	// Read address channel for axi 4 lite interfaces
	input ARVALID,
	output ARREADY,
	input [31:0] ARADDR, // read address signals
	input [2:0] ARPROT,  // protection type for read channel

	// Read data channel for axi 4 lite interfaces
	output RVALID,
	input RREADY, 
	output [31:0] RDATA, // data output 
	output [1:0] RRESP); // response of reading status

//=========================================================================================//
//==================================AXI LITE logic=========================================//
//=========================================================================================//

	parameter DEPTH = 8; // depth of FIFO

	reg [31:0] memory [0:DEPTH-1]; // register array for storing data
	reg [3:0] wr_ptr, rd_ptr;	// pointers for read and write channel
	reg [2:0] count; 		// Current numbers of valid entries

	// write address decoder
	always @(posedge ACLK or negedge ARESET_N) begin
		if(~ARESET_N) begin
			wr_ptr <= 1'b0;
		end
		else if(AWVALID && AWREADY) begin
			wr_ptr <= wr_ptr + 1'b1;
		end
		else begin
			wr_ptr <= wr_ptr;
		end
	end

	// read address channel
	always @(posedge ACLK or negedge ARESET_N) begin
		if(~ARESET_N) begin 
			rd_ptr <= 1'b0;
		end
		else if(ARVALID && ARREADY) begin
			rd_ptr <= rd_ptr + 1'b1;
		end
		else begin
			rd_ptr <= rd_ptr;	
		end
	end
	
	// response logic
	always @(posedge ACLK or negedge ARESET_N) begin
		if(~ARESET_N) begin
			// return to default status
			BVALID <= 1'b0;
			RVALID <= 1'b0;
			BRESP <= 2'b0;
			RRESP <= 2'b0;
		end
		else if(BREADY && (AWVALID || WVALID)) begin
			BRESP <= 2'b0;
			BVALID <= 1'b1;
		end
		else if(BREADY && ARVALID) begin
			RRESP <= 2'b0;
			RVALID <= 1'b1;
		end
		else begin
			BVALID <= BVALID;
			RVALID <= RVALID;
			BRESP <= BRESP;
			RRESP <= RRESP;

		end
	end

	// write data logic 
	always @(posedge ACLK or negedge ARESET_N) begin
		if(~ARESET_N) begin
			WREADY <= 1'b0;
			count <= 1'b0;
		end
		else if(WVALID && WREADY && (count < DEPTH)) begin
			memory_reg[wr_ptr] <= wdata;
			count <= count + 1'b1;
		end
		else if(BREADY && (AWVALID || WVALID)) begin
			WREADY <= 1'b1;
		end
		else begin
			WREADY <= WREADY;
			count <= count;
		end
	end

	// read data logic
	always @(posedge ACLK or negedge ARESET_N) begin
		if(~ARESER_N) begin
			ARREADY <= 1'b0;
		end
		else if(RREADY && ARVALID && (count > 0)) begin
			RDATA <= memory_reg[rd_ptr];
			count <= count - 1;
			ARREADY <= 1'b1;
		end
		else if(count == 4'h0 || (~RREADY && ARVALID)) begin
			ARREADY <= 1'b0;
		end
	end


	// assign output for ready signals
	assign AWREADY = (count < DEPTH) ? 1'b1 : 1'b0;

endmodule 
