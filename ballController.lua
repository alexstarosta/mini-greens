local py = require("physics")
local settings = require("settings")
local composer = require("composer")

local ballController = {}

local ball, finishx, finishy, touchBox

function ballController.addEvents(ball)

  touchBox = display.newRect(centerX, centerY, screenWidth, screenHeight)
  touchBox.alpha = 0.01

  local forceText, touchSpot
  local directionRays = display.newGroup()
  
  local function drawBeam(startX, startY, endX, endY)
    local ray = display.newLine( directionRays, startX, startY, endX, endY )
    ray.fill = {1}
    ray.strokeWidth = 5
  end
  
  local function resetBeams()
    display.remove(directionRays)
    directionRays = display.newGroup()
	end
  
  local function getLength(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt(dx * dx + dy * dy)
  end
  
  local function castRay(startX, startY, endX, endY)
    local hits = py.rayCast(startX, startY, endX, endY, "closest")
    
    if (hits and directionRays.numChildren <= -1) then
      
      local hitFirst = hits[1]
      local hitX, hitY = hitFirst.position.x, hitFirst.position.y
      
      drawBeam(startX, startY, hitX, hitY)
      
      local reflectX, reflectY = py.reflectRay(startX, startY, hitFirst)
      local reflectLen = getLength(startX, startY, endX, endY) - getLength(startX, startY, hitX, hitY)
      local reflectEndX = (hitX + (reflectX * reflectLen))
      local reflectEndY = (hitY + (reflectY * reflectLen))
      
      if reflectX and reflectY then
        castRay(hitX, hitY, reflectEndX, reflectEndY) 
      end
      
    else
      drawBeam(startX, startY, endX, endY)
    end
  end
  
  local function ballCheck()
    local x,y = ball:getLinearVelocity()
    if math.abs(x) ~= 0 or math.abs(y) ~= 0 then
      display.getCurrentStage():setFocus(nil)
      return true
    end
    return false
  end
  
  local startTouch = false

  function touchBox:touch(event)
    
    if ballCheck() then
      return true
    end
    
    local phase = event.phase
    
    if phase == "began" then
    
      forceText = display.newText("", ball.x, ball.y - 75, settings.mainFont, 40)
      touchSpot = display.newCircle(event.x, event.y, 30)
      touchSpot.alpha = 0.2
      
      display.getCurrentStage():setFocus(touchBox)
      startTouch = true
    
    elseif phase == "moved" and startTouch then
    
      local dx = event.x - event.xStart
      local dy = event.y - event.yStart
      local force = math.sqrt(dx * dx + dy * dy)
      
      if force > settings.maxHit then
        local scalingFactor = settings.maxHit / force
        dx = dx * scalingFactor
        dy = dy * scalingFactor
        force = settings.maxHit
      end
      
      resetBeams()
      
      if (force/settings.maxHit * 100) > 5 then
        forceText.text = tostring(math.floor(force/settings.maxHit * 105) - 5)
        castRay(ball.x, ball.y, ball.x - dx, ball.y - dy)
      else
        forceText.text = ""
      end
    
    elseif (phase == "ended" or phase == "cancelled") and startTouch then
      
      display.getCurrentStage():setFocus(nil)
      startTouch = false
      
      forceText:removeSelf()
      touchSpot:removeSelf()
      timer.performWithDelay(1, function() resetBeams() end)
      
      ball.strokes = ball.strokes + 1
      
      local dx = event.x - event.xStart
      local dy = event.y - event.yStart
      local force = math.sqrt(dx * dx + dy * dy) + 0.1
      
      local directionX = dx / force
      local directionY = dy / force
      
      if force > settings.maxHit then
        force = settings.maxHit
      elseif (force/settings.maxHit * 100) < 5 then
        force = 0
        ball.strokes = ball.strokes - 1
      end
      
      local forceMagnitude = force * -0.3
      local forceX = directionX * forceMagnitude
      local forceY = directionY * forceMagnitude
      
      ball:applyForce(forceX, forceY, ball.x, ball.y)
      
      local editingController = require("editingController")
      editingController.lastStrokes = ball.strokes
      
    end
    
    return true
  end

  touchBox:addEventListener("touch", touchBox)

end

function ballController.slowBall()
  local x,y = ball:getLinearVelocity()
  x, y = x * 0.985, y * 0.985
  if math.abs(y) < 40 and math.abs(x) < 40 then
    x, y = 0, 0
  end 
  ball:setLinearVelocity(x,y)
end

function ballController.ballSlowing(ball)
  Runtime:addEventListener("enterFrame", ballController.slowBall)
end

function ballController.checkIfFinish()
  if ball.bodyType == "static" then
    return
  end
  local dx = ball.x - finishx
  local dy = ball.y - finishy
  if math.sqrt(dx * dx + dy * dy) < 25 then
    ball.bodyType = "static"
    ball:setLinearVelocity(0,0)
    transition.to(ball, {time = 1000, alpha = 0, width = 0, height = 0})
    timer.performWithDelay(1500, ballController.removeBall)
  end
end

function ballController.finishCheck(ball, finishx, finishy)
  Runtime:addEventListener("enterFrame", ballController.checkIfFinish)
end

function ballController.removeBall()
  local guiBuilder = require("guiBuilder")
  local editingController = require("editingController")
  local levelBuilder = require("levelBuilder")
  local levelRenderer = require("levelRenderer")
  
  if ball.playing then
    
    for i = 1,#levelRenderer.renderedObjects do
      levelRenderer.renderedObjects[i]:removeSelf()
      levelRenderer.renderedObjects[i] = nil
    end
    
    levelRenderer.renderedObjects = {}
    levelBuilder.deathZones:removeSelf()
    levelBuilder.deathZones = display.newGroup()
    
    timer.performWithDelay(10, function()
      composer.removeScene("player")
      composer.gotoScene("menu")
    end)
  else
    display.remove(guiBuilder.returnlvlBtn)
    display.remove(guiBuilder.returnlvlIcon)
    
    levelBuilder.hideWater()
    
    editingController.levelTested = true
    guiBuilder.testedText.text = "Tested: True"
    guiBuilder.topBarGrp.alpha = 1
    guiBuilder.bottomBarGrp.alpha = 1
  end
  
  Runtime:removeEventListener("enterFrame", ballController.checkIfFinish)
  Runtime:removeEventListener("enterFrame", ballController.slowBall)
  display.remove(ball)
  display.remove(touchBox)
  ball = nil
  
end

function ballController.removeBallButLose()
  local guiBuilder = require("guiBuilder")
  local editingController = require("editingController")
  local levelBuilder = require("levelBuilder")
  local levelRenderer = require("levelRenderer")
  
  display.remove(guiBuilder.returnlvlBtn)
  display.remove(guiBuilder.returnlvlIcon)
  
  if ball.playing then
    for i = 1,#levelRenderer.renderedObjects do
      levelRenderer.renderedObjects[i]:removeSelf()
      levelRenderer.renderedObjects[i] = nil
    end
    
    levelRenderer.renderedObjects = {}
    levelBuilder.deathZones:removeSelf()
    levelBuilder.deathZones = display.newGroup()
    
    timer.performWithDelay(10, function()
      composer.removeScene("player")
      composer.gotoScene("menu")
    end)
  else
    levelBuilder.hideWater()
    
    guiBuilder.topBarGrp.alpha = 1
    guiBuilder.bottomBarGrp.alpha = 1
  end
  
  Runtime:removeEventListener("enterFrame", ballController.checkIfFinish)
  Runtime:removeEventListener("enterFrame", ballController.slowBall)
  display.remove(ball)
  display.remove(touchBox)
  ball = nil
end

function ballController.ballCollision(event)

  if (event.other.objectType == "deathwall" or event.other.objectType == "hole") and event.phase == "began" then
    
    local width, height = ball.width, ball.height
    
    local function moveBall()
      ball.x = ball.startx
      ball.y = ball.starty
      ball.height = height
      ball.width = width
      ball.alpha = 1
      ball.bodyType = "dynamic"
    end
    
    ball.bodyType = "static"
    ball:setLinearVelocity(0,0)
    transition.to(ball, {time = 1000, alpha = 0, width = 0, height = 0})
    timer.performWithDelay(1500, moveBall)
  end
  
  if event.other.objectType == "speedup" and event.phase == "began" then
    if event.other.direction == "up" then
      ball:applyForce(0, -100, ball.x, ball.y)
    elseif event.other.direction == "down" then
      ball:applyForce(0, 100, ball.x, ball.y)
    elseif event.other.direction == "right" then
      ball:applyForce(100, 0, ball.x, ball.y)
    elseif event.other.direction == "left" then
      ball:applyForce(-100, 0, ball.x, ball.y)
    end
  end
end

function ballController.createBall(radius, x, y, fx, fy, playing)
  ball = display.newRoundedRect(x, y, radius*2, radius*2, 999)
  ball.startx, ball.starty = x, y
  ball.playing = playing
  finishx, finishy = fx, fy
  
  ball.strokes = 0
  ball.radius = radius
  ball.isSleepingAllowed = false
  
  py.addBody(ball, "dynamic", {radius = radius})
  ball:addEventListener("collision", ballController.ballCollision)
  ballController.addEvents(ball)
  ballController.ballSlowing(ball)
  ballController.finishCheck(ball, finishx, finishy)
  
  return ball
end

return ballController