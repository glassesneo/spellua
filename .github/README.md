# spellua
spellua is a high level LuaJIT bindings for Nim.

## Installation
```sh
nimble install spellua
```

## Usage
```nim
import
  std/os,
  spellua

let driver = LuaDriver.init()
driver.loadFile(getAppDir()/"sample.lua")

# Get lua variables
echo driver.getString(Name)
echo driver.getInteger(Size)
echo driver.getBoolean(Enable)

# Bind lua variables
driver.bindString(V1)
echo V1

# Sync nim variables to lua runtime
let syncVal = 5
driver.syncInteger(syncVal)
echo driver.getInteger(syncVal)

# Call lua function (partly supported)
driver.call("PrintValue", 100)

driver.close()
```

```lua
-- sample.lua
Name = [[=================
Hello World
=================]]

Size = 640

Enable = true

V1 = "bound variable"

---@param value integer
function PrintValue(value)
  print(value)
end
```

## License
spellua is licensed under the WTFPL license. See COPYING for details.

