#include <limits.h>
#include <stdint.h>
#include <stdio.h>

static inline uint8_t get_ith_bit(uint64_t number, uint64_t i)
{
    return (number >> i) & 1;
}

void operation_and(uint64_t* res, uint64_t* temp)
{
    *res &= *temp;
    *temp = 0;
}

void operation_or(uint64_t* res, uint64_t* temp)
{
    *res |= *temp;
    *temp = 0;
}

void operation_xor(uint64_t* res, uint64_t* temp)
{
    *res ^= *temp;
    *temp = 0;
}

void operation_i(uint64_t* res)
{
    *res = ~(*res);
}

void add(uint64_t* temp, const char* c)
{
    uint64_t one = 1;
    if ('0' <= *c && '9' >= *c) {
        *temp |= one << ((int)(*c) - (int)('0'));
    }
    else if ('A' <= *c && 'Z' >= *c) {
        *temp |= one << (10 + (int)(*c) - (int)('A'));
    }
    else if ('a' <= *c && 'z' >= *c) {
        *temp |= one << (36 + (int)(*c) - (int)('a'));
    }
}

int main(void)
{
    char c = '0';
    uint64_t res = 0;
    uint64_t temp = 0;

    while (1) {
        c = getchar();
        if (!(('0' <= c && c <= '9') || ('A' <= c && c <= 'Z') ||
            ('a' <= c && c <= 'z') || c == '&' || c == '|' || c == '~' ||
            c == '^'))
            break;
        if (c == '&') {
            operation_and(&res, &temp);
        }
        else if (c == '|') {
            operation_or(&res, &temp);
        }
        else if (c == '^') {
            operation_xor(&res, &temp);
        }
        else if (c == '~') {
            operation_i(&res);
        }
        else {
            add(&temp, &c);
        }
    }

    for (int i = 0; i < 10; ++i) {
        if (get_ith_bit(res, i)) {
            char s = (char)(i + (int)('0'));
            printf("%c", s);
        }
    }

    for (int i = 10; i < 36; ++i) {
        if (get_ith_bit(res, i)) {
            char s = (char)(i - 10 + (int)('A'));
            printf("%c", s);
        }
    }

    for (int i = 36; i < 62; ++i) {
        if (get_ith_bit(res, i)) {
            char s = (char)(i - 36 + (int)('a'));
            printf("%c", s);
        }
    }
}