TOP=tb_counter
RTL=rtl/counter.v rtl/tb_counter.v
CPP=sim_main.cpp
BUILD=build

all: run

$(BUILD):
	mkdir -p $(BUILD)

compile: $(BUILD)
	verilator -cc --exe --build -Wall -O3 -CFLAGS "-O3" \
	  -Mdir $(BUILD) \
	  -o sim_main \
	  $(RTL) $(CPP) -top-module $(TOP) \
	  --trace

run: compile
	$(BUILD)/sim_main

clean:
	rm -rf $(BUILD)
