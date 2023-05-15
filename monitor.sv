`define MONITOR_IF fifo_intf.monitor_cb

class monitor;
virtual fifo_intf vif_fifo;
mailbox mon2scb; // initialising the mailbox


function new(virtual fifo_intf vif_fifo,mailbox mon2scb);
this.vif_fifo =vif_fifo;
this.mon2scb = mon2scb;
endfunction


 
 task main;
  forever begin
   transaction trans_mon;
   trans_mon = new();
   
   //wait(vif_fifo.rd_en);
   if(vif_fifo.rd_en);
   
   $display("Reading");
 //  @(vif_fifo.monitor_cb);

   if(`MONITOR_IF.rd_en)begin
    trans_mon.rd_en = `MONITOR_IF.rd_en ;
 //   @(vif_fifo.monitor_cb);
     trans_mon.data_out = `MONITOR_IF.data_out;
     trans_mon.full = `MONITOR_IF.full;
     trans_mon.empty = `MONITOR_IF.empty;
    $display("\t ADDR= %0h \t DATA IN = %0h",trans_mon.wr_en,trans_mon.data_in);
   end
   mon2scb.put(trans_mon);
  end   
 endtask
endclass
