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

module alu(
    input  logic clk,
    input  logic [31:0] a, b,
    input  logic [2:0] alucontrol,
    output logic [31:0] result,
    output logic zero
);

  logic [31:0] condinvb, sum;
  logic [63:0] HiLo;
  logic [31:0] sumSlt;
  logic [63:0] next_HiLo;

  assign zero = (result == 32'b0);
  assign condinvb = alucontrol[2] ? ~b : b;
  assign sumSlt = a + condinvb + alucontrol[2];

  initial begin
    HiLo = 64'b0;
  end

  // Compute next HiLo value based on alucontrol
  always_comb begin
    case (alucontrol)
      3'b011: next_HiLo = {32'b0, a * b}; // mult, only update HiLo
      // Add more cases if other operations should modify HiLo
      default: next_HiLo = HiLo; // Retain current HiLo for all other operations
    endcase
  end

  // Result computation block
  always_comb begin
    case (alucontrol)
      3'b000: result = a & b; // and
      3'b001: result = a | b; // or
      3'b010: result = a + b; // add
      3'b100: result = HiLo[31:0]; // MFLO
      3'b101: result = HiLo[63:32]; // MFHI
      3'b110: result = sumSlt; // sub
      3'b111: result = sumSlt[31]; // slt
      default: result = 32'b0; // default case to handle undefined alucontrol values
    endcase
  end

  // Update HiLo at every positive clock edge if there is a change
  always @(posedge clk) begin
    HiLo <= next_HiLo;
  end

endmodule

`endif // ALU
