local levelRenderer = require("levelRenderer")
local settings = require("settings")
local py = require("physics")

local water, cover

local levelBuilder = {}

levelBuilder.deathZones = display.newGroup()

function levelBuilder.createPrimaryDeathZones()
  levelBuilder.createDeathZone(-25, centerY, settings.tileWidth, screenWidth)
  levelBuilder.createDeathZone(centerX, 630, screenWidth, settings.tileWidth)
  levelBuilder.createDeathZone(centerX, screenHeight - 620, screenWidth, settings.tileWidth)
  levelBuilder.createDeathZone(screenWidth + 25, centerY, settings.tileWidth, screenWidth)
end

function levelBuilder.createWater()
  water = display.newRect(centerX, centerY, screenHeight, screenHeight)
  water.fill = settings.waterColor
  
  cover = display.newRect(centerX, centerY, screenHeight, screenHeight)
  cover.fill = settings.offBlack
  
  return water, cover
end

function levelBuilder.showWater()
  cover.alpha = 0.15
end

function levelBuilder.hideWater()
  cover.alpha = 1
end

function levelBuilder.createGreen()
  local green = {}
  local greenGroup
  for row = 1,10 do
    green[row] = {}
    for column = 1,10 do
      green[row][column] = {}
    end
  end
  green, greenGroup = levelRenderer.renderGreen(green)
  levelBuilder.createPrimaryDeathZones()
  return green, greenGroup
end

function levelBuilder.createObject(objtype, tile, rotation)
  levelRenderer.renderObject(string.lower(objtype), tile, rotation)
end

function levelBuilder.createStart(tile)
  levelRenderer.renderStart(tile)
end

function levelBuilder.createFinish(tile)
  levelRenderer.renderFinish(tile)
end

function levelBuilder.removeObject(x, y)
  local editingController = require("editingController")
  local guiBuilder = require("guiBuilder")
  
  if #levelRenderer.renderedObjects == 0 then
    return
  end
  
  for i = 1,#levelRenderer.renderedObjects do
    if x == levelRenderer.renderedObjects[i].x and y == levelRenderer.renderedObjects[i].y then
      if levelRenderer.renderedObjects[i].objectType == "start" then
        editingController.startPlaced = false
        editingController.levelValid = false
        guiBuilder.validText.text = "Valid: False"
      elseif levelRenderer.renderedObjects[i].objectType == "finish" then
        editingController.finishPlaced = false
        editingController.levelValid = false
        guiBuilder.validText.text = "Valid: False"
      end
      display.remove(levelRenderer.renderedObjects[i])
      table.remove(levelRenderer.objectsPackage, i)
      table.remove(levelRenderer.renderedObjects, i)
      guiBuilder.objAmountText.text = "Total Objs: "..#levelRenderer.renderedObjects
      return
    end
  end
end

function levelBuilder.createDeathZone(x, y, width, height)
  local rect = display.newRect(levelBuilder.deathZones, x, y, width, height)
  rect.objectType = "deathwall"
  rect.alpha = 0
  py.addBody(rect, "static", {isSensor = true})
end

return levelBuilder