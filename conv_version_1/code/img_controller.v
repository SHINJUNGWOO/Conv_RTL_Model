`timescale 1ns / 1ps

module img_controller #(parameter kernel_size = 3'b101,img_size = 8'h1C, filter_size = 4'b0110)(
    input start,
    input clk,
    input[7:0] img_data,  
    input[7:0] w_data,    
    output[9:0] img_addr, 
    output[7:0] w_addr,
    output d_ena,
    output reg [23:0] data,
    output reg[12:0] out_addr,
    output reg done,
    output reg data_out_flag
    );
    
    reg[9:0] s_img_addr;
    reg[7:0] s_w_addr;
    wire[23:0] calc_data;
    wire calc_done;
    wire data_in_done;
    wire start_cnt;
    reg[7:0] row_state;
    reg[7:0] col_state;
    reg[3:0] filter_state;
    reg[1:0] state;
    reg out_addr_flag;
    
    assign start_cnt = (state ==2'b01)? data_in_done: start;
    
    start_controller SC(
    .start(start_cnt),          //start
    .clk(clk),            // clk
    .s_img_addr(s_img_addr),// start address
    .s_w_addr(s_w_addr),  // start address
    .img_data(img_data),  // data from ram
    .w_data(w_data),    // data from ram
    .img_addr(img_addr), // address for ram
    .w_addr(w_addr),   // address for ram
    .d_ena(d_ena),         // data_ena for ram
    .calc_data(calc_data), // calculated data
    .done(calc_done),             // done Flag
    .data_in_done(data_in_done)
    );


    
    always @(posedge clk) begin
        data_out_flag <= calc_done;
        if (state == 2'b00) begin
            if (start == 1'b1) begin
                row_state <=8'h00;
                col_state <=8'h00;
                state <= 1'b1;
                out_addr_flag <=1'b0;
                 s_img_addr <=s_img_addr + 1'b1;
                 //for board test
                 done<=1'b0;
                 
            end
            else begin 
                state <= 2'b00;
                s_img_addr <= 10'b0000000000;
                s_w_addr <= 8'b00000000;
                data <= 24'h000000;
                //done<=1'b0;
                row_state <=8'h00;
                col_state <=8'h00;
                filter_state <= 4'h0;
                out_addr <= 13'b0000000000000;
                out_addr_flag <=1'b0;
            end
        end
        else if(state == 2'b01) begin
            if (filter_state == (filter_size -1'b1) & col_state == (img_size-1'b1) & row_state == (img_size-1'b1)) begin
                    state <=2'b10;
                end
            else if (data_in_done == 1'b1) begin
                if(col_state == (img_size-1'b1) & row_state == (img_size-1'b1)) begin
                    filter_state<= filter_state +1'b1;
                    s_img_addr <= 10'b0000000000;
                    row_state <=8'h00;
                    col_state <=8'h00;
                end
                else if(col_state == (img_size-1'b1)) begin
                    row_state <= row_state+1'b1;
                    col_state <= 8'h00;
                    s_img_addr <=s_img_addr + kernel_size;
                 end
                else begin
                   col_state <= col_state + 1'b1;
                   s_img_addr <=s_img_addr + 1'b1;
                end
            end
            if(calc_done == 1'b1) begin
                if (out_addr_flag ==1'b1) out_addr <= out_addr +1'b1;
                else begin 
                    out_addr <= 13'b0000000000000;
                    out_addr_flag <=1'b1;
                end
                data <= calc_data;
            end
        end
        else if( state ==2'b10) begin
            if( out_addr == ((img_size)*(img_size) * filter_size-1'b1)) begin
                    state <= 2'b00;
                    out_addr_flag <=1'b0;
                    done <= 1'b1;
            end
            else if(calc_done ==1'b1) begin
                    out_addr <= out_addr +1'b1;
                    data <= calc_data;
                
            end

        end
        else state <= 2'b00;
    end
endmodule
