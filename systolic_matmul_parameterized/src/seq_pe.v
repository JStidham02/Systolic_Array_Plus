module seq_pe(clk, reset, load, stationary_weight_in, pass_wieght_in, accumulator_in, stationary_weight_out, pass_weight_out, accumulator_out);
        parameter WBITS = 8;
        parameter ABITS = 16;
        input load;
        input clk;
        input reset;

        input [WBITS - 1 : 0] stationary_weight_in;
        input [WBITS - 1 : 0] pass_wieght_in;
        input [ABITS - 1 : 0] accumulator_in;
        output wire [ABITS - 1 : 0] accumulator_out;
        output wire [WBITS - 1 : 0] stationary_weight_out;
        output wire [WBITS - 1 : 0] pass_weight_out;

        reg [WBITS - 1 : 0] stationary_weight_latch;
        reg [WBITS - 1 : 0] pass_weight_latch;
        reg [ABITS - 1 : 0] accumulator_latch;

        assign stationary_weight_out = stationary_weight_latch;
        assign pass_weight_out = pass_weight_latch;
        assign accumulator_out = accumulator_latch;

        reg [ABITS - 1 : 0] accumulate;

        always @(*) begin
                accumulate = stationary_weight_latch * pass_wieght_in + accumulator_in; 
        end

        always @(posedge clk) begin
                if (reset == 1'b1) begin
                        stationary_weight_latch <= 0;
                        pass_weight_latch <= 0;
                        accumulator_latch <= 0;
                end

                else if (load == 1'b1) begin
                        stationary_weight_latch <= stationary_weight_in;
                        pass_weight_latch <= 0;
                        accumulator_latch <= 0;
                end

                else begin
                        pass_weight_latch <= pass_wieght_in;
                        accumulator_latch = accumulate;
                end

        end 



endmodule