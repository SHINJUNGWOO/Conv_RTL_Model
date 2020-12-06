`timescale 1ns / 1ps
module testbench_queue_mac_controller( );
reg start;
wire clk;
wire [7:0] img_data,weight_data;
wire [9:0] img_address;
wire[7:0] weight_address;
wire img_data_ena,weight_data_ena;
wire[12:0] out_address;
wire[23:0] out_data;
wire data_validity;
wire done;
//test

    top_module TM(
    .clk(clk),
    .start(start)
    );


//test

queue_mac_controller QMC(
    .clk(clk),
    .start(start),
    .img_data(img_data),
    .weight_data(weight_data),
    .img_address(img_address),
    .weight_address(weight_address),
    .img_data_ena(img_data_ena),
    .weight_data_ena(weight_data_ena),
    .data_validity(data_validity),
    .done(done),
    .out_address(out_address),
    .out_data(out_data)
    );
    img_x img(
        .clkb(clk),    // input wire clkb
        .enb(img_data_ena),      // input wire enb
        .addrb(img_address),  // input wire [9 : 0] addrb
        .doutb(img_data)  // output wire [7 : 0] doutb
    );
    weight weight(
        .clkb(clk),    // input wire clkb
        .enb(weight_data_ena),      // input wire enb
        .addrb(weight_address),  // input wire [9 : 0] addrb
        .doutb(weight_data)  // output wire [7 : 0] doutb
    );
    output_data_controller ODC(
    .clk(clk),
    .data_validity(data_validity),
    .data(out_data),
    .address(out_address)
    );


clock_gen Clock_gen(clk); 

initial begin
    start=0;
    #100;
    start = 1;
        #100;
    start = 0;
    #56200;
    start=1;
    #50;
    start=0;
    
end
endmodule

