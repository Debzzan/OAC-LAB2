// Multiplexador 2 para 1 — largura configurável via parâmetro
// Seleciona entre duas entradas (in0 ou in1) com base no sinal de seleção (sel).
// Usado em vários pontos do datapath RISC-V para rotear sinais.
//
// sel = 0 → saída recebe in0
// sel = 1 → saída recebe in1
//
// Exemplos de uso no datapath:
//   - Selecionar entre rs2 e imediato como 2º operando da ALU  (ALUSrc)
//   - Selecionar o próximo PC entre PC+4 e endereço de desvio  (Branch/Jump)
//   - Selecionar entre resultado da ALU e dado da memória       (MemtoReg)

module mux2_1 #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in0, // entrada 0 (selecionada quando sel = 0)
    input  [WIDTH-1:0] in1, // entrada 1 (selecionada quando sel = 1)
    input              sel, // sinal de seleção vindo da unidade de controle
    output [WIDTH-1:0] out  // saída: in0 ou in1 conforme sel
);
    // Atribuição contínua: lógica puramente combinacional, sem estado
    assign out = sel ? in1 : in0;
endmodule
