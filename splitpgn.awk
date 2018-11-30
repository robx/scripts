#!/usr/bin/awk

BEGIN { i = 0 }

/^\[Event/ { close(out)
             i += 1
             out = i ".pgn" }

{ print $0 >out }
