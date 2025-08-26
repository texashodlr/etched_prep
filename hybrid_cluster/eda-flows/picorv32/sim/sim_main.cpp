#include <verilated.h>
#include "Vtb_counter.h"

static vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vtb_counter* top = new Vtb_counter;

    // Reset low initially
    top->rst_n = 0;
    top->clk   = 0;

    int cycles = 0;
    const int MAX_CYCLES = 1000;
    bool pass = false;

    while (!Verilated::gotFinish() && cycles < MAX_CYCLES) {
        // Rising edge
        top->clk = 1;
        top->eval();
        main_time++;

        // Deassert reset after 3 cycles
        if (cycles == 3) top->rst_n = 1;

        // Falling edge
        top->clk = 0;
        top->eval();
        main_time++;
        cycles++;

        // After 53 cycles total (3 in reset + 50 counting)
        if (cycles == 53) {
            uint8_t q_val = top->q;  // now exposed as a top-level port
            pass = (q_val < 50);
            break;
        }
    }

    if (pass) {
        VL_PRINTF("PASS\n");
    } else {
        VL_PRINTF("FAIL\n");
        delete top;
        return 1;
    }

    delete top;
    return 0;
}