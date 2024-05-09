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
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // Fibonacci sequence expected values
  reg [31:0] expected_fib [0:9];
  initial begin
    $dumpfile("computer.vcd");
    $dumpvars(0,clk,reset,writedata,dataadr,memwrite);
    $display("Time              reset writedata     dataadr     memwrite");
    $monitor("t=%t\t0x%7h\t%7d\t%8d",$realtime,writedata,dataadr,memwrite);
    expected_fib[0] = 0;
    expected_fib[1] = 1;
    expected_fib[2] = 1;
    expected_fib[3] = 2;
    expected_fib[4] = 3;
    expected_fib[5] = 5;
    expected_fib[6] = 8;
    expected_fib[7] = 13;
    expected_fib[8] = 21;
    expected_fib[9] = 34;
  end

  // Memory address where Fibonacci sequence starts
  reg [31:0] fib_start_addr;
  initial fib_start_addr = 100;

  integer i;
  
  // check Fibonacci sequence
  always@(negedge clk)
    begin
      if(memwrite) begin
        for (i = 0; i < 10; i = i + 1) begin
          if(dataadr === fib_start_addr + i*4) begin
            if(writedata !== expected_fib[i]) begin
              $display("Simulation failed at Fibonacci index %d: expected %d, got %d", i, expected_fib[i], writedata);
              $finish;
            end
          end
        end
        if (dataadr === fib_start_addr + 36) begin // Address of the last Fibonacci number + 4
          $display("Simulation succeeded");
          $finish;
        end
      end
    end
endmodule