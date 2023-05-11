//`include "transaction.sv"
class scoreboard;
mailbox mon2scb dri2scr;
 int no_trans;
 bit[7:0]fifo[DEPTH];
 bit [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
 
 
 function new(mailbox mon2scb,scr2dri);
   this.mon2scb = mon2scb;
  mon2scb=new();
  this.dri2scr = dri2scr;
  dri2scr=new();
   foreach(fifo[i])begin
    fifo[i] = 8'hff;
   end
 endfunction 
 
  task main;
   forever begin   
    transaction trans_score_in, trans_score_out;
    #50
      dri2scr=new();
      mon2scb=new();
    mon2scb.get(trans_score_out);
    dri2scr.get(trans_score_in);
    if(trans_score_out.wd_en)begin
     fifo[w_ptr] = trans_score_out.data_in;
      w_ptr++;
    end  
    if(trans_score_out.rd_en)begin
     if(trans_score_out.data_out == fifo[r_ptr])begin
        r_ptr++;
        $display("yup");
      end
      else begin
        $display("nop");
      end
    end
    assert (trans_score_out.data_out == trans_score_in.data_out) $display ("%0t      Output is %h and is as expected Success",$time, trans_score_out.data_out);

    if(trans_score_out.full)begin
      $display("fifo is full");
    end
    if(trans_score_out.empty)begin
      $display("fifo is empty");
    end
    no_trans++;
   end
  endtask
endclass
