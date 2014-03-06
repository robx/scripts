#!/usr/bin/env python
# coding=utf8

import curses

import locale
locale.setlocale(locale.LC_ALL,"")

# bits 0..3 represent directions left,up,right,down
chars = u" ╴╵┘╶─└┴╷┐│┤┌┬├┼"

class Grid(object):

    def __init__(self, w, h):
        self.cells = {}
        for i in xrange(w):
            for j in xrange(h):
                self.cells[i, j] = 0

    def toggle_edge(self, p, q):
        if p > q:
            p, q = q, p
        if p[0] < q[0]:
            self.cells[p] ^= 4
            self.cells[q] ^= 1
        else:
            self.cells[p] ^= 8
            self.cells[q] ^= 2

    def charat(self, p):
        return chars[self.cells[p]]

def init():
    scr = curses.initscr()
    curses.noecho()
    curses.cbreak()
    scr.keypad(1)
    return scr

def shutdown(scr):
    curses.nocbreak()
    scr.keypad(0)
    curses.echo()
    curses.endwin()

def main():
    scr = init()
    (h, w) = scr.getmaxyx()
    g = Grid(w, h)
    scr.move(0, 0)
    p = (0, 0)
    drawing = True
    while True:
        x = scr.getch()
        if x == ord('q'):
            break
        elif x == ord('d'):
            drawing = not drawing
            continue
        elif x == 260:  # left
            d = (-1, 0)
        elif x == 259:  # up
            d = (0, -1)
        elif x == 261:  # right
            d = (1, 0)
        elif x == 258:  # down
            d = (0, 1)
        else:
            continue
        q = (p[0] + d[0], p[1] + d[1])
        if q[0] < 0 or q[0] >= h or q[1] < 0 or q[1] >= w:
            continue
        if drawing:
            g.toggle_edge(p, q)
        p = q
        for x in xrange(w - 1):
            for y in xrange(h - 1):
                scr.addstr(y, x, g.charat((x, y)).encode("utf-8"))
        scr.move(p[1], p[0])
        scr.refresh()
    shutdown(scr)

if __name__ == "__main__":
    main()
