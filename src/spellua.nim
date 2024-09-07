import
  std/macros,
  pkg/[seiryu],
  spellua/binding

type
  LuaDriver* = ref object
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

