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

    // Sinais internos para visualização no waveform, no estilo janela de registradores do RARS.
    // No Quartus, procure por banco_registradores|debug_x0[31..0] até debug_x31[31..0].
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x0;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x1;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x2;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x3;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x4;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x5;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x6;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x7;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x8;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x9;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x10;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x11;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x12;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x13;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x14;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x15;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x16;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x17;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x18;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x19;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x20;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x21;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x22;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x23;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x24;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x25;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x26;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x27;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x28;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x29;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x30;
    (* keep = "true", preserve = "true" *) reg [31:0] debug_x31;

    // -------------------------------------------------------------------------
    // LEITURA ASSÍNCRONA (Combinacional)
    // O valor sai no exato instante em que o endereço chega na porta!
    // Se o endereço for 0 (x0), a saída é forçada para 0, conforme o padrão RISC-V.
    // -------------------------------------------------------------------------
    assign readData_1 = (ReadReg1 == 5'd0) ? 32'd0 : registradores[ReadReg1];
    assign readData_2 = (ReadReg2 == 5'd0) ? 32'd0 : registradores[ReadReg2];

    always @(*) begin
        debug_x0  = registradores[0];
        debug_x1  = registradores[1];
        debug_x2  = registradores[2];
        debug_x3  = registradores[3];
        debug_x4  = registradores[4];
        debug_x5  = registradores[5];
        debug_x6  = registradores[6];
        debug_x7  = registradores[7];
        debug_x8  = registradores[8];
        debug_x9  = registradores[9];
        debug_x10 = registradores[10];
        debug_x11 = registradores[11];
        debug_x12 = registradores[12];
        debug_x13 = registradores[13];
        debug_x14 = registradores[14];
        debug_x15 = registradores[15];
        debug_x16 = registradores[16];
        debug_x17 = registradores[17];
        debug_x18 = registradores[18];
        debug_x19 = registradores[19];
        debug_x20 = registradores[20];
        debug_x21 = registradores[21];
        debug_x22 = registradores[22];
        debug_x23 = registradores[23];
        debug_x24 = registradores[24];
        debug_x25 = registradores[25];
        debug_x26 = registradores[26];
        debug_x27 = registradores[27];
        debug_x28 = registradores[28];
        debug_x29 = registradores[29];
        debug_x30 = registradores[30];
        debug_x31 = registradores[31];
    end

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
