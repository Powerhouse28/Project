//`include "environment.sv"
program test(fifo_intf intf);
  environment env;
  
  initial begin
    $vcdpluson;
    env = new(intf);
    env.gen.repeat_count = 16;
    env.drv.repeat_count = 16;
    env.mon.repeat_count = 16;
    env.run();
   //$finish();
  end
endprogram
