`define MONITOR_IF fifo_intf.monitor_cb

class monitor;
virtual fifo_intf vif_fifo;
mailbox mon2scb; // initialising the mailbox
int repeat_count;
transaction trans_mon;

function new(virtual fifo_intf vif_fifo,mailbox mon2scb);
this.vif_fifo =vif_fifo;
this.mon2scb = mon2scb;
endfunction


 
 task main;
  $display("Monitor");
  repeat(repeat_count) begin
   trans_mon = new();
    @(posedge vif_fifo.clk);

    if(`MONITOR_IF.wr_en) begin
     trans_mon.wr_en = `MONITOR_IF.wr_en ;
     trans_mon.data_in = `MONITOR_IF.data_in;
     trans_mon.full = `MONITOR_IF.full;
     trans_mon.empty = `MONITOR_IF.empty;
     $display("Write En: %h\tFIFO Output: %h",`MONITOR_IF.wr_en, `MONITOR_IF.data_in);
     end

    if(`MONITOR_IF.rd_en) begin
     trans_mon.rd_en = `MONITOR_IF.rd_en ;
     trans_mon.data_out = `MONITOR_IF.data_out;
     trans_mon.full = `MONITOR_IF.full;
     trans_mon.empty = `MONITOR_IF.empty;

	$display("Read En: %h\tFIFO Output: %h",`MONITOR_IF.rd_en, `MONITOR_IF.data_out);
  end 
  mon2scb.put(trans_mon);
 end  
 endtask
endclass
