`define MONITOR_IF fifo_intf.monitor_cb

class monitor;
virtual fifo_intf vif_fifo;
mailbox #(transaction) mon2scb,drv2mon; // initialising the mailbox
int repeat_count;
transaction trans_mon;

function new(virtual fifo_intf vif_fifo,mailbox #(transaction) mon2scb,drv2mon);
this.vif_fifo =vif_fifo;
this.mon2scb = mon2scb;
this.drv2mon = drv2mon;
endfunction

 task main;
  $display("Monitor");
  repeat(repeat_count) begin
   //trans_mon = new();
   drv2mon.get(trans_mon); // driver to mon
    
    @(`MONITOR_IF);

    trans_mon.data_out = `MONITOR_IF.data_out; // this has to be done full and empty flags
    trans_mon.full =`MONITOR_IF.full;
    trans_mon.empty =`MONITOR_IF.empty;
    $display("|                          Data out : %h                                                                                 |",`MONITOR_IF.data_out);
 
  mon2scb.put(trans_mon);
 end  
 endtask
endclass
