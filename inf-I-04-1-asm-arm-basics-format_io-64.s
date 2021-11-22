        .text
        .global main

        // Макросы для push и pop (можно и без них)
        .macro push Xn
                sub sp, sp, 16 // Выделяем место на стеке
                str \Xn, [sp]
        .endm

        .macro pop Xn
                ldr \Xn, [sp]
                add sp, sp, 16 // Освобождаем место на стеке
        .endm

main:
        // Сохраняем адрес возврата из main
        push x30

        // Выделяем на стеке место под значение, получаемое из scanf
        sub sp, sp, 32
        mov x1, sp // Одно слагаемое

        add sp, sp, 16
        mov x2, sp // Второе слагаемое

        sub sp, sp, 16

        // Вызываем библиотечный scanf("%d", &a)
        adr x0, scanf_format
        bl scanf

        //Достаём из стека первое число
        ldr x1, [sp]
        add sp, sp, 16

        //Достаём из стека второе число
        ldr x2, [sp]
        add sp, sp, 16

        //Складываем числа
        add x1, x1, x2

        // Вызываем библиотечный printf
        adr x0, printf_format
        bl printf

        // Возвращаем адрес возврата из main на место
        pop x30

        // Успех, нулевой код возврата
        mov x0, 0
        ret

        .section .rodata
scanf_format:
        .string "%d %d"

printf_format:
        .string "%d"

