`include "Single_Port_RAM.v"
`timescale 1ns/1ps
module Single_Port_RAM_TB #(parameter IN_DATA_WIDTH_TB=8, parameter ADDR_WIDTH_TB=6);
    reg [IN_DATA_WIDTH_TB-1:0] Data_TB;
    reg [ADDR_WIDTH_TB-1:0] Address_TB;
    reg WE_TB;
    reg CLK_TB;
    wire [IN_DATA_WIDTH_TB-1:0] Output_TB;

    parameter CLK_PERIOD=10;

    initial begin
        initialize;
        
        // Test 1: Write and read at address 0
        write_data(6'b000000, 8'hB5);
        read_data(6'b000000, 8'hB5);
        
        // Test 2: Write and read at address 1
        write_data(6'b000001, 8'hD4);
        read_data(6'b000001, 8'hD4);

        // Test 3: Write and read at address 2
        write_data(6'b000010, 8'hA3);
        read_data(6'b000010, 8'hA3);

        // Additional tests can be added here

        $stop;
    end

    task initialize;
    begin
        Address_TB = 0;
        Data_TB = 0;
        WE_TB = 0;
        CLK_TB = 0;
    end
    endtask

    task write_data;
        input [ADDR_WIDTH_TB-1:0] addr;
        input [IN_DATA_WIDTH_TB-1:0] data;
    begin
        @(posedge CLK_TB);
        Address_TB = addr;
        Data_TB = data;
        WE_TB = 1;
        @(posedge CLK_TB);
        WE_TB = 0;
    end
    endtask

    task read_data;
        input [ADDR_WIDTH_TB-1:0] addr;
        input [IN_DATA_WIDTH_TB-1:0] expected_data;
    begin
        @(posedge CLK_TB);
        Address_TB = addr;
        WE_TB = 0;
        @(posedge CLK_TB);
        check_output(expected_data);
    end
    endtask

    task check_output;
        input [IN_DATA_WIDTH_TB-1:0] expected_data;
    begin
        if (Output_TB == expected_data) begin
            $display("Test Passed: Expected %h, Received %h", expected_data, Output_TB);
        end else begin
            $display("Test Failed: Expected %h, Received %h", expected_data, Output_TB);
        end
    end
    endtask

    // Clock generator
    always #(CLK_PERIOD/2) CLK_TB = ~CLK_TB;

    // Module instantiation
    Single_Port_RAM #(.IN_DATA_WIDTH(IN_DATA_WIDTH_TB), .ADDR_WIDTH(ADDR_WIDTH_TB)) DUT (
        .Data(Data_TB),
        .Address(Address_TB),
        .WE(WE_TB),
        .CLK(CLK_TB),
        .Output(Output_TB)
    );
endmodule
