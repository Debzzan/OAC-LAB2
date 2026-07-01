.data
A: .word 1,2,3,4
B: .word 5,6,7,8
C: .word 0,0,0,0

.text
main:
    lui     t3, 0x10010
    addi    t4, t3, 16
    addi    t5, t3, 32
    lw      a0, 0(t3)
    lw      a1, 0(t4)
    jal     ra, mult

    addi    t6, a0, 0

    lw      a0, 4(t3)
    lw      a1, 8(t4)
    jal     ra, mult

    add     t6, t6, a0
    sw      t6, 0(t5)
    lw      a0, 8(t3)
    lw      a1, 0(t4)
    jal     ra, mult

    addi    t6, a0, 0

    lw      a0, 12(t3)
    lw      a1, 8(t4)
    jal     ra, mult

    add     t6, t6, a0
    sw      t6, 8(t5)
    lw      a0, 0(t3)
    lw      a1, 4(t4)
    jal     ra, mult

    addi    t6, a0, 0

    lw      a0, 4(t3)
    lw      a1, 12(t4)
    jal     ra, mult

    add     t6, t6, a0
    sw      t6, 4(t5)
    lw      a0, 8(t3)
    lw      a1, 4(t4)
    jal     ra, mult

    addi    t6, a0, 0

    lw      a0, 12(t3)
    lw      a1, 12(t4)
    jal     ra, mult

    add     t6, t6, a0
    sw      t6, 12(t5)

    jalr    x0, 0(ra)

mult:

    addi    t0, x0, 0      
    addi    t1, a1, 0      

repeat:

    beq     t1, x0, finish

    add     t0, t0, a0
    addi    t1, t1, -1

    jal     x0, repeat

finish:

    addi    a0, t0, 0

    jalr    x0, 0(ra)