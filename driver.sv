`include "transaction.sv"
//`include "transaction.sv"
`define DRIVER_IF fifo_intf.DRIVER.driver_cb
//DRIVER_IF ponts to the DRIVER modport in interface
class driver;
  
  int no_trans;
  virtual fifo_intf vif_fifo;
  mailbox gen2drv;
  
  function new(virtual fifo_intf vif_fifo,mailbox gen2drv);
    this.vif_fifo = vif_fifo;
    this.gen2drv = gen2drv;
  endfunction  
  
  task reset;
    $display("resetting");
    wait(vif_fifo.rst);
    `DRIVER_IF.data_in <= 0;
    `DRIVER_IF.wr_en <= 0;
    `DRIVER_IF.rd_en <= 0;
    wait(!vif_fifo.rst);
    $display("done resetting");
  endtask