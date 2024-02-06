module fifo_axi(
//==============Global input port==================//
	input ACLK,
	input ARESET_N,

//==============Write address channel=============//
	input AWADDR,
	input AWVALID,
	input AWPROT,
	output AWREADY,

//==============Write data channel================//
	input WVALID,
	input WDATA,
	input WSTRB,
	output WREADY,

//=============Write response channel=============//
	input BREADY,
	output BVALID,
	output BREADY,

//==============Read address channel=============//
	input ARVALID,
	input ARADDR,
	input ARPROT,
	output ARREADY,

//==============Read data channel================//
	input RREADY,
	output RVALID,
	output RDATA,
	output RRESP);

endmodule
