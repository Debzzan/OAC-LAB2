.data
n:       .word 10
limit:   .word 50
array:   .word 12,55,88,10,51,49,50,100,3,75
count:   .word 0

.text
main:
    lui     t0, 0x10010
    lw      t1, 0(t0)
    lw      t2, 4(t0)
    addi    t3, t0, 8
    slli    t4, t1, 2
    add     t4, t4, t3
    addi    t5, x0, 0

loop:

    beq     t3, t4, done

    lw      t6, 0(t3)

    slt     a0, t2, t6
    beq     a0, x0, next

    addi    t5, t5, 1

next:

    addi    t3, t3, 4
    jal     x0, loop

done:

    lui     a1, 0x10010
    addi    a1, a1, 48

    sw      t5, 0(a1)

    jalr    x0, 0(ra)