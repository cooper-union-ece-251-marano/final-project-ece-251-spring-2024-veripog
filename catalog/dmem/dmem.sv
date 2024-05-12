//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Prof Rob Marano
// 
//     Create Date: 2023-02-07
//     Module Name: dmem
//     Description: 32-bit RISC memory ("data" segment)
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef DMEM
`define DMEM

`timescale 1ns/100ps

module dmem(input         clk, we, 
            input  [31:0] a, wd, 
            output [31:0] rd); 

  reg  [31:0] RAM[63:0]; // 64 words of memory (each 32 bits wide)
  
// word addressable
  assign rd = RAM[a[31:2]]; // read data from memory at address a

  always @(posedge clk) // write on rising edge
    if (we)
      RAM[a[31:2]] <= wd; // write data to memory at address a
endmodule

`endif // DMEM
