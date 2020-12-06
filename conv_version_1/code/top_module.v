`timescale 1ns / 1ps


module top_module(
    input start,
    input reset,
    input clk,
    output done,
    output test_pin,
    output test_pin2
    );
    wire[7:0] img_data;
    wire[7:0] w_data;
    wire[9:0] img_addr;
    wire[7:0] w_addr;
    wire d_ena;
    wire[23:0] data;
    wire [12:0]out_addr;
    //wire done;
    wire data_out_flag;
    
    assign test_pin = state;
    assign test_pin2 = start_cnt;
    reg start_cnt;
    img_controller IC(
        .start(start_cnt),
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
    data_out_controller DOC(
    .clk(clk),
    .start(data_out_flag),
    .data(data),
    .addr(out_addr)
    );
    reg state;
    always @(posedge clk) begin
        if (state ==1'b0) begin
            if (start==1'b1) begin
                state <=1'b1;
                start_cnt <= 1'b1;
            end
            else begin
                state <=1'b0;
                start_cnt <= 1'b0;
            end
            
        end
        else  if(state ==1'b1) begin

            if (reset ==1'b1) begin
                state <=1'b0;
            end
            else state <=1'b1;
            start_cnt <=1'b0;
        end
        else state <=1'b0;
    end
    
endmodule
