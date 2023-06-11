module testbench();

        reg clk;
        reg reset;
        reg load;

        reg [7:0] row_1_data;
        reg [7:0] row_2_data;
        reg [7:0] row_1_load;
        reg [7:0] row_2_load;
        reg [7:0] col_1_initial;
        reg [7:0] col_2_initial;

        wire [7:0] col_1_out;
        wire [7:0] col_2_out;



// testbench to test array2_2 module for 2x2 matrix MAC
        array_2_2 my_array(
                .row_1_data(row_1_data),
                .row_2_data(row_2_data),
                .row_1_load(row_1_load),
                .row_2_load(row_2_load),
                .col_1_initial(col_1_initial),
                .col_2_initial(col_2_initial),
                .clk(clk),
                .reset(reset),
                .load(load),
                .col_1_out(col_1_out),
                .col_2_out(col_2_out));



        initial begin
                // initial values
                clk = 0;
                reset = 0;
                load = 0;

                row_1_data = 8'b0;
                row_2_data = 8'b0;
                row_1_load = 8'b0;
                row_2_load = 8'b0;
                col_1_initial = 8'b0;
                col_2_initial = 8'b0;

                // one cycle of uninitialized values
                clk = 1'b0; #10
                clk = 1'b1; #10
                // assert reset
                reset = 1'b1;

                clk = 1'b0; #10
                clk = 1'b1; #10
                // load col 2
                reset = 1'b0;
                load = 1'b1;

                row_1_load = 2;
                row_2_load = 4;

                clk = 1'b0; #10
                clk = 1'b1; #10
                // load col 1
                row_1_load = 1;
                row_2_load = 3;

                clk = 1'b0; #10
                clk = 1'b1; #10

                // deassert load, compute first sum
                load = 1'b0;

                row_1_data = 1;
                row_2_data = 0;
                col_1_initial = 2;

                clk = 1'b0; #10
                clk = 1'b1; #10

                // compute second sum
                row_1_data = 0;
                row_2_data = 0;
                col_2_initial = 2;

                clk = 1'b0; #10
                clk = 1'b1; #10
                // compute third sum
                row_1_data = 0;
                row_2_data = 1;
                col_1_initial = 0;

                clk = 1'b0; #10
                clk = 1'b1; #10
                // compute fourth sum
                row_1_data = 0;
                row_2_data = 0;
                col_2_initial = 0;

                clk = 1'b0; #10
                clk = 1'b1; #10

                clk = 1'b0; #10
                clk = 1'b1; #10

                clk = 1'b0; #10
                clk = 1'b1;

                //done


                


        end










endmodule