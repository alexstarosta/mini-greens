local settings = require("settings")
local py = require("physics")

local levelRenderer = {}

levelRenderer.renderedObjects = {}
levelRenderer.objectsPackage = {}

function levelRenderer.renderGreen(green)
  
  local greenGroup = display.newGroup()
  
  for x = 1,#green do
    for y = 1,#green[x] do
      
      green[x][y].rect = display.newRect(greenGroup, centerX, centerY, settings.tileWidth, settings.tileWidth)
      
      if (x+y)%2 == 0 then
        green[x][y].rect.fill = settings.mainColor
      else
        green[x][y].rect.fill = settings.secondaryColor
      end
      
      green[x][y].rect.x = (x-1) * settings.tileWidth + settings.tileWidth/2 + (screenWidth - settings.gridWidth)/2
      green[x][y].rect.y = (y-1) * settings.tileWidth + settings.tileWidth + (screenWidth - settings.gridWidth)/2 + screenHeight/4
    end
  end
  
  return green, greenGroup
  
end

function levelRenderer.renderStart(tile)
  local editingController = require("editingController")
  local guiBuilder = require("guiBuilder")
  
  local ro
  local x = tile.x
  local y = tile.y
  
  ro = display.newRoundedRect(x, y, settings.tileWidth*0.7, settings.tileWidth*0.7, 5)
  ro.fill = settings.secondaryColorDark
  
  ro.objectType = "start"
  levelRenderer.renderedObjects[#levelRenderer.renderedObjects+1] = ro
  
  levelRenderer.objectsPackage[#levelRenderer.objectsPackage+1] = {
    x = tostring(x),
    y = tostring(y),
    rotation = tostring(0),
    objectType = "start",
  }
  
  if guiBuilder.topInfoText ~= nil then
    guiBuilder.topInfoText.text = ""
    editingController.startPlaced = true
    editingController.placingStart = false
    
    if editingController.startPlaced and editingController.finishPlaced then
      editingController.levelValid = true
      guiBuilder.validText.text = "Valid: True"
    end
    
    guiBuilder.objAmountText.text = "Total Objs: "..#levelRenderer.renderedObjects
  end
  
end

function levelRenderer.renderFinish(tile)
  local editingController = require("editingController")
  local guiBuilder = require("guiBuilder")
  
  local ro
  local x = tile.x
  local y = tile.y
  
  ro = display.newCircle(x, y, settings.holeWidth)
  ro.fill = settings.offBlack
  
  ro.objectType = "finish"
  levelRenderer.renderedObjects[#levelRenderer.renderedObjects+1] = ro
  
  levelRenderer.objectsPackage[#levelRenderer.objectsPackage+1] = {
    x = tostring(x),
    y = tostring(y),
    rotation = tostring(0),
    objectType = "finish",
    }
  
  if guiBuilder.topInfoText ~= nil then
    guiBuilder.topInfoText.text = ""
    editingController.finishPlaced = true
    editingController.placingFinish = false
    
    if editingController.startPlaced and editingController.finishPlaced then
      editingController.levelValid = true
      guiBuilder.validText.text = "Valid: True"
    end
    
    guiBuilder.objAmountText.text = "Total Objs: "..#levelRenderer.renderedObjects
  end
  
end

function levelRenderer.renderObject(object, tile, rotation)
  local guiBuilder = require("guiBuilder")
  
  local ro
  
  rotation = tonumber(rotation)
  
  if rotation == 0 then
    rotation = ""
  end
  
  local x = tile.x
  local y = tile.y
  
  if object == "hole" then
    ro = display.newRect(x, y, settings.tileWidth/2, settings.tileWidth/2)
    ro.fill = settings.waterColor
    py.addBody(ro, "static", {isSensor = true})
    ro:scale(2,2)
  elseif object == "bumper" then
    ro = display.newImageRect("assets/sprites/bumper.png", settings.tileWidth, settings.tileWidth)
    ro.x, ro.y = x, y
    py.addBody(ro, "static", {radius = settings.tileWidth/2, bounce = 1.25})
  elseif object == "speedup" then
    
    if rotation == 270 then
      ro = display.newImageRect("assets/sprites/speedup270.png", settings.tileWidth, settings.tileWidth)
      ro.direction = "up"
    elseif rotation == "" then
      ro = display.newImageRect("assets/sprites/speedup.png", settings.tileWidth, settings.tileWidth)
      ro.direction = "right"
    elseif rotation == 90 then
      ro = display.newImageRect("assets/sprites/speedup90.png", settings.tileWidth, settings.tileWidth)
      ro.direction = "down"
    elseif rotation == 180 then
      ro = display.newImageRect("assets/sprites/speedup180.png", settings.tileWidth, settings.tileWidth)
      ro.direction = "left"
    end

    ro.x, ro.y = x, y
    py.addBody(ro, "static", {isSensor = true})
  else
    
    x = tile.x - settings.tileWidth/2
    y = tile.y - settings.tileWidth/2
    
    ro = display.newPolygon(x, y, settings[object..rotation])
    py.addBody(ro, "static", {chain = settings[object..rotation], bounce = 0.5, connectFirstAndLastChainVertex = true})
    
    if rotation == "" then
      ro.objectRotate = 0
    else
      ro.objectRotate = tonumber(rotation)
    end
  
    ro.anchorX = 0
    ro.anchorY = 0
  
  end

  if rotation == "" then
    rotation = 0
  end

  ro.objectType = tostring(object)
  
  levelRenderer.renderedObjects[#levelRenderer.renderedObjects+1] = ro
  
  levelRenderer.objectsPackage[#levelRenderer.objectsPackage+1] = {
    x = tostring(x),
    y = tostring(y),
    rotation = tostring(rotation),
    objectType = tostring(object),
    }
  
  if guiBuilder.objAmountText ~= nil then
    guiBuilder.objAmountText.text = "Total Objs: "..#levelRenderer.renderedObjects
  end
  
  return ro
  
end

return levelRenderer