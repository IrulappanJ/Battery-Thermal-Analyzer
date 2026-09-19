`timescale 1ns / 1ps

module battery_tb;

    reg clk;
    reg reset;
    reg sample_enable;

    reg [7:0] temperature;
    reg [7:0] battery_level;
    reg charging;

    wire signed [8:0] temp_delta;
    wire [1:0] state;
    wire alert;

    localparam [1:0] NORMAL   = 2'b00;
    localparam [1:0] WARNING  = 2'b01;
    localparam [1:0] CRITICAL = 2'b10;

    battery_thermal_analyzer uut (
        .clk(clk),
        .reset(reset),
        .sample_enable(sample_enable),
        .temperature(temperature),
        .battery_level(battery_level),
        .charging(charging),
        .temp_delta(temp_delta),
        .state(state),
        .alert(alert)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task apply_sample;
        input [7:0] new_temperature;
        begin
            @(negedge clk);
            temperature   = new_temperature;
            sample_enable = 1'b1;

            @(negedge clk);
            sample_enable = 1'b0;

            @(posedge clk);
            #1;
        end
    endtask

    task check_result;
        input signed [8:0] expected_delta;
        input [1:0] expected_state;
        input expected_alert;

        begin
            if (temp_delta !== expected_delta)
                $display("ERROR: temp_delta expected=%0d actual=%0d",
                         expected_delta, temp_delta);

            if (state !== expected_state)
                $display("ERROR: state expected=%b actual=%b",
                         expected_state, state);

            if (alert !== expected_alert)
                $display("ERROR: alert expected=%b actual=%b",
                         expected_alert, alert);
        end
    endtask

    initial begin
        reset         = 1'b1;
        sample_enable = 1'b0;
        temperature   = 8'd27;
        battery_level = 8'd80;
        charging      = 1'b0;

        #12;
        reset = 1'b0;

        apply_sample(8'd27);
        check_result(9'sd0, NORMAL, 1'b0);

        apply_sample(8'd30);
        check_result(9'sd3, WARNING, 1'b0);

        apply_sample(8'd35);
        check_result(9'sd5, CRITICAL, 1'b1);

        apply_sample(8'd43);
        check_result(9'sd8, CRITICAL, 1'b1);

        apply_sample(8'd51);
        check_result(9'sd8, CRITICAL, 1'b1);

        apply_sample(8'd32);
        check_result(-9'sd19, NORMAL, 1'b0);

        $display("SIMULATION COMPLETED");
        $finish;
    end

endmodule