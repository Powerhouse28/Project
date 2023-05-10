#parameter DATA_WIDTH=8;
#parameter DEPTH= 8;

interface fifo_if;
reg clk,rst_n;
reg w_en, r_en;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire full, empty;

endinterface
