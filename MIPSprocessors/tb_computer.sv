module testbench();

  reg         clk;
  reg         reset;

  wire [31:0] writedata, dataadr;
  wire memwrite;

  // instantiate device to be tested
  computer dut(clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      $readmemh("me.dat", dut.imem.RAM);
      $dumpfile("computer.vcd");
      $dumpvars(0,dut, memwrite, dataadr, writedata);
      // Monitor signals
      $monitor("%d: pc = %h, instr = %h, memwrite = %b, dataadr = %h, writedata = %h",
              $time, dut.cpu.pc, dut.cpu.instr, memwrite, dataadr, writedata);

      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check that 7 gets written to address 84
  always@(negedge clk)
    begin
      if(memwrite) begin
        if(dataadr === 84 & writedata === 2) begin
          $display("Simulation succeeded");
          $stop;
        end else if (dataadr !== 80) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end
endmodule