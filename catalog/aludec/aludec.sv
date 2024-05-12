//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
//     Create Date: 2023-02-07
//     Module Name: aludec
//     Description: 32-bit RISC ALU decoder
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef ALUDEC
`define ALUDEC

`timescale 1ns/100ps

module aludec(input [5:0] funct, 
              input [1:0] aluop, 
              output reg [2:0] alucontrol);
    always @(*)
        case(aluop)
            2'b00: alucontrol <= 3'b010;  // add (for LW, SW, ADDI where applicable)
            2'b01: alucontrol <= 3'b110;  // sub (for BEQ)
            default: case(funct)          // RTYPE operations
                6'b100000: alucontrol <= 3'b010; // ADD
                6'b100010: alucontrol <= 3'b110; // SUB
                6'b100100: alucontrol <= 3'b000; // AND
                6'b100101: alucontrol <= 3'b001; // OR
                6'b100111: alucontrol <= 3'b011; // NOR
                6'b101010: alucontrol <= 3'b111; // SLT
                default:   alucontrol <= 3'bxxx; // undefined
            endcase
        endcase
endmodule

`endif // ALUDEC
