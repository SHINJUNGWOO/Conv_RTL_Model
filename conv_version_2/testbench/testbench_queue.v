`timescale 1ns / 1ps

module testbench_queue( );
reg work;
reg clear;
reg hold;
wire clk;
wire [7:0] data;
wire [9:0] address;
wire data_ena;
wire is_full;
    queue #(.queue_size(5),.data_size(8)) Q_ue(
        .work(work),
        .clear(clear),
        .hold(hold),
        .clk(clk),
        .data(data),
        .address(address),
        .data_ena(data_ena),
        .is_full(is_full)
     );
    img_x img(
        .clkb(clk),    // input wire clkb
        .enb(data_ena),      // input wire enb
        .addrb(address),  // input wire [9 : 0] addrb
        .doutb(data)  // output wire [7 : 0] doutb
    );

clock_gen Clock_gen(clk); 

initial begin
    work =1'b0;
    clear = 1'b0;
    #250;
    work =1'b1;
    #500;
    //work = 1'b0;
    #200;
    hold = 1'b1;
    #50;
    
end
endmodule
