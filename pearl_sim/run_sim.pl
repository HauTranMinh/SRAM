#----------------------------------------------------------------------
#----------------------THIS IS FOR QUESTASIM---------------------------
#----------------------------------------------------------------------

print("======================================================================/n");
#==========================Path to simulation tool that is using================
my $SIM_TOOL = "C:/questasim64_10.2c/win64";
print("=====Simulator: $SIM_TOOL \n");

print("======================================================================/n");

#===============================================================================

#=========================Define all used tools=================================

my $VLib = "$SIM_TOOL/vlib.exe";
my $VLog = "$SIM_TOOL/vlog.exe";
my $VOpt = "$SIM_TOOL/vopt.exe";
my $VSim = "$SIM_TOOL/vsim.exe";
my $VCov = "$SIM_TOOL/vcover.exe"; # This is for coverage report, only on questasim


if ($ARGV[0] eq "-wave"){
	if($ARGV[1] eq "") {
		print "DO NO HAVE THE WAVELIFE";
	} else {
		system "$VSim -gui -novopt work.$ARGV[1]";
	}
}
elsif ($ARGV[0] =~ "-sim"){
	# if the directory existed, it gonna be removed
	if (-d "MyWork"){
		system "rm -rf MyWork";
	}

	# create wrking libary
	system "$VLib MyWork";

	# Compile the source code 
	system "$VLog -work MyWork -sv MooreFsm.sv TestBench.sv -l vlog.log";

	# Optimize the design
	system "$VOpt -work MyWork TestBench -o MyOpt";

	if ($ARGV[0] eq "-sim") {
		# Load the design in to simulator and run
		system "$VSim -c MyWork.MyOpt -do \"run -all; quit\" -l vsim.log";
	}
	else {
		system "$VSim -c -novopt MyWork.TestBench -do \"run -all; quit\" -l vsim.log";	
	}
}
elsif ($ARGV[0] eq "-report_cov"){
	system "$VCov merge coverage/merged.ucdb coverage/*.ucdb";
	system "$VCov report -all -file coverage/report_summary.txt coverage.merged.ucdb";
	system "$VCov report -codeAll -details -all -file coverage/report_detail.txt coverage/merged.ucdb " 

}
elsif ($ARGV[0] eq "-clean") {
	system "rm -rf work";
	system "rm -rf log";
	system "rm -rf wave";
	system "rm -rf *.ini";
	system "rm -rf *.log";
	system "rm -rf *.wlf";
	system "rm -rf transcript";
	system "rm -rf coverage";

	
}
else {
	print " Please select one of the below option: \n";
	print " -sim 			: Run the simulation with the optimization\n";
	print " -simnovopt		: Run the simulation without the optimization\n";
	print " -wave <VCD file_name>	: View the waveform\n";
	print " -report_cov		: Make the coverage and report\n";
	print " -clean			: To make your work space clean\n";
}

1;
