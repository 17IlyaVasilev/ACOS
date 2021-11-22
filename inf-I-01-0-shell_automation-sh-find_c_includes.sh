#!/usr/bin/bash

#Функция ищет соответствующий мануал и выводит его содержимое на поток вывода
function read_man() {
    local c_function = $1

        # Разделитель, который будет использован при итерации в for ниже
        local IFS = :

    local man_content =
        for dir in $MANPATH
            do
                # Проверяем наличие директории man3 на текущей итерации по MANPATH
                local man_dir = "$dir/man3"
                if[!- d "$man_dir"]
                    then
                    continue
                    fi

                    # Проверяем наличие текстового файла с соответствующим маном
                    local man_filepath = "$man_dir/$c_function.3"
                    if[-r "$man_filepath"]
                        then
                        # Читаем содержимое мана
                        man_content = $(cat "$man_filepath")
                        fi

                        # Проверяем наличие сжатого файла с соответствующим маном
                        local compressed_man_filepath = "$man_dir/$c_function.3.gz"
                        if[-f "$compressed_man_filepath"]
                            then
                            # Распаковываем и читаем содержимое мана с помощью gunzip
                            man_content = "$(gunzip -c "$compressed_man_filepath")"
                            fi

                            # Если мы нашли мануал, можем останавливать поиск
                            if[!- z "$man_content"]
                                then
                                break
                                fi
                                done

                                echo "$man_content"
}

#Функция извлекает первый include из переданного мана и выводит его на поток вывода
function extract_include() {
    # Даём понятное обозначение первому аргументу
        local man_content = $1

        # Здесь группа \1 - это содержимое угловых скобок
        local pattern = '^\.B #include <([a-zA-Z0-9_.]+)>'

        # 1. Оставляем только строки, соответствующие шаблону с помощью grep
        # 2. Заменяем строки на первую группу с помощью sed
        # 3. Оставляем только первую из строк(вдруг их несколько) с помощью head
        echo "$man_content" | grep - E "$pattern" | sed - E "s/$pattern/\1/" | head - n 1
}

while read c_function
do
found_include = "---"

man_content = $(read_man $c_function)

# Проверяем наличие мануала и если он есть, то извлекаем из него include
if[!- z "$man_content"]
then
# Вызываем функцию extract_include и сохраняем её вывод в found_include
found_include = $(extract_include "$man_content")
fi

echo "$found_include"
done