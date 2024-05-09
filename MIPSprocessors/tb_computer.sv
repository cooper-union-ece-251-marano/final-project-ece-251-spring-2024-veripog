module tb_computer();

  reg         clk;
  reg         reset;

  wire [31:0] writedata, dataadr;
  wire memwrite;

  // instantiate device to be tested
  computer dut(clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
        $dumpfile("computer.vcd");
        $dumpvars(0,clk,reset,writedata,dataadr,memwrite);
        $monitor("t=%t\t0x%7h\t%7d\t%8d",$realtime,writedata,dataadr,memwrite);
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
        if(dataadr === 84 & writedata === 7) begin
          $display("Simulation succeeded");
          $stop;
        end else if (dataadr !== 80) begin
          $display("Simulation failed");
          $stop;
        end else begin
          $display("Simulation end");
          $stop;
        end
      end
    end
endmodule