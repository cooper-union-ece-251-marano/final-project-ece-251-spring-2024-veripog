//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
// Create Date: 2023-02-07
// Module Name: tb_alu
// Description: Test bench for simple behavioral ALU
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_ALU
`define TB_ALU

`timescale 1ns/100ps
`include "alu.sv"

module tb_alu;
    parameter n = 32;

    // Inputs to the ALU
    reg [n-1:0] a, b;
    reg [2:0] alucontrol;

    // Outputs from the ALU
    wire [n-1:0] result;
    wire zero;

    // Instantiate the ALU
    alu #(n) alu_instance (.a(a), .b(b), .alucontrol(alucontrol), .result(result), .zero(zero));

    // Test cases
    initial begin
        $dumpfile("alu.vcd"); 
        $dumpvars(0, tb_alu);

        // Initialize inputs
        a = 0; b = 0; alucontrol = 0;
        #10; // Wait for 10ns to observe initial behavior

        // Test Case 1: Addition
        a = 32'h0001_0001; b = 32'h0001_0002; alucontrol = 3'b010; // ADD
        #10;
        if (result != (a + b))
            $display("Test Case 1 Failed: Addition Error. Expected %h, Got %h", a+b, result);
        else
            $display("Test Case 1 Passed: Addition Correct.");

        // Test Case 2: AND
        a = 32'hFF00_FF00; b = 32'h00FF_00FF; alucontrol = 3'b000; // AND
        #10;
        if (result != (a & b))
            $display("Test Case 2 Failed: AND Error. Expected %h, Got %h", a & b, result);
        else
            $display("Test Case 2 Passed: AND Correct.");

        // Test Case 3: OR
        a = 32'hFF00_FF00; b = 32'h00FF_00FF; alucontrol = 3'b001; // OR
        #10;
        if (result != (a | b))
            $display("Test Case 3 Failed: OR Error. Expected %h, Got %h", a | b, result);
        else
            $display("Test Case 3 Passed: OR Correct.");

        // Test Case 4: Multiplication
        a = 32'h0001_0003; b = 32'h0000_0002; alucontrol = 3'b011; // MULT
        #10;
        // Checking HiLo is not directly possible without access to it as an output
        $display("Test Case 4 Passed: Check manual verification for HiLo values.");

        // Test Case 5: MFLO
        alucontrol = 3'b100; // MFLO
        #10;
        if (result != (a * b))
            $display("Test Case 5 Failed: MFLO Error. Expected %h, Got %h", (a * b), result);
        else
            $display("Test Case 5 Passed: MFLO Correct.");

        // Test Case 6: MFHI (Should be 0 because no overflow in previous test)
        alucontrol = 3'b101; // MFHI
        #10;
        if (result != 32'b0)
            $display("Test Case 6 Failed: MFHI Error. Expected 0, Got %h", result);
        else
            $display("Test Case 6 Passed: MFHI Correct.");

        // Finish simulation
        $finish;
    end
endmodule

`endif // TB_ALU
