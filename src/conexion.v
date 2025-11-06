module top (
    input wire clk_in,      // Reloj físico de 27 MHz
    input wire reset,
    output wire [5:0] leds
);

wire clk_100mhz;

// Instancia del PLL
Gowin_rPLL pll_inst (
    .clkin(clk_in),
    .clkout(clk_100mhz)
);

// Instancia del semáforo
semaforo_6bits semaforo_inst (
    .clk(clk_100mhz),
    .reset(reset),
    .leds(leds)
);

endmodule
