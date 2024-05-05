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

module alu
    #(parameter n = 32)(
    //
    // ---------------- PORT DEFINITIONS ----------------
    //
        input wire clk,                  // Clock signal
        input wire [n-1:0] a,           // Input operand A
        input wire [n-1:0] b,           // Input operand B
        input wire [2:0] alu_control,   // ALU control signals
        output reg [n-1:0] result,      // Result of ALU operation
        output reg zero                  // Zero flag
    );
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    always @(posedge clk)
    begin
        case(alu_control)
            3'b000: result = a + b;             // ADD
            3'b001: result = a - b;             // SUBTRACT
            3'b010: result = a & b;             // AND
            3'b011: result = a | b;             // OR
            3'b100: result = a ^ b;             // XOR
            3'b101: result = ~(a | b);          // NOR
            3'b110: result = b << a[4:0];       // SLL, shift left logical
            3'b111: result = b >>> a[4:0];      // SRA, shift right arithmetic
            default: result = 32'hxxxxxxxx;     // Undefined operation
        endcase

        // Set the zero flag if result is zero
        zero = (result == 0);
    end

endmodule

`endif // ALU
