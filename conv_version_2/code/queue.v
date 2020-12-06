`timescale 1ns / 1ps

module queue #(parameter queue_size = 32*4+5,parameter data_size = 8,parameter address_size = 10 ,parameter img_size =128*128)(
    input work,
    input clear,
    input hold,
    input clk,
    input[data_size-1:0] data,
    output reg[address_size -1:0] address,
    output reg data_ena,
    output reg is_full,
    output reg [queue_size * data_size -1:0] queue
    );
    
    reg [23:0] counter;
    reg[2:0] data_work;
    
    always @(posedge clk) begin
        data_work[0] <= work;
        data_work[1] <= data_work[0];
        data_work[2] <= data_work[1]; 
        if (clear == 1'b1) begin
            queue <= 0;
            counter <=0;
            address <= 0;
            is_full <=1'b0;
            data_ena <= 1'b0;
        end
        else if(hold == 1'b1) begin
            queue <= queue;
            counter <=counter ;
            address <= address;
            is_full <= is_full;
            
        end
        else if (clear == 1'b0) begin
            
            if (work == 1'b0 & data_work[0] ==1'b0 & data_work[1] == 1'b0 & data_work[2] == 1'b0) begin
                queue <= 0;
                counter <=0;
                address <= 0;
                is_full <=1'b0;
                data_ena <= 1'b0;
                // out case initialize
            end                           
            else if (work == 1'b1) begin
                if (data_work[0] ==1'b1) address <= address +1'b1;
                data_ena <= 1'b1;
                // get data
            end
            else if ( data_work[1] ==1'b0)  data_ena <= 1'b0;
            // data_input end 
            else if(work == 1'b0) address <= 0;
            // address append;
            
            if (data_work[2] == 1'b1 & data_work[1] == 1'b1) begin
                queue  = queue << data_size;
                queue[data_size-1:0]  = data;
                
                if (counter > img_size-1'b1) begin
                    counter <= counter;
                    is_full <= 1'b0;
                end
                else if (counter >= queue_size -1'b1) begin
                    counter <= counter+1'b1;
                    is_full <= 1'b1;
                end

                else begin
                    counter <= counter +1'b1;
                    is_full <= 1'b0;
                end    
            end
        end
        else begin 
            queue <= 0;
            counter <=0;
            address <= 0;
            is_full <=1'b0;
        end
    end
endmodule
