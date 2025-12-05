`timescale 1ns / 1ps

module uart_sim_tb;

    reg         clk;
    reg         we;
    reg  [31:0] addr;
    reg  [31:0] wdata;

    uart_sim dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .wdata(wdata)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("==== UART SIM TEST START ====");

        we = 0;
        addr = 0;
        wdata = 0;
        #10;

        // Write 'A' (0x41) to UART TX address
        we    = 1;
        addr  = 32'h00000080;
        wdata = 32'h00000041;
        #10;

        // Stop writing
        we = 0;
        #10;

        $display("\n==== UART SIM TEST END ====");
        $finish;
    end

endmodule
