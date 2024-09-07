import
  std/os,
  ../src/spellua,
  ../src/spellua/binding

let driver = LuaDriver.new()

driver.loadFile(getAppDir()/"sample.lua")

echo driver.getString(Name)

echo driver.getInteger(Size)

echo driver.getBoolean(Enable)

driver.close()

