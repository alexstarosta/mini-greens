local settings = require("settings")
local composer = require("composer")
local widget = require("widget")
local json = require("json")
local userdata = require("userdata")
local firebaseHandler = require("firebaseHandler")

local menuGuiBuilder = {}

menuGuiBuilder.elementsGrp = display.newGroup()
menuGuiBuilder.playMenu = display.newGroup()
menuGuiBuilder.loadingGrp = display.newGroup()
menuGuiBuilder.staticGrp = display.newGroup()

local scrollView, inputField

function menuGuiBuilder.showUser()
  local function createTextBox(x, y, width, height)
    local userInput = ""
    
    inputField = native.newTextField(x, y, width, height)
    inputField.inputType = "no-emoji"
    inputField.hasBackground = false
    inputField.font = native.newFont(settings.mainFont, 46)
    
    local function onUserInput(event)
      if event.phase == "editing" then
        
        userInput = event.text
        userdata.username = userInput
        
        if #userInput > 12 then
          userInput = userInput:sub(1, 12)
          inputField.text = userInput
          userdata.username = userInput
          native.setKeyboardFocus(nil)
        end
        
      end
    end
    
    inputField:addEventListener("userInput", onUserInput)
    inputField:resizeFontToFitHeight()
  
    return inputField
  end
  
  menuGuiBuilder.usernameTextbox = createTextBox(300, 250, screenWidth*0.4, 70)
  
  timer.performWithDelay(10, function()
    inputField.text = userdata.username
  end)
  
  local usernameText = display.newRoundedRect(menuGuiBuilder.usernameTextbox.x, menuGuiBuilder.usernameTextbox.y, screenWidth*0.4 + 20, menuGuiBuilder.usernameTextbox.height + 10, 20)
  usernameText.fill = settings.secondaryColorDark
  
  local usernameTextboxBack = display.newRoundedRect(menuGuiBuilder.usernameTextbox.x, menuGuiBuilder.usernameTextbox.y, screenWidth*0.4 + 20, menuGuiBuilder.usernameTextbox.height + 10, 20)
  usernameTextboxBack.fill = settings.secondaryColorDark
  
  local accountText = display.newText("Signed in as:", 190, menuGuiBuilder.usernameTextbox.y - 80, settings.mainFont, 40)
end

function menuGuiBuilder.createPlayGui()
  
  local firebaseHandler = require("firebaseHandler")
  firebaseHandler.getData()
  
  menuGuiBuilder.playMenu:toFront()
  local cover = display.newRect(menuGuiBuilder.playMenu, centerX, centerY, screenWidth, screenHeight)
  cover.fill = {0,0.75}
  cover:addEventListener("touch", function() return true end)
  
  local panel = display.newRoundedRect(menuGuiBuilder.playMenu, centerX, centerY, screenWidth*0.9, screenHeight*0.8, 50)
  panel.fill = settings.mainColorDark
  
  local returnBtn = display.newRoundedRect(menuGuiBuilder.playMenu, 135 + 50, screenHeight*0.1 + 50, screenHeight/6 - 250, screenHeight/6 - 250, 25)
  returnBtn.fill = settings.secondaryColorDark
  returnBtn.anchorY = 0
  
  local returnIcon = display.newImageRect(menuGuiBuilder.playMenu, "assets/icons/return.png", returnBtn.width, returnBtn.height)
  returnIcon.x = returnBtn.x
  returnIcon.y = returnBtn.y + returnBtn.height/2
  
  local titleText = display.newText(menuGuiBuilder.playMenu, "Level Catalogue", centerX + 50, returnBtn.y + 20, settings.mainFont, 80)
  titleText.anchorY = 0
  
  local function removePlayGui()
    menuGuiBuilder.playMenu:removeSelf()
    menuGuiBuilder.playMenu = display.newGroup()
    menuGuiBuilder.loadingGrp:removeSelf()
    menuGuiBuilder.loadingGrp = display.newGroup()
    scrollView:removeSelf()
    menuGuiBuilder.inEditor = false
    menuGuiBuilder.usernameTextbox.x = 300
  end
  
  returnBtn:addEventListener("tap", removePlayGui)
  
  local function createCatalogue(info)
    scrollView = widget.newScrollView(
      {
          x = centerX,
          y = centerY + 80,
          width = screenWidth * 0.8,
          height = screenWidth * 1.35,
          horizontalScrollDisabled = true,
          hideBackground = true,
          hideScrollBar = true
      }
    )
    
    local count = 1
    
    for i,v in pairs(info) do
      local grp = display.newGroup()
      grp.anchorChildren = true
      grp.x = centerX - 113
      grp.y = grp.y + 87
      grp:toFront()
      
      local info = json.decode(v)
    
      local levelBar = display.newRoundedRect(grp, centerX, centerY, screenWidth*0.8, 175, 30)
      levelBar.fill = settings.secondaryColorDark
      
      local levelIcon = display.newRoundedRect(grp, screenWidth*0.2 - 25, centerY, 150, 150, 25)
      levelIcon.fill = settings.mainColorDark
      
      local levelIconImg = display.newImageRect(grp, "assets/icons/flag.png", 150, 150)
      levelIconImg.x, levelIconImg.y = levelIcon.x, levelIcon.y
      
      local levelTitle = display.newText(grp, info.title, levelIcon.x + 90, centerY - 30, settings.mainFont, 50)
      levelTitle.anchorX = 0
      
      local parText = display.newText(grp, "Par: "..info.par, levelIcon.x + 90, centerY + 20, settings.mainFont, 40)
      parText.anchorX = 0
      parText.alpha = 0.8
      
      local playBtn = display.newRoundedRect(grp, screenWidth - (screenWidth*0.2 - 25), centerY, 150, 150, 999)
      
      local playIcon = display.newImageRect(grp, "assets/play.png", 60, 60)
      playIcon.x, playIcon.y = playBtn.x + 5, playBtn.y
      playBtn.fill = settings.mainColorDark
       
      local authorText = display.newText(grp, "By: "..info.builder, playIcon.x - 100, centerY + 20, settings.mainFont, 40)
      authorText.anchorX = 1
      authorText.alpha = 0.8
      
      grp:translate(0,(count-1)*190)
      
      local function playLevel()
        local options = {
          params = info.objects
        }
        composer.gotoScene("player", options)
      end
      
      playBtn:addEventListener("tap", playLevel)
      
      count = count + 1
      
      scrollView:insert(grp)
    end
  end
  
  local loadingCover = display.newRect(menuGuiBuilder.loadingGrp, centerX, centerY, screenWidth, screenHeight)
  loadingCover.fill = {0,0.5}
  
  local sheetOptions = {
    width = 800,
    height = 800,
    numFrames = 59
  }

  local loadingSheet = graphics.newImageSheet( "assets/loading.png", sheetOptions )

  local loadingSequence = {
    {
      name = "loading",
      start = 2,
      count = 58,
      time = 1000,
      loopCount = 0,
      loopDirection = "forward"
    }
  }
  
  local loadingSprite = display.newSprite(menuGuiBuilder.loadingGrp, loadingSheet, loadingSequence)
  loadingSprite.x = centerX
  loadingSprite.y = centerY
  loadingSprite:setSequence("loading")
  loadingSprite:play()
  
  menuGuiBuilder.loadingGrp:toFront()
  menuGuiBuilder.loadingGrp.alpha = 1
  
  timer.performWithDelay(5000, function()
    createCatalogue(json.decode(firebaseHandler.lastItems))
    menuGuiBuilder.loadingGrp.alpha = 0
  end)
  
end

function menuGuiBuilder.createTitleGui()
  
  local bg = display.newRect(menuGuiBuilder.staticGrp, centerX, centerY, screenHeight, screenHeight)
  bg.alpha = 1
  bg.fill.effect = "generator.checkerboard"
  bg.fill.effect.color1 = settings.mainColor
  bg.fill.effect.color2 = {settings.mainColor[1] - 0.1, settings.mainColor[2] - 0.1, settings.mainColor[3] - 0.1}
  bg.fill.effect.xStep = 50
  bg.fill.effect.yStep = 50
  
  local cover = display.newRect(menuGuiBuilder.staticGrp, centerX, centerY, screenHeight, screenHeight)
  cover.fill = {1,0.2}
  
  local logodark = display.newImageRect(menuGuiBuilder.elementsGrp, "assets/logodark.png", 2701, 1433)
  menuGuiBuilder.elementsGrp:toFront()
  logodark.alpha = 0.5
  logodark.x = centerX + 15
  logodark.y = centerY - screenHeight/5 + 15
  logodark:scale(0.3,0.3)
  transition.to(logodark, {time = 3500, iterations = -1, xScale = 0.325, yScale = 0.325, transition = easing.continuousLoop})
  
  local logo = display.newImageRect(menuGuiBuilder.elementsGrp, "assets/logo.png", 2701, 1433)
  menuGuiBuilder.elementsGrp:toFront()
  logo.x = centerX
  logo.y = centerY - screenHeight/5
  logo:scale(0.3,0.3)
  transition.to(logo, {time = 3500, iterations = -1, xScale = 0.325, yScale = 0.325, transition = easing.continuousLoop})
  
  local createBtn = display.newRoundedRect(menuGuiBuilder.elementsGrp, centerX, centerY + 200, screenWidth * 0.6, 150, 25)
  
  local createText = display.newText(menuGuiBuilder.elementsGrp, "Create Levels", createBtn.x, createBtn.y - 10, settings.mainFont, 90)
  createText.fill = settings.mainColorDark
  
  local playBtn = display.newRoundedRect(menuGuiBuilder.elementsGrp, centerX, createBtn.y + 200, screenWidth * 0.6, 150, 25)
  
  local playText = display.newText(menuGuiBuilder.elementsGrp, "Play Levels", playBtn.x, playBtn.y - 10, settings.mainFont, 90)
  playText.fill = settings.mainColorDark
  
  local creditTextShadow = display.newText(menuGuiBuilder.elementsGrp, "Alex Starosta 2023", centerX + 4, screenHeight - 100 + 4, settings.mainFont, 40)
  creditTextShadow.fill = settings.mainColorDark
  
  local creditText = display.newText(menuGuiBuilder.elementsGrp, "Alex Starosta 2023", centerX, screenHeight - 100, settings.mainFont, 40)
  
  -- FUNCTIONS
  
  local function createLevel()
    if menuGuiBuilder.inEditor then
      return
    end
    composer.gotoScene("editor")
    menuGuiBuilder.inEditor = true
    menuGuiBuilder.usernameTextbox.x = -300
  end
  
  createBtn:addEventListener("tap", createLevel)
  
  local function playLevels()
    if menuGuiBuilder.inEditor then
      return
    end
    menuGuiBuilder.createPlayGui()
    menuGuiBuilder.inEditor = true
    menuGuiBuilder.usernameTextbox.x = -300
  end
  
  playBtn:addEventListener("tap", playLevels)
  
end

return menuGuiBuilder