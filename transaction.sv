class transaction;
  //only input signals for randomisation and no ports
  bit rst_n,clk;
  rand bit [7:0] data_in;
  rand bit wr_en,rd_en;	
  bit[7:0]data_out;
  bit full,empty;
  
  constraint wr_rd_en{wr_en != rd_en;};

endclass