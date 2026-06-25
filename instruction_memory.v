module im (
    input wire clk,          // <-- O CLOCK VOLTOU PARA USAR OS BLOCOS M10K
    input wire [31:0] addr, 
    output reg [31:0] inst   // <-- VOLTOU PARA REG
);

    (* ram_init_file = "UnicicloInst.mif" *) reg [31:0] mem [0:32767];

    always @(posedge clk) begin
        inst <= mem[addr[15:2]]; // Lê exatamente na virada do clock
    end

endmodule