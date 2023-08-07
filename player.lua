local composer = require( "composer" )
local py = require("physics")
local json = require("json")
local ballController = require("ballController")
local editingController = require("editingController")
local levelRenderer = require("levelRenderer")
local levelBuilder = require("levelBuilder")
local guiBuilder = require("guiBuilder")
local settings = require("settings")
 
local scene = composer.newScene()
 
local green, greenGroup, ball, water, cover, returnGrp
 
function scene:create( event )
 
    local sceneGroup = self.view
    
    py.start()
    py.setGravity(0,0)
    py.setTimeStep(1/60)
    py.setTimeScale(0.75)
    --py.setDrawMode("hybrid")
    
    water, cover = levelBuilder.createWater()
    cover.alpha = 0
    green, greenGroup = levelBuilder.createGreen()
    
    returnGrp = display.newGroup()
    
    local returnlvlBtn = display.newRoundedRect(returnGrp, 135, screenHeight/6/3, screenHeight/6 - 250, screenHeight/6 - 250, 25)
    returnlvlBtn.fill = settings.secondaryColorDark
    returnlvlBtn.anchorY = 0
    returnlvlBtn:addEventListener("tap", ballController.removeBallButLose)
    
    local returnlvlIcon = display.newImageRect(returnGrp, "assets/icons/return.png", returnlvlBtn.width, returnlvlBtn.height)
    returnlvlIcon.x = returnlvlBtn.x
    returnlvlIcon.y = returnlvlBtn.y + returnlvlBtn.height/2
    
    for i,v in pairs(event.params) do
      local info = v
      if info.objectType == "start" then 
        levelBuilder.createStart({x = info.x, y = info.y})
      elseif info.objectType == "finish" then 
        levelBuilder.createFinish({x = info.x, y = info.y})
      else
        if info.objectType == "bumper" or info.objectType == "speedup" or info.objectType == "hole" then
           levelBuilder.createObject(info.objectType, {x = info.x, y = info.y}, info.rotation)
        else
          levelBuilder.createObject(info.objectType, {x = info.x + settings.tileWidth/2, y = info.y + settings.tileWidth/2}, info.rotation)
        end
      end
    end
    
    local finishx, finishy
    for i = 1,#levelRenderer.renderedObjects do
      if levelRenderer.renderedObjects[i].objectType == "finish" then
        finishx, finishy = levelRenderer.renderedObjects[i].x ,levelRenderer.renderedObjects[i].y
      end
    end
    
    for i = 1,#levelRenderer.renderedObjects do
      if levelRenderer.renderedObjects[i].objectType == "start" then
        ballController.createBall(25, levelRenderer.renderedObjects[i].x, levelRenderer.renderedObjects[i].y, finishx, finishy, true)
        return
      end
    end
    
    returnGrp:toFront()
 
end
 
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
      -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    
    sceneGroup:insert(water)
    sceneGroup:insert(cover)
    sceneGroup:insert(greenGroup)
    sceneGroup:insert(returnGrp)
 
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene