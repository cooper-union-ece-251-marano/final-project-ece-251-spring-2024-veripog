//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Prof Rob Marano
// 
//     Create Date: 2023-02-07
//     Module Name: tb_computer
//     Description: Test bench for a single-cycle MIPS computer
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_COMPUTER
`define TB_COMPUTER

`timescale 1ns/100ps

`include "computer.sv"
`include "../clock/clock.sv"

module testbench();

  reg         clk;
  reg         reset;

  wire [31:0] writedata, dataadr;
  wire memwrite;

  // instantiate device to be tested
  computer dut(clk, reset, writedata, dataadr, memwrite);

  // initialize test
  initial
    begin
      $readmemh("mult.dat", dut.imem.RAM, 0, 63);
      $dumpfile("computer.vcd");
      $dumpvars(0, dut, memwrite, dataadr, writedata);
      // Monitor signals
      $monitor("%d: pc = %h, instr = %h, memwrite = %b, dataadr = %h, writedata = %h, rs = %h, rt = %h, immediate = %h, ra1 = %h, ra2 = %h, wa3 = %h, wd3 = %h, rd1 = %h, rd2 = %h",
               $time, dut.cpu.pc, dut.cpu.instr, memwrite, dataadr, writedata, 
               dut.cpu.instr[25:21], dut.cpu.instr[20:16], dut.cpu.instr[15:0],
               dut.cpu.dp.rf.ra1, dut.cpu.dp.rf.ra2, dut.cpu.dp.rf.wa3,
               dut.cpu.dp.rf.wd3, dut.cpu.dp.rf.rd1, dut.cpu.dp.rf.rd2);

      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  always @(negedge clk or posedge clk) begin
      if (memwrite) begin
          if (dataadr === 0) begin
              $display("Address: %h", dataadr);
              $display("Output (hex): %h", writedata);
              $display("Output (dec): %d", writedata);
              $finish();
          end
      end
  end
endmodule

`endif // TB_COMPUTER