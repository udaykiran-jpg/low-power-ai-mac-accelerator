module mac_pe #(
    parameter DW = 8,
    parameter ACC_W = 32
)(
    input  wire signed [DW-1:0] a_in,
    input  wire signed [DW-1:0] w_in,
    input  wire signed [ACC_W-1:0] acc_in,
    input  wire en,
    input  wire valid,
    output wire signed [ACC_W-1:0] acc_out
);

    wire signed [2*DW-1:0] mul_res;
    wire signed [ACC_W-1:0] sum_res;
    wire skip;

    assign mul_res = a_in * w_in;
    assign skip = (a_in == {DW{1'b0}}) || (w_in == {DW{1'b0}});
    assign sum_res = acc_in + {{(ACC_W-(2*DW)){mul_res[2*DW-1]}}, mul_res};
    assign acc_out = (en && valid && !skip) ? sum_res : acc_in;

endmodule
