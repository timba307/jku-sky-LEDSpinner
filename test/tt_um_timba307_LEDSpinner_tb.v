// Copyright 2025 Tim Tremetsberger
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE−2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/*
  Testbench für tt_um_timba307_LEDSpinner
  - 50 MHz Systemtakt
  - nutzt den internen Prescaler (Tick-Rate via ui_in[3:0])
  - stop/guess Sequenzen zum Prüfen von dp/7-Segment
*/

`timescale 1ns/1ns

// Alle Sourcefiles beim Kompilieren mitgeben (Top enthält bereits die `include`s)

module tt_um_timba307_LEDSpinner_tb;

  // Inputs des Tops
  reg  [7:0] ui_in  = 8'h00; // [3:0]=speed, [7]=stop
  reg  [7:0] uio_in = 8'h00; // [5:0]=guess
  reg        ena    = 1'b1;
  reg        clk    = 1'b0;
  reg        rst_n  = 1'b0;  // active-low

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // DUT
  tt_um_timba307_LEDSpinner dut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(ena),
    .clk(clk),
    .rst_n(rst_n)
  );

  // 50 MHz Clock
  /* verilator lint_off STMTDLY */
  always #10 clk = ~clk;
  /* verilator lint_on STMTDLY */

  initial begin
    $dumpfile("tt_um_timba307_LEDSpinner_tb.vcd");
    $dumpvars;

    // Reset halten
    /* verilator lint_off STMTDLY */
    #200 rst_n = 1'b1; // deassert reset nach 200 ns

    // Schnellste Prescaler-Option im Design ist "default" → 8 Hz (limit=6_250_000)
    // Setze speed_bits so, dass der default-Case greift (z.B. 4'b0101)
    ui_in[3:0] = 4'b0101;

    // guesses: zunächst alle 0 → dp sollte AUS bleiben, wenn Wheel stoppt
    uio_in[5:0] = 6'b000000;

    // Zuerst drehen lassen (stop=0)
    ui_in[7] = 1'b0;

    // Eine Weile laufen lassen
    #300_000_000; // 0.3 s

    // Stop anfordern, noch ohne Guess → dp bleibt 0
    ui_in[7] = 1'b1;
    #200_000_000; // warten bis gestoppt

    // Jetzt alle guesses aktivieren → dp sollte bei Stillstand 1 sein
    uio_in[5:0] = 6'b111111;
    #100_000_000;

    // Erneut starten (stop=0)
    ui_in[7] = 1'b0;
    #300_000_000;

    // Noch einmal stoppen
    ui_in[7] = 1'b1;
    #200_000_000;

    $finish;
    /* verilator lint_on STMTDLY */
  end
endmodule
