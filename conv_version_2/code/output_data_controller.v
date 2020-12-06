`timescale 1ns / 1ps

module output_data_controller(
    input clk,
    input data_validity,
    input[23:0] data,
    input[12:0] address
    );
    reg ena,enb;
    reg wea;
    wire[23:0] remain_data;
    reg [13:0] write_address;
    reg [13:0] write_address_temp_1;
    reg [13:0] write_address_temp_2;
    reg [23:0]write_data;
    reg [3:0] data_signal;
    reg [23:0] data_temp_1;
    reg [23:0] data_temp_2;
    img_y img_y (
        .clka(clk),    // input wire clka
        .ena(ena),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(write_address),  // input wire [12 : 0] addra
        .dina(write_data),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(enb),      // input wire enb
        .addrb(address),  // input wire [12 : 0] addrb
        .doutb(remain_data)  // output wire [23 : 0] doutb
        );
    always @(*) begin
        wea <= data_signal[2];
        ena <= data_signal[2] | data_signal[3];
        enb <= data_validity  | data_signal[1];
    end 
        
    always @(posedge clk) begin
        data_signal[0] <= data_validity;
        data_signal[1] <= data_signal[0];
        data_signal[2] <= data_signal[1];
        data_signal[3] <= data_signal[2];
        data_signal[4] <= data_signal[3];
        
        write_address_temp_1 <= address;
        write_address_temp_2 <= write_address_temp_1;
        write_address <= write_address_temp_2;
        
        data_temp_1 <= data;
        data_temp_2 <= data_temp_1;
        
        
        write_data <= data_temp_2 + remain_data;
    end
        
endmodule
