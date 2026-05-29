#!/bin/bash

source config.conf

cp golang-stager/stager.go golang-stager/main_build.go
sed -i "s/___TARGET___/$TARGET/g" golang-stager/main_build.go


# --- FOR NIM ---
cp nim/stager.nim nim/main_build.nim
sed -i "s/___TARGET___/$TARGET/g" nim/main_build.nim


# --- FOR RUST ---
cp rust/showtoon/templates/template.rs rust/showtoon/src/main_build.rs
sed -i "s/___TARGET___/$TARGET/g" rust/showtoon/src/main_build.rs
cp rust/showtoon/src/main_build.rs rust/showtoon/src/main.rs
