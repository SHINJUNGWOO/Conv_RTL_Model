`timescale 1ns / 1ns


module testbench_memory();
wire clk;
reg ena;
reg wea;
reg[12:0] addr;
reg[23:0] dina;
reg start;

data_out_controller Dcc(
    .clk(clk),
    .start(start),
    .data(dina),
    .addr(addr)
    );
clock_gen Clock_gen_0(clk);

initial begin
ena=1'b1;
wea=1'b1;
addr = 12'b0000000000;
dina = 24'h000010;
#50
start = 1;
#50;
start = 0;
#400
start = 1;
dina = 24'h000010;
#50;
start = 0;
end
endmodule

