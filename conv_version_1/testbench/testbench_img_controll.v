`timescale 1ns / 1ps


module testbench_img_controll();
reg start;
wire clk;
wire[7:0] img_data;
wire[7:0] w_data;
wire[9:0] img_addr;
wire[7:0] w_addr;
wire d_ena;
wire[23:0] data;
wire [12:0]out_addr;
wire done;
wire data_out_flag;

img_controller IC(
    .start(start),
    .clk(clk),
    .img_data(img_data),  
    .w_data(w_data),    
    .img_addr(img_addr), 
    .w_addr(w_addr),
    .d_ena(d_ena),
    .data(data),
    .out_addr(out_addr),
    .done(done),
    .data_out_flag(data_out_flag)
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

initial begin
    #125;
    start = 1'b1;
    #50;
    start = 1'b0;
end




endmodule
