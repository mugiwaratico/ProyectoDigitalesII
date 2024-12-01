//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Logica UART2

module UART_2 (
    input UART2_CLK,
    input IDLE_UART2,
    input [7:0] data_in2,
    input RX_Serial2,
    input TX_1,
    output reg [10:0] Packet_In2,
    output reg TX_Serial2
);

reg [3:0] Contador_Packet_Out;
reg [7:0] Data_Tempora2;
reg [2:0] state;
reg [3:0] Contador_Unos;
reg [3:0] Contador_Ciclos;
reg [3:0] Contador_Packet_In;
reg [3:0] Contador_Data;
reg Bandera_TX1;

parameter Preparacion_Datos = 1, Inicio_Transmision = 2, Transmision = 3, Parada = 4, Espera = 5;

always @(posedge UART2_CLK) begin //or negedge TX_1
    // Logica Receptor
    if (Bandera_TX1 == 0) begin
        Contador_Packet_In <= 4'd11;
        Packet_In2 <= 0;
        if(TX_1) begin
            Bandera_TX1 <= 0;
        end else begin
            Bandera_TX1 <= 1;
            Packet_In2[Contador_Packet_In - 1] <= RX_Serial2;
            Contador_Packet_In <= Contador_Packet_In - 1;
        end
    end else begin 
        if(Contador_Packet_In > 0) begin
            Packet_In2[Contador_Packet_In - 1] <= RX_Serial2;
            Contador_Packet_In <= Contador_Packet_In - 1;
        end else begin
            Bandera_TX1 <= 0;
            Contador_Packet_In <= 4'd11;
        end
    end
  
    // Logica Transmisor
    if(IDLE_UART2) begin
        TX_Serial2 <= 1;
        Contador_Ciclos <= 0;
        Contador_Packet_Out <= 0;
        Contador_Unos <= 0;
        state <= Preparacion_Datos;
    end else begin
        case (state)
            Preparacion_Datos : begin
                Data_Tempora2 <= data_in2;
                state <= Inicio_Transmision;
            end
            Inicio_Transmision : begin
                TX_Serial2 <= 0;
                state <= Transmision;
            end
            Transmision : begin
                if(Contador_Packet_Out < 8) begin
                    TX_Serial2 <= data_in2[Contador_Packet_Out];
                    Contador_Packet_Out <= Contador_Packet_Out + 1;
                    if(data_in2[Contador_Packet_Out]) Contador_Unos <= Contador_Unos + 1;
                end else begin
                    if (Contador_Unos % 2 == 0) begin
                        TX_Serial2 <= 0;
                    end else begin
                        TX_Serial2 <= 1;
                    end
                    state <= Parada;
                end
            end
            Parada : begin
                TX_Serial2 <= 1;
                state <= Espera; 
            end
            Espera : begin
                if(Contador_Ciclos < 500) begin
                    if(Data_Tempora2 != data_in2) begin
                        state <= Preparacion_Datos;
                        Packet_In2 <= 0;
                    end 
                    Contador_Ciclos <= Contador_Ciclos + 1;
                end
            end
        endcase

    
    end

end

endmodule