//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Prof Rob Marano
// 
//     Create Date: 2023-02-07
//     Module Name: cpu
//     Description: 32-bit RISC-based CPU (MIPS)
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef CPU
`define CPU

`timescale 1ns/100ps

`include "../controller/controller.sv"
`include "../datapath/datapath.sv"

module cpu(input         clk, reset, 
           output [31:0] pc, 
           input  [31:0] instr, 
           output        memwrite, 
           output [31:0] aluout, writedata, 
           input  [31:0] readdata); 

  wire        memtoreg, branch, 
              pcsrc, zero,
              alusrc, regdst, regwrite, jump;
  wire [2:0]  alucontrol;

  controller c(instr[31:26], instr[5:0], zero, // opcode, funct, zero
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump,
               alucontrol);
  datapath dp(clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump,
              alucontrol,
              zero, pc, instr,
              aluout, writedata, readdata);
endmodule

`endif // CPU
