module elevator (
    input clk,
    input emergency,
    input [1:0] call,
    output reg door,
    output reg direction
);

reg [1:0] floor, next_floor;

initial begin
    floor = 2'b00;
    door = 1'b1;
    direction = 1'b1;
end

always @(posedge clk or posedge emergency) begin
    if (emergency) begin
        floor <= floor;
    end else begin
        floor <= next_floor;
    end
end

always @(*) begin
        if (emergency) begin
        door = 1'b1;       // open door on emergency
        next_floor = floor; // stay on the same floor
    end 
    else begin
        if (call == floor) begin
            door = 1'b1;
            next_floor = floor;
        end 
        else if (call > floor) begin
            door = 1'b0;
            direction = 1'b1;
            next_floor = floor + 1;
        end 
        else begin
            door = 1'b0;
            direction = 1'b0;
            next_floor = floor - 1;
        end
    end
end

endmodule