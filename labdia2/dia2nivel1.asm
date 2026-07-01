.data
n:      .word 8
array:  .word 3,1,4,1,5,9,2,6
result: .word 0

.text
main:
    lui     s0, 0x10010
    lw      s1, 0(s0)
    addi    s2, s0, 4
    add     s3, s3, s2
    addi    s4, x0, 0

loop:

    beq     s2, s3, finish

    lw      s5, 0(s2)
    add     s4, s4, s5

    addi    s2, s2, 4

    jal     x0, loop

finish:

    lui     s6, 0x10010
    addi    s6, s6, 36

    sw      s4, 0(s6)

    jalr    x0, 0(ra)
