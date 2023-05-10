//`include "transaction.sv"
class scoreboard;
 mailbox mon2scb;
 int no_trans;
 bit[7:0]fifo[DEPTH];
 reg [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
 
 
 function new(mailbox mon2scb);
   this.mon2scb = mon2scb;
   foreach(fifo[i])begin
    fifo[i] = 8'hff;
   end
 endfunction 
 
  task main;
   forever begin   
    transaction trans;
    #50
    mon2scb.get(trans);
    if(trans.w_en)begin
      fifo[w_ptr] = trans.data_in;
      w_ptr++;
    end  
    if(trans.r_en)begin
      if(trans.data_out == fifo[r_ptr])begin
        r_ptr++;
        $display("yup");
      end
      else begin
        $display("nop");
      end
    end
    if(trans.full)begin
      $display("fifo is full");
    end
    if(trans.empty)begin
      $display("fifo is empty");
    end
    no_trans++;
   end
  endtask
endclass
