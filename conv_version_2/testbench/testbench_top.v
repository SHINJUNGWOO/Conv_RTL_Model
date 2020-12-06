`timescale 1ns / 1ps

module testbench_top();
    
    wire clk;
    reg start;
    wire done;
    top_module TM(
    .clk(clk),
    .start(start),
    .done(done)
    );
    clock_gen cg(clk); 
    initial begin
        start =1'b0;
        #100;
        start =1'b1;
        #100;
        start =1'b0;
        #100;
    end

endmodule
