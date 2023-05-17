module synchronous_fifo 
  #(
  parameter DEPTH=8, 
  DATA_WIDTH=8
  ) 
(
  input clk, rst_n,
  input wr_en, rd_en,
  input [DATA_WIDTH-1:0] data_in,
  output reg [DATA_WIDTH-1:0] data_out,
  output full, empty
);
  
  reg [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
  reg [DATA_WIDTH-1:0] fifo[DEPTH];
  
  // Set Default values on reset.
  always@(posedge clk) 
  begin
    if(!rst_n) 
    begin
      w_ptr <= 0; 
      r_ptr <= 0;
      data_out <= 0;
      for(int i=0 ;i<8; i++)
            begin
              fifo[i] <= 0;
            end
    end
  end
  
  // To write data to FIFO
  always@(posedge clk) 
  begin
    if(wr_en & !full)
    begin
      fifo[w_ptr] <= data_in;
      w_ptr <= w_ptr + 1;
    end
  end
  
  // To read data from FIFO
  always@(posedge clk) 
  begin
    if(rd_en & !empty) 
    begin
      data_out <= fifo[r_ptr];
      r_ptr <= r_ptr + 1;
    end
  end
  
  //to assign full and empty flags
  assign full = ((w_ptr+1'b1) == r_ptr);
  assign empty = (w_ptr == r_ptr);

endmodule
