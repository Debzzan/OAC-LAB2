module REGISTERS (
    input wire        clk,          // Sinal de clock (sincronizado com o PC)
    input wire        reset,        // Sinal de reset assíncrono (igual ao PC)
    input wire        RegWrite,     // Habilita escrita no banco (sinal de controle)
    input wire [4:0]  ReadReg1,     // Endereço rs1 (5 bits)
    input wire [4:0]  ReadReg2,     // Endereço rs2 (5 bits)
    input wire [4:0]  WriteReg,     // Endereço rd (5 bits)
    input wire [31:0] WriteData,    // Dado a ser gravado (32 bits)
    output wire [31:0] readData_1,   // Dado lido rs1 (32 bits)
    output wire [31:0] readData_2    // Dado lido rs2 (32 bits)
);

    // Matriz de 32 registradores de 32 bits
    reg [31:0] regs [0:31];

    // Leitura Assíncrona: Se o endereço for x0 (0), retorna 0. Senão, lê o banco.
    assign readData_1 = (ReadReg1 == 5'b0) ? 32'b0 : regs[ReadReg1];
    assign readData_2 = (ReadReg2 == 5'b0) ? 32'b0 : regs[ReadReg2];

    // Escrita Síncrona e Reset Assíncrono
    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            regs[0]  <= 32'b0; regs[1]  <= 32'b0; regs[2]  <= 32'b0; regs[3]  <= 32'b0;
            regs[4]  <= 32'b0; regs[5]  <= 32'b0; regs[6]  <= 32'b0; regs[7]  <= 32'b0;
            regs[8]  <= 32'b0; regs[9]  <= 32'b0; regs[10] <= 32'b0; regs[11] <= 32'b0;
            regs[12] <= 32'b0; regs[13] <= 32'b0; regs[14] <= 32'b0; regs[15] <= 32'b0;
            regs[16] <= 32'b0; regs[17] <= 32'b0; regs[18] <= 32'b0; regs[19] <= 32'b0;
            regs[20] <= 32'b0; regs[21] <= 32'b0; regs[22] <= 32'b0; regs[23] <= 32'b0;
            regs[24] <= 32'b0; regs[25] <= 32'b0; regs[26] <= 32'b0; regs[27] <= 32'b0;
            regs[28] <= 32'b0; regs[29] <= 32'b0; regs[30] <= 32'b0; regs[31] <= 32'b0;
        end
        else begin
            if (RegWrite && (WriteReg != 5'b0)) begin
                regs[WriteReg] <= WriteData;
            end
        end
    end

endmodule