# spellua
spellua is a high level LuaJIT bindings for Nim.

## Usage
```nim
import
  std/os,
  spellua

let driver = LuaDriver.new()

driver.loadFile(getAppDir()/"sample.lua")

# Get lua variables
echo driver.getString(Name)

echo driver.getInteger(Size)

echo driver.getBoolean(Enable)

# Bind lua variables
driver.bindString(V1)

echo V1

driver.close()
```

```lua:sample.lua
Name = [[=================
Hello World
=================]]

Size = 640

Enable = true

V1 = "bound variable"
```

## License
ecslib is licensed under the MIT license. See COPYING for details.

