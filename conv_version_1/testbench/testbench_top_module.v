`timescale 1ns / 1ps

module testbench_top_module();
wire clk;
reg start;
wire done;
wire test;
wire test2;
top_module TM(
    .start(start),
    .clk(clk),
    .done(done),
    .test_pin(test),
    .test_pin2(test2)
    );

clock_gen Clock_gen(clk);

initial begin
    #200;
    start=1'b1;
end
endmodule
