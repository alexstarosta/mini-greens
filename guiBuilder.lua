local settings = require("settings")
local editorSettings = require("editorSettings")
local editingController = require("editingController")
local levelRenderer = require("levelRenderer")
local ballController = require("ballController")
local composer = require("composer")

local guiBuilder = {}

guiBuilder.currentGuiObjects = {}
guiBuilder.currentGuiGroup = display.newGroup()
guiBuilder.titleText = ""

local inputField

function guiBuilder.createTextBox(x, y, width, height)

  local userInput = ""

  inputField = native.newTextField(centerX, centerY - 100, width, height)
  inputField.inputType = "no-emoji"
  inputField.hasBackground = false
  inputField.font = native.newFont(settings.mainFont, 56)

  local function onUserInput(event)
    if event.phase == "editing" then
      
      userInput = event.text
      guiBuilder.titleText = userInput
      
      if #userInput > 20 then
        userInput = userInput:sub(1, 20)
        inputField.text = userInput
        guiBuilder.titleText = userInput
        native.setKeyboardFocus(nil)
      end
      
    end
  end

  inputField:addEventListener("userInput", onUserInput)
  inputField:resizeFontToFitHeight()
  
  return inputField

end

function guiBuilder.createUploadGui(par, builder, objects)
  guiBuilder.uploadGrp = display.newGroup()
  
  local divider = display.newRect(guiBuilder.uploadGrp, centerX, centerY, screenWidth, screenHeight)
  divider.fill = {0,0.5}
  divider:addEventListener("touch", function() return true end)
  
  local panel = display.newRoundedRect(guiBuilder.uploadGrp, centerX, centerY, screenWidth * 0.95, screenWidth, 50)
  panel.fill = settings.mainColorDark
  
  local returnBtn = display.newRoundedRect(guiBuilder.uploadGrp, 155, screenHeight/4 + 100, screenHeight/6 - 250, screenHeight/6 - 250, 25)
  returnBtn.fill = settings.secondaryColorDark
  returnBtn.anchorY = 0
  
  local returnIcon = display.newImageRect(guiBuilder.uploadGrp, "assets/icons/return.png", returnBtn.width, returnBtn.height)
  returnIcon.x = returnBtn.x
  returnIcon.y = returnBtn.y + returnBtn.height/2
  
  local titleText = display.newText(guiBuilder.uploadGrp, "Upload Level", centerX, returnBtn.y, settings.mainFont, 80)
  titleText.anchorY = 0
  
  local titleTextboxBack = display.newRoundedRect(guiBuilder.uploadGrp, centerX, centerY - 100, screenWidth*0.8 + 50, 150, 20)
  titleTextboxBack.fill = settings.secondaryColorDark
  local titleTextbox = guiBuilder.createTextBox(centerX, centerY, screenWidth*0.8, 100)
  
  local titleExplainText = display.newText(guiBuilder.uploadGrp, "Level Title (3-20 Characters)", returnIcon.x - returnIcon.width/2 + 10, centerY - 270, settings.mainFont, 50)
  titleExplainText.anchorY = 0
  titleExplainText.anchorX = 0
  
  local parText = display.newText(guiBuilder.uploadGrp, "Level Par: "..par, returnIcon.x - returnIcon.width/2 + 10, centerY + 30, settings.mainFont, 50)
  parText.anchorY = 0
  parText.anchorX = 0
  
  local builderText = display.newText(guiBuilder.uploadGrp, "Level Builder: "..builder, returnIcon.x - returnIcon.width/2 + 10, centerY + 100, settings.mainFont, 50)
  builderText.anchorY = 0
  builderText.anchorX = 0
  
  local objectsText = display.newText(guiBuilder.uploadGrp, "Total Objects: "..objects, returnIcon.x - returnIcon.width/2 + 10, centerY + 170, settings.mainFont, 50)
  objectsText.anchorY = 0
  objectsText.anchorX = 0
  
  local uploadBtn = display.newRoundedRect(guiBuilder.uploadGrp, centerX, centerY + 400, screenWidth*0.4 + 50, 150, 20)
  uploadBtn.fill = settings.secondaryColorDark
  
  local uploadText = display.newText(guiBuilder.uploadGrp, "UPLOAD", uploadBtn.x, uploadBtn.y - 10, settings.mainFont, 80)
  
  -- FUNCTIONS
  
  local function uploadLevel()
    local levelRenderer = require("levelRenderer")
    local firebaseHandler = require("firebaseHandler")
    
    if #guiBuilder.titleText >= 3 and #guiBuilder.titleText <= 20 then
      inputField:removeSelf()
      guiBuilder.uploadGrp.alpha = 0
      
      local levelTable = {
        title = guiBuilder.titleText,
        par = par,
        builder = builder,
        objects = levelRenderer.objectsPackage
      }
      
      firebaseHandler.uploadLevel(levelTable)
      guiBuilder.returnToMenu()
    end
  end
  
  uploadBtn:addEventListener("tap", uploadLevel)
  
  local function closeGui()
    guiBuilder.uploadGrp:removeSelf()
    titleTextbox:removeSelf()
  end
  
  returnBtn:addEventListener("tap", closeGui)
  
end
  

function guiBuilder.createEditingGui()
  
  -- INFO TEXT
  
  guiBuilder.topInfoText = display.newText("", centerX, screenHeight/6 + 140, settings.mainFont, 80)
  transition.to(guiBuilder.topInfoText, {time = 1500, iterations = -1, xScale = 1.1, yScale = 1.1, transition = easing.continuousLoop})
  
  -- TOP BAR
  
  guiBuilder.topBarGrp = display.newGroup()
  
  local topBar = display.newRect(guiBuilder.topBarGrp, centerX, 0, screenWidth, screenHeight/6)
  topBar.anchorY = 0
  topBar.fill = settings.mainColorDark
  
  local returnBtn = display.newRoundedRect(guiBuilder.topBarGrp, 135, topBar.height/3, screenHeight/6 - 250, screenHeight/6 - 250, 25)
  returnBtn.fill = settings.secondaryColorDark
  returnBtn.anchorY = 0
  
  local returnIcon = display.newImageRect(guiBuilder.topBarGrp, "assets/icons/return.png", returnBtn.width, returnBtn.height)
  returnIcon.x = returnBtn.x
  returnIcon.y = returnBtn.y + returnBtn.height/2
  
  local toolsBtn = display.newRoundedRect(guiBuilder.topBarGrp, returnBtn.x + returnBtn.width + 60, topBar.height/3, screenHeight/6 - 175, screenHeight/6 - 175, 25)
  toolsBtn.fill = settings.secondaryColorDark
  toolsBtn.anchorY = 0
  
  local toolsIcon = display.newImageRect(guiBuilder.topBarGrp, "assets/icons/tools/"..editorSettings.currentTool..".png", toolsBtn.width, toolsBtn.height)
  toolsIcon.x = toolsBtn.x
  toolsIcon.y = toolsBtn.y + toolsBtn.height/2
  
  local secondaryBtn = display.newRoundedRect(guiBuilder.topBarGrp, toolsBtn.x + toolsBtn.width + 25, topBar.height/3, screenHeight/6 - 175, screenHeight/6 - 175, 25)
  secondaryBtn.fill = settings.secondaryColorDark
  secondaryBtn.anchorY = 0
  
  local secondaryIcon = display.newImageRect(guiBuilder.topBarGrp, "assets/icons/blocks/"..editorSettings.currentBlock..".png", secondaryBtn.width, secondaryBtn.height)
  secondaryIcon.x = secondaryBtn.x
  secondaryIcon.y = secondaryBtn.y + secondaryBtn.height/2
  
  guiBuilder.infoText = display.newText(guiBuilder.topBarGrp, "Obj: None \n X: nil \n Y: nil", secondaryBtn.x + secondaryBtn.width - 80, topBar.height/3, settings.mainFont, 35)
  guiBuilder.infoText.anchorY = 0
  guiBuilder.infoText.anchorX = 0
  
  function guiBuilder.infoText.reset()
    guiBuilder.infoText.text = "Selected: None \n X: nil \n Y: nil"
  end
  
  guiBuilder.objAmountText = display.newText(guiBuilder.topBarGrp, "Total Objs: "..#levelRenderer.renderedObjects, secondaryBtn.x + secondaryBtn.width - 80, topBar.height/3 + 175, settings.mainFont, 35)
  guiBuilder.objAmountText.anchorY = 0
  guiBuilder.objAmountText.anchorX = 0
    
  function guiBuilder.topBarGrp.changeTool()
    toolsIcon:removeSelf()
    toolsIcon = display.newImageRect(guiBuilder.topBarGrp, "assets/icons/tools/"..editorSettings.currentTool..".png", toolsBtn.width, toolsBtn.height)
    toolsIcon.x = toolsBtn.x
    toolsIcon.y = toolsBtn.y + toolsBtn.height/2
  end
  
  function guiBuilder.topBarGrp.changeSecondary()
    secondaryIcon:removeSelf()
    if editorSettings.currentTool == "oplacer" then
      secondaryIcon = display.newImageRect(guiBuilder.topBarGrp, "assets/icons/obstacles/"..editorSettings.currentObstacle..".png", secondaryBtn.width, secondaryBtn.height)
      secondaryIcon.x = secondaryBtn.x
      secondaryIcon.y = secondaryBtn.y + secondaryBtn.height/2
    else
      secondaryIcon = display.newImageRect(guiBuilder.topBarGrp, "assets/icons/blocks/"..editorSettings.currentBlock..".png", secondaryBtn.width, secondaryBtn.height)
      secondaryIcon.x = secondaryBtn.x
      secondaryIcon.y = secondaryBtn.y + secondaryBtn.height/2
    end
  end
  
  -- BOTTOM BAR
  
  guiBuilder.bottomBarGrp = display.newGroup()
  
  local bottomBar = display.newRect(guiBuilder.bottomBarGrp, centerX, screenHeight, screenWidth, screenHeight/6)
  bottomBar.anchorY = 1
  bottomBar.fill = settings.mainColorDark
  
  local themeBtn = display.newRoundedRect(guiBuilder.bottomBarGrp, 170, screenHeight - bottomBar.height/3, screenHeight/6 - 175, screenHeight/6 - 175, 25)
  themeBtn.fill = settings.secondaryColorDark
  themeBtn.anchorY = 1
  
  local themeIcon = display.newImageRect(guiBuilder.bottomBarGrp, "assets/icons/theme.png", themeBtn.width, themeBtn.height)
  themeIcon.x = themeBtn.x
  themeIcon.y = themeBtn.y - themeBtn.height/2
  
  local startBtn = display.newRoundedRect(guiBuilder.bottomBarGrp, themeBtn.x + themeBtn.width + 25, screenHeight - bottomBar.height/3 - (screenHeight/6 - 175)/2 - 12.5, screenHeight/6 - 175, screenHeight/6 - 175, 25)
  startBtn.height = startBtn.height/2 - 12.5
  startBtn.fill = settings.secondaryColorDark
  startBtn.anchorY = 1
  
  local startBtnText = display.newText(guiBuilder.bottomBarGrp, "Place Start", startBtn.x, startBtn.y - startBtn.height/2, settings.mainFont, 35)
  
  local finishBtn = display.newRoundedRect(guiBuilder.bottomBarGrp, themeBtn.x + themeBtn.width + 25, screenHeight - bottomBar.height/3, screenHeight/6 - 175, screenHeight/6 - 175, 25)
  finishBtn.height = finishBtn.height/2 - 12.5
  finishBtn.fill = settings.secondaryColorDark
  finishBtn.anchorY = 1
  
  local finishBtnText = display.newText(guiBuilder.bottomBarGrp, "Place Finish", finishBtn.x, finishBtn.y - finishBtn.height/2, settings.mainFont, 35)
  
  local testBtn = display.newRoundedRect(guiBuilder.bottomBarGrp, startBtn.x + startBtn.width + 25, screenHeight - bottomBar.height/3 - (screenHeight/6 - 175)/2 - 12.5, screenHeight/6 - 175, screenHeight/6 - 175, 25)
  testBtn.height = testBtn.height/2 - 12.5
  testBtn.fill = settings.secondaryColorDark
  testBtn.anchorY = 1
  
  local testBtnText = display.newText(guiBuilder.bottomBarGrp, "Test Level", testBtn.x, testBtn.y - testBtn.height/2, settings.mainFont, 35)
  
  local uploadBtn = display.newRoundedRect(guiBuilder.bottomBarGrp, finishBtn.x + finishBtn.width + 25, screenHeight - bottomBar.height/3, screenHeight/6 - 175, screenHeight/6 - 175, 25)
  uploadBtn.height = uploadBtn.height/2 - 12.5
  uploadBtn.fill = settings.secondaryColorDark
  uploadBtn.anchorY = 1
  
  local uploadBtnText = display.newText(guiBuilder.bottomBarGrp, "Upload Level", uploadBtn.x, uploadBtn.y - uploadBtn.height/2, settings.mainFont, 35)
  
  guiBuilder.testedText = display.newText(guiBuilder.bottomBarGrp, "Tested: False", uploadBtn.x + uploadBtn.width - 80, screenHeight - bottomBar.height/3 - themeBtn.height, settings.mainFont, 35)
  guiBuilder.testedText.anchorY = 0
  guiBuilder.testedText.anchorX = 0
  
  guiBuilder.validText = display.newText(guiBuilder.bottomBarGrp, "Valid: False", uploadBtn.x + uploadBtn.width - 80, screenHeight - bottomBar.height/3 - 175, settings.mainFont, 35)
  guiBuilder.validText.anchorY = 0
  guiBuilder.validText.anchorX = 0
  
  -- TOOLS PANEL
  
  local toolsGrp = display.newGroup()
  
  for i = 1,4 do
    local toolBtn, toolIcon = display.newRoundedRect(toolsGrp, 115  + ((screenHeight/6 - 250)/1.25 + 4)*(i-1), topBar.height + (screenHeight/6 - 250)/1.25, screenHeight/6 - 290, screenHeight/6 - 290, 25)
    toolBtn.fill = settings.secondaryColorDark
    
    if i == 1 then
      toolIcon = display.newImageRect(toolsGrp, "assets/icons/tools/bplacer.png", toolBtn.width, toolBtn.height)
      toolIcon:addEventListener("tap", function() editorSettings.currentTool = "bplacer" ; toolsGrp.alpha = 0 ; guiBuilder.topBarGrp.changeTool() ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 2 then
      toolIcon = display.newImageRect(toolsGrp, "assets/icons/tools/oplacer.png", toolBtn.width, toolBtn.height)
      toolIcon:addEventListener("tap", function() editorSettings.currentTool = "oplacer" ; toolsGrp.alpha = 0 ; guiBuilder.topBarGrp.changeTool() ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 3 then
      toolIcon = display.newImageRect(toolsGrp, "assets/icons/tools/rotator.png", toolBtn.width, toolBtn.height)
      toolIcon:addEventListener("tap", function() editorSettings.currentTool = "rotator" ; toolsGrp.alpha = 0 ; guiBuilder.topBarGrp.changeTool() ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 4 then
      toolIcon = display.newImageRect(toolsGrp, "assets/icons/tools/eraser.png", toolBtn.width, toolBtn.height)
      toolIcon:addEventListener("tap", function() editorSettings.currentTool = "eraser" ; toolsGrp.alpha = 0 ; guiBuilder.topBarGrp.changeTool() ; guiBuilder.topBarGrp.changeSecondary() end)
    end
    
    toolIcon.x = toolBtn.x
    toolIcon.y = toolBtn.y
    
  end
  
  toolsGrp.x = (screenWidth - toolsGrp.width - 115)/2
  toolsGrp.alpha = 0
  
  -- SECONDARY PANELS
  
  local secondaryGrpBlocks = display.newGroup()
  
  for i = 1,8 do
    local blockBtn, blockIcon = display.newRoundedRect(secondaryGrpBlocks, 115  + ((screenHeight/6 - 250)/1.25 + 4)*(i-1), topBar.height + (screenHeight/6 - 250)/1.25, screenHeight/6 - 290, screenHeight/6 - 290, 25)
    blockBtn.fill = settings.secondaryColorDark
    
    if i == 1 then
      blockIcon = display.newImageRect(secondaryGrpBlocks, "assets/icons/blocks/block.png", blockBtn.width, blockBtn.height)
      blockIcon:addEventListener("tap", function() editorSettings.currentBlock = "block" ; secondaryGrpBlocks.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 2 then
      blockIcon = display.newImageRect(secondaryGrpBlocks, "assets/icons/blocks/smallblock.png", blockBtn.width, blockBtn.height)
      blockIcon:addEventListener("tap", function() editorSettings.currentBlock = "smallblock" ; secondaryGrpBlocks.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 3 then
      blockIcon = display.newImageRect(secondaryGrpBlocks, "assets/icons/blocks/wedge.png", blockBtn.width, blockBtn.height)
      blockIcon:addEventListener("tap", function() editorSettings.currentBlock = "wedge" ; secondaryGrpBlocks.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 4 then
      blockIcon = display.newImageRect(secondaryGrpBlocks, "assets/icons/blocks/smallwedge.png", blockBtn.width, blockBtn.height)
      blockIcon:addEventListener("tap", function() editorSettings.currentBlock = "smallwedge" ; secondaryGrpBlocks.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 5 then
      blockIcon = display.newImageRect(secondaryGrpBlocks, "assets/icons/blocks/incurve.png", blockBtn.width, blockBtn.height)
      blockIcon:addEventListener("tap", function() editorSettings.currentBlock = "incurve" ; secondaryGrpBlocks.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 6 then
      blockIcon = display.newImageRect(secondaryGrpBlocks, "assets/icons/blocks/smallincurve.png", blockBtn.width, blockBtn.height)
      blockIcon:addEventListener("tap", function() editorSettings.currentBlock = "smallincurve" ; secondaryGrpBlocks.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 7 then
      blockIcon = display.newImageRect(secondaryGrpBlocks, "assets/icons/blocks/outcurve.png", blockBtn.width, blockBtn.height)
      blockIcon:addEventListener("tap", function() editorSettings.currentBlock = "outcurve" ; secondaryGrpBlocks.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 8 then
      blockIcon = display.newImageRect(secondaryGrpBlocks, "assets/icons/blocks/smalloutcurve.png", blockBtn.width, blockBtn.height)
      blockIcon:addEventListener("tap", function() editorSettings.currentBlock = "smalloutcurve" ; secondaryGrpBlocks.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    end
    
    blockIcon.x = blockBtn.x
    blockIcon.y = blockBtn.y
    
  end
  
  secondaryGrpBlocks.x = (screenWidth - secondaryGrpBlocks.width - 115)/2
  secondaryGrpBlocks.alpha = 0
  
  local secondaryGrpObstacles = display.newGroup()
  
  for i = 1,3 do
    local obstacleBtn, obstacleIcon = display.newRoundedRect(secondaryGrpObstacles, 115  + ((screenHeight/6 - 250)/1.25 + 4)*(i-1), topBar.height + (screenHeight/6 - 250)/1.25, screenHeight/6 - 290, screenHeight/6 - 290, 25)
    obstacleBtn.fill = settings.secondaryColorDark
    
    if i == 1 then
      obstacleIcon = display.newImageRect(secondaryGrpObstacles, "assets/icons/obstacles/bumper.png", obstacleBtn.width, obstacleBtn.height)
      obstacleIcon:addEventListener("tap", function() editorSettings.currentObstacle = "bumper" ; secondaryGrpObstacles.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 2 then
      obstacleIcon = display.newImageRect(secondaryGrpObstacles, "assets/icons/obstacles/hole.png", obstacleBtn.width, obstacleBtn.height)
      obstacleIcon:addEventListener("tap", function() editorSettings.currentObstacle = "hole" ; secondaryGrpObstacles.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    elseif i == 3 then
      obstacleIcon = display.newImageRect(secondaryGrpObstacles, "assets/icons/obstacles/speedup.png", obstacleBtn.width, obstacleBtn.height)
      obstacleIcon:addEventListener("tap", function() editorSettings.currentObstacle = "speedup" ; secondaryGrpObstacles.alpha = 0 ; guiBuilder.topBarGrp.changeSecondary() end)
    end
    
    obstacleIcon.x = obstacleBtn.x
    obstacleIcon.y = obstacleBtn.y
    
  end
  
  secondaryGrpObstacles.x = (screenWidth - secondaryGrpObstacles.width - 115)/2
  secondaryGrpObstacles.alpha = 0
  
  -- THEME PANEL
  
  -- TODO
  
  -- HELPER EVENTS
  
  local function openTools()
    secondaryGrpBlocks.alpha = 0
    secondaryGrpObstacles.alpha = 0
    toolsGrp.alpha = 1
    return true
  end
  
  toolsBtn:addEventListener("tap", openTools)
  
  local function openSecondary()
    toolsGrp.alpha = 0
    if editorSettings.currentTool == "oplacer" then
      secondaryGrpBlocks.alpha = 0
      secondaryGrpObstacles.alpha = 1
    elseif editorSettings.currentTool == "bplacer" then
      secondaryGrpObstacles.alpha = 0
      secondaryGrpBlocks.alpha = 1
    end
    return true
  end
  
  secondaryBtn:addEventListener("tap", openSecondary)
  
  local function placeStart()
    if editingController.startPlaced then
      return
    end
    editorSettings.currentTool = "bplacer" ; toolsGrp.alpha = 0 ; guiBuilder.topBarGrp.changeTool() ; guiBuilder.topBarGrp.changeSecondary()
    guiBuilder.topInfoText.text = "Place Start"
    editingController.placingFinish = false
    editingController.placingStart = true
    secondaryGrpBlocks.alpha = 0
    secondaryGrpObstacles.alpha = 0
    toolsGrp.alpha = 0
    return true
  end
  
  startBtn:addEventListener("tap", placeStart)
  
  local function placeFinish()
    if editingController.finishPlaced then
      return
    end
    editorSettings.currentTool = "bplacer" ; toolsGrp.alpha = 0 ; guiBuilder.topBarGrp.changeTool() ; guiBuilder.topBarGrp.changeSecondary()
    guiBuilder.topInfoText.text = "Place Finish"
    editingController.placingStart = false
    editingController.placingFinish = true
    secondaryGrpBlocks.alpha = 0
    secondaryGrpObstacles.alpha = 0
    toolsGrp.alpha = 0
    return true
  end
  
  finishBtn:addEventListener("tap", placeFinish)
  
  local function testLevel()
    if editingController.finishPlaced and editingController.startPlaced and editingController.levelValid then
      local levelBuilder = require("levelBuilder")
      levelBuilder.showWater()
      
      guiBuilder.returnlvlBtn = display.newRoundedRect(135, topBar.height/3, screenHeight/6 - 250, screenHeight/6 - 250, 25)
      guiBuilder.returnlvlBtn.fill = settings.secondaryColorDark
      guiBuilder.returnlvlBtn.anchorY = 0
      guiBuilder.returnlvlBtn:addEventListener("tap", ballController.removeBallButLose)
      
      guiBuilder.returnlvlIcon = display.newImageRect("assets/icons/return.png", guiBuilder.returnlvlBtn.width, guiBuilder.returnlvlBtn.height)
      guiBuilder.returnlvlIcon.x = guiBuilder.returnlvlBtn.x
      guiBuilder.returnlvlIcon.y = guiBuilder.returnlvlBtn.y + guiBuilder.returnlvlBtn.height/2
      
      guiBuilder.topBarGrp.alpha = 0
      guiBuilder.bottomBarGrp.alpha = 0
      secondaryGrpBlocks.alpha = 0
      secondaryGrpObstacles.alpha = 0
      toolsGrp.alpha = 0
      
      local finishx, finishy
      for i = 1,#levelRenderer.renderedObjects do
        if levelRenderer.renderedObjects[i].objectType == "finish" then
          finishx, finishy = levelRenderer.renderedObjects[i].x ,levelRenderer.renderedObjects[i].y
        end
      end
      
      for i = 1,#levelRenderer.renderedObjects do
        if levelRenderer.renderedObjects[i].objectType == "start" then
          ballController.createBall(25, levelRenderer.renderedObjects[i].x, levelRenderer.renderedObjects[i].y, finishx, finishy)
          return
        end
      end
    end
    return true
  end
  
  testBtn:addEventListener("tap", testLevel)
  
  local function uploadLevel()
    local userdata = require("userdata")
    if editingController.levelValid and editingController.levelTested then
      guiBuilder.createUploadGui(editingController.lastStrokes, userdata.username, #levelRenderer.renderedObjects)
    else
      return true
    end
  end
  
  uploadBtn:addEventListener("tap", uploadLevel)
  
  function guiBuilder.returnToMenu()
    guiBuilder.topBarGrp:removeSelf()
    guiBuilder.bottomBarGrp:removeSelf()
    secondaryGrpBlocks:removeSelf()
    secondaryGrpObstacles:removeSelf()
    toolsGrp:removeSelf()
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
    
    levelRenderer.renderedObjects = {}
    
    local menuGuiBuilder = require("menuGuiBuilder")
    menuGuiBuilder.inEditor = false
    
    timer.performWithDelay(10, function()
      composer.removeScene("editor")
      composer.gotoScene("menu")
    end)
  end
  
  returnBtn:addEventListener("tap", guiBuilder.returnToMenu)
  
end

return guiBuilder