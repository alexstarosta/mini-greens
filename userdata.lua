local userdata = {}

local filename = "playerData.txt"

function userdata.fileExists()
  local path = system.pathForFile( filename, system.DocumentsDirectory)
  local f=io.open(path,"r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function userdata.saveState()
  local path = system.pathForFile( filename, system.DocumentsDirectory)
  local file = io.open( path, "w" )
  local contents = userdata.username
  file:write( contents )
  io.close( file )
end

function userdata.loadSavedState()
  local path = system.pathForFile( filename,system.DocumentsDirectory)
  local file = io.open( path, "r" )
  local contents = file:read( "*a" )
  userdata.username = tostring(contents)
  io.close(file)
end

local function onSystemEvent( event )
  if event.type == "applicationExit" then
    userdata.saveState()
  elseif event.type == "applicationStart"  then
    if userdata.fileExists() then
      userdata.loadSavedState()
    else
      userdata.username = "guest"..math.random(100,999)
    end
  end
end

function userdata.checkSystemEvents()
  Runtime:addEventListener( "system", onSystemEvent )
end

return userdata