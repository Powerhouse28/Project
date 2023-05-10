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
    transaction trans_score;
    #50
    mon2scb.get(trans_score);
    if(trans_score.w_en)begin
      fifo[w_ptr] = trans_score.data_in;
      w_ptr++;
    end  
    if(trans_score.r_en)begin
      if(trans_score.data_out == fifo[r_ptr])begin
        r_ptr++;
        $display("yup");
      end
      else begin
        $display("nop");
      end
    end
    if(trans_score.full)begin
      $display("fifo is full");
    end
    if(trans_score.empty)begin
      $display("fifo is empty");
    end
    no_trans++;
   end
  endtask
endclass
