local composer = require( "composer" )
local py = require("physics")
local ballController = require("ballController")
local editingController = require("editingController")
local levelRenderer = require("levelRenderer")
local levelBuilder = require("levelBuilder")
local guiBuilder = require("guiBuilder")
 
local scene = composer.newScene()
 
local green, greenGroup, ball, water, cover
 
function scene:create( event )
 
    local sceneGroup = self.view
    
    editingController.placingStart = false
    editingController.placingFinish = false
    editingController.startPlaced = false
    editingController.finishPlaced = false
    editingController.levelValid = false
    editingController.levelTested = false
    editingController.lastStrokes = 0
    
    for i = 1,#levelRenderer.renderedObjects do
      levelRenderer.renderedObjects[i]:removeSelf()
      levelRenderer.renderedObjects[i] = nil
    end
    
    for i = 1,#levelRenderer.objectsPackage do
      levelRenderer.objectsPackage[i] = nil
    end
    
    py.start()
    py.setGravity(0,0)
    py.setTimeStep(1/60)
    py.setTimeScale(0.75)
    --py.setDrawMode("hybrid")
    
    water, cover = levelBuilder.createWater()
    green, greenGroup = levelBuilder.createGreen()
    
    editingController.startEditing(green, greenGroup)
    
    guiBuilder.createEditingGui()
 
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
 
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene