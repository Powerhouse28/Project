//Generator generates signals and declares the transaction class handles
//Randomise transactions
`include "transaction.sv"
class generator;
  //declaring transaction class 
  rand transaction trans_gen;
  mailbox gen2drv;
  int repeat_count;
  event drv2gen;

  function new( mailbox gen2drv, event drv2gen);
    this.gen2drv = gen2drv;
    this.drv2gen = drv2gen;  
  endfunction
  
  task main();
   repeat(repeat_count)begin 
    trans_gen = new();
    if(!trans_gen.randomize()) $fatal("Gen::trans randomization failed"); 
     gen2drv.put(trans_gen);
   end 
   ->drv2gen;
  endtask

endclass
