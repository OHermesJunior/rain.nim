import terminal, random, os

let
  winWidth = terminalWidth()
  winHeight = terminalHeight()
  farQuantity = 50
  closeQuantity = 30

type
  Drop = ref object
    velocity, x, y: int
    draw: char

var
  drops: seq[Drop]
  run = true

proc initDrops() =
  for i in 0..farQuantity - 1:
    drops.add(Drop())
    drops[i].velocity = rand(3..5)
    drops[i].x = rand(0..winWidth)
    drops[i].y = rand(0..winHeight)
    drops[i].draw = ':'
  
  for i in farQuantity..closeQuantity + farQuantity:
    drops.add(Drop())
    drops[i].velocity = rand(1..2)
    drops[i].x = rand(0..winWidth)
    drops[i].y = rand(0..winHeight)
    drops[i].draw = '|'

proc show(drop: Drop) =
  setCursorPos(drop.x, drop.y)
  stdout.write(drop.draw)
  stdout.flushFile()
  setCursorPos(0, winHeight)

proc clearScreen() =
  setCursorPos(0,0)
  for h in 1..winHeight:
    for w in 1..winWidth:
      stdout.write(" ")
      stdout.flushFile()

proc fall() =
  clearScreen()
  for drop in drops:
    drop.show()
    drop.y += drop.velocity
    if drop.y > winHeight:
      drop.y = 0

proc exit() {.noconv.} =
  run = false
  setCursorPos(0, winHeight)
  eraseLine()
  showCursor()

when isMainModule:
  setControlCHook(exit)
  hideCursor()
  randomize()
  initDrops()
  eraseScreen()
  while run:
    fall()
    sleep(100)