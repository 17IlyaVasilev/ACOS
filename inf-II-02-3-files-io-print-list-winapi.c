#include <fcntl.h>
#include <fileapi.h>
#include <stdint.h>
#include <stdio.h>
#include <windows.h>

int main(int argc, char* argv[])
{
    int value = 0;
    int next_pointer = 0;
    HANDLE out = GetStdHandle(STD_OUTPUT_HANDLE);
    HANDLE input_fd = CreateFile(
        argv[1],
        GENERIC_READ,
        FILE_SHARE_READ,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_READONLY,
        NULL);

    while (1) {
        int read_count = 0;
        int write_count = 0;
        ReadFile(input_fd, &value, 4, &read_count, NULL);
        if (read_count == 0)
            break;
        char buffer[30];
        int snp = snprintf(buffer, 30, "%d ", value);
        WriteFile(out, buffer, snp, &write_count, NULL);
        //printf("%d ", value);
        ReadFile(input_fd, &next_pointer, 4, &read_count, NULL);
        LARGE_INTEGER LI_next_pointer;
        LI_next_pointer.QuadPart = (__int64)next_pointer;

        if (next_pointer == 0) {

            break;
        }
        else {
            SetFilePointerEx(input_fd, LI_next_pointer, NULL, FILE_BEGIN);
        }
    }

    CloseHandle(input_fd);
}