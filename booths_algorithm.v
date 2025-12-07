module booths_algorithm #(parameter n=4)(
    input [n-1:0] M, // multiplicand
    input [n-1:0] Q, // multiplier
    input clk,
    input reset,
    output reg [2*n-1:0] P // product
);

parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011;
reg [2:0] state;
reg [n-1:0] A; // accumulator
reg Q_1; // prev lsb of Q
reg [n-1:0] Q_reg; // temporary reg for Q value
reg [n-1:0] count;

    function [n-1:0] twos_complement;
        input [n-1:0] num;
        begin
            twos_complement = ~num + 1;
        end
    endfunction

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= s0;
        A <= 0;
        Q_reg <= Q;
        Q_1 <= 0;
        count <= n; // n cycles for n bits
        P <= 0;
    end else begin
        case (state)
            s0: begin
                A <= 0;
                Q_reg <= Q;
                Q_1 <= 0;
                count <= n;
                state <= s1;
                end
            s1: begin
                if (count != 0)
                    state <= s2;
                else
                    state <= s3;
                end
            s2: begin
                case ({Q_reg[0], Q_1})
                    2'b01: A <= A + M; // A = A + M
                    2'b10: A <= A + twos_complement(M); // A = A - M
                    default: A <= A;
                endcase
                // right shift
                {A, Q_reg, Q_1} <= {A[n-1], A, Q_reg, Q_1} >> 1;
                count <= count - 1;
                state <= s1;
                end
            s3: begin
                P <= {A, Q_reg};
                state <= s3; // stay in s3
                end
            endcase
        end
    end
endmodule

