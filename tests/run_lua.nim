import std/os
import ../src/spellua, ../src/spellua/binding

let driver = LuaDriver.init()
driver.loadFile(getAppDir() / "sample.lua")

echo driver.getString(Name)
echo driver.getInteger(Size)
echo driver.getBoolean(Enable)

driver.bindString(V1)
echo V1

let syncVal = 5
driver.syncInteger(syncVal)
echo driver.getInteger(syncVal)

driver.call("PrintValue", 100)

driver.close()
