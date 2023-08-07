local firebaseHandler = {}

local firebaseDatabase = require("plugin.firebaseDatabase")
local json = require("json")

firebaseDatabase.init()

function firebaseHandler.uploadLevel(levelInfo)
  
  local function randStr()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local length = 6
    local randomString = ""

    for i = 1, length do
      local randomIndex = math.random(1, #chars)
      randomString = randomString .. string.sub(chars, randomIndex, randomIndex)
    end

    return randomString
  end
  
  local id = randStr()
  
  firebaseDatabase.update("levels",{[id] = json.encode(levelInfo)}, function (ev)
      if(ev.isError) then
        native.showAlert( "Could not Upload Data", ev.error , {"Ok"} )
      end
    end
   )
end

function firebaseHandler.getData()
  local data
  firebaseDatabase.get("levels", function (ev)
    if(ev.isError) then
      native.showAlert( "Could not Get Data", ev.error , {"Ok"} )
      firebaseHandler.getData()
    else
      firebaseHandler.lastItems = json.encode(ev.data)
    end
  end)
end

return firebaseHandler