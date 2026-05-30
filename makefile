.PHONY: all go rust nim organize format cleanup

all: replace format rust nim go organize replace

go:
	cd go && GOOS=windows GOARCH=amd64 GOROOT=/usr/lib/go-1.22 go build -o go-stager.exe stager.go
	cd go && cp go-stager.exe ../
	rm go/go-stager.exe

rust:
	cd rust/stager && cargo build --release --target x86_64-pc-windows-gnu
	cp rust/stager/target/x86_64-pc-windows-gnu/release/stager.exe ./rust-stager.exe

nim:
	nim c -d:mingw --os:windows --cpu:amd64 --cc:gcc --gcc.exe:x86_64-w64-mingw32-gcc --gcc.linkerexe:x86_64-w64-mingw32-gcc nim/stager.nim
	cp nim/stager.exe ./nim-stager.exe
	rm nim/stager.exe

organize:
	mkdir -p objects
	mv nim-stager.exe rust-stager.exe go-stager.exe objects/

replace:
	cp templates/template.go go/stager.go
	cp templates/template.rs rust/stager/src/main.rs
	cp templates/template.nim nim/stager.nim

format:
	bash ./format_template.sh

cleanup:
	# rm -rf objects/
	rm -f go/go-stager.exe nim/stager.exe
