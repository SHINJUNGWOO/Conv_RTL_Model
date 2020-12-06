`timescale 1ns / 1ps

module start_controller(
    input start,          //start
    input clk,            // clk
    input[9:0] s_img_addr,// start address
    input[7:0] s_w_addr,  // start address
    input[7:0] img_data,  // data from ram
    input[7:0] w_data,    // data from ram
    output[9:0] img_addr, // address for ram
    output[7:0] w_addr,   // address for ram
    output d_ena,         // data_ena for ram
    output [23:0] calc_data, // calculated data
    output done,             // done Flag
    output data_in_done,
    output[1:0] test,
    output[1:0] test2
    );
    wire data_in_A,data_in_B;
    wire start_A,start_B;
    wire done_A,done_B;
    wire d_ena_A,d_ena_B;
    wire data_in_done_A,data_in_done_B;
    wire[23:0] calc_data_A;
    wire[23:0] calc_data_B;
    wire [9:0] img_addr_A,img_addr_B;
    wire [7:0] w_addr_A,w_addr_B;
    reg[1:0] work_state;

    assign start_A = (work_state == 2'b00) ? start:
                      (work_state == 2'b01) ? start & ~(data_in_B & ~data_in_done_B):
                      (work_state == 2'b10) ? 1'b0:1'b0;
    assign start_B = (work_state == 2'b00) ? 1'b0:
                      (work_state == 2'b01) ? 1'b0:
                      (work_state == 2'b10) ? start & ~(data_in_A & ~data_in_done_A):1'b0;                       
    
                                  
    assign calc_data = (done_A == 1'b1) ? calc_data_A:
                       (done_B == 1'b1)? calc_data_B: 24'h000000;
    assign done = done_A | done_B;
    assign img_addr = (data_in_A==1'b1) ? img_addr_A:
                    (data_in_B ==1'b1)? img_addr_B:img_addr_A;
    
    assign  w_addr = (data_in_A==1'b1) ? w_addr_A:
                    (data_in_B ==1'b1)? w_addr_B: w_addr_A;
               
    assign d_ena = d_ena_A | d_ena_B;
    assign data_in_done = data_in_done_A | data_in_done_B;
    
    //test
    assign test ={start_A,start_B};
    assign test2 =work_state;
    //assign test = work_state;
    //assign test = {data_in_A,data_in_B};
    //test

    multi_controller A_multi(
    .start(start_A),          // start
    .clk(clk),              // clk
    .s_img_addr(s_img_addr),// [9:0] start address
    .s_w_addr(s_w_addr),    // [7:0] start address
    .img_data(img_data),    // [8:0] data from ram
    .w_data(w_data),        // [8:0] data from ram
    .img_addr(img_addr_A),    // [9:0] address for ram
    .w_addr(w_addr_A),        // [7:0] address for ram
    .d_ena(d_ena_A),          // data_ena for ram
    .data_in_ena(data_in_A),
    .calc_data(calc_data_A),  // [23:0]calculated data
    .data_in_done(data_in_done_A),
    .done(done_A)            // done Flag
    );
    multi_controller B_multi(
    .start(start_B),          // start
    .clk(clk),              // clk
    .s_img_addr(s_img_addr),// [9:0] start address
    .s_w_addr(s_w_addr),    // [7:0] start address
    .img_data(img_data),    // [8:0] data from ram
    .w_data(w_data),        // [8:0] data from ram
    .img_addr(img_addr_B),    // [9:0] address for ram
    .w_addr(w_addr_B),        // [7:0] address for ram
    .d_ena(d_ena_B),          // data_ena for ram
    .data_in_ena(data_in_B),
    .calc_data(calc_data_B),  // [23:0]calculated data
    .data_in_done(data_in_done_B),
    .done(done_B)            // done Flag
    );

    always @(posedge clk) begin
        if(d_ena_A ==1'b0 & d_ena_B ==1'b0) work_state <= 2'b00;
        else if(d_ena_A ==1'b0 & d_ena_B ==1'b1) work_state <= 2'b01;
        else if(d_ena_A ==1'b1 & d_ena_B ==1'b0) work_state <= 2'b10;
        else if(d_ena_A ==1'b1 & d_ena_B ==1'b1) work_state <= 2'b11;
        else work_state <= 2'b00;
        
    end
endmodule
/*
 TODO LIST
 - 입력 겹치지 않도록 확인
 - ,clac 되는 동안 다른 리소스 사용할 수 있도록 확인
*/