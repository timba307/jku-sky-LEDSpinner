![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

# LED Spinner TinyTapeout Project
**Module:** `tt_um_timba307_LEDSpinner`

Play Roulette using a 7-segment display hooked up to the chip. Using the TinyTapeout Demo Board, the built-in 7-segment can be used directly.

## Features
- Five different Roulette speeds
- Guess on which segment the wheel will stop
- Display point lights up as win confirmation
- Pseudo-random number generator randomizes stopping position

## Top-Level I/O

| Signal         | Dir | W | Purpose |
|---|---:|---:|---|
| `ui_in[3:0]`   | in  | 4 | Set speed, only `4b0000`, `4b0001`, `4b0011`, `4b0111`, `4b1111` are allowed for 1 Hz, 2 Hz, 4 Hz, 8 Hz and 16 Hz respectively. Invalid config triggers 1 kHz speed for testing purposes. |
| `ui_in[7]`  | in | 1 | Stop the wheel |
| `uio_in[0]`    | in  | 1 | Guess top segment |
| `uio_in[1]`    | in  | 1 | Guess top right segment |
| `uio_in[2]`    | in  | 1 | Guess bottom right segment |
| `uio_in[3]`    | in  | 1 | Guess bottom segment |
| `uio_in[4]`    | in  | 1 | Guess bottom left segment |
| `uio_in[5]`    | in  | 1 | Guess top left segment |
| `uo_out[6:0]`  | out  | 7 | 7-segment outer ring |
| `uo_out[7]`   | out | 1 | 7-segment display point |
| `clk`          | in  | 1 | System clock |
| `rst_n`        | in  | 1 | Async reset (active-low) |
| `ena`          | in  | 1 | Always `1` on TinyTapeout |
