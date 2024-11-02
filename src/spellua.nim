import std/macros
import pkg/seiryu
import spellua/binding

type LuaDriver* = ref object
  state*: LuaState

proc new*(T: type LuaDriver): T {.construct.} =
  result.state = newstate()
  result.state.openlibs()

proc loadFile*(driver: LuaDriver, filename: string) =
  if (driver.state.loadfile(filename.cstring) or driver.state.pcall(0, 0, 0)) != 0:
    let msg = driver.state.tostring(-1)
    raiseAssert("error" & ": " & $msg)

proc close*(driver: LuaDriver) =
  driver.state.close()

macro getNumber*(driver: LuaDriver, name: untyped): Number =
  let nameStrLit = name.strVal.newLit()
  return quote:
    block:
      defer:
        `driver`.state.pop(1)
      `driver`.state.getglobal(`nameStrLit`)
      `driver`.state.tonumber(-1)

macro getInteger*(driver: LuaDriver, name: untyped): Integer =
  let nameStrLit = name.strVal.newLit()
  return quote:
    block:
      defer:
        `driver`.state.pop(1)
      `driver`.state.getglobal(`nameStrLit`)
      `driver`.state.tointeger(-1)

macro getBoolean*(driver: LuaDriver, name: untyped): bool =
  let nameStrLit = name.strVal.newLit()
  return quote:
    block:
      defer:
        `driver`.state.pop(1)
      `driver`.state.getglobal(`nameStrLit`)
      `driver`.state.toboolean(-1) == 1

macro getString*(driver: LuaDriver, name: untyped): string =
  let nameStrLit = name.strVal.newLit()
  return quote:
    block:
      defer:
        `driver`.state.pop(1)
      `driver`.state.getglobal(`nameStrLit`)
      $`driver`.state.tostring(-1)

template bindNumber*(driver: LuaDriver, name: untyped): untyped =
  let name {.inject.} = driver.getNumber(name)

template bindInteger*(driver: LuaDriver, name: untyped): untyped =
  let name {.inject.} = driver.getInteger(name)

template bindBoolean*(driver: LuaDriver, name: untyped): untyped =
  let name {.inject.} = driver.getBoolean(name)

template bindString*(driver: LuaDriver, name: untyped): untyped =
  let name {.inject.} = driver.getString(name)

proc setBoolean*(driver: LuaDriver, name: string, value: bool) =
  driver.state.pushboolean(cast[cint](value))
  driver.state.setglobal(name)

proc setString*(driver: LuaDriver, name: string, value: string) =
  driver.state.pushstring(value.cstring)
  driver.state.setglobal(name)

proc setNumber*(driver: LuaDriver, name: string, value: float) =
  driver.state.pushnumber(value)
  driver.state.setglobal(name)

proc setInteger*(driver: LuaDriver, name: string, value: int) =
  driver.state.pushinteger(cast[cint](value))
  driver.state.setglobal(name)

macro syncBoolean*(driver: LuaDriver, name: untyped) =
  let nameStrLit = name.strVal.newLit()
  return quote:
    block:
      `driver`.state.pushboolean(cast[cint](`name`))
      `driver`.state.setglobal(`nameStrLit`)

macro syncString*(driver: LuaDriver, name: untyped) =
  let nameStrLit = name.strVal.newLit()
  return quote:
    block:
      `driver`.state.pushstring(`name`)
      `driver`.state.setglobal(`nameStrLit`)

macro syncNumber*(driver: LuaDriver, name: untyped) =
  let nameStrLit = name.strVal.newLit()
  return quote:
    block:
      `driver`.state.pushnumber(cast[float](`name`))
      `driver`.state.setglobal(`nameStrLit`)

macro syncInteger*(driver: LuaDriver, name: untyped) =
  let nameStrLit = name.strVal.newLit()
  return quote:
    block:
      `driver`.state.pushinteger(cast[cint](`name`))
      `driver`.state.setglobal(`nameStrLit`)

