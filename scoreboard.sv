//`include "transaction.sv"
class scoreboard #(parameter DATA_WIDTH=8, DEPTH= 8);
 transaction trans_score_in, trans_score_out;
mailbox mon2scb, drv2scr;
 int no_trans;
 bit[7:0]fifo[DEPTH];
 bit [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
 
	covergroup cov;
		//write the functional coverage definition here
		coverpoint trans_score_in.data_in;

		option.auto_bin_max = 16;
	
	endgroup
 
 
 function new(mailbox mon2scb,drv2scr);
	$display("yup");
   this.mon2scb = mon2scb;
  mon2scb=new();
  this.drv2scr = drv2scr;
  drv2scr=new();
  cov = new;
   foreach(fifo[i])begin
    fifo[i] = 8'hff;
   end
	 $display("yup23");
 endfunction 
	
  task main;
    begin   
	    $display("yup21"); 
      drv2scr=new();
      mon2scb=new();
    mon2scb.get(trans_score_out);
    drv2scr.get(trans_score_in);
    cov.sample();
trans_score_in.wr_en=1;trans_score_in.rd_en=1;
if(trans_score_in.wr_en)begin
	  $display("yup2");
     fifo[w_ptr] = trans_score_in.data_in;
      w_ptr++;

    end  
    if(trans_score_in.rd_en)begin
     if(trans_score_in.data_out == fifo[r_ptr])begin
        r_ptr++;
	     $display("yup3");
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
