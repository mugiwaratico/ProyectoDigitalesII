`include "Transmisor_Receptor.v"

module UART_System (
    input wire clk,
    input wire idle_uart1,
    input wire idle_uart2,
    input wire [7:0] dataIn_uart1,
    input wire [7:0] dataIn_uart2,
    output wire Tx_1,
    output wire Tx_2,
    output wire [10:0] Rx_1,
    output wire [10:0] Rx_2
);

    // Señales de interconexión entre los módulos UART_1 y UART_2
    wire tx_uart1_to_rx_uart2;  // Transmisión de UART_1 a recepción de UART_2
    wire tx_uart2_to_rx_uart1;  // Transmisión de UART_2 a recepción de UART_1
    wire [10:0] Packet_In1_dut;
    wire [10:0] Packet_In2_dut;  

    // Instancia del módulo UART_1
    UART_1 uart1 (
        .UART1_CLK(clk),
        .IDLE_UART1(idle_uart1),
        .data_in1(dataIn_uart1),
        .Packet_In1(Packet_In1_dut),  // RX de UART_1 conectado al TX de UART_2
        .TX_2(tx_uart2_to_rx_uart1),
        .RX_Serial1(tx_uart2_to_rx_uart1),
        .TX_Serial1(tx_uart1_to_rx_uart2)   // TX de UART_1 conectado al RX de UART_2
    );

    // Instancia del módulo UART_2
    UART_2 uart2 (
        .UART2_CLK(clk),
        .IDLE_UART2(idle_uart2),
        .data_in2(dataIn_uart2),
        .Packet_In2(Packet_In2_dut),  // RX de UART_2 conectado al TX de UART_1
        .TX_1(tx_uart1_to_rx_uart2),
        .RX_Serial2(tx_uart1_to_rx_uart2),
        .TX_Serial2(tx_uart2_to_rx_uart1)
    );
    
  // Asignaciones de salida para monitoreo en el testbench
    assign Tx_1 = tx_uart1_to_rx_uart2;
    assign Tx_2 = tx_uart2_to_rx_uart1;
    assign Rx_1 = Packet_In1_dut;
    assign Rx_2 = Packet_In2_dut;

endmodule