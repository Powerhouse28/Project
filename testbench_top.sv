//`include "interface.sv"
module tb_top;
 bit clk,rst_n;
 
 always #5 clk = ~ clk;
 
 always #5 rst_n= ~rst_n;
 /*initial begin 
 rst_n = 1;
  #5 rst_n = 0;
 end*/
 
 fifo_intf intf() ;
 test t1(intf);

 synchronous_fifo DUT
    (.data_out(intf.data_out),
          .full(intf.full),
          .empty(intf.empty),
          .data_in(intf.data_in),
     .wr_en(intf.wr_en),
     .rd_en(intf.rd_en),
          .clk(intf.clk),
          .rst_n(intf.rst_n));
endmodule


