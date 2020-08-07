#!/usr/bin/env sh

git clone https://github.com/ChatKitty/slate.git slate

rm -r slate/source
ln -s ../source slate/source

rm -rf slate/.git