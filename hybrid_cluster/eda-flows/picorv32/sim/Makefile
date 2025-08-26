TOP=tb_counter
RTL=rtl/counter.v rtl/tb_counter.v
BUILD=build

all: run
$(BUILD):
	mkdir -p $(BUILD)

compile: $(BUILD)
	verilator -cc --exe --build -Wall -O3 -CFLAGS "-O3" \
	  -o $(BUILD)/sim_main $(RTL) -top-module $(TOP) \
	  --trace --timing --binary

run: compile
	$(BUILD)/sim_main

clean:
	rm -rf $(BUILD)
