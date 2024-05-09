`timescale 1ns / 1ps

module computer_tb;

  reg clk;
  reg reset;

  wire [31:0] writedata, dataadr;
  wire memwrite;

  // Instantiate the device under test (DUT)
  computer dut(clk, reset, writedata, dataadr, memwrite);

  // Initialize instruction memory with the test program
  initial begin
    $readmemh("gpt.dat", dut.imem.RAM);
  end

  // Clock generation
  always begin
    clk = 1; #5; // 5 ns high
    clk = 0; #5; // 5 ns low
  end

  // Test sequence
  initial begin
    $dumpfile("computer.vcd");
    $dumpvars(0,dut.cpu.pc, dut.cpu.instr, memwrite, dataadr, writedata);
    // Monitor signals
    $monitor("%d: pc = %h, instr = %h, memwrite = %b, dataadr = %h, writedata = %h",
             $time, dut.cpu.pc, dut.cpu.instr, memwrite, dataadr, writedata);

    // Apply reset
    reset <= 1; #22;
    reset <= 0;

    // Run for a sufficient period to execute the test program
    #200;

    // Finish the simulation
    $finish;
  end

  always@(negedge clk)
    begin
      if(memwrite) begin
        if (dut.dmem.RAM[21] == 88) begin
          $display("Test Passed: Memory location 84 contains the correct value 88");
        end else begin
          $display("Test Failed: Memory location 84 contains %d instead of 88", dut.dmem.RAM[21]);
        end
      end
    end
endmodule
