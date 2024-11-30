`include "dut.v"

// Archivo: testbench.v
module UART_System_tb;
    reg clk;
    reg clk_half;
    reg idle_uart1, idle_uart2;
    reg [7:0] dataIn_uart1, dataIn_uart2;
    wire Tx_1, Tx_2;
    wire [10:0] Rx_1;
    wire [10:0] Rx_2;

    // Instancia del sistema UART
    UART_System uut (
        .clk(clk),
        .idle_uart1(idle_uart1),
        .idle_uart2(idle_uart2),
        .dataIn_uart1(dataIn_uart1),
        .dataIn_uart2(dataIn_uart2),
        .Tx_1(Tx_1),
        .Tx_2(Tx_2),
        .Rx_1(Rx_1),
        .Rx_2(Rx_2)
    );

    // Generador de reloj (10 ns de periodo)
    always #5 clk = ~clk;
    always #10 clk_half = ~clk_half;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
    end

endmodule