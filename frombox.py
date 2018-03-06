#!/usr/bin/env python3

import sys

# bits 0..3 represent directions left,up,right,down
box = " ╴╵┘╶─└┴╷┐│┤┌┬├┼"

def convert(s):
    top = ""
    bottom = ""
    for i in range(len(s)):
        c = s[i]
        if c not in box:
            c = " "
        x = box.index(c)
        top += "o"
        if x & 8:
            bottom += "|"
        else:
            bottom += " "
        if i == len(s) - 1:
            break
        if x & 4:
            top += "-"
        else:
            top += " "
        bottom += "."
    return top, bottom

def splitspace(s):
    for x in range(len(s)):
        if s[x] != " ":
            break
    return s[:x], s[x:]

def isloop(s):
    for c in s:
        if c in box[1:]:
            return True
    return False

if __name__ == "__main__":
    prev = None
    white = None
    for l in sys.stdin:
        if isloop(l):
            if prev is not None:
                print(prev)
            if white is None:
                white, rest = splitspace(l[:-1])
            else:
                rest = l[len(white):-1]
            top, bottom = convert(rest)
            print(white + top)
            prev = white + bottom
        else:
            prev = None
            white = None
            print(l, end='')
