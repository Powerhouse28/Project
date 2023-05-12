
//#parameter;
//#parameter DATA_WIDTH=8;
//#parameter DEPTH= 8;

interface fifo_intf#(parameter DATA_WIDTH=8, DEPTH= 8);
reg clk,rst_n;
reg wr_en, rd_en;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire full, empty;

clocking driver_cb@(posedge clk);
    default input #1 output #1;
    input clk,rst_n;
    input data_in;
    input wr_en,rd_en;
    input data_out;
    input full,empty;
endclocking

clocking monitor_cb@(posedge clk);
    default input #1 output #1;
    input clk,rst_n;
    input data_in;
    input wr_en,rd_en;
    input data_out;
    input full,empty;
endclocking
  
    modport driver(clocking driver_cb,input clk,rst_n);
        modport monitor(clocking monitor_cb,input clk,rst_n);

endinterface
