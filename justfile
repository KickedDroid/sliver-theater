[working-directory: 'go']
go:
    GOOS=windows GOARCH=amd64 GOROOT=/usr/lib/go-1.22 go build -o go-stager.exe stager.go
    cp go-stager.exe ../

rust:
    cd rust/stager && cargo build --release --target x86_64-pc-windows-gnu
    cp rust/stager/target/x86_64-pc-windows-gnu/release/stager.exe rust-stager.exe

nim:
    nim c -d:mingw --os:windows --cpu:amd64 --cc:gcc --gcc.exe:x86_64-w64-mingw32-gcc --gcc.linkerexe:x86_64-w64-mingw32-gcc nim/main_build.nim
    cp nim/main_build.exe nim-stager.exe

organize:
    mv nim-stager.exe rust-stager.exe go-stager.exe objects

format:
    bash ./format_template.sh

cleanup:
    # rm -rf objects/
    rm rust/stager/src/main_build.rs nim/main_build.nim nim/main_build.exe
    rm go/go-stager.exe

all: format rust nim go organize cleanup
