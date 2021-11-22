#include <limits.h>
#include <stdint.h>

// Функция для сложения двух бит с учётом переноса
static inline uint8_t
bit_sum(uint8_t bit_a, uint8_t bit_b, uint8_t carry, int* new_carry)
{
    // Находим новое значение переноса и записываем по адресу
    *new_carry = (bit_a + bit_b + carry) / 2;

    // Находим значение суммы и возвращаем его в качестве результата
    return (bit_a + bit_b + carry) % 2;
}

// Функция для получения i-го бита числа
static inline uint8_t get_ith_bit(ITYPE number, uint64_t i)
{
    return (number >> i) & 1;
}

void sum(ITYPE first, ITYPE second, ITYPE* res, int* CF)
{
    // Находим число бит в ITYPE
    uint64_t bits_count = sizeof(ITYPE) * CHAR_BIT;
    *res = 0;
    for (uint64_t i = 0; i < bits_count; ++i) {
        // Находим i-ые биты наших чисел
        uint8_t bit_a = get_ith_bit(first, i);
        uint8_t bit_b = get_ith_bit(second, i);

        // Находим сумму бит с учётом переноса
        ITYPE sum = bit_sum(bit_a, bit_b, *CF, CF);

        // Записываем бит-результат в соответствующую позицию *res
        *res |= sum << i;
    }
}

void mul(ITYPE first, ITYPE second, ITYPE* res, int* CF)
{
    // Находим число бит в ITYPE
    uint64_t bits_count = sizeof(ITYPE) * CHAR_BIT;

    // Обнуляем содержимое, находящееся по адресу res
    *res = 0;
    for (uint64_t i = 0; i < bits_count; ++i) {
        uint8_t bit_a = get_ith_bit(first, i);
        if (bit_a == 1) {
            sum(*res, (second << i), res, CF);
        }
    }
}