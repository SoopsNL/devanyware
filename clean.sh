#!/usr/bin/env -S zsh

setopt EXTENDED_GLOB
[[ -n *.log(#qN) ]] && rm -f *.log || true