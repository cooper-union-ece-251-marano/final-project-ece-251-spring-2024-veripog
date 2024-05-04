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
    reg [1:0] aluOp;
    wire [2:0] alu_control;

    // Instantiate the ALU Decoder
    aludec #(.n(n)) uut (
        .funct(funct),
        .aluOp(aluOp),
        .alu_control(alu_control)
    );

    // Initial block for test stimuli
    initial begin
        // Initialize Inputs
        funct = 0;
        aluOp = 0;

        // Display results
        $monitor("Time = %t, aluOp = %b, funct = %b, alu_control = %b", $time, aluOp, funct, alu_control);

        // Test Case 1: LW or SW operation
        aluOp = 2'b00; #10;
        if (alu_control !== 3'b010) $display("Error: LW or SW should set alu_control to 010");

        // Test Case 2: BEQ operation
        aluOp = 2'b01; #10;
        if (alu_control !== 3'b110) $display("Error: BEQ should set alu_control to 110");

        // R-type instructions
        aluOp = 2'b10;
        funct = 6'b100000; #10;  // ADD
        if (alu_control !== 3'b000) $display("Error: ADD should set alu_control to 000");

        funct = 6'b100010; #10;  // SUB
        if (alu_control !== 3'b001) $display("Error: SUB should set alu_control to 001");

        funct = 6'b100100; #10;  // AND
        if (alu_control !== 3'b010) $display("Error: AND should set alu_control to 010");

        funct = 6'b100101; #10;  // OR
        if (alu_control !== 3'b011) $display("Error: OR should set alu_control to 011");

        funct = 6'b101010; #10;  // SLT
        if (alu_control !== 3'b111) $display("Error: SLT should set alu_control to 111");

        funct = 6'b000000; #10;  // SLL
        if (alu_control !== 3'b100) $display("Error: SLL should set alu_control to 100");

        funct = 6'b000010; #10;  // SRL
        if (alu_control !== 3'b101) $display("Error: SRL should set alu_control to 101");

        // Testing undefined funct
        funct = 6'b111111; #10;  // Undefined funct
        if (alu_control !== 3'bxxx) $display("Error: Undefined funct should set alu_control to xxx");

        // Testing undefined aluOp
        aluOp = 2'b11; #10;  // Undefined aluOp
        if (alu_control !== 3'bxxx) $display("Error: Undefined aluOp should set alu_control to xxx");

        // Finish simulation
        $finish;
    end
endmodule
`endif // TB_ALUDEC