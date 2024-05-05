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
        a = 32'h0001_0001; b = 32'h0001_0002; alucontrol = 3'b000; // ADD
        #10;
        if (result != (a + b))
            $display("Test Case 1 Failed: Addition Error. Expected %h, Got %h", a+b, result);
        else
            $display("Test Case 1 Passed: Addition Correct.");

        // Test Case 2: Subtraction
        a = 32'h0002_0003; b = 32'h0001_0001; alucontrol = 3'b001; // SUBTRACT
        #10;
        if (result != (a - b))
            $display("Test Case 2 Failed: Subtraction Error. Expected %h, Got %h", a-b, result);
        else
            $display("Test Case 2 Passed: Subtraction Correct.");

        // Test Case 3: AND
        a = 32'hFF00_FF00; b = 32'h00FF_00FF; alucontrol = 3'b010; // AND
        #10;
        if (result != (a & b))
            $display("Test Case 3 Failed: AND Error. Expected %h, Got %h", a & b, result);
        else
            $display("Test Case 3 Passed: AND Correct.");

        // Test Case 4: OR
        a = 32'hFF00_FF00; b = 32'h00FF_00FF; alucontrol = 3'b011; // OR
        #10;
        if (result != (a | b))
            $display("Test Case 4 Failed: OR Error. Expected %h, Got %h", a | b, result);
        else
            $display("Test Case 4 Passed: OR Correct.");

        // Test Case 5: XOR
        a = 32'hFF00_FF00; b = 32'h00FF_00FF; alucontrol = 3'b100; // XOR
        #10;
        if (result != (a ^ b))
            $display("Test Case 5 Failed: XOR Error. Expected %h, Got %h", a ^ b, result);
        else
            $display("Test Case 5 Passed: XOR Correct.");

        // Test Case 6: NOR
        a = 32'h0F0F_0F0F; b = 32'hF0F0_F0F0; alucontrol = 3'b101; // NOR
        #10;
        if (result != ~(a | b))
            $display("Test Case 6 Failed: NOR Error. Expected %h, Got %h", ~(a | b), result);
        else
            $display("Test Case 6 Passed: NOR Correct.");

        // Test Case 7: SLL
        a = 5; b = 32'h1; alucontrol = 3'b110; // Shift left logical
        #10;
        if (result != (b << a))
            $display("Test Case 7 Failed: SLL Error. Expected %h, Got %h", b << a, result);
        else
            $display("Test Case 7 Passed: SLL Correct.");

        // Test Case 8: SRA
        a = 5; b = 32'h8000_0000; alucontrol = 3'b111; // Shift right arithmetic
        #10;
        if (result != (b >>> a))
            $display("Test Case 8 Failed: SRA Error. Expected %h, Got %h", b >>> a, result);
        else
            $display("Test Case 8 Passed: SRA Correct.");

        // Finish simulation
        $finish;
    end
endmodule

`endif // TB_ALU
