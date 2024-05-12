//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
//     Create Date: 2023-02-07
//     Module Name: tb_adder
//     Description: Test bench for simple behavioral adder
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_ADDER
`define TB_ADDER

`timescale 1ns/100ps
`include "adder.sv"

module tb_adder;

    parameter WIDTH = 32;  // Parameter for the width of the adder
    reg [WIDTH-1:0] A, B;  // Inputs are reg for the testbench
    reg Cin;               // Carry-in for the testbench
    wire [WIDTH-1:0] Sum;  // Output Sum is wire for the testbench
    wire Cout;             // Carry-out for the testbench
    reg EN;                // Enable signal for the testbench
    reg RST;               // Reset signal for the testbench

    // Instantiate the Unit Under Test (UUT)
    adder #(.WIDTH(WIDTH)) uut(
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .Sum(Sum), 
        .Cout(Cout),
        .EN(EN),
        .RST(RST)
    );

    initial begin
        $dumpfile("adder.vcd"); 
        $dumpvars(0, tb_adder);

        // Initialize signals
        A = 0; B = 0; Cin = 0; EN = 0; RST = 1; #10;
        RST = 0; EN = 1; // Release reset and enable the adder

        // Test Case 1: Zero Addition
        A = 0; B = 0; Cin = 0;
        #10;
        assert(Sum == 0 && Cout == 0) else $display("Test Case 1 Failed");

        // Test Case 2: Maximum Value Addition without carry
        A = {WIDTH{1'b1}}; B = 0; Cin = 0;
        #10;
        assert(Sum == {WIDTH{1'b1}}) else $display("Test Case 2 Failed");

        // Test Case 3: Maximum Value Addition with carry
        A = {WIDTH{1'b1}}; B = {WIDTH{1'b1}}; Cin = 1;
        #10;
        assert(Sum == {WIDTH{1'b1}} && Cout == 1) else $display("Test Case 3 Failed");

        // Test Case 4: Check carry propagation
        A = {1'b1, {WIDTH-1{1'b0}}};
        B = {1'b1, {WIDTH-1{1'b0}}};
        Cin = 0;
        #10;
        assert(Sum == 0 && Cout == 1) else $display("Test Case 4 Failed: Expected Sum=0, Cout=1, Got Sum=%b, Cout=%b", Sum, Cout);

        // Disable and ensure outputs are zero
        EN = 0;
        #10;
        assert(Sum == 0 && Cout == 0) else $display("Disabled Test Failed");

        // Re-enable and check with random values
        EN = 1;
        repeat (5) begin
            A = $random;
            B = $random;
            Cin = $random % 2;
            #10;
        end
        
        // Finish simulation
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time = %0t: A=%b, B=%b, Cin=%b, EN=%b, RST=%b -> Sum=%b, Cout=%b",
                $time, A, B, Cin, EN, RST, Sum, Cout);
    end

endmodule
`endif // TB_ADDER