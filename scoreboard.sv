
class scoreboard #(parameter DATA_WIDTH=8, DEPTH= 8);
 transaction trans_score_in, trans_score_out;
mailbox #(transaction) mon2scb, drv2scr;
 int no_trans, err = 0;

 bit[7:0]fifo[DEPTH];
 bit [$clog2(DEPTH)-1:0] w_ptr=0, r_ptr=0;
 
covergroup cov;

    coverpoint trans_score_in.data_in;
    coverpoint trans_score_out.data_in;
    coverpoint trans_score_in.rd_en;
    coverpoint trans_score_in.wr_en;
   
    option.auto_bin_max = 8;
   

  
  endgroup
   
 
 function new(mailbox #(transaction) mon2scb,drv2scr);
	$display("yup");
   this.mon2scb = mon2scb;
  this.drv2scr = drv2scr;
  cov= new;
   foreach(fifo[i])begin
    fifo[i] = 8'hff;
   end

 endfunction 
	
  task main;
   //forever
   w_ptr=0;
   r_ptr=0;
   repeat (16) begin   
    #50
      drv2scr.get(this.trans_score_in);
      mon2scb.get(this.trans_score_out);
      cov.sample();

      $display("|                          Trans_score_in : Out %h In %h                                                                 |",trans_score_in.data_out,trans_score_in.data_in);
   
      if(trans_score_in.wr_en && !trans_score_out.full) begin
     fifo[w_ptr] = trans_score_in.data_in;
      w_ptr++;
              $display("|                      Write operation                                                                                   |");

   
    end 

    $display("|                          Trans_score_out : Out %h In %h                                                                |",trans_score_out.data_out,trans_score_out.data_in);

    if(trans_score_in.rd_en && !trans_score_out.empty)begin
      if(trans_score_in.data_out == fifo[r_ptr])begin
        r_ptr++;
	      $display("|                      Read operation                                                                                    |");
      end
      else begin
      end
      $display("|                          When r_en is %h : Monitor data: %h                                                             |",this.trans_score_in.rd_en,this.trans_score_out.data_out);
    end
    
    if (trans_score_out.data_out == trans_score_in.data_out)
      begin
        $display ("|                     %0t: Success Output is %h and is as expected                                                       |",$time, trans_score_out.data_out);
    
      end
    else begin $display("|                       %t Output is wrong, Failed                                                                     |",$time);
      err++; end
    
    no_trans++;
   end
$display("|-------------------------- Error Count : %d -------------------------------------------------------------------|", err);
          $display("|------------------------------------------------------------------------------------------------------------------------|");


  endtask

endclass
