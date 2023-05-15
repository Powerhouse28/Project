//`include "transaction.sv"

class scoreboard;
mailbox mon2scb, drv2scr ; //scr2dri;

 int no_trans;
 bit[7:0]fifo[DEPTH];
 bit [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
 
	covergroup cov;
		//write the functional coverage definition here
		coverpoint trans_score_in.data_in;

		option.auto_bin_max = 16;
	
	endgroup
 
 
 function new(mailbox mon2scb,drv2scr);
   this.mon2scb = mon2scb;

  this.drv2scr = drv2scr;

   foreach(fifo[i])begin
    fifo[i] = 8'hff;
   end
 endfunction 
 
  task main;
   forever begin   
    
    #50

    mon2scb.get(trans_score);
    drv2scr.get(trans_score_out)
    if(trans_score.w_en)begin
      fifo[w_ptr] = trans_score.data_in;

      w_ptr++;
    end  
    if(trans_score_in.rd_en)begin
     if(trans_score_in.data_out == fifo[r_ptr])begin
        r_ptr++;
        $display("yup");
      end
      else begin
        $display("nop");
      end
    end
    assert (trans_score_out.data_out == trans_score_in.data_out) $display ("%0t      Output is %h and is as expected Success",$time, trans_score_out.data_out);
    else $error("%t Output is wrong, Failed",$time);
    if(trans_score_in.full)begin
      $display("fifo is full");
    end
    if(trans_score_in.empty)begin
      $display("fifo is empty");
    end
    no_trans++;
   end
  endtask
endclass
