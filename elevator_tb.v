// Testbench for elevator module
module elevator_tb;
    reg clk, emergency;
    reg [1:0] call;
    wire door, direction;

    elevator uut (
        .clk(clk),
        .emergency(emergency),
        .call(call),
        .door(door),
        .direction(direction)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("Time\tCurrent floor\tcall\tdoor\tdirection\temergency");
        $monitor("%g\t%b\t%b\t%b\t%b", $time, uut.floor, call, door, direction, emergency);
        emergency = 0;
        call = 2'b00;
        #10;

        // Move to floor 3
        call = 2'b10;
        #40;

        // Open door at floor 2
        call = 2'b01;
        #10;

        // Move to floor 1
        call = 2'b00;
        #20;

        // Emergency stop
        emergency = 1;
        #10;
        emergency = 0;
        #10;

        // Move to floor 4
        call = 2'b11;
        #30;

        // Move to floor 1
        call = 2'b00;
        #30;

        $finish;
    end
endmodule
