# Low-Power AI MAC Accelerator

This repository contains a high-level RTL implementation of a dedicated low-power AI Multiply-Accumulate (MAC) accelerator designed for edge AI inference workloads.

## Architecture summary

- 8x8 processing element (PE) array
- 8-bit signed activations and weights
- 32-bit accumulator
- Weight-stationary style dataflow
- Zero-skipping to reduce dynamic power
- Clock gating support through PE enable signals
- Simple FSM controller for tile scheduling and output capture

## Directory structure

- `rtl/` : synthesizable RTL modules
- `tb/` : testbench for functional verification
- `sim/` : simulation helpers

## Core modules

- `mac_pe.v` : multiply-accumulate primitive with zero-skipping
- `mac_array.v` : 8x8 PE tile for parallel MAC computation
- `mac_controller.v` : control FSM for MAC tile execution
- `mem_bank.v` : simple synchronous SRAM macro
- `top_mac_accelerator.v` : top-level accelerator wrapper

## Typical usage

Compile and run with `iverilog` or `iverilog + vcs` style tooling:

```bash
iverilog -g2012 -s tb_top_mac_accelerator -o sim/mac_accelerator tb/tb_top_mac_accelerator.v rtl/*.v
vvp sim/mac_accelerator
```

## Design notes

This implementation intentionally emphasizes a clear, readable, synthesizable RTL structure rather than a highly optimized production ASIC design. It is suitable as a starting point for:

- custom edge AI accelerator exploration
- FPGA emulation
- low-power design benchmarking
- teaching and architecture study

## Future enhancements

- optional bias addition and output quantization
- more advanced memory tiling
- support for INT4 / mixed precision
- AXI-compatible host interface
- power estimation and cycle accounting

