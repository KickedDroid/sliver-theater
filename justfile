[working-directory: 'go']
go:
    GOOS=windows GOARCH=amd64 GOROOT=/usr/lib/go-1.22 go build -o go-stager.exe stager.go
    cp go-stager.exe ../objects
    rm go-stager.exe

rust:
    cd rust/stager && cargo build --release --target x86_64-pc-windows-gnu
    cp rust/stager/target/x86_64-pc-windows-gnu/release/stager.exe objects/rust-stager.exe

nim:
    nim c -d:mingw --os:windows --cpu:amd64 --cc:gcc --gcc.exe:x86_64-w64-mingw32-gcc --gcc.linkerexe:x86_64-w64-mingw32-gcc nim/stager.nim
    cp nim/stager.exe nim-stager.exe
    mv nim-stager.exe objects/
    rm nim/stager.exe

format:
    bash ./format_template.sh

replace:
    cp templates/template.go go/stager.go
    cp templates/template.rs rust/stager/src/main.rs
    cp templates/template.nim nim/stager.nim

all: replace format rust nim go replace
