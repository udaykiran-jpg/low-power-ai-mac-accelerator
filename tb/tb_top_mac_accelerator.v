module top_mac_accelerator #(
    parameter ROWS = 8,
    parameter COLS = 8,
    parameter DW = 8,
    parameter ACC_W = 32,
    parameter AW = 6,
    parameter DEPTH = 64
)(
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    input  wire signed [DW-1:0] act_in [0:ROWS-1],
    input  wire signed [DW-1:0] wgt_in [0:ROWS*COLS-1],
    output wire done,
    output reg  signed [ACC_W-1:0] result [0:ROWS*COLS-1]
);

    wire valid;
    wire [ROWS-1:0] pe_en;
    wire signed [DW-1:0] act_vec [0:ROWS-1];
    wire signed [DW-1:0] wgt_vec [0:ROWS*COLS-1];
    wire signed [ACC_W-1:0] acc_vec [0:ROWS*COLS-1];

    integer i;
    integer k;

    mac_controller #(
        .ROWS(ROWS),
        .COLS(COLS)
    ) u_controller (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .valid(valid),
        .pe_en(pe_en),
        .done(done)
    );

    mac_array #(
        .ROWS(ROWS),
        .COLS(COLS),
        .DW(DW),
        .ACC_W(ACC_W)
    ) u_array (
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .pe_en(pe_en),
        .act_in(act_vec),
        .wgt_in(wgt_vec),
        .acc_out(acc_vec)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (k = 0; k < ROWS * COLS; k = k + 1) begin
                result[k] <= {ACC_W{1'b0}};
            end
        end else if (valid) begin
            for (k = 0; k < ROWS * COLS; k = k + 1) begin
                result[k] <= acc_vec[k];
            end
        end
    end

    generate
        for (i = 0; i < ROWS; i = i + 1) begin : act_assign
            assign act_vec[i] = act_in[i];
        end
        for (i = 0; i < ROWS * COLS; i = i + 1) begin : wgt_assign
            assign wgt_vec[i] = wgt_in[i];
        end
    endgenerate

endmodule
