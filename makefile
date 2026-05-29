.PHONY: all go rust nim organize format cleanup

all: format rust nim go organize cleanup

go:
	cd go-stager && GOOS=windows GOARCH=amd64 GOROOT=/usr/lib/go-1.22 go build -o go-stager.exe stager.go
	cp go-stager/go-stager.exe ./

rust:
	cd rust/showtoon && cargo build --release --target x86_64-pc-windows-gnu
	cp rust/showtoon/target/x86_64-pc-windows-gnu/release/showtoon.exe ./rust-stager.exe

nim:
	nim c -d:mingw --os:windows --cpu:amd64 --cc:gcc --gcc.exe:x86_64-w64-mingw32-gcc --gcc.linkerexe:x86_64-w64-mingw32-gcc nim/main_build.nim
	cp nim/main_build.exe ./nim-stager.exe

organize:
	mkdir -p objects
	mv nim-stager.exe rust-stager.exe go-stager.exe objects/

format:
	bash ./format_template.sh

cleanup:
	# rm -rf objects/
	rm -f rust/showtoon/src/main_build.rs nim/main_build.nim nim/main_build.exe
	rm -f go-stager/go-stager.exe
