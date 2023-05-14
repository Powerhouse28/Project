//Generator generates signals and declares the transaction class handles
//Randomise transactions
//`include "transaction.sv"
class generator;
  //declaring transaction class 
  rand transaction trans_gen;
  mailbox gen2drv,drv2gen;
  int repeat_count;
  

  function new( mailbox gen2drv, drv2gen);
    this.gen2drv = gen2drv;
    this.drv2gen = drv2gen;  
  endfunction
  
  task main();
   repeat(repeat_count)begin 
    trans_gen = new();
    if(!trans_gen.randomize()) $fatal("Gen::trans randomization failed"); 
     gen2drv.put(trans_gen);
     drv2gen.get(trans_gen);
   end 
  endtask

endclass
