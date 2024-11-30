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
        // Inicialización de señales
        clk = 0;
        clk_half = 0;
        idle_uart1 = 1;
        idle_uart2 = 1;
        dataIn_uart1 = 8'b00111000;  // Primer dato para UART_1
        dataIn_uart2 = 8'b01010101;  // Primer dato para UART_2

        // Comienza la primera transmisión de UART_1 a UART_2
        #10 
        idle_uart1 = 0;  // Activar UART_1 para iniciar transmisión
       
        // Esperar para completar la transmisión de UART_1 a UART_2
        #200;  // Ajusta el tiempo según el diseño para completar la transmisión

        idle_uart1 = 1;

        idle_uart2 = 0;

        #200

        // Datos para la segunda transmisión de UART_2 a UART_1
               // Poner UART_1 en reposo
               // Activar UART_2 para iniciar transmisión
        dataIn_uart1 = 8'b11110000;  // Nuevo dato para la segunda transmisión de UART_1 a UART_2
        dataIn_uart2 = 8'b00001111;  // Nuevo dato para la segunda transmisión de UART_2 a UART_1

         // Comienza la primera transmisión de UART_1 a UART_2
        idle_uart2 = 1;
        #10 idle_uart1 = 0;  // Activar UART_1 para iniciar transmisión

        // Esperar para completar la transmisión de UART_1 a UART_2
        #200;  // Ajusta el tiempo según el diseño para completar la transmisión

        idle_uart1 = 1;

        idle_uart2 = 0;

        #200

        // Finalizar la simulación
        $finish;
    end

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
    end

endmodule