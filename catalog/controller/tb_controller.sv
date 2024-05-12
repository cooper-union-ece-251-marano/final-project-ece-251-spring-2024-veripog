//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
//     Create Date: 2023-02-07
//     Module Name: tb_controller
//     Description: Test bench for controller
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_CONTROLLER
`define TB_CONTROLLER

`timescale 1ns/100ps
`include "controller.sv"

`timescale 1ns/100ps
`include "controller.sv"

module tb_controller;
    parameter n = 32;  // Parameter for future use if needed

    // Test Inputs
    reg [5:0] op;
    reg [5:0] funct;
    reg zero;

    // Test Outputs
    wire memtoreg;
    wire memwrite;
    wire pcsrc;
    wire alusrc;
    wire regdst;
    wire regwrite;
    wire jump;
    wire [2:0] alucontrol;

    // Instantiate the Unit Under Test (UUT)
    controller #(.n(n)) uut (
        .op(op),
        .funct(funct),
        .zero(zero),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol)
    );

    // Initial Block for Test Vectors
    initial begin
        $dumpfile("controller.vcd"); 
        $dumpvars(0, tb_controller);
        
        // Initialize Inputs
        op = 0;
        funct = 0;
        zero = 0;

        // Apply Test Vectors
        // Test Case 1: R-type operation (e.g., ADD)
        #10 op = 6'b000000; funct = 6'b100000; zero = 0;  // ADD operation
        #10 assert(regwrite && regdst && !alusrc && !memwrite && !memtoreg && (alucontrol == 3'b010)) else $display("Test Case 1 Failed: ADD operation incorrect");
        // TODO: TEST CASE 1: ADD operation incorrect

        // Test Case 2: Branch on equal (BEQ) where zero is true
        #10 op = 6'b000100; funct = 6'bxxxxxx; zero = 1;  // BEQ operation
        #10 assert(pcsrc && !jump && !alusrc && !regwrite && !memwrite && !memtoreg) else $display("Test Case 2 Failed: BEQ operation incorrect");

        // Test Case 3: Load word (LW)
        #10 op = 6'b100011; funct = 6'bxxxxxx; zero = 0;  // LW operation
        #10 assert(alusrc && memtoreg && regwrite && !regdst && !memwrite && !pcsrc && !jump) else $display("Test Case 3 Failed: LW operation incorrect");

        // Test Case 4: Jump (J)
        #10 op = 6'b000010; funct = 6'bxxxxxx; zero = 0;  // J operation
        #10 assert(jump && !pcsrc && !alusrc && !regwrite && !memwrite && !memtoreg) else $display("Test Case 4 Failed: J operation incorrect");

        // Finish Simulation
        #100 $finish;
    end

    // Monitoring changes for debugging
    initial begin
        $monitor("Time = %t, op = %b, funct = %b, zero = %b, Outputs = {%b %b %b %b %b %b %b %b}",
                 $time, op, funct, zero, memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, alucontrol);
    end

endmodule
`endif // TB_CONTROLLER