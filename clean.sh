#!/usr/bin/env zsh

setopt EXTENDED_GLOB
[[ -n *.log(#qN) ]] && rm -f *.log || true