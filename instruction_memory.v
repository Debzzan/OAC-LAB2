module im (
    input wire clk,
    input wire [31:0] addr,
    output reg [31:0] inst
);

    parameter TEXT_BASE = 32'h00400000;
    parameter DEPTH = 32768;

    (* ram_init_file = "UnicicloInst.mif" *) reg [31:0] mem [0:DEPTH-1];

    wire [31:0] byte_offset = addr - TEXT_BASE;
    wire [31:0] word_index = byte_offset >> 2;
    wire valid_addr = (addr >= TEXT_BASE) && (word_index < DEPTH);

    always @(*) begin
        if (valid_addr)
            inst = mem[word_index[14:0]];
        else
            inst = 32'h0000006f; // endereco fora do .text: segura o PC
    end

endmodule
