//`include "environment.sv"
program test(fifo_intf intf);
  environment env;
  
  initial begin
    $vcdpluson;
    env = new(intf);
    env.gen.repeat_count = 10;
    env.drv.repeat_count = 10;
    env.mon.repeat_count = 10;
    env.run();
   //$finish();
  end
endprogram
