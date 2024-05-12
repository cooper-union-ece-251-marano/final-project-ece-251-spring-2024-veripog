//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Prof Rob Marano
// 
//     Create Date: 2023-02-07
//     Module Name: computer
//     Description: 32-bit RISC
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef COMPUTER
`define COMPUTER

`timescale 1ns/100ps

`include "../cpu/cpu.sv"
`include "../imem/imem.sv"
`include "../dmem/dmem.sv"

module computer(input         clk, reset, 
                output [31:0] writedata, dataadr, 
                output        memwrite);

  wire [31:0] pc, instr, readdata; 
  
  // instantiate processor and memories
  cpu cpu(clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);
  imem imem(pc[7:2], instr); // pc index out of 64 words of instructions, 32 bit instruction
  dmem dmem(clk, memwrite, dataadr, writedata, readdata);
endmodule

`endif // COMPUTER
