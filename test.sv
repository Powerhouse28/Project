`include "environment.sv"
program test(fifo_if intf);
  environment env;
  
  initial begin
    $vcdpluson;
    env = new(intf);
    env.gen.repeat_count = 10;
    env.run();
  end
endprogram
