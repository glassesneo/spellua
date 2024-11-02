import std/typeinfo

const LibName =
  when defined(MACOSX):
    "libluajit-5.1.dylib"
  elif defined(UNIX):
    "libluajit-5.1.so(|.0)"
  else:
    "luajit-5.1.dll"

const GlobalSIndex = -10002

type
  LuaState* = pointer
  Alloc* = proc(ud, thePtr: pointer, oSize, nSize: cint) {.cdecl.}
  LuaType* {.pure.} = enum
    None = -1
    Nil = 0
    Boolean = 1
    LightUserData = 2
    Number = 3
    String = 4
    Table = 5
    Function = 6
    UserData = 7
    Thread = 8
    MinStack = 20

  Number* = float
  Integer* = cint

{.pragma: plua, importc: "lua_$1".}

{.push callConv: cdecl, dynlib: LibName.}

proc close*(state: LuaState) {.plua.}

proc openlibs*(state: LuaState) {.importc: "luaL_openlibs".}

proc settop*(state: LuaState, index: cint) {.plua.}

proc pcall*(state: LuaState, nargs, nresults, errf: cint): cint {.plua.}

proc tonumber*(state: LuaState, index: cint): Number {.plua.}

proc tointeger*(state: LuaState, index: cint): Integer {.plua.}

proc toboolean*(state: LuaState, index: cint): cint {.plua.}

proc tolstring*(state: LuaState, index: cint, length: ptr cint): cstring {.plua.}

proc getfield*(state: LuaState, index: cint, k: cstring) {.plua.}

proc luatype*(state: LuaState, index: cint): cint {.importc: "lua_type".}

proc pushnil*(state: LuaState) {.plua.}
proc pushnumber*(state: LuaState, n: Number) {.plua.}
proc pushinteger*(state: LuaState, n: Integer) {.plua.}
proc pushboolean*(state: LuaState, b: cint) {.plua.}
proc pushstring*(state: LuaState, s: cstring) {.plua.}

proc setfield*(state: LuaState, index: cint, k: cstring) {.plua.}
proc setglobal*(state: LuaState, s: cstring) =
  state.setfield(GlobalSIndex, s)

proc settable*(state: LuaState, index: cint) {.plua.}
proc setmetatable*(state: LuaState, index: cint) {.plua.}

proc call*(state: LuaState, nargs: cint, nresults: cint) {.importc: "lua_call".}

{.push importc: "luaL_$1".}

proc newstate*(): LuaState

proc loadfile*(state: LuaState, filename: cstring): cint

{.pop.}

{.pop.}

proc pushany*(state: LuaState, v: Any) =
  # conditional push value to Lua stack
  if v.isNil:
    state.pushnil()
  elif v.kind == akBool:
    state.pushboolean(cast[cint](v.getBool))
  elif v.kind == akInt:
    state.pushinteger(cast[cint](v.getInt))
  elif v.kind == akFloat:
    state.pushnumber(v.getFloat)
  elif v.kind == akString:
    state.pushstring(v.getString.cstring)
  else:
    raise newException(AssertionError, "unsupported type")

proc pop*(state: LuaState, n: cint) =
  state.settop(-n - 1)

proc tostring*(state: LuaState, i: cint): cstring =
  result = state.tolstring(i, nil)

proc getglobal*(state: LuaState, s: cstring) =
  state.getfield(GlobalSIndex, s)

