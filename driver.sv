//`include "transaction.sv"
`define DRIVER_IF fifo_intf.driver_cb
//DRIVER_IF ponts to the DRIVER modport in interface
class driver;
  
  int no_trans;
  virtual fifo_intf vif_fifo;
  mailbox gen2drv, drv2scr;
  transaction tr = new();
 // function new (mailbox gen2drv, drv2scr, input virtual fifo_intf vif_fifo);
 // task reset ();
 // task drive ();

  function new(virtual fifo_intf vif_fifo,mailbox gen2drv, drv2scr);
    this.vif_fifo = vif_fifo;
    this.gen2drv = gen2drv;
    this.drv2scr = drv2scr;
  //  tr = new();
  fork
    reset(); 
    drive();
  join_none
  endfunction  
  
  task reset;
  tr = new();
  $display("resetting");
  //  wait(vif_fifo.rst_n);
  if(vif_fifo.rst_n);
  begin
    //`DRIVER_IF.data_in <= 0;
   // `DRIVER_IF.wr_en <= 0;
   // `DRIVER_IF.rd_en <= 0;
   // wait(!vif_fifo.rst_n);
  end
  //@(vif_fifo.driver_cb);
  if (!vif_fifo.rst_n);
  begin
    $display("done resetting");
  end
  endtask

  task drive;
    repeat(10) begin
      gen2drv.get(tr);
    //tr = new();
    $display("Driving the output");
    `DRIVER_IF.data_in <= tr.data_in;
    `DRIVER_IF.wr_en <= tr.wr_en;
    `DRIVER_IF.rd_en <= tr.rd_en;
    $display("data_in = %h, %h", tr.data_in, `DRIVER_IF.data_in);
    //assert (`DRIVER_IF.data_in == 0) $display("Data in the stack");
    //else  $display("Stack still empty");
  //@(vif_fifo.driver_cb);
    // forever begin
      begin
      //tr = new();
      drv2scr.put(tr);
  //    @(vif_fifo.driver_cb);
    end

    end
     $display("Finished driving");
  endtask


endclass
