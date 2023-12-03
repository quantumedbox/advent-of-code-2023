module advent-of-code

import std/os/file
import std/os/path

fun main()
  println(calculate(read-text-file(cwd() / "input")).show())

fun calculate( grid: string )
  walk-grid(grid.lines().map(list))

fun walk-grid( grid: list<list<char>> )
  var result := 0
  var v := 0
  var e := False

  fun check-cell( x : int, y : int ) : bool
    [(-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)].any fn(o)
      match grid[y + o.snd()]
        Just(row) -> match row[x + o.fst()]
          Just(cell) -> !cell.is-digit() && cell != '.'
          Nothing -> False
        Nothing -> False

  fun update()
    if e then result := result + v
    v := 0
    e := False

  grid.foreach-indexed fn( y : int, line : list<char> )
    line.foreach-indexed fn( x : int, ch : char )
      if ch.is-digit() then
        if !e then e := check-cell(x, y)
        v := (v * 10) + (ch.int() - 0x30)
      else update()

    update()

  result
