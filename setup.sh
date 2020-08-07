#!/usr/bin/env sh

rm -rf slate

git clone https://github.com/ChatKitty/slate.git slate

rm -r slate/source
ln -s ../source slate/source

rm -rf slate/.git