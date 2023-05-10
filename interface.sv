#parameter DATA_WIDTH=8;
#parameter DEPTH= 8;
#parameter DATA_WIDTH=8;
#parameter DEPTH= 8;

interface fifo_if;
reg clk,rst_n;
reg w_en, r_en;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire full, empty;

clocking driver_cb@(posedge clk);
    default input #1 output #1;
    input clk,rst;
    output data_in;
    output wr_en,rd_en;
    input data_op;
    input full,empty;
endclocking

clocking monitor_cb@(posedge clk);
    default input #1 output #1;
    input clk,rst;
    input data_in;
    input wr_en,rd_en;
    input data_op;
    input full,empty;
endclocking
  
modport driver(clocking driver_cb,input clk,rst);
modport monitor(clocking monitor_cb,input clk,rst);

endinterface
