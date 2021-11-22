    .intel_syntax noprefix

    .text
    .global avx_sin

avx_sin:
    mov r8, 1
    vcvtsi2sd xmm3, xmm3, r8
    vdivsd xmm1, xmm0, xmm3 #x
	mov r9, 1 #счетчик
	vdivsd xmm2, xmm0, xmm3 #член ряда
    mov r8, 0
    vcvtsi2sd xmm3, xmm3, r8 #ноль
    
	.Loop:
        #домножение на x и деление на счетчик
        vmulsd xmm2, xmm2, xmm1
        inc r9
        vcvtsi2sd xmm4, xmm4, r9
        vdivsd xmm2, xmm2, xmm4
        
        #еще раз тоже самое
        vmulsd xmm2, xmm2, xmm1
        inc r9
        vcvtsi2sd xmm4, xmm4, r9
        vdivsd xmm2, xmm2, xmm4
        
        #меняем знак
        mov r8, -1
        vcvtsi2sd xmm4, xmm4, r8
        vdivsd xmm2, xmm2, xmm4
        
        #прибавляем к сумме
        vaddsd xmm0, xmm0, xmm2
        vcomisd xmm3, xmm2 
        jnz .Loop
	
    ret
