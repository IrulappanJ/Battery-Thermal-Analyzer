
# FPGA-Based Battery Thermal Safety Analyzer

## Overview

The FPGA-Based Battery Thermal Safety Analyzer is a Verilog HDL prototype designed to monitor battery temperature and temperature variation between consecutive samples. The system classifies the thermal condition into three levels: **NORMAL, WARNING, and CRITICAL**.

The design is implemented and verified using **AMD Xilinx Vivado** and targeted for an **AMD Xilinx Artix-7 FPGA device**.

## Objectives

- Monitor battery temperature digitally.
- Calculate temperature variation between consecutive samples.
- Classify the battery thermal condition.
- Generate a critical safety alert.
- Verify the RTL design through behavioral simulation.
- Evaluate FPGA implementation, timing, and power characteristics.

## Key Features

- Verilog HDL implementation
- FPGA-based thermal monitoring
- Temperature-change calculation
- Three-level thermal classification
- NORMAL, WARNING, and CRITICAL states
- Critical-state alert output
- 100 MHz clock operation
- Behavioral simulation verification
- Synthesis and implementation analysis
- Timing and power analysis

## Thermal Classification Logic

The system uses temperature and temperature variation to determine the thermal condition.

| Condition | State | Alert |
|---|---|---:|
| Temperature < 42°C and temperature change < 3°C | NORMAL | 0 |
| Temperature ≥ 42°C or temperature change ≥ 3°C | WARNING | 0 |
| Temperature ≥ 50°C or temperature change ≥ 5°C | CRITICAL | 1 |

The **CRITICAL** condition has the highest priority and is evaluated before the **WARNING** condition.

## System Architecture

```text
                  Temperature Input
                         |
                         v
              +----------------------+
              | Previous Temperature |
              +----------------------+
                         |
                         v
              +----------------------+
              | Temperature Change   |
              | Calculation          |
              +----------------------+
                         |
                         v
              +----------------------+
              | Thermal Classification|
              | Logic                |
              +----------------------+
                         |
                  +------+------+------+
                  |             |      |
                  v             v      v
               NORMAL        WARNING  CRITICAL
                                      |
                                      v
                                    ALERT
````

## Test Sequence

The design was verified using the following temperature sequence:

```text
27°C → 30°C → 35°C → 43°C → 51°C → 32°C
```

### Expected Classification

| Temperature | Expected State | Alert |
| ----------: | -------------- | ----: |
|        27°C | NORMAL         |     0 |
|        30°C | WARNING        |     0 |
|        35°C | CRITICAL       |     1 |
|        43°C | CRITICAL       |     1 |
|        51°C | CRITICAL       |     1 |
|        32°C | NORMAL         |     0 |

The final 32°C condition demonstrates recovery to the NORMAL state.

## FPGA Implementation

| Parameter       | Value              |
| --------------- | ------------------ |
| HDL             | Verilog            |
| Design Tool     | AMD Xilinx Vivado  |
| FPGA Family     | AMD Xilinx Artix-7 |
| Target Device   | `xc7a35tcpg236-1`  |
| Clock Period    | 10 ns              |
| Clock Frequency | 100 MHz            |

## Resource Utilization

| Resource        | Result |
| --------------- | -----: |
| Slice LUTs      |     32 |
| Slice Registers |     36 |
| DSP             |      0 |
| BRAM            |      0 |

## Timing Results

| Timing Parameter           |    Result |
| -------------------------- | --------: |
| Worst Negative Slack (WNS) | +5.155 ns |
| Total Negative Slack (TNS) |      0 ns |
| Hold Slack (WHS)           | +0.238 ns |
| Hold Violations            |         0 |
| Pulse Width Slack          | +4.500 ns |

## Power Analysis

| Parameter            |  Result |
| -------------------- | ------: |
| Total On-Chip Power  | 0.070 W |
| Dynamic Power        | 0.001 W |
| Device Static Power  | 0.068 W |
| Junction Temperature |  25.3°C |

> **Note:** These are FPGA tool estimates and are not physical power measurements.

## Verification

The project includes:

* Behavioral simulation waveform
* Synthesis result
* Implementation/device result
* Timing summary
* Power report

The corresponding screenshots are available in the `Results` directory.

## Repository Structure

```text
Battery-Thermal-Analyzer/
│
├── README.md
│
├── RTL/
│   └── battery_thermal_analyzer.v
│
├── Simulation/
│   └── battery_tb.v
│
├── Constraints/
│   └── battery_thermal_analyzer.xdc
│
└── Results/
    ├── behavioral_simulation.jpg
    ├── implementation_device.jpg
    ├── power_report.jpg
    ├── synthesis.jpg
    └── timing_summary.jpg
```

## Limitations

This project is an FPGA-based functional prototype for thermal-condition monitoring and classification. It is not a complete commercial Battery Management System (BMS).

Current limitations include:

* No physical temperature sensor interface
* Battery-level and charging inputs are reserved for future development
* No battery voltage or current monitoring
* No complete thermal-runaway prediction model
* Temperature variation is calculated between consecutive samples
* Power values are FPGA tool estimates rather than physical measurements
* No physical LED or buzzer interface
* No data-logging or communication interface

## Future Development

* Physical temperature sensor integration
* Battery voltage and current monitoring
* Battery State of Charge (SoC) estimation
* Battery State of Health (SoH) estimation
* Thermal trend analysis
* LED and buzzer warning interface
* Data logging
* Communication interface
* Integration with a larger Battery Management System

## Conclusion

The FPGA-Based Battery Thermal Safety Analyzer demonstrates a compact RTL-based approach for monitoring battery thermal conditions and generating safety classifications.

The design was verified through behavioral simulation and evaluated through FPGA synthesis, implementation, timing, and power analysis. The project provides a foundation for future development toward a more comprehensive battery monitoring and protection subsystem.

## Author

**Irulappan J**

Electronics and Communication Engineering
**National Engineering College**

````




