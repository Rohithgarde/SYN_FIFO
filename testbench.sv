  import uvm_pkg::*;
`include "uvm_macros.svh"
`include "f_interface.sv"
`include "f_test.sv"
`include "design.sv"
module tb;

  
  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
  initial begin
    clk = 1;
    reset = 0;
    #5;
    reset = 1;
  end
  
  f_interface tif(clk, reset);
  
  my_fifo dut(.clk(tif.clk),
               .rstn(tif.reset),
               .i_wrdata(tif.i_wrdata),
               .i_wren(tif.i_wren),
               .i_rden(tif.i_rden),
               .o_full(tif.o_full),
               .o_empty(tif.o_empty),
               .o_alm_full(tif.o_alm_full),
               .o_alm_empty(tif.o_alm_empty),
               .o_rddata(tif.o_rddata));
  
  initial begin
    uvm_config_db#(virtual f_interface)::set(null, "", "vif", tif);

    run_test("f_test");
  end
  initial begin
        $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule
