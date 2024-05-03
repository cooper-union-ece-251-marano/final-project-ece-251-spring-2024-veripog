//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
//     Create Date: 2023-02-07
//     Module Name: adder
//     Description: simple behavorial adder
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef ADDER
`define ADDER

`timescale 1ns/100ps

module adder
    #(parameter n = 32)(
    //
    // ---------------- PORT DEFINITIONS ----------------
    //
    input [31:0] A,
    input [31:0] B,
    output [31:0] Y
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    assign Y = A + B;
endmodule

`endif // ADDER