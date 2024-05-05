//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
//     Create Date: 2023-02-07
//     Module Name: tb_datapath
//     Description: Test bench for datapath
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_DATAPATH
`define TB_DATAPATH

`timescale 1ns / 100ps
`include "datapath.sv"

module tb_datapath;
    parameter n = 32;
    reg clk, reset;
    reg memtoreg, pcsrc;
    reg alusrc, regdst;
    reg regwrite, jump;
    reg [2:0] alucontrol;
    wire zero;
    wire [n-1:0] pc;
    reg [n-1:0] instr;
    wire [n-1:0] aluout, writedata;
    reg [n-1:0] readdata;

    // Instantiate the datapath
    datapath #(.n(n)) DUT (
        .clk(clk),
        .reset(reset),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol),
        .zero(zero),
        .pc(pc),
        .instr(instr),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = !clk;  // Generate a clock with 10 ns period
    end

    // Test initialization and instruction execution
    initial begin
        reset = 1; memtoreg = 0; pcsrc = 0; alusrc = 0; regdst = 0; regwrite = 0; jump = 0; alucontrol = 3'b010;
        instr = 32'h00000000; readdata = 0;

        // Reset the system
        #20 reset = 0;

        // First test: ADD instruction
        #10;
        instr = 32'h00852020; // add $a0, $a0, $a1
        alucontrol = 3'b010; // ALU control code for ADD
        regwrite = 1;
        regdst = 1; // Result goes to rd field
        memtoreg = 0;
        alusrc = 0; // ALU source is the register

        // Second test: Branch on equal
        #20;
        instr = 32'h10840005; // beq $a0, $a0, target
        pcsrc = zero; // PC source should switch if zero is true
        alucontrol = 3'b110; // ALU control for subtraction (used to set zero)

        // Third test: Immediate operation (ADDI)
        #20;
        instr = 32'h20840001; // addi $a0, $a0, 1
        alusrc = 1; // ALU source is immediate
        regdst = 0; // Result goes to rt field
        alucontrol = 3'b010; // ALU add
        regwrite = 1;

        // Further instructions can be added here

        #100; // Allow some time for the last instruction effects

        // End simulation
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %t, PC = %h, ALUOut = %h, WriteData = %h, Zero = %b, Instruction = %h", $time, pc, aluout, writedata, zero, instr);
    end

endmodule
`endif // TB_DATAPATH
