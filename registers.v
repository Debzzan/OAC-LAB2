module REGISTERS (
    input wire        clk,          // Sinal de clock (sincronizado com o PC)
    input wire        reset,        // Sinal de reset assíncrono (igual ao PC)
    input wire        RegWrite,     // Habilita escrita no banco (sinal de controle)
    input wire [4:0]  ReadReg1,     // Endereço rs1 (5 bits)
    input wire [4:0]  ReadReg2,     // Endereço rs2 (5 bits)
    input wire [4:0]  WriteReg,     // Endereço rd (5 bits)
    input wire [31:0] WriteData,    // Dado a ser gravado (32 bits)
    output wire [31:0] readData_1,  // Dado lido rs1 (32 bits - ASSÍNCRONO)
    output wire [31:0] readData_2   // Dado lido rs2 (32 bits - ASSÍNCRONO)
);

    // Array de 32 registradores de 32 bits
    reg [31:0] registradores [0:31];
    integer i;

    // -------------------------------------------------------------------------
    // LEITURA ASSÍNCRONA (Combinacional)
    // O valor sai no exato instante em que o endereço chega na porta!
    // Se o endereço for 0 (x0), a saída é forçada para 0, conforme o padrão RISC-V.
    // -------------------------------------------------------------------------
    assign readData_1 = (ReadReg1 == 5'd0) ? 32'd0 : registradores[ReadReg1];
    assign readData_2 = (ReadReg2 == 5'd0) ? 32'd0 : registradores[ReadReg2];

    // -------------------------------------------------------------------------
    // ESCRITA SÍNCRONA (Sequencial)
    // A gravação só ocorre quando o clock vira (borda de subida).
    // -------------------------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Zera todos os registradores quando o botão de reset for apertado
            for (i = 0; i < 32; i = i + 1) begin
                registradores[i] <= 32'd0;
            end
        end else begin
            // Só grava se o sinal de controle permitir e se NÃO for o registrador x0!
            if (RegWrite && (WriteReg != 5'd0)) begin
                registradores[WriteReg] <= WriteData;
            end
        end
    end

endmodule