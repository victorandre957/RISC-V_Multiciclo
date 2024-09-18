.text

    lui x5, 2
    addi x5, x5, 0
    auipc x7, 2

    addi x6, x0, 10
    add x8, x6, x6
    sub x9, x8, x6

    and x10, x8, x6
    or x11, x8, x6
    xor x12, x8, x6

    slt x13, x6, x8

    jal x14, br
    nop

br:
    jalr x15, 12(x14)
    nop

    ori x16, x6, 0x000000ff
    andi x17, x6, 0x000000ff
    xori x18, x6, 0x000000F0

    slti x19, x6, 100
    sltiu x20, x6, 100

    sll x21, x6, x5
    srl x22, x6, x5
    sra x23, x6, x5

    slli x24, x6, 2
    srli x25, x6, 2
    srai x26, x6, 2

    beq x6, x9, bt
    nop
bt:
    blt x6, x9, bg
    nop
bg:
    bge x8, x6, btu
    nop
btu:
    bltu x6, x8, bgeu
    nop
bgeu:
    bgeu x8, x0 bne
    nop
bne:
    bne x8, x0 lui
    nop
lui:
    lui x9, 2
    sw x6, 0(x29)
    lw x30, 0(x29)
    add x30, x0, x30
