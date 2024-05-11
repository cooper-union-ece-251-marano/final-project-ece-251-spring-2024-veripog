//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Prof Rob Marano
// 
//     Create Date: 2023-02-07
//     Module Name: regfile
//     Description: 32-bit RISC register file
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef REGFILE
`define REGFILE

`timescale 1ns/100ps

module regfile(input         clk,      we3, // clock and write enable
               input  [4:0]  ra1, ra2, wa3, // 2 read addresses, 1 write address
               input  [31:0]           wd3, // write data
               output [31:0] rd1, rd2);     // 2 read data

  reg [31:0] rf[31:0]; // 32 registers (each 32 bits wide)

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  always @(posedge clk)
    if (we3) 
      rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0; // read data from register 1
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0; // read data from register 2
endmodule

`endif // REGFILE
