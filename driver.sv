//`include "transaction.sv"
`define DRIVER_IF fifo_intf.driver_cb
//DRIVER_IF ponts to the DRIVER modport in interface
class driver;
  
  int no_trans,repeat_count;
  virtual fifo_intf vif_fifo;
  mailbox gen2drv, drv2scr;
  transaction tr;

  function new(virtual fifo_intf vif_fifo,mailbox gen2drv, drv2scr);
    this.vif_fifo = vif_fifo;
    this.gen2drv = gen2drv;
    this.drv2scr = drv2scr;
    
  endfunction  
  
  task reset;
  $display("resetting");
  @(vif_fifo.driver_cb);
  `DRIVER_IF.rst_n <= 0;
  @(negedge vif_fifo.clk);
    $display("done resetting");
    `DRIVER_IF.rst_n <= 1;
  
  endtask

  task drive;
    repeat(repeat_count) begin
      gen2drv.get(this.tr);
    //tr = new();
    $display("Driving the output");
     $display("data_in = %h\tWrite: %h\t Read: %h", tr.data_in,  tr.wr_en,  tr.rd_en );
     @(posedge vif_fifo.clk);
     `DRIVER_IF.data_in <= tr.data_in;
     `DRIVER_IF.wr_en <= 1;
     `DRIVER_IF.rd_en <=0;

     @(negedge vif_fifo.clk);
     `DRIVER_IF.wr_en <= 0;
     `DRIVER_IF.rd_en <= 1;
     drv2scr.put(tr);
    end
     $display("Finished driving");
  endtask



endclass
