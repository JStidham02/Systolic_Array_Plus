module testbench();
        parameter N = 2;
        parameter WBITS = 8;
        parameter ABITS = 16;

        reg clk;
        reg reset;
        reg load;
        reg [(WBITS*N) - 1:0] weights_in_vector;
        reg [(ABITS*N) - 1:0] sums_in_vector;
        wire [(ABITS*N) - 1:0] accumulator_out_vector;

        reg [WBITS - 1 : 0] weights_in[N - 1 : 0];
        reg [ABITS - 1 : 0] sums_in[N - 1 : 0];
        reg [ABITS - 1 : 0] accumulators_out [N - 1 : 0];

        integer i;
        integer index;
        integer index_2;
        integer index_3;

        array my_array  (
                .clk(clk),
                .reset(reset),
                .load(load),
                .weights_in_vector(weights_in_vector),
                .sums_in_vector(sums_in_vector),
                .accumuators_out_vector(accumulator_out_vector));


        always@(*) begin
                for (index = 0; index < N; index = index + 1) begin
                        index_2 = index*WBITS;
                        index_3 = index*ABITS;
                        weights_in_vector[index_2 +: WBITS] = weights_in[index];
                        sums_in_vector[index_3 +: ABITS] = sums_in[index];
                        accumulators_out[index] = accumulator_out_vector[index_3 +: ABITS];
                end
        end




        initial begin

                clk = 0;
                reset = 0;
                load = 0;

                weights_in[0] = 0;
                weights_in[1] = 0;

                sums_in[0] = 0;
                sums_in[1] = 0;

                for (i = 0; i < N; i = i + 1) begin
                        weights_in[i] = 0;
                        sums_in[i] = 0;
                end

                clk = 1'b0; #10
                clk = 1'b1; #10

                reset = 1'b1;
                
                clk = 1'b0; #10
                clk = 1'b1; #10

                reset = 1'b0;
                load = 1'b1;

                weights_in[0] = 2;
                weights_in[1] = 4;
                
                clk = 1'b0; #10
                clk = 1'b1; #10

                weights_in[0] = 1;
                weights_in[1] = 3;

                clk = 1'b0; #10
                clk = 1'b1; #10

                load = 1'b0;

                weights_in[0] = 1;
                weights_in[1] = 0;

                clk = 1'b0; #10
                clk = 1'b1; #10

                weights_in[0] = 0;
                weights_in[1] = 0;

                clk = 1'b0; #10
                clk = 1'b1; #10

                weights_in[0] = 0;
                weights_in[1] = 1;
                
                clk = 1'b0; #10
                clk = 1'b1; #10

                weights_in[0] = 0;
                weights_in[1] = 0;

                clk = 1'b0; #10
                clk = 1'b1; #10
                clk = 1'b0; #10
                clk = 1'b1; #10
                clk = 1'b0; #10
                clk = 1'b1; #10
                clk = 1'b0; #10
                clk = 1'b1;     

        end


        
        





endmodule