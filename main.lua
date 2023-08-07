--[[
  //                         //
  //  Alex Starosta 2023     //
  //  miniGreens             //
  //  June 2023              //
  //                         //
--]]


local composer = require( "composer" )
local userdata = require("userdata")

math.randomseed = (os.time())

-- helpful screen constants

display.setStatusBar( display.HiddenStatusBar )
centerX = display.contentCenterX
centerY = display.contentCenterY
screenLeft = display.screenOriginX
screenWidth = display.contentWidth - screenLeft * 2
screenRight = screenLeft + screenWidth
screenTop = display.screenOriginY
screenHeight = display.contentHeight - screenTop * 2
screenBottom = screenTop + screenHeight
display.contentWidth = screenWidth
display.contentHeight = screenHeight

userdata.checkSystemEvents()
composer.gotoScene("menu")