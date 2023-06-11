module array(clk, reset, load, weights_in_vector, sums_in_vector, accumuators_out_vector);
        parameter WBITS = 8;
        parameter ABITS = 16;
        parameter N = 2;

        input clk;
        input reset;
        input load;
        input [(N * WBITS) - 1 : 0] weights_in_vector;
        input [(N * ABITS) - 1 : 0] sums_in_vector;
        output reg [(N * ABITS) - 1 : 0] accumuators_out_vector;

        reg [WBITS - 1 : 0] weights_in[N - 1 : 0];
        reg [ABITS - 1 : 0] sums_in[N - 1 : 0];
        reg [ABITS - 1 : 0] accumulators_out[N - 1 : 0];

        // need to convert weights in to a 1D array to be a parameter
        // expand back out to create 2D array

        integer ii;
        integer jj;
        integer col;
        integer index;
        integer index_2;
        integer index_3;
        genvar i;
        genvar j;

        wire [WBITS - 1 : 0] stationary_weight[N - 1 : 0][N : 0]; // all but first column
        wire [WBITS - 1 : 0] pass_weight[N - 1: 0][N : 0]; // all but first column
        wire [ABITS - 1 : 0] accumuators[N : 0][N - 1: 0]; // all bit first row



        always @(*) begin
                for (index = 0; index < N; index = index + 1) begin
                        index_2 = index*WBITS;
                        index_3 = index*ABITS;
                        weights_in[index] = weights_in_vector[index_2 +: WBITS];
                        sums_in[index] = sums_in_vector[index_3 +: ABITS];
                        accumuators_out_vector[index_3 +: ABITS] = accumulators_out[index];
                end
        end

        always @(*) begin
                
                for (col = 0; col < N; col = col + 1) begin
                        accumulators_out[col] = accumuators[N][col];
                end
        end

        generate
                // case i = 0, j = 0
                seq_pe #(.WBITS(WBITS), .ABITS(ABITS)) pe (
                                        .clk(clk),
                                        .reset(reset),
                                        .load(load),
                                        .stationary_weight_in(weights_in[0]),
                                        .pass_wieght_in(weights_in[0]),
                                        .accumulator_in(sums_in[0]),
                                        .stationary_weight_out(stationary_weight[0][1]),
                                        .pass_weight_out(pass_weight[0][1]),
                                        .accumulator_out(accumuators[1][0]));
                // case i != 0, j = 0
                for (i = 1; i < N; i = i + 1) begin
                        seq_pe #(.WBITS(WBITS), .ABITS(ABITS)) pe (
                                .clk(clk),
                                .reset(reset),
                                .load(load),
                                .stationary_weight_in(weights_in[i]),
                                .pass_wieght_in(weights_in[i]),
                                .accumulator_in(accumuators[i][0]),
                                .stationary_weight_out(stationary_weight[i][1]),
                                .pass_weight_out(pass_weight[i][1]),
                                .accumulator_out(accumuators[i + 1][0]));
                end
                // case i = 0, j != 0
                for (j = 1; j < N; j = j + 1) begin
                        seq_pe #(.WBITS(WBITS), .ABITS(ABITS)) pe (
                                .clk(clk),
                                .reset(reset),
                                .load(load),
                                .stationary_weight_in(stationary_weight[0][j]),
                                .pass_wieght_in(pass_weight[0][j]),
                                .accumulator_in(sums_in[j]),
                                .stationary_weight_out(stationary_weight[0][j + 1]),
                                .pass_weight_out(pass_weight[0][j + 1]),
                                .accumulator_out(accumuators[1][j]));
                end
                // case i != 0, j != 0
                for (i = 1; i < N; i = i + 1) begin
                        for (j = 1; j < N; j = j + 1) begin
                                seq_pe #(.WBITS(WBITS), .ABITS(ABITS)) pe (
                                        .clk(clk),
                                        .reset(reset),
                                        .load(load),
                                        .stationary_weight_in(stationary_weight[i][j]),
                                        .pass_wieght_in(pass_weight[i][j]),
                                        .accumulator_in(accumuators[i][j]),
                                        .stationary_weight_out(stationary_weight[i][j + 1]),
                                        .pass_weight_out(pass_weight[i][j + 1]),
                                        .accumulator_out(accumuators[i + 1][j]));
                        end
                end
        endgenerate



endmodule