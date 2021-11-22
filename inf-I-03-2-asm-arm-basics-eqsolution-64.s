.text
.global solve

solve :
mov w4, 0 //текущей корень 
mov w5, 254 //максимальный возможный корень
LoopBegin : //цикл               
    cmp w4, w5 //сравнение   
    bgt LoopEnd //выход из цикла, если условие не выполняется
    mul w6, w0, w4 //Ax      
    add w6, w6, w1 //Ax + B 
    mul w6, w6, w4 //Axx + Bx 
    add w6, w6, w2 //Axx + Bx + C
    mul w6, w6, w4 //Axxx + Bxx + Cx
    add w6, w6, w3 //Axxx + Bxx + Cx + D
    cmp w6, 0 //является ли x корнем
    beq ans //присваивание значения корня и return               
    add w4, w4, 1 //увеличиваем рссматриваемый корень на 1 
    b LoopBegin //в начало цикла                               
    LoopEnd : //конец цикла

ans:
mov w0, w4
ret