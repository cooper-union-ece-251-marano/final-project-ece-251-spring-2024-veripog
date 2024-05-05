`ifndef tb_harris
`define tb_harris

`timescale 1ms/100us // 1ms period, 100us precision

`include "harris.sv"

module mips_single_cycle_tb();

  logic        clk;
  logic        reset;

  logic [31:0] writedata, dataadr;
  logic        memwrite;

  logic firstTest, secondTest;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite);

  initial
  begin
      firstTest = 1'b0;
      secondTest = 1'b0;
      $dumpfile("mips_single_cycle_test.vcd");
      $dumpvars(0,clk,reset,writedata,dataadr,memwrite);
      // $display("writedata\tdataadr\tmemwrite");
      $monitor("0x%7h\t%7d\t%8d",writedata,dataadr,memwrite);
      // $dumpvars(0,clk,a,b,ctrl,result,zero,negative,carryOut,overflow);
      // $display("Ctl Z  N  O  C  A                    B                    ALUresult");
      // $monitor("%3b %b  %b  %b  %b  %8b (0x%2h;%3d)  %8b (0x%2h;%3d)  %8b (0x%2h;%3d)",ctrl,zero,negative,overflow,carryOut,a,a,a,b,b,b,result,result,result);
  end

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

  always @(posedge clk)
  begin
      $display("+");
      $display("\t+instr = 0x%8h",dut.instr);
      $display("\t+op = 0b%6b",dut.mips.c.op);
      $display("\t+controls = 0b%9b",dut.mips.c.md.controls);
      $display("\t+funct = 0b%6b",dut.mips.c.ad.funct);
      $display("\t+aluop = 0b%2b",dut.mips.c.ad.aluop);
      $display("\t+alucontrol = 0b%3b",dut.mips.c.ad.alucontrol);
      $display("\t+alu result = 0x%8h",dut.mips.dp.alu.result);
      $display("\t+HiLo = 0x%8h",dut.mips.dp.alu.HiLo);
      $display("\t+$v0 = 0x%4h",dut.mips.dp.rf.rf[2]);
      $display("\t+$v1 = 0x%4h",dut.mips.dp.rf.rf[3]);
      $display("\t+$a0 = 0x%4h",dut.mips.dp.rf.rf[4]);
      $display("\t+$a1 = 0x%4h",dut.mips.dp.rf.rf[5]);
      $display("\t+$t0 = 0x%4h",dut.mips.dp.rf.rf[8]);
      $display("\t+$t1 = 0x%4h",dut.mips.dp.rf.rf[9]);
      $display("\t+regfile -- ra1 = %d",dut.mips.dp.rf.ra1);
      $display("\t+regfile -- ra2 = %d",dut.mips.dp.rf.ra2);
      $display("\t+regfile -- we3 = %d",dut.mips.dp.rf.we3);
      $display("\t+regfile -- wa3 = %d",dut.mips.dp.rf.wa3);
      $display("\t+regfile -- wd3 = %d",dut.mips.dp.rf.wd3);
      $display("\t+regfile -- rd1 = %d",dut.mips.dp.rf.rd1);
      $display("\t+regfile -- rd2 = %d",dut.mips.dp.rf.rd2);
      $display("\t+RAM[%4d] = %4d",dut.dmem.a,dut.dmem.rd);
      $display("writedata\tdataadr\tmemwrite");
  end

  // check results
  always @(negedge clk)
    begin
      $display("-");
      $display("\t-instr = 0x%8h",dut.instr);
      $display("\t-op = 0b%6b",dut.mips.c.op);
      $display("\t-controls = 0b%9b",dut.mips.c.md.controls);
      $display("\t-funct = 0b%6b",dut.mips.c.ad.funct);
      $display("\t-aluop = 0b%2b",dut.mips.c.ad.aluop);
      $display("\t-alucontrol = 0b%3b",dut.mips.c.ad.alucontrol);
      $display("\t-alu result = 0x%8h",dut.mips.dp.alu.result);
      $display("\t-HiLo = 0x%8h",dut.mips.dp.alu.HiLo);
      $display("\t-$v0 = 0x%4h",dut.mips.dp.rf.rf[2]);
      $display("\t-$v1 = 0x%4h",dut.mips.dp.rf.rf[3]);
      $display("\t-$a0 = 0x%4h",dut.mips.dp.rf.rf[4]);
      $display("\t-$a1 = 0x%4h",dut.mips.dp.rf.rf[5]);
      $display("\t-$t0 = 0x%4h",dut.mips.dp.rf.rf[8]);
      $display("\t-$t1 = 0x%4h",dut.mips.dp.rf.rf[9]);
      $display("\t-regfile -- ra1 = %d",dut.mips.dp.rf.ra1);
      $display("\t-regfile -- ra2 = %d",dut.mips.dp.rf.ra2);
      $display("\t-regfile -- we3 = %d",dut.mips.dp.rf.we3);
      $display("\t-regfile -- wa3 = %d",dut.mips.dp.rf.wa3);
      $display("\t-regfile -- wd3 = %d",dut.mips.dp.rf.wd3);
      $display("\t-regfile -- rd1 = %d",dut.mips.dp.rf.rd1);
      $display("\t-regfile -- rd2 = %d",dut.mips.dp.rf.rd2);
      $display("\t+RAM[%4d] = %4d",dut.dmem.a,dut.dmem.rd);
      $display("writedata\tdataadr\tmemwrite");
      if (dut.dmem.RAM[84] === 32'h9504)
        begin
          $display("Successfully wrote 0x%4h at RAM[%3d]",84,32'h9504);
          firstTest = 1'b1;
        end
      if (dut.dmem.RAM[88] === 0)
        begin
          $display("Successfully wrote 0x%4h at RAM[%3d]",88,0);
          secondTest = 1'b1;
        end
      if(memwrite) begin
        if(dataadr === 84 & writedata === 32'h9504)
        begin
          $display("Successfully wrote 0x%4h at RAM[%3d]",writedata,dataadr);
          firstTest = 1'b1;
        end
        if(dataadr === 88 & writedata === 0)
        begin
          $display("Successfully wrote 0x%4h at RAM[%3d]",writedata,dataadr);
          secondTest = 1'b1;
        //if(dataadr === 60 & writedata === 28) begin
            // $display("Simulation succeeded");
            // $finish;
          // end
        end
        // else if (dataadr !== 80) begin
        //   $display("Simulation failed");
        //   $finish;
        // end
      end
      if (firstTest === 1'b1 & secondTest === 1'b1)
      begin
          $display("Program successfully completed");
          $finish;
      end
      // else
      // begin
      //     $display("Program UNsuccessfully completed");
      //     $finish;
      // end
    end
endmodule

`endif // tb_harris