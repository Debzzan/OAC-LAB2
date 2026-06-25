module REGISTERS (
    input wire        clk,          // Sinal de clock (sincronizado com o PC)
    input wire        reset,        // Sinal de reset assíncrono (igual ao PC)
    input wire        RegWrite,     // Habilita escrita no banco (sinal de controle)
    input wire [4:0]  ReadReg1,     // Endereço rs1 (5 bits)
    input wire [4:0]  ReadReg2,     // Endereço rs2 (5 bits)
    input wire [4:0]  WriteReg,     // Endereço rd (5 bits)
    input wire [31:0] WriteData,    // Dado a ser gravado (32 bits)
    output wire [31:0] readData_1,  // Dado lido rs1 (32 bits - ASSÍNCRONO)
    output wire [31:0] readData_2,  // Dado lido rs2 (32 bits - ASSÍNCRONO)
    output wire [31:0] out_x0,
    output wire [31:0] out_x1,
    output wire [31:0] out_x2,
    output wire [31:0] out_x3,
    output wire [31:0] out_x4,
    output wire [31:0] out_x5,
    output wire [31:0] out_x6,
    output wire [31:0] out_x7,
    output wire [31:0] out_x8,
    output wire [31:0] out_x9,
    output wire [31:0] out_x10,
    output wire [31:0] out_x11,
    output wire [31:0] out_x12,
    output wire [31:0] out_x13,
    output wire [31:0] out_x14,
    output wire [31:0] out_x15,
    output wire [31:0] out_x16,
    output wire [31:0] out_x17,
    output wire [31:0] out_x18,
    output wire [31:0] out_x19,
    output wire [31:0] out_x20,
    output wire [31:0] out_x21,
    output wire [31:0] out_x22,
    output wire [31:0] out_x23,
    output wire [31:0] out_x24,
    output wire [31:0] out_x25,
    output wire [31:0] out_x26,
    output wire [31:0] out_x27,
    output wire [31:0] out_x28,
    output wire [31:0] out_x29,
    output wire [31:0] out_x30,
    output wire [31:0] out_x31
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

    assign out_x0  = 32'd0;
    assign out_x1  = registradores[1];
    assign out_x2  = registradores[2];
    assign out_x3  = registradores[3];
    assign out_x4  = registradores[4];
    assign out_x5  = registradores[5];
    assign out_x6  = registradores[6];
    assign out_x7  = registradores[7];
    assign out_x8  = registradores[8];
    assign out_x9  = registradores[9];
    assign out_x10 = registradores[10];
    assign out_x11 = registradores[11];
    assign out_x12 = registradores[12];
    assign out_x13 = registradores[13];
    assign out_x14 = registradores[14];
    assign out_x15 = registradores[15];
    assign out_x16 = registradores[16];
    assign out_x17 = registradores[17];
    assign out_x18 = registradores[18];
    assign out_x19 = registradores[19];
    assign out_x20 = registradores[20];
    assign out_x21 = registradores[21];
    assign out_x22 = registradores[22];
    assign out_x23 = registradores[23];
    assign out_x24 = registradores[24];
    assign out_x25 = registradores[25];
    assign out_x26 = registradores[26];
    assign out_x27 = registradores[27];
    assign out_x28 = registradores[28];
    assign out_x29 = registradores[29];
    assign out_x30 = registradores[30];
    assign out_x31 = registradores[31];

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
