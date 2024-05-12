//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
//     Create Date: 2023-02-07
//     Module Name: alu
//     Description: 32-bit RISC-based CPU alu (MIPS)
//
// Revision: 1.0
// see https://github.com/Caskman/MIPS-Processor-in-Verilog/blob/master/ALU32Bit.v
//////////////////////////////////////////////////////////////////////////////////
`ifndef ALU
`define ALU

`timescale 1ns/100ps
module alu(input [31:0] a, b, 
           input [2:0] alucont, 
           output reg [31:0] result, 
           output zero);
  
  wire [31:0] b2 = alucont[2] ? ~b : b;
  wire [31:0] sum = a + b2 + alucont[2];
  wire slt = sum[31];

  always @(*)
      case(alucont)
          3'b000: result = a & b;         // AND
          3'b001: result = a | b;         // OR
          3'b010: result = sum;           // ADD
          3'b011: result = ~(a | b);      // NOR
          3'b110: result = sum;           // SUB
          3'b111: result = {31'b0, slt};  // SLT
      endcase

  assign zero = (result == 0);
endmodule

`endif // ALU
