//`include "transaction.sv"
class scoreboard #(parameter DATA_WIDTH=8, DEPTH= 8);
 transaction trans_score_in, trans_score_out;
mailbox mon2scb, drv2scr;
 int no_trans;
 bit[7:0]fifo[DEPTH];
 bit [$clog2(DEPTH)-1:0] w_ptr=0, r_ptr=0;
 
	//covergroup cov;
		//write the functional coverage definition here
	//	coverpoint trans_score_in.data_in;

	//	option.auto_bin_max = 16;
	
	//endgroup

      covergroup cov1;
        //write the functional coverage definition here
        coverpoint data_in;
    bins min = {8'h0};
    bins mid_max [] = {8'h1:8'hf};
    bins def = default;
    
    endgroup
 
 
 function new(mailbox mon2scb,drv2scr);
	$display("yup");
   this.mon2scb = mon2scb;
    //mon2scb=new();
  this.drv2scr = drv2scr;
  //drv2scr=new();
  cov = new;
   foreach(fifo[i])begin
    fifo[i] = 8'hff;
   end
	 $display("yup23");
 endfunction 
	
  task main;
   //forever
   w_ptr=0;
   r_ptr=0;
   repeat (10) begin   
	   $display("yup2");
    //#50
      //drv2scr=new();
      //mon2scb=new();
      mon2scb.get(this.trans_score_out);
      drv2scr.get(this.trans_score_in);
      cov.sample();

      $display("Write enable:%h",trans_score_in.wr_en);
      if(!trans_score_in.wr_en) begin
     fifo[w_ptr] = trans_score_in.data_in;
      w_ptr++;
      $display("Write pointer %h",w_ptr);
    end  

    $display("Read enable:%h %h",trans_score_in.rd_en,trans_score_out.rd_en);
    if(trans_score_out.rd_en)begin
      if(trans_score_out.data_out == fifo[r_ptr])begin
        //r_ptr++;
	      $display("yup3");
      end
      else begin
        $display("nop");
      end
      r_ptr++;
      $display("Read pointer %h",r_ptr);
    end
    
    if (trans_score_out.data_out == trans_score_in.data_out)
      begin
        $display ("%0t Output is %h and is as expected Success",$time, trans_score_out.data_out);
    
      end
    else $error("%t Output is wrong, Failed",$time);
    
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
