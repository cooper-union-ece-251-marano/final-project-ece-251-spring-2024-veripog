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

module aludec
    #(parameter n = 32)(
    //
    // ---------------- PORT DEFINITIONS ----------------
    //
        input wire [5:0] funct,         // Function field from the instruction
        input wire [1:0] aluOp,         // ALU operation mode from control unit
        output reg [2:0] alu_control    // Control signals for the ALU
    );
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    always @(*) begin
        case (aluOp)
            2'b00: alu_control = 3'b010; // LW or SW (add)
            2'b01: alu_control = 3'b110; // BEQ (subtract)

            2'b10: begin
                case (funct) // R-type instructions
                    6'b100000: alu_control = 3'b000; // ADD
                    6'b100010: alu_control = 3'b001; // SUB
                    6'b100100: alu_control = 3'b010; // AND
                    6'b100101: alu_control = 3'b011; // OR
                    6'b101010: alu_control = 3'b111; // SLT (set on less than)
                    6'b000000: alu_control = 3'b100; // SLL (shift left logical)
                    6'b000010: alu_control = 3'b101; // SRL (shift right logical)
                    default:   alu_control = 3'bxxx; // Undefined operation
                endcase
            end

            default: alu_control = 3'bxxx; // Undefined operation
        endcase
    end

endmodule

`endif // ALUDEC
