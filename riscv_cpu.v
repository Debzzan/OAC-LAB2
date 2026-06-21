// Arquivo principal do processador
module riscv_cpu (
	input wire clk,              
	input wire reset_pc            
);

wire [31:0] next_addr_pc;
wire [31:0] current_addr_pc;

pc program_counter (
	.clk(clk),
	.reset(reset_pc),
	.next_addr(next_addr_pc),
	.current_addr(current_addr_pc)
);

endmodule