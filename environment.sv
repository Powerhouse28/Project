//`include "transaction.sv"
//`include "generator.sv"
//`include "driver.sv"
//`include "monitor.sv"
//`include "scoreboard.sv"
class environment;
  
  generator gen;
  driver drv;
 // monitor mon;
  scoreboard scb;
  
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb,drv2scr,drv2mon;

  
  //event drv2gen;//to show generation of signals have stopped
  virtual fifo_intf vif_fifo;
  
  function new(virtual fifo_intf vif_fifo);
    this.vif_fifo = vif_fifo;
    gen2drv = new(1);
    mon2scb = new(1);
    drv2scr=new(1);
    drv2mon=new(1);
    gen = new(gen2drv);
    drv = new(vif_fifo,gen2drv,drv2scr,drv2mon);
  //  mon = new(vif_fifo,mon2scb,drv2mon);
    scb = new(drv2scr);
  endfunction
  
  task pre_test();
   drv.reset();
  endtask
  
  task test();
   fork
   gen.main();
   drv.drive();
   //drv.driveRead();
  // mon.main();
   scb.main();
   join
  endtask
  
  //task post_test();
  // wait(drv2gen.triggered);
  // if (gen.repeat_count == drv.no_trans);
  // wait(gen.repeat_count == scb.no_trans);
  //endtask
  
  task run();
   pre_test();
   test();
 // post_test();
   $finish;
  endtask
endclass
