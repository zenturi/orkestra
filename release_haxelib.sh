#!/bin/sh
rm -f Orkestra.zip
zip -r Orkestra.zip src *.hxml *.json *.md run.n
haxelib submit Orkestra.zip $HAXELIB_PWD --always