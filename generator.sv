//Generator generates signals and declares the transaction class handles
//Randomise transactions
//`include "transaction.sv"
class generator;
  //declaring transaction class 
  rand transaction trans_gen;
  mailbox #(transaction) gen2drv;
  int repeat_count;
 // event drv2gen;

  function new( mailbox #(transaction) gen2drv);
  $display("\t\t GENERATOR");
    this.gen2drv = gen2drv;
    //this.drv2gen = drv2gen;  
  endfunction
  
task main();
  

  repeat (repeat_count) begin
    transaction trans_gen = new();
    if (!trans_gen.randomize())
      $fatal("Gen::trans randomization failed");

    gen2drv.put(trans_gen);
    $display("Data in:\t%h", trans_gen.data_in);
  end

 // ->drv2gen;
endtask



endclass
