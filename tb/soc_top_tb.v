`timescale 1ns / 1ps

module soc_top_tb;

    reg clk;
    reg rst;

    soc_top dut (
        .clk(clk),
        .rst(rst)
    );

    initial clk = 0;
    always #5 clk = ~clk;   // 100 MHz

    integer i;

    initial begin
        $display("==== SOC TOP TEST START ====");

        rst = 1;
        #20;
        rst = 0;

        // Run for a few cycles and print PC & instruction
        for (i = 0; i < 10; i = i + 1) begin
            #10;
            // We can't access PC directly, but we can peek instruction address
            // via hierarchical name if needed; for now just show that sim runs.
            $display("Cycle %0d", i);
        end

        $display("==== SOC TOP TEST END ====");
        $finish;
    end

endmodule
