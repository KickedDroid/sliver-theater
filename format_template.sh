#!/bin/bash

source config.conf

cp golang-stager/stager.go golang-stager/main_build.go
sed -i "s/___TARGET___/$TARGET/g" golang-stager/main_build.go


# --- FOR NIM ---
cp nim/stager.nim nim/main_build.nim
sed -i "s/___TARGET___/$TARGET/g" nim/main_build.nim


# --- FOR RUST ---
cp rust/stager/templates/template.rs rust/stager/src/main_build.rs
sed -i "s/___TARGET___/$TARGET/g" rust/stager/src/main_build.rs
cp rust/stager/src/main_build.rs rust/stager/src/main.rs
