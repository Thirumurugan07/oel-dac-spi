// Testbench for dac_reg: a "virtual lab bench" that drives the inputs
// and checks the outputs. It is NOT hardware, it only runs in the simulator.
module dac_reg_tb;

    // --- Signals that connect to the design under test (DUT) ---
    reg        clk   = 0;      // reg = a variable the testbench can set
    reg        rst_n = 0;      // starts in reset (0 = reset active)
    reg        we    = 0;      // write enable
    reg  [7:0] d_in  = 0;      // data input
    wire [7:0] dac_code;       // wire = output of the DUT, we only read it

    integer errors = 0;        // counts failed checks

    // --- Plug the DUT into the bench (like putting a chip in a socket) ---
    dac_reg #(.N(8)) dut (
        .clk      (clk),       // .port_name (signal_in_testbench)
        .rst_n    (rst_n),
        .we       (we),
        .d_in     (d_in),
        .dac_code (dac_code)
    );

    // --- Clock generator: flips every 5 time units, so one period = 10 ---
    always #5 clk = ~clk;

    // --- The test sequence (runs once, top to bottom, like main() in C) ---
    initial begin
        $dumpfile("sim/dac_reg.vcd");   // write a waveform file for GTKWave
        $dumpvars(0, dac_reg_tb);       // record all signals in this module

        // TEST 1: after reset, dac_code must be 0
        #20 rst_n = 1;                  // wait 20 time units, then release reset
        if (dac_code !== 8'h00) begin
            $display("FAIL: reset value, got %h", dac_code);
            errors = errors + 1;
        end else $display("PASS: reset value");

        // TEST 2: write A5
        d_in = 8'hA5;  we = 1;          // present the data and enable the write
        @(posedge clk); #1;             // wait for the next rising edge, plus 1 unit
        we = 0;                         // we is high for exactly one clock edge
        if (dac_code !== 8'hA5) begin
            $display("FAIL: write, got %h", dac_code);
            errors = errors + 1;
        end else $display("PASS: write");

        // TEST 3: hold. we = 0, so a new d_in must be ignored
        d_in = 8'h3C;
        repeat (2) @(posedge clk);      // wait for 2 rising edges
        #1;
        if (dac_code !== 8'hA5) begin
            $display("FAIL: hold, got %h", dac_code);
            errors = errors + 1;
        end else $display("PASS: hold");

        // TEST 4: asynchronous reset clears the code without waiting for a clock
        rst_n = 0;  #1;
        if (dac_code !== 8'h00) begin
            $display("FAIL: async reset, got %h", dac_code);
            errors = errors + 1;
        end else $display("PASS: async reset");

        // Summary
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);

        $finish;                        // stop the simulation
    end

endmodule