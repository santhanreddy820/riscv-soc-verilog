`timescale 1ns / 1ps

module uart_sim (
    input  wire        clk,
    input  wire        we,
    input  wire [31:0] addr,
    input  wire [31:0] wdata
);

    localparam UART_TX_ADDR = 32'h00000080;

    always @(posedge clk) begin
        if (we && (addr == UART_TX_ADDR)) begin
            // Debug message + actual character
            $display("UART WRITE @%0t : addr=0x%08h data=0x%08h char='%c'",
                     $time, addr, wdata, wdata[7:0]);
            $write("%c", wdata[7:0]);
        end
    end

endmodule
