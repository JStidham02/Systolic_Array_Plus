module array_2_2(row_1_data, row_2_data, row_1_load, row_2_load, col_1_initial, col_2_initial, clk, reset, load, col_1_out, col_2_out);
        input wire [7:0] row_1_data;
        input wire [7:0] row_2_data;
        input wire [7:0] row_1_load;
        input wire [7:0] row_2_load;
        input wire [7:0] col_1_initial;
        input wire [7:0] col_2_initial;
        input wire load;
        input wire clk;
        input wire reset;
        output wire [7:0] col_1_out;
        output wire [7:0] col_2_out;

        reg [7:0] stationary_weights[1:0][1:0]; // latched weight that is stationary
        reg [7:0] pass_weights[1:0]; // latched weight that is passed through
        reg [7:0] pe_result_reg[1:0][1:0]; // latched MAC result from prev cycle
        reg [7:0] mac_result[1:0][1:0]; // combinational MAC result

        // results form the columns
        assign col_1_out = pe_result_reg[1][0];
        assign col_2_out = pe_result_reg[1][1];

        // combinational MAC
        always @(*) begin
                mac_result[0][0] = stationary_weights[0][0] * row_1_data + col_1_initial;
                mac_result[0][1] = stationary_weights[0][1] * pass_weights[0] + col_2_initial;
                mac_result[1][0] = stationary_weights[1][0] * row_2_data + pe_result_reg[0][0];
                mac_result[1][1] = stationary_weights[1][1] * pass_weights[1] + pe_result_reg[0][1];
        end

        // synchronous latches
        always @(posedge clk) begin
                //reset regs
                if (reset == 1'b1) begin
                        pe_result_reg[0][0] <= 8'b0;
                        pe_result_reg[0][1] <= 8'b0;
                        pe_result_reg[1][0] <= 8'b0;
                        pe_result_reg[1][1] <= 8'b0;

                        stationary_weights[0][0] <= 8'b0;
                        stationary_weights[0][1] <= 8'b0;
                        stationary_weights[1][0] <= 8'b0;
                        stationary_weights[1][1] <= 8'b0;

                        pass_weights[0] <= 8'b0;
                        pass_weights[1] <= 8'b0;

                end

                // load stationary weights
                else if (load == 1'b1) begin
                        stationary_weights[0][0] <= row_1_load;
                        stationary_weights[1][0] <= row_2_load;
                        stationary_weights[0][1] <= stationary_weights[0][0];
                        stationary_weights[1][1] <= stationary_weights[1][0];
                end

                // MAC + propigate
                else begin
                        // propagate pass weights
                        pass_weights[0] <= row_1_data;
                        pass_weights[1] <= row_2_data;
                        // latch prev sums
                        pe_result_reg[0][0] <= mac_result[0][0];
                        pe_result_reg[0][1] <= mac_result[0][1];
                        pe_result_reg[1][0] <= mac_result[1][0];
                        pe_result_reg[1][1] <= mac_result[1][1];
                end



        end








endmodule