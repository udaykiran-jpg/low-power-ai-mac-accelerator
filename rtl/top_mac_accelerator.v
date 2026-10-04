module mem_bank #(
    parameter DEPTH = 64,
    parameter DW = 8,
    parameter AW = 6
)(
    input  wire clk,
    input  wire rst_n,
    input  wire wr_en,
    input  wire rd_en,
    input  wire [AW-1:0] addr,
    input  wire [DW-1:0] data_in,
    output reg  [DW-1:0] data_out
);

    reg [DW-1:0] mem [0:DEPTH-1];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {DW{1'b0}};
            end
            data_out <= {DW{1'b0}};
        end else begin
            if (wr_en) begin
                mem[addr] <= data_in;
            end
            if (rd_en) begin
                data_out <= mem[addr];
            end
        end
    end

endmodule
