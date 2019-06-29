import terminal, random, os

type
  Drop = object
    velocity, x, y: int
    draw: char

proc initDrops(winWidth, winHeight, farQuantity, closeQuantity: int): seq[Drop] =
  result = newSeq[Drop](farQuantity + closeQuantity)
  for i in 0..<farQuantity:
    result[i].velocity = rand(3..5)
    result[i].x = rand(0..winWidth)
    result[i].y = rand(0..winHeight)
    result[i].draw = ':'

  for i in farQuantity..result.high:
    result[i].velocity = rand(1..2)
    result[i].x = rand(0..winWidth)
    result[i].y = rand(0..winHeight)
    result[i].draw = '|'

proc show(drop: Drop) =
  setCursorPos(drop.x, drop.y)
  stdout.write(drop.draw)

proc clearScreen(winWidth, winHeight: int) =
  setCursorPos(0,0)
  for h in 1..winHeight:
    eraseLine()
    cursorDown()

proc fall(drops: var seq[Drop], winWidth, winHeight: int) =
  clearScreen(winWidth, winHeight)
  for drop in drops.mitems:
    drop.show()
    drop.y += drop.velocity
    if drop.y > winHeight:
      drop.y = 0
  stdout.flushFile()

proc exit() {.noconv.} =
  setCursorPos(0, terminalHeight())
  eraseLine()
  showCursor()
  quit 0

when isMainModule:
  let
    winWidth = terminalWidth()
    winHeight = terminalHeight()
    farQuantity = 50
    closeQuantity = 30
    frameTime = 100

  setControlCHook(exit)
  hideCursor()
  randomize()

  var drops = initDrops(winWidth, winHeight, farQuantity, closeQuantity)

  eraseScreen()

  while true:
    drops.fall(winWidth, winHeight)
    sleep(frameTime)
