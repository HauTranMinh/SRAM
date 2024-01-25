TESTNAME        ?=

all: build run

build:
	mkdir -p log
	mkdir -p wave
	mkdir -p coverage
	vlib work
	vmap work work
	vlog -cover bcesxf -f compile.f



run:
	vsim -l $(TESTNAME).log -coverage  -voptargs=+acc work.$(TESTNAME) -do "coverage save -onexit $(TESTNAME).ucdb; log -r /*;run -all; exit"
	mv $(TESTNAME).log ./log
	cp -rf vsim.wlf wave/$(TESTNAME).wlf
	mv $(TESTNAME).ucdb ./coverage
	ln -sf ./log/$(TESTNAME).log sim.log
report_cov:
	vcover merge coverage/merged.ucdb coverage/*.ucdb
	vcover report -all -file coverage/report_summary.txt coverage/merged.ucdb
	vcover report -codeAll -details -all -file coverage/report_detail.txt coverage/merged.ucdb

clean:
	rm -rf work
	rm -rf log
	rm -rf wave
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript
	rm -rf coverage
dump:
	vsim -gui -novopt work.${TESTNAME}
