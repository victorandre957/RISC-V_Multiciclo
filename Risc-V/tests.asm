.text

# LUI
    li    x5,   0x2000
    auipc x4, 2      
    
# LW e SW
    li x6, 10			
    sw x6, 0(x5)                
    lw x7, 0(x5)               

# ADD e ADDI
    add x8, x6, x7           

# SUB
    sub x9, x8, x7           

# AND e OR
    and x10, x8, x7           
    or x11, x8, x7            

# XOR e SLT
    xor x12, x8, x7           
    slt x13, x7, x8          

# BEQ, BNE, BLT, BLTU, BGE, BGEU
    beq x10, x0, beq_label       
beq_label:
    blt x7, x8, blt_label        
blt_label:
    bge x8, x7, bge_label        
bge_label:
    bltu x7, x8, bltu_label      
bltu_label:
    bgeu x8, x7, bgeu_label      
bgeu_label:
    bne x10, x0, bne_label      

# JAL e JALR
bne_label:
    jal x14, jump_label      
jump_label:
    jalr x15, 4(x14)        

# ORI, ANDI, XORI
    ori x16, x6, 0xFF        
    andi x17, x6, 0xF        
    xori x18, x6, 0xF0       

# SLTI, SLTIU
    slti x19, x6, 100        
    sltiu x20, x6, 100      

# SLL, SRL, SRA
    sll x21, x7, x5          
    srl x22, x7, x5          
    sra x23, x7, x5          

# SLLI, SRLI, SRAI
    slli x24, x7, 2          
    srli x25, x7, 2          
    srai x26, x7, 2
