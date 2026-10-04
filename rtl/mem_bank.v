module mac_controller #(
    parameter ROWS = 8,
    parameter COLS = 8
)(
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    output reg  valid,
    output reg  [ROWS-1:0] pe_en,
    output reg  done
);

    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam MAC = 2'b10;
    localparam DONE_S = 2'b11;

    reg [1:0] state;
    reg [7:0] cycle_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            valid <= 1'b0;
            pe_en <= {ROWS{1'b0}};
            done <= 1'b0;
            cycle_count <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    valid <= 1'b0;
                    pe_en <= {ROWS{1'b0}};
                    done <= 1'b0;
                    cycle_count <= 8'd0;
                    if (start) begin
                        state <= LOAD;
                    end
                end

                LOAD: begin
                    valid <= 1'b1;
                    pe_en <= {ROWS{1'b1}};
                    cycle_count <= cycle_count + 1'b1;
                    state <= MAC;
                end

                MAC: begin
                    valid <= 1'b1;
                    pe_en <= {ROWS{1'b1}};
                    if (cycle_count >= 8'd1) begin
                        state <= DONE_S;
                        done <= 1'b1;
                        valid <= 1'b0;
                    end
                end

                DONE_S: begin
                    valid <= 1'b0;
                    pe_en <= {ROWS{1'b0}};
                    done <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
