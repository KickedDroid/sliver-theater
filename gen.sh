#!/bin/bash

generate() {

    mkdir -p objects/
    if [ "$#" -ne 3]; then
        echo "Usage: <template> <IP> <PORT>"
        return 1
    fi

    local templ="$1"
    local ip="$2"
    local port="$3"
    local filename="config.conf"

    echo "TARGET=$ip:$port" > "$filename"

    #[ -f justfile ] && just $templ || make "$templ"

    if just $templ; then
            echo "Build succeeded using justfile!"
        else
            echo "Justfile build failed or 'just' not installed. Trying Makefile..."

            if make $templ; then
                echo "Build succeeded using Makefile!"
            else
                echo "Error: Both build options failed."
                return 1
            fi
        fi

}
generate "$1" "$2" "$3"
