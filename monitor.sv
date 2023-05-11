`define MONITOR_IF fifo_intf.monitor_cb
class monitor;
virtual fifo_intf vif_fifo;
mailbox mon2scb; // initialising the mailbox


function new(fifo_if fifo_inst,mailbox mon2scb);
this.fifo_inst =fifo_inst;
this.mon2scb = mon2scb;
endfunction


task main;
forever begin
transaction trans_mon;
 
 task main;
  forever begin
   transaction trans_mon;
   trans_mon = new();
   @(fifo_inst.monitor_cb);

   if(MONITOR_IF.wr_en||MONITOR_IF.rd_en); // wait was used 
   begin
   	if(MONITOR_IF.wr_en)begin
    	trans_mon.wr_en = MONITOR_IF.wr_en ;
    	trans_mon.data_in = MONITOR_IF.data_in; 
    	trans_mon.full = MONITOR_IF.full;
    	trans_mon.empty = MONITOR_IF.empty;
    	$display("\t ADDR= %0h \t DATA IN = %0h",trans_mon.wr_en,trans_mon.data_in);
   	end
   @(fifo_inst.monitor_cb);
   if(MONITOR_IF.rd_en)begin
    trans_mon.rd_en = MONITOR_IF.rd_en ;
    @(fifo_inst.monitor_cb);
     trans_mon.data_out = MONITOR_IF.data_out;
     trans_mon.full = MONITOR_IF.full;
     trans_mon.empty = MONITOR_IF.empty;
    $display("\t ADDR= %0h \t DATA IN = %0h",trans_mon.wr_en,trans_mon.data_in);
   end
   mon2scb.put(trans_mon);
  end   
 endtask
endclass