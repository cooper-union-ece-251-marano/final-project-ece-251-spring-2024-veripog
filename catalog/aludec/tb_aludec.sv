//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
//     Create Date: 2023-02-07
//     Module Name: tb_aludec
//     Description: Test bench for simple behavorial ALU decoder
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_ALUDEC
`define TB_ALUDEC

`timescale 1ns / 100ps
`include "aludec.sv"

module tb_aludec;
    // Parameter definition for modularity (currently unused in aludec)
    parameter n = 32;

    // Test Bench Signals
    reg [5:0] funct;
    reg [1:0] aluop;
    wire [2:0] alucontrol;

    // Instantiate the ALU Decoder
    aludec #(.n(n)) uut (
        .funct(funct),
        .aluop(aluop),
        .alucontrol(alucontrol)
    );

    // Initial block for test stimuli
    initial begin
        // Initialize Inputs
        funct = 0;
        aluop = 0;

        // Display results
        $monitor("Time = %t, aluop = %b, funct = %b, alucontrol = %b", $time, aluop, funct, alucontrol);

        // Test Case 1: LW or SW operation
        aluop = 2'b00; #10;
        if (alucontrol !== 3'b010) $display("Error: LW or SW should set alucontrol to 010");

        // Test Case 2: BEQ operation
        aluop = 2'b01; #10;
        if (alucontrol !== 3'b110) $display("Error: BEQ should set alucontrol to 110");

        // R-type instructions
        aluop = 2'b10;
        funct = 6'b100000; #10;  // ADD
        if (alucontrol !== 3'b000) $display("Error: ADD should set alucontrol to 000");

        funct = 6'b100010; #10;  // SUB
        if (alucontrol !== 3'b001) $display("Error: SUB should set alucontrol to 001");

        funct = 6'b100100; #10;  // AND
        if (alucontrol !== 3'b010) $display("Error: AND should set alucontrol to 010");

        funct = 6'b100101; #10;  // OR
        if (alucontrol !== 3'b011) $display("Error: OR should set alucontrol to 011");

        funct = 6'b101010; #10;  // SLT
        if (alucontrol !== 3'b111) $display("Error: SLT should set alucontrol to 111");

        funct = 6'b000000; #10;  // SLL
        if (alucontrol !== 3'b100) $display("Error: SLL should set alucontrol to 100");

        funct = 6'b000010; #10;  // SRL
        if (alucontrol !== 3'b101) $display("Error: SRL should set alucontrol to 101");

        // Testing undefined funct
        funct = 6'b111111; #10;  // Undefined funct
        if (alucontrol !== 3'bxxx) $display("Error: Undefined funct should set alucontrol to xxx");

        // Testing undefined aluop
        aluop = 2'b11; #10;  // Undefined aluop
        if (alucontrol !== 3'bxxx) $display("Error: Undefined aluop should set alucontrol to xxx");

        // Finish simulation
        $finish;
    end
endmodule
`endif // TB_ALUDEC