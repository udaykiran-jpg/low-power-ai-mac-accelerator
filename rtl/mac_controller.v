module mac_array #(
    parameter ROWS = 8,
    parameter COLS = 8,
    parameter DW = 8,
    parameter ACC_W = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire valid,
    input  wire [ROWS-1:0] pe_en,
    input  wire signed [DW-1:0] act_in [0:ROWS-1],
    input  wire signed [DW-1:0] wgt_in [0:ROWS*COLS-1],
    output reg  signed [ACC_W-1:0] acc_out [0:ROWS*COLS-1]
);

    integer i;
    integer j;
    integer k;

    wire signed [ACC_W-1:0] acc_next [0:ROWS*COLS-1];

    genvar gi;
    genvar gj;

    generate
        for (gi = 0; gi < ROWS; gi = gi + 1) begin : row_gen
            for (gj = 0; gj < COLS; gj = gj + 1) begin : col_gen
                localparam integer IDX = gi * COLS + gj;

                mac_pe #(
                    .DW(DW),
                    .ACC_W(ACC_W)
                ) u_pe (
                    .a_in(act_in[gi]),
                    .w_in(wgt_in[IDX]),
                    .acc_in(acc_out[IDX]),
                    .en(pe_en[gi]),
                    .valid(valid),
                    .acc_out(acc_next[IDX])
                );
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (k = 0; k < ROWS * COLS; k = k + 1) begin
                acc_out[k] <= {ACC_W{1'b0}};
            end
        end else if (valid) begin
            for (k = 0; k < ROWS * COLS; k = k + 1) begin
                acc_out[k] <= acc_next[k];
            end
        end
    end

endmodule
