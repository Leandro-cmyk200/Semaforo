module semaforo_6bits (
    input wire clk,         // Reloj de 24 MHz
    input wire reset,       // Reset activo en bajo
    output reg [5:0] leds,  // Salida visual del semáforo
    output reg verde,
    output reg amarillo,
    output reg rojo
);

    // Estados del semáforo
    parameter EST_VERDE            = 2'b00;
    parameter EST_VERDE_AMARILLO   = 2'b01;
    parameter EST_ROJO             = 2'b10;
    parameter EST_AMARILLO         = 2'b11;

    reg [1:0] estado_actual;
    reg [28:0] conta;
    reg [28:0] limite;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            estado_actual <= EST_VERDE;
            conta         <= 29'd0;
            limite        <= 29'd240000000;   // 10 segundos
            leds          <= 6'b001111;       // verde encendido
            verde         <= 0;               // Encendido
            amarillo      <= 1;               // Apagado
            rojo          <= 1;               // Apagado
        end else begin
            if (conta >= limite) begin
                conta <= 29'd0;

                case (estado_actual)
                    EST_VERDE: begin
                        leds     <= 6'b001111;       // Verde encendido
                        limite   <= 29'd240000000;   // 10 segundos
                        verde    <= 0;
                        amarillo <= 1;
                        rojo     <= 1;
                        estado_actual <= EST_VERDE_AMARILLO;
                    end

                    EST_VERDE_AMARILLO: begin
                        leds     <= 6'b000011;       // Verde y amarillo encendidos
                        limite   <= 29'd120000000;   // 5 segundos
                        verde    <= 0;
                        amarillo <= 0;
                        rojo     <= 1;
                        estado_actual <= EST_ROJO;
                    end

                    EST_ROJO: begin
                        leds     <= 6'b111100;       // Rojo encendido
                        limite   <= 29'd480000000;   // 20 segundos
                        verde    <= 1;
                        amarillo <= 1;
                        rojo     <= 0;
                        estado_actual <= EST_AMARILLO;
                    end

                    EST_AMARILLO: begin
                        leds     <= 6'b110011;       // Amarillo encendido
                        limite   <= 29'd120000000;   // 5 segundos
                        verde    <= 1;
                        amarillo <= 0;
                        rojo     <= 1;
                        estado_actual <= EST_VERDE;
                    end
                endcase
            end else begin
                conta <= conta + 29'd1;
            end
        end
    end

endmodule