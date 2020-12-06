`timescale 1ns / 1ns



module testbench_address_controller();
reg[9:0] s_img_addr;
reg[7:0] s_w_addr;
reg start;
wire clk;
wire[9:0] img_addr;
wire[7:0] w_addr;
wire d_ena;
wire[7:0] img_data;
wire[7:0] w_data;
wire[23:0] calc_data;
wire done;
wire data_in_done;

wire [1:0] test;
wire [1:0] test2;
/*
multi_controller MC(
    .start(start),          //start
    .clk(clk),            // clk
    .s_img_addr(s_img_addr),// start address
    .s_w_addr(s_w_addr),  // start address
    .img_data(img_data),  // data from ram
    .w_data(w_data),    // data from ram
    .img_addr(img_addr),
    .w_addr(w_addr), // address for ram
    .d_ena(d_ena),         // data_ena for ram
    .calc_data(calc_data), // calculated data
    .done(done),            // don Flag
    .test(mult)
    );
 */
 start_controller sc(
    .start(start),          //start
    .clk(clk),            // clk
    .s_img_addr(s_img_addr),// start address
    .s_w_addr(s_w_addr),  // start address
    .img_data(img_data),  // data from ram
    .w_data(w_data),    // data from ram
    .img_addr(img_addr),
    .w_addr(w_addr), // address for ram
    .d_ena(d_ena),         // data_ena for ram
    .calc_data(calc_data), // calculated data
    .done(done),
    .data_in_done(data_in_done),            // done Flag),
    .test(test),
    .test2(test2)
    );
img_x img(
  .clkb(clk),    // input wire clkb
  .enb(d_ena),      // input wire enb
  .addrb(img_addr),  // input wire [9 : 0] addrb
  .doutb(img_data)  // output wire [7 : 0] doutb
);
weight_w weight(
  .clkb(clk),    // input wire clkb
  .enb(d_ena),      // input wire enb
  .addrb(w_addr),  // input wire [9 : 0] addrb
  .doutb(w_data)  // output wire [7 : 0] doutb
);

clock_gen Clock_gen(clk);
reg start_cnt;
initial begin
    start_cnt =0;
    start =0;
    #125;
    start_cnt =1;
    s_img_addr = 10'b0000000000;
    s_w_addr = 8'b00000000;
    start =1;
    #50;
    start =0;
    #2400;
    s_img_addr = 10'b0000000101;
    s_w_addr = 8'b00000101;
end
always @(data_in_done) begin
    if (start_cnt ==1'b1) begin
        if (start ==1'b0) start <= 1;
        else start <=0;
    end 
end
endmodule
