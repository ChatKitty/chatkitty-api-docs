#!/usr/bin/env sh

mv slate temp

git clone https://github.com/ChatKitty/slate.git slate

rm -r slate/source
ln -s ../source slate/source

mv -v temp/* slate/

rm -rf slate/.git