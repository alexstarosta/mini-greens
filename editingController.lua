local settings = require("settings")
local editorSettings = require("editorSettings")
local levelBuilder = require("levelBuilder")
local levelRenderer = require("levelRenderer")

local editingController = {}

editingController.placingStart = false
editingController.placingFinish = false

editingController.startPlaced = false
editingController.finishPlaced = false

editingController.levelValid = false
editingController.levelTested = false

editingController.lastStrokes = 0

function editingController.editingEvents(green, greenGroup)
  
  local function getDistance(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt ( dx * dx + dy * dy )
  end
  
  local function getAccuratePlacement(xtap, ytap, xtile, ytile)
    local distance, x, y = math.huge
    if getDistance(xtap, ytap, xtile - settings.tileWidth/2, ytile - settings.tileWidth/2) < distance then
      x, y = xtile, ytile
      distance = getDistance(xtap, ytap, xtile - settings.tileWidth/2, ytile - settings.tileWidth/2)
    end
    if getDistance(xtap, ytap, xtile + settings.tileWidth/2, ytile - settings.tileWidth/2) < distance then
      x, y = xtile + settings.tileWidth/2, ytile
      distance = getDistance(xtap, ytap, xtile + settings.tileWidth/2, ytile - settings.tileWidth/2)
    end
    if getDistance(xtap, ytap, xtile + settings.tileWidth/2, ytile + settings.tileWidth/2) < distance then
      x, y = xtile + settings.tileWidth/2, ytile + settings.tileWidth/2
      distance = getDistance(xtap, ytap, xtile + settings.tileWidth/2, ytile + settings.tileWidth/2)
    end
    if getDistance(xtap, ytap, xtile - settings.tileWidth/2, ytile + settings.tileWidth/2) < distance then
      x, y = xtile, ytile + settings.tileWidth/2
      distance = getDistance(xtap, ytap, xtile - settings.tileWidth/2, ytile + settings.tileWidth/2)
    end
    return x, y
  end
  
  local function getClosestTile(xtap, ytap)
    local distance, closest = math.huge
    local minDistance = 100
    for x = 1,#green do
      for y = 1,#green[x] do
        if getDistance(xtap, ytap, green[x][y].rect.x, green[x][y].rect.y) < distance then
          closest = green[x][y].rect
          distance = getDistance(xtap, ytap, green[x][y].rect.x, green[x][y].rect.y)
        end
      end
    end
    if distance > minDistance then
      return nil
    else
      return closest
    end
  end
  
  local function overlapCheck(x, y, mainTile)
    
    x = x - settings.tileWidth/2
    y = y - settings.tileWidth/2
    
    for i = 1,#levelRenderer.renderedObjects do
      if levelRenderer.renderedObjects[i].x == x and levelRenderer.renderedObjects[i].y == y then
        return false
      end
      if mainTile ~= nil then
        if levelRenderer.renderedObjects[i].x == mainTile.x - settings.tileWidth/2 and levelRenderer.renderedObjects[i].y == mainTile.y - settings.tileWidth/2 then
          if not string.find(levelRenderer.renderedObjects[i].objectType, "small") then
            return false
          end
        end
        if levelRenderer.renderedObjects[i].x == mainTile.x and levelRenderer.renderedObjects[i].y == mainTile.y then
          if not string.find(levelRenderer.renderedObjects[i].objectType, "small") then
            return false
          end
        end
      end
    end
    return true
    
  end
  
  local function createObjectInTile(xtap, ytap)
    
    local guiBuilder = require("guiBuilder")
    
    local closest = getClosestTile(xtap, ytap)
    local x, y, object
    
    if editorSettings.currentTool == "bplacer" then
      object = editorSettings.currentBlock
    elseif editorSettings.currentTool == "oplacer" then
      object = editorSettings.currentObstacle
    end
    
    if closest == nil then
      return
    end
    
    if string.find(object, "small") then
      x, y = getAccuratePlacement(xtap, ytap, closest.x, closest.y)
      
      if overlapCheck(x, y, closest) then
        levelBuilder.createObject(object, {x = x, y = y}, 0)
        guiBuilder.infoText.text = "Obj: "..object.." \n X: "..x.." \n Y: "..y
      end
    else
      if overlapCheck(closest.x, closest.y) and overlapCheck(closest.x + settings.tileWidth/2, closest.y) and overlapCheck(closest.x + settings.tileWidth/2, closest.y + settings.tileWidth/2) and overlapCheck(closest.x, closest.y + settings.tileWidth/2) then
        levelBuilder.createObject(object, closest, 0)
        guiBuilder.infoText.text = "Obj: "..object.." \n X: "..closest.x.." \n Y: "..closest.y
      end
    end
    
  end
  
  local function eraseObjectInTile(xtap, ytap)
    local closest = getClosestTile(xtap, ytap)
    local x, y = getAccuratePlacement(xtap, ytap, closest.x, closest.y)
    
    x = x - settings.tileWidth/2
    y = y - settings.tileWidth/2
    
    if closest == nil then
      return
    end
    
    for i = 1,#levelRenderer.renderedObjects do
      if levelRenderer.renderedObjects[i].x == x and levelRenderer.renderedObjects[i].y == y then
        levelBuilder.removeObject(x, y)
        return
      end
    end
    for i = 1,#levelRenderer.renderedObjects do
      if levelRenderer.renderedObjects[i] ~= nil then
        if levelRenderer.renderedObjects[i].x == closest.x - settings.tileWidth/2 and levelRenderer.renderedObjects[i].y == closest.y - settings.tileWidth/2 then
          if not string.find(levelRenderer.renderedObjects[i].objectType, "small") then
            levelBuilder.removeObject(closest.x - settings.tileWidth/2, closest.y - settings.tileWidth/2)
            return
          end
        end
        if levelRenderer.renderedObjects[i].x == closest.x and levelRenderer.renderedObjects[i].y == closest.y then
          if not string.find(levelRenderer.renderedObjects[i].objectType, "small") then
            levelBuilder.removeObject(closest.x, closest.y)
          end
        end
      end
    end
    
  end
  
  local function rotateObject(xtap, ytap)
    local closest = getClosestTile(xtap, ytap)
    local x, y = getAccuratePlacement(xtap, ytap, closest.x, closest.y)
    
    x = x - settings.tileWidth/2
    y = y - settings.tileWidth/2
    
    if closest == nil then
      return
    end
    
    local function adjustObject(object, index, rotation)
      
      if object.objectType == "block" or object.objectType == "smallblock" or object.objectType == "hole" or object.objectType == "bumper" then
        return
      end
      
      if object.objectType == "speedup" then
        if object.direction == "left" then
          levelBuilder.createObject(object.objectType, {x = object.x, y = object.y}, 270)
        elseif object.direction == "up" then
          levelBuilder.createObject(object.objectType, {x = object.x, y = object.y}, 0)
        elseif object.direction == "right" then
          levelBuilder.createObject(object.objectType, {x = object.x, y = object.y}, 90)
        elseif object.direction == "down"then
          levelBuilder.createObject(object.objectType, {x = object.x, y = object.y}, 180)
        end
      else
        if string.find(object.objectType, "small") then
          if rotation == 0 then
            levelBuilder.createObject(object.objectType, {x = object.x + settings.tileWidth/2, y = object.y + settings.tileWidth/2}, 0)
          elseif rotation == 90 then
            levelBuilder.createObject(object.objectType, {x = object.x + settings.tileWidth/2, y = object.y + settings.tileWidth/2}, 90)
          elseif rotation == 180 then
            levelBuilder.createObject(object.objectType, {x = object.x + settings.tileWidth/2, y = object.y + settings.tileWidth/2}, 180)
          elseif rotation == 270 then
            levelBuilder.createObject(object.objectType, {x = object.x + settings.tileWidth/2, y = object.y + settings.tileWidth/2}, 270)
          end
        else
          if rotation == 0 then
            levelBuilder.createObject(object.objectType, {x = object.x + settings.tileWidth/2, y = object.y + settings.tileWidth/2}, 0)
          elseif rotation == 90 then
            levelBuilder.createObject(object.objectType, {x = object.x + settings.tileWidth/2, y = object.y + settings.tileWidth/2}, 90)
          elseif rotation == 180 then
            levelBuilder.createObject(object.objectType, {x = object.x + settings.tileWidth/2, y = object.y + settings.tileWidth/2}, 180)
          elseif rotation == 270 then
            levelBuilder.createObject(object.objectType, {x = object.x + settings.tileWidth/2, y = object.y + settings.tileWidth/2}, 270)
          end
        end
      end
      
      display.remove(object)
      table.remove(levelRenderer.renderedObjects, index)
      table.remove(levelRenderer.objectsPackage, index)
      
    end
    
    for i = 1,#levelRenderer.renderedObjects do
      if levelRenderer.renderedObjects[i].x == x and levelRenderer.renderedObjects[i].y == y then
        local rotation
        if levelRenderer.renderedObjects[i].objectRotate == nil then
          rotation = 90
        else
          rotation = levelRenderer.renderedObjects[i].objectRotate + 90
        end
        if rotation >= 360 then
          rotation = 0
        end
        adjustObject(levelRenderer.renderedObjects[i], i, rotation)
        return
      end
    end
    
    for i = 1,#levelRenderer.renderedObjects do
      if levelRenderer.renderedObjects[i].x == closest.x - settings.tileWidth/2 and levelRenderer.renderedObjects[i].y == closest.y - settings.tileWidth/2 then
        if not string.find(levelRenderer.renderedObjects[i].objectType, "small") then
          local rotation
          if levelRenderer.renderedObjects[i].objectRotate == nil then
            rotation = 90
          else
            rotation = levelRenderer.renderedObjects[i].objectRotate + 90
          end
          if rotation >= 360 then
            rotation = 0
          end
          adjustObject(levelRenderer.renderedObjects[i], i, rotation)
          return
        end
      end
      if levelRenderer.renderedObjects[i].x == closest.x and levelRenderer.renderedObjects[i].y == closest.y then
        if not string.find(levelRenderer.renderedObjects[i].objectType, "small") then
          local rotation
          if levelRenderer.renderedObjects[i].objectRotate == nil then
            rotation = 90
          else
            rotation = levelRenderer.renderedObjects[i].objectRotate + 90
          end
          if rotation >= 360 then
            rotation = 0
          end
          adjustObject(levelRenderer.renderedObjects[i], i, rotation)
          return
        end
      end
    end
    
  end
  
  local function placeStart(xtap, ytap)
    local closest = getClosestTile(xtap, ytap)
    
    if closest == nil then
      return
    end
    
    if overlapCheck(closest.x, closest.y) then
      levelBuilder.createStart(closest)
    end
  end
  
  local function placeFinish(xtap, ytap)
    local closest = getClosestTile(xtap, ytap)
    
    if closest == nil then
      return
    end
    
    if overlapCheck(closest.x, closest.y) then
      levelBuilder.createFinish(closest)
    end
  end

  local function onTouch(event)
    local guiBuilder = require("guiBuilder")
    local phase = event.phase
    
    if phase == "began" then
      
      editingController.levelTested = false
      guiBuilder.testedText.text = "Tested: False"
      
      guiBuilder.infoText.reset()
      if editingController.placingStart then
        placeStart(event.x, event.y)
      elseif editingController.placingFinish then
        placeFinish(event.x, event.y)
      else
        if editorSettings.currentTool == "bplacer" then
          createObjectInTile(event.x, event.y)
        elseif editorSettings.currentTool == "oplacer" then
          createObjectInTile(event.x, event.y)
        elseif editorSettings.currentTool == "rotator" then
          rotateObject(event.x, event.y)
        elseif editorSettings.currentTool == "eraser" then
          eraseObjectInTile(event.x, event.y)
        end
      end
    
    elseif phase == "moved" then
      
      if editingController.placingStart then
        placeStart(event.x, event.y)
      elseif editingController.placingFinish then
        placeFinish(event.x, event.y)
      else
        if editorSettings.currentTool == "bplacer" then
          createObjectInTile(event.x, event.y)
        elseif editorSettings.currentTool == "oplacer" then
          createObjectInTile(event.x, event.y)
        elseif editorSettings.currentTool == "rotator" then
          --rotateObject(event.x, event.y)
        elseif editorSettings.currentTool == "eraser" then
          eraseObjectInTile(event.x, event.y)
        end
      end
    
    elseif phase == "ended" or phase == "cancelled" then
    
    end
  end
  
  greenGroup:addEventListener("touch", onTouch)
  
end

function editingController.startEditing(green, greenGroup)
  editingController.editingEvents(green, greenGroup)
end

return editingController