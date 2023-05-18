//`include "transaction.sv"
class scoreboard #(parameter DATA_WIDTH=8, DEPTH= 8);
 transaction trans_score_in, trans_score_out;
mailbox #(transaction) mon2scb, drv2scr;
 int no_trans, repeat_count;

 bit[7:0]fifo[DEPTH];
 bit [$clog2(DEPTH)-1:0] w_ptr=0, r_ptr=0;
 
	covergroup cov;
		//write the functional coverage definition here
		coverpoint trans_score_in.data_in;
    option.auto_bin_max = 16;
	
	endgroup
 
 
 function new(mailbox #(transaction) mon2scb,drv2scr);
	//$display("\t\t Scoreboard ");
   this.mon2scb = mon2scb;
  this.drv2scr = drv2scr;
  cov = new;
   foreach(fifo[i])begin
    fifo[i] = 8'hff;
   end
	 //$display("yup23");
 endfunction 
	
  task main;
   //forever
   $display("\t\t Scoreboard ");
   w_ptr=1;
   r_ptr=0;
   repeat (16) begin   
	 //  $display("yup2");
    //#50
      //drv2scr=new();
      //mon2scb=new();
      drv2scr.get(this.trans_score_in);
      mon2scb.get(this.trans_score_out);
      cov.sample();
	  $display("|  Transaction_in : Out %h In %h                                                                                         |",trans_score_in.data_out,trans_score_in.data_in);
      if(trans_score_in.wr_en && !trans_score_out.full) begin
     fifo[w_ptr] = trans_score_in.data_in;
      w_ptr++;
    end 

    if(trans_score_out.rd_en && !trans_score_out.empty)begin
      if(trans_score_out.data_out == fifo[r_ptr])begin
        r_ptr++;
	      $display("|  Write Operation                                                                                                                |");
      end
      else begin
        $display("|  Read Operation                                                                                                                   |");
      end
	    $display("|  Monitor data: %h                                                                                                      |",this.trans_score_out.data_in);
    end
    
    if (trans_score_out.data_out == trans_score_in.data_out)
      begin
        $display("|  %t : Output is %h , %h and is as expected Success                                                   |",$time, trans_score_out.data_in, trans_score_out.data_out);
                   
      end
    else $error("%t Output is wrong, Failed \n",$time);
         
    if(trans_score_out.full)begin
    $display("| 	fifo is full                                                                                                     |");
    end
         
    if(trans_score_out.empty)begin
    $display("| 	fifo is empty                                                                                                    |");
    end
    no_trans++;
    $display("|   %t : trans_score_out IN : %h OUT : %h \t trans_score_in IN : %h OUT : %h                         |",$time, trans_score_out.data_in, trans_score_out.data_out, trans_score_in.data_in, trans_score_in.data_out);
        $display("|------------------------------------------------------------------------------------------------------------------------|");

   end
  endtask
endclass
