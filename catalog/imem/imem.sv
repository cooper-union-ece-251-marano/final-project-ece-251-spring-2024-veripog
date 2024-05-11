//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Prof Rob Marano
// 
//     Create Date: 2023-02-07
//     Module Name: imem
//     Description: 32-bit RISC memory (instruction "text" segment)
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef IMEM
`define IMEM

`timescale 1ns/100ps

module imem(input  [5:0] a, // 6-bit address (program counter)
            output [31:0] rd); // 32-bit instruction

  reg  [31:0] RAM[63:0]; // 64 words of memory (each 32 bits wide)

  initial 
    begin
        // $readmemh("memfile.dat", RAM, 0, 63); // Explicitly defining the range
    end


  assign rd = RAM[a]; // word aligned
endmodule

`endif // IMEM
