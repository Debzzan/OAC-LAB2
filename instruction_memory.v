// Memória de instruções 
module im (
	input wire [31:0] addr,  // Endereço da próxima instrução (vindo do pc)
	output reg [31:0] inst  // Instrução atual carregada pelo endereço
);

// PC = PC + 4
// x00000000 = b00000000000000000000000000000000
// x00000004 = b00000000000000000000000000000100
// x00000004 [31:2] = b000000000000000000000000000001 = 1 em decimal
// x00000008 [31:2] = b000000000000000000000000000010 = 2 em decimal
// x0000000C [31:2] = b000000000000000000000000000011 = 3 em decimal

reg [31:0] inst_mem [0:1023];  // Máximo de 1024 linhas suportadas por código .asm

always @(*) begin
	inst = inst_mem[addr[31:2]];
end

endmodule