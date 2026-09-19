`timescale 1ns / 1ps

module battery_thermal_analyzer #(
    parameter integer TEMP_WARNING   = 42,
    parameter integer TEMP_CRITICAL  = 50,
    parameter integer DELTA_WARNING  = 3,
    parameter integer DELTA_CRITICAL = 5
)(
    input wire clk,
    input wire reset,
    input wire sample_enable,

    input wire [7:0] temperature,
    input wire [7:0] battery_level,
    input wire charging,

    output reg signed [8:0] temp_delta,
    output reg [1:0] state,
    output reg alert
);

    localparam [1:0] NORMAL   = 2'b00;
    localparam [1:0] WARNING  = 2'b01;
    localparam [1:0] CRITICAL = 2'b10;

    reg [7:0] previous_temperature;
    reg initialized;

    reg signed [8:0] current_delta;

    always @* begin
        current_delta =
            $signed({1'b0, temperature}) -
            $signed({1'b0, previous_temperature});
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            previous_temperature <= 8'd0;
            temp_delta            <= 9'sd0;
            state                 <= NORMAL;
            alert                 <= 1'b0;
            initialized           <= 1'b0;
        end
        else if (sample_enable) begin
            if (!initialized) begin
                previous_temperature <= temperature;
                temp_delta            <= 9'sd0;
                state                 <= NORMAL;
                alert                 <= 1'b0;
                initialized           <= 1'b1;
            end
            else begin
                previous_temperature <= temperature;
                temp_delta            <= current_delta;

                if ((temperature >= TEMP_CRITICAL) ||
                    (current_delta >= DELTA_CRITICAL)) begin
                    state <= CRITICAL;
                    alert <= 1'b1;
                end
                else if ((temperature >= TEMP_WARNING) ||
                         (current_delta >= DELTA_WARNING)) begin
                    state <= WARNING;
                    alert <= 1'b0;
                end
                else begin
                    state <= NORMAL;
                    alert <= 1'b0;
                end
            end
        end
    end

endmodule