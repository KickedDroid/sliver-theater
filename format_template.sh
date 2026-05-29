#!/bin/bash
source config.conf
sed -i "s/___TARGET___/$TARGET/g" go/stager.go

# --- FOR NIM ---
sed -i "s/___TARGET___/$TARGET/g" nim/stager.nim

# --- FOR RUST ---
sed -i "s/___TARGET___/$TARGET/g" rust/stager/src/main.rs
