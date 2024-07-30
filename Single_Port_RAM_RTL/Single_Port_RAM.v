module Single_Port_RAM #(parameter IN_DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
input wire [IN_DATA_WIDTH-1:0] Data,
input wire [ADDR_WIDTH-1:0] Address,
input wire WE,
input wire CLK,
output wire [IN_DATA_WIDTH-1:0] Output
);

reg [IN_DATA_WIDTH-1:0] RAM [0: (2**ADDR_WIDTH-1)];
reg [ADDR_WIDTH-1:0] Address_Reg;

always @(posedge CLK )
begin
   if(WE)
    begin
        RAM[Address] <= Data;
    end
    else
    begin
        Address_Reg <= Address;
    end
end

assign Output = RAM[Address_Reg];
endmodule
