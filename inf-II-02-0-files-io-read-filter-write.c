#include <fcntl.h>
#include <unistd.h>

static const int BUFFER_SIZE = 4096;

ssize_t dump_char_buffer(int fd, char buffer[], int buffer_size)
{
    ssize_t shift = 0;
    ssize_t write_count = 0;
    while ((write_count = write(fd, buffer + shift, buffer_size - shift)) !=
           0) {
        if (write_count == -1) {
            return -1;
        }

        shift += write_count;
    }

    return 0;
}

int main(int argc, char* argv[])
{
    char input_buffer[BUFFER_SIZE];
    char digit_buffer[BUFFER_SIZE];
    char other_buffer[BUFFER_SIZE];

    int exit_code = 0;

    int input_fd = open(argv[1], O_RDONLY);
    if (input_fd == -1) {
        exit_code = 1;

        return exit_code;
    }

    int digit_fd = open(argv[2], O_WRONLY | O_CREAT, 0644);
    if (digit_fd == -1) {
        close(input_fd);

        exit_code = 2;

        return exit_code;
    }

    int other_fd = open(argv[3], O_WRONLY | O_CREAT, 0644);
    if (other_fd == -1) {
        close(input_fd);
        close(digit_fd);

        exit_code = 2;

        return exit_code;
    }

    while (1) {
        ssize_t read_count = 0;
        ssize_t digit_count = 0;
        ssize_t other_count = 0;

        read_count = read(input_fd, input_buffer, BUFFER_SIZE);
        if (read_count == -1) {
            exit_code = 3;

            break;
        } else if (read_count == 0) {
            break;
        }

        for (int i = 0; i < read_count; ++i) {
            if ('0' <= input_buffer[i] && input_buffer[i] <= '9') {
                digit_buffer[digit_count] = input_buffer[i];
                ++digit_count;
            } else {
                other_buffer[other_count] = input_buffer[i];
                ++other_count;
            }
        }

        ssize_t dump_result =
            dump_char_buffer(digit_fd, digit_buffer, digit_count);
        if (dump_result == -1) {
            exit_code = 3;

            break;
        }

        dump_result = dump_char_buffer(other_fd, other_buffer, other_count);
        if (dump_result == -1) {
            exit_code = 3;

            break;
        }
    }

    close(input_fd);
    close(digit_fd);
    close(other_fd);

    return exit_code;
}