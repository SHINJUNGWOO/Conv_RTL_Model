`timescale 1ns / 1ps

module make_img();

    wire clk;
    reg start;
    wire done;
    wire[23:0] out_data;
    wire data_validity;
    wire img_end_pin;
    top_module TM(
    .clk(clk),
    .start(start),
    .done(done),
    .out_data_pin(out_data),
    .data_validity_pin(data_validity),
    .img_end_pin(img_end_pin)
    );
    
    
    clock_gen cg(clk); 
    
    integer fr;
       wire[23:0] relu ;
       assign relu =(out_data[23] ==1'b1)? 24'h000000:out_data;
       

    initial begin
        fr = $fopen("D:/2020_2_study/HDL_Train/fpga_board_prac/new_test/test8.txt", "w");
        
        start =1'b0;
        #100;
        start =1'b1;
        #100;
        start =1'b0;

        
    end
    
    always @(posedge clk) begin
        if (data_validity == 1'b1) begin
            $display("%d\n",relu);
            $fwrite(fr,"%6h ",relu);
        end
        if (img_end_pin == 1'b1) begin
            $fwrite(fr,"\n");
        end
        
        if( done == 1'b1) begin
            $fclose(fr);
            $finish;

        end
        

    end
   
endmodule
