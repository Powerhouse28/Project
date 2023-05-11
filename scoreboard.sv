//`include "transaction.sv"
class scoreboard;
mailbox mon2scb scr2dri;
 int no_trans;
 bit[7:0]fifo[DEPTH];
 bit [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
 
 
 function new(mailbox mon2scb,scr2dri);
   this.mon2scb = mon2scb;
  this.scr2dri = scr2dri;
   foreach(fifo[i])begin
    fifo[i] = 8'hff;
   end
 endfunction 
 
  task main;
   forever begin   
    transaction trans_score, trans_score_out;
    #50
    mon2scb.get(trans_score_out);
    scr2dri.get(trans_score_in)
    if(trans_score.w_en)begin
     fifo[w_ptr] = trans_score_out.data_in;
      w_ptr++;
    end  
    if(trans_score.r_en)begin
     if(trans_score_out.data_out == fifo[r_ptr])begin
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
