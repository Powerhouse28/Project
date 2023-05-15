//`include "transaction.sv"
`define DRIVER_IF fifo_intf.driver_cb
//DRIVER_IF ponts to the DRIVER modport in interface
class driver;
  
  int no_trans;
  virtual fifo_intf vif_fifo;
  mailbox gen2drv, drv2scr,drv2gen;
  transaction tr;
 // function new (mailbox gen2drv, drv2scr, input virtual fifo_intf vif_fifo);
 // task reset ();
 // task drive ();

  function new(virtual fifo_intf vif_fifo,mailbox gen2drv,drv2gen, drv2scr);
    this.vif_fifo = vif_fifo;
    this.gen2drv = gen2drv;
    this.drv2scr = drv2scr;
    this.drv2gen=drv2gen;
  //  tr = new();
    fork
    reset();
    drive();
  join_none
  endfunction  
  
  task reset;
  tr = new();
//  
  
    if(vif_fifo.rst_n) begin
      $display("resetting");
    `DRIVER_IF.data_in <= 0;
    `DRIVER_IF.wr_en <= 0;
   `DRIVER_IF.rd_en <= 0;
    //  vif_fifo.rst_n=0;
    end
    
    //wait(!vif_fifo.rst_n);
    else begin
      vif_fifo.rst_n=1;
      $display("done resetting");
    end
  endtask

  task drive;
    repeat(10) begin
    //tr = new();
    $display("Driving the output");
    `DRIVER_IF.data_in <= tr.data_in;
    `DRIVER_IF.wr_en <= tr.wr_en;
    `DRIVER_IF.rd_en <= tr.rd_en;
      $display("DONE Driving the output");
    //assert (`DRIVER_IF.data_in == 0) $display("Data in the stack");
    //else  $display("Stack still empty");
  //  @(vif_fifo.driver_cb);
    // initial begin
      gen2drv.get(tr);
       drv2gen.put(tr);
      //tr = new();
      drv2scr.put(tr);
       $display("above Finished driving");
    //  @(vif_fifo.driver_cb);
  //  end

    end
     $display("Finished driving");
  endtask


endclass
