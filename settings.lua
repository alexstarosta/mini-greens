local settings = {}

-- BALL SETTINGS

settings.maxHit = 500
settings.minHit = 10

-- TILE SETTINGS

settings.gridWidth = screenWidth*0.9
settings.gridHeight = screenWidth*0.9
settings.gridAmount = 10
settings.tileWidth = settings.gridWidth/settings.gridAmount
settings.holeWidth = 35

-- TILE TYPES

settings.block = { 0, 0, 0, settings.tileWidth, settings.tileWidth, settings.tileWidth, settings.tileWidth, 0,}
settings.smallblock = { 0, 0, 0, settings.tileWidth/2, settings.tileWidth/2, settings.tileWidth/2, settings.tileWidth/2, 0,}

settings.wedge = { 0, 0, 0, settings.tileWidth, settings.tileWidth, 0,}
settings.smallwedge = { 0, 0, 0, settings.tileWidth/2, settings.tileWidth/2, 0,}

settings.wedge90 = { 0, 0, 0, settings.tileWidth, settings.tileWidth, settings.tileWidth,}
settings.smallwedge90 = { 0, 0, 0, settings.tileWidth/2, settings.tileWidth/2, settings.tileWidth/2,}

settings.wedge180 = { 0, settings.tileWidth, settings.tileWidth, settings.tileWidth, settings.tileWidth, 0}
settings.smallwedge180 = { 0, settings.tileWidth/2, settings.tileWidth/2, settings.tileWidth/2, settings.tileWidth/2, 0}

settings.wedge270 = { 0, 0, settings.tileWidth, settings.tileWidth, settings.tileWidth, 0,}
settings.smallwedge270 = { 0, 0, settings.tileWidth/2, settings.tileWidth/2, settings.tileWidth/2, 0,}

settings.outcurve = { 0,0, settings.tileWidth, 0, 
  settings.tileWidth*0.995, settings.tileWidth*0.1,
  settings.tileWidth*0.9798, settings.tileWidth*0.2,
  settings.tileWidth*0.9539, settings.tileWidth*0.3,
  settings.tileWidth*0.9165, settings.tileWidth*0.4,
  settings.tileWidth*0.866, settings.tileWidth*0.5,
  settings.tileWidth*0.8, settings.tileWidth*0.6,
  settings.tileWidth*0.7141, settings.tileWidth*0.7,
  settings.tileWidth*0.6, settings.tileWidth*0.8,
  settings.tileWidth*0.5, settings.tileWidth*0.866,
  settings.tileWidth*0.4, settings.tileWidth*0.9165,
  settings.tileWidth*0.3, settings.tileWidth*0.9539,
  settings.tileWidth*0.2, settings.tileWidth*0.9798,
  settings.tileWidth*0.1, settings.tileWidth*0.995,
  0, settings.tileWidth,
}
settings.smalloutcurve = { 0,0, settings.tileWidth/2, 0, 
  settings.tileWidth/2*0.995, settings.tileWidth/2*0.1,
  settings.tileWidth/2*0.9798, settings.tileWidth/2*0.2,
  settings.tileWidth/2*0.9539, settings.tileWidth/2*0.3,
  settings.tileWidth/2*0.9165, settings.tileWidth/2*0.4,
  settings.tileWidth/2*0.866, settings.tileWidth/2*0.5,
  settings.tileWidth/2*0.8, settings.tileWidth/2*0.6,
  settings.tileWidth/2*0.7141, settings.tileWidth/2*0.7,
  settings.tileWidth/2*0.6, settings.tileWidth/2*0.8,
  settings.tileWidth/2*0.5, settings.tileWidth/2*0.866,
  settings.tileWidth/2*0.4, settings.tileWidth/2*0.9165,
  settings.tileWidth/2*0.3, settings.tileWidth/2*0.9539,
  settings.tileWidth/2*0.2, settings.tileWidth/2*0.9798,
  settings.tileWidth/2*0.1, settings.tileWidth/2*0.995,
  0, settings.tileWidth/2,
}

settings.outcurve90 = { 0,0, settings.tileWidth, 0, 
  settings.tileWidth, settings.tileWidth,
  settings.tileWidth*0.9, settings.tileWidth*0.995,
  settings.tileWidth*0.8, settings.tileWidth*0.9798,
  settings.tileWidth*0.7, settings.tileWidth*0.9539,
  settings.tileWidth*0.6, settings.tileWidth*0.9165,
  settings.tileWidth*0.5, settings.tileWidth*0.866,
  settings.tileWidth*0.4, settings.tileWidth*0.8,
  settings.tileWidth*0.3, settings.tileWidth*0.7141,
  settings.tileWidth*(1 - 0.8), settings.tileWidth*(1 - 0.4),
  settings.tileWidth*(1 -0.866), settings.tileWidth*(1 - 0.5),
  settings.tileWidth*(1 -0.9165), settings.tileWidth*(1 - 0.6),
  settings.tileWidth*(1 -0.9539), settings.tileWidth*(1 - 0.7),
  settings.tileWidth*(1 -0.9798), settings.tileWidth*(1 - 0.8),
  settings.tileWidth*(1 -0.995), settings.tileWidth*(1 - 0.9),
  0, settings.tileWidth,
}

settings.smalloutcurve90 = { 0,0, settings.tileWidth/2, 0, 
  settings.tileWidth/2, settings.tileWidth/2,
  settings.tileWidth/2*0.9, settings.tileWidth/2*0.995,
  settings.tileWidth/2*0.8, settings.tileWidth/2*0.9798,
  settings.tileWidth/2*0.7, settings.tileWidth/2*0.9539,
  settings.tileWidth/2*0.6, settings.tileWidth/2*0.9165,
  settings.tileWidth/2*0.5, settings.tileWidth/2*0.866,
  settings.tileWidth/2*0.4, settings.tileWidth/2*0.8,
  settings.tileWidth/2*0.3, settings.tileWidth/2*0.7141,
  settings.tileWidth/2*(1 - 0.8), settings.tileWidth/2*(1 - 0.4),
  settings.tileWidth/2*(1 -0.866), settings.tileWidth/2*(1 - 0.5),
  settings.tileWidth/2*(1 -0.9165), settings.tileWidth/2*(1 - 0.6),
  settings.tileWidth/2*(1 -0.9539), settings.tileWidth/2*(1 - 0.7),
  settings.tileWidth/2*(1 -0.9798), settings.tileWidth/2*(1 - 0.8),
  settings.tileWidth/2*(1 -0.995), settings.tileWidth/2*(1 - 0.9),
  0, settings.tileWidth/2,
}

settings.outcurve180 = { settings.tileWidth, 0, 
  settings.tileWidth, settings.tileWidth,
  0, settings.tileWidth,
  settings.tileWidth*(1 -0.995), settings.tileWidth*0.9,
  settings.tileWidth*(1 -0.9798), settings.tileWidth*0.8,
  settings.tileWidth*(1 -0.9539), settings.tileWidth*0.7,
  settings.tileWidth*(1 -0.9165), settings.tileWidth*0.6,
  settings.tileWidth*(1 -0.866), settings.tileWidth*0.5,
  settings.tileWidth*(1 - 0.8), settings.tileWidth*0.4,
  settings.tileWidth*0.3, settings.tileWidth*(1 - 0.7141),
  settings.tileWidth*0.4, settings.tileWidth*(1 - 0.8),
  settings.tileWidth*0.5, settings.tileWidth*(1 - 0.866),
  settings.tileWidth*0.6, settings.tileWidth*(1 - 0.9165),
  settings.tileWidth*0.7, settings.tileWidth*(1 - 0.9539),
  settings.tileWidth*0.8, settings.tileWidth*(1 - 0.9798),
  settings.tileWidth*0.9, settings.tileWidth*(1 - 0.995),
}

settings.smalloutcurve180 = { settings.tileWidth/2, 0, 
  settings.tileWidth/2, settings.tileWidth/2,
  0, settings.tileWidth/2,
  settings.tileWidth/2*(1 - 0.995), settings.tileWidth/2*0.9,
  settings.tileWidth/2*(1 - 0.9798), settings.tileWidth/2*0.8,
  settings.tileWidth/2*(1 - 0.9539), settings.tileWidth/2*0.7,
  settings.tileWidth/2*(1 - 0.9165), settings.tileWidth/2*0.6,
  settings.tileWidth/2*(1 - 0.866), settings.tileWidth/2*0.5,
  settings.tileWidth/2*(1 - 0.8), settings.tileWidth/2*0.4,
  settings.tileWidth/2*0.3, settings.tileWidth/2*(1 - 0.7141),
  settings.tileWidth/2*0.4, settings.tileWidth/2*(1 - 0.8),
  settings.tileWidth/2*0.5, settings.tileWidth/2*(1 - 0.866),
  settings.tileWidth/2*0.6, settings.tileWidth/2*(1 - 0.9165),
  settings.tileWidth/2*0.7, settings.tileWidth/2*(1 - 0.9539),
  settings.tileWidth/2*0.8, settings.tileWidth/2*(1 - 0.9798),
  settings.tileWidth/2*0.9, settings.tileWidth/2*(1 - 0.995),
}

settings.outcurve270 = { 0, 0, 
  settings.tileWidth*(1 - 0.9), settings.tileWidth*(1 - 0.995),
  settings.tileWidth*(1 - 0.8), settings.tileWidth*(1 - 0.9798),
  settings.tileWidth*(1 - 0.7), settings.tileWidth*(1 - 0.9539),
  settings.tileWidth*(1 - 0.6), settings.tileWidth*(1 - 0.9165),
  settings.tileWidth*(1 - 0.5), settings.tileWidth*(1 - 0.866),
  settings.tileWidth*(1 - 0.4), settings.tileWidth*(1 - 0.8),
  settings.tileWidth*0.7141, settings.tileWidth*0.3,
  settings.tileWidth*0.8, settings.tileWidth*0.4,
  settings.tileWidth*0.866, settings.tileWidth*0.5,
  settings.tileWidth*0.9165, settings.tileWidth*0.6,
  settings.tileWidth*0.9539, settings.tileWidth*0.7,
  settings.tileWidth*0.9798, settings.tileWidth*0.8,
  settings.tileWidth*0.995, settings.tileWidth*0.9,
  settings.tileWidth, settings.tileWidth,
  0, settings.tileWidth,
}

settings.smalloutcurve270 = { 0, 0, 
  settings.tileWidth/2*(1 - 0.9), settings.tileWidth/2*(1 - 0.995),
  settings.tileWidth/2*(1 - 0.8), settings.tileWidth/2*(1 - 0.9798),
  settings.tileWidth/2*(1 - 0.7), settings.tileWidth/2*(1 - 0.9539),
  settings.tileWidth/2*(1 - 0.6), settings.tileWidth/2*(1 - 0.9165),
  settings.tileWidth/2*(1 - 0.5), settings.tileWidth/2*(1 - 0.866),
  settings.tileWidth/2*(1 - 0.4), settings.tileWidth/2*(1 - 0.8),
  settings.tileWidth/2*0.7141, settings.tileWidth/2*0.3,
  settings.tileWidth/2*0.8, settings.tileWidth/2*0.4,
  settings.tileWidth/2*0.866, settings.tileWidth/2*0.5,
  settings.tileWidth/2*0.9165, settings.tileWidth/2*0.6,
  settings.tileWidth/2*0.9539, settings.tileWidth/2*0.7,
  settings.tileWidth/2*0.9798, settings.tileWidth/2*0.8,
  settings.tileWidth/2*0.995, settings.tileWidth/2*0.9,
  settings.tileWidth/2, settings.tileWidth/2,
  0, settings.tileWidth/2,
}

settings.incurve = {  settings.tileWidth, settings.tileWidth, settings.tileWidth, 0, 
  settings.tileWidth*0.995, settings.tileWidth*0.1,
  settings.tileWidth*0.9798, settings.tileWidth*0.2,
  settings.tileWidth*0.9539, settings.tileWidth*0.3,
  settings.tileWidth*0.9165, settings.tileWidth*0.4,
  settings.tileWidth*0.866, settings.tileWidth*0.5,
  settings.tileWidth*0.8, settings.tileWidth*0.6,
  settings.tileWidth*0.7141, settings.tileWidth*0.7,
  settings.tileWidth*0.6, settings.tileWidth*0.8,
  settings.tileWidth*0.5, settings.tileWidth*0.866,
  settings.tileWidth*0.4, settings.tileWidth*0.9165,
  settings.tileWidth*0.3, settings.tileWidth*0.9539,
  settings.tileWidth*0.2, settings.tileWidth*0.9798,
  settings.tileWidth*0.1, settings.tileWidth*0.995,
  0, settings.tileWidth,
}
settings.smallincurve = { settings.tileWidth/2,settings.tileWidth/2, settings.tileWidth/2, 0, 
  settings.tileWidth/2*0.995, settings.tileWidth/2*0.1,
  settings.tileWidth/2*0.9798, settings.tileWidth/2*0.2,
  settings.tileWidth/2*0.9539, settings.tileWidth/2*0.3,
  settings.tileWidth/2*0.9165, settings.tileWidth/2*0.4,
  settings.tileWidth/2*0.866, settings.tileWidth/2*0.5,
  settings.tileWidth/2*0.8, settings.tileWidth/2*0.6,
  settings.tileWidth/2*0.7141, settings.tileWidth/2*0.7,
  settings.tileWidth/2*0.6, settings.tileWidth/2*0.8,
  settings.tileWidth/2*0.5, settings.tileWidth/2*0.866,
  settings.tileWidth/2*0.4, settings.tileWidth/2*0.9165,
  settings.tileWidth/2*0.3, settings.tileWidth/2*0.9539,
  settings.tileWidth/2*0.2, settings.tileWidth/2*0.9798,
  settings.tileWidth/2*0.1, settings.tileWidth/2*0.995,
  0, settings.tileWidth/2,
}

settings.incurve90 = { 0, settings.tileWidth, 
  settings.tileWidth, settings.tileWidth,
  settings.tileWidth*0.9, settings.tileWidth*0.995,
  settings.tileWidth*0.8, settings.tileWidth*0.9798,
  settings.tileWidth*0.7, settings.tileWidth*0.9539,
  settings.tileWidth*0.6, settings.tileWidth*0.9165,
  settings.tileWidth*0.5, settings.tileWidth*0.866,
  settings.tileWidth*0.4, settings.tileWidth*0.8,
  settings.tileWidth*0.3, settings.tileWidth*0.7141,
  settings.tileWidth*(1 - 0.8), settings.tileWidth*(1 - 0.4),
  settings.tileWidth*(1 -0.866), settings.tileWidth*(1 - 0.5),
  settings.tileWidth*(1 -0.9165), settings.tileWidth*(1 - 0.6),
  settings.tileWidth*(1 -0.9539), settings.tileWidth*(1 - 0.7),
  settings.tileWidth*(1 -0.9798), settings.tileWidth*(1 - 0.8),
  settings.tileWidth*(1 -0.995), settings.tileWidth*(1 - 0.9),
  0, 0,
}

settings.smallincurve90 = { 0, settings.tileWidth/2, 
  settings.tileWidth/2, settings.tileWidth/2,
  settings.tileWidth/2*0.9, settings.tileWidth/2*0.995,
  settings.tileWidth/2*0.8, settings.tileWidth/2*0.9798,
  settings.tileWidth/2*0.7, settings.tileWidth/2*0.9539,
  settings.tileWidth/2*0.6, settings.tileWidth/2*0.9165,
  settings.tileWidth/2*0.5, settings.tileWidth/2*0.866,
  settings.tileWidth/2*0.4, settings.tileWidth/2*0.8,
  settings.tileWidth/2*0.3, settings.tileWidth/2*0.7141,
  settings.tileWidth/2*(1 - 0.8), settings.tileWidth/2*(1 - 0.4),
  settings.tileWidth/2*(1 -0.866), settings.tileWidth/2*(1 - 0.5),
  settings.tileWidth/2*(1 -0.9165), settings.tileWidth/2*(1 - 0.6),
  settings.tileWidth/2*(1 -0.9539), settings.tileWidth/2*(1 - 0.7),
  settings.tileWidth/2*(1 -0.9798), settings.tileWidth/2*(1 - 0.8),
  settings.tileWidth/2*(1 -0.995), settings.tileWidth/2*(1 - 0.9),
  0, 0,
}

settings.incurve180 = { 0, 0, 
  0, settings.tileWidth,
  settings.tileWidth*(1 -0.995), settings.tileWidth*0.9,
  settings.tileWidth*(1 -0.9798), settings.tileWidth*0.8,
  settings.tileWidth*(1 -0.9539), settings.tileWidth*0.7,
  settings.tileWidth*(1 -0.9165), settings.tileWidth*0.6,
  settings.tileWidth*(1 -0.866), settings.tileWidth*0.5,
  settings.tileWidth*(1 - 0.8), settings.tileWidth*0.4,
  settings.tileWidth*0.3, settings.tileWidth*(1 - 0.7141),
  settings.tileWidth*0.4, settings.tileWidth*(1 - 0.8),
  settings.tileWidth*0.5, settings.tileWidth*(1 - 0.866),
  settings.tileWidth*0.6, settings.tileWidth*(1 - 0.9165),
  settings.tileWidth*0.7, settings.tileWidth*(1 - 0.9539),
  settings.tileWidth*0.8, settings.tileWidth*(1 - 0.9798),
  settings.tileWidth*0.9, settings.tileWidth*(1 - 0.995),
  settings.tileWidth, 0,
}

settings.smallincurve180 = { 0, 0, 
  0, settings.tileWidth/2,
  settings.tileWidth/2*(1 -0.995), settings.tileWidth/2*0.9,
  settings.tileWidth/2*(1 -0.9798), settings.tileWidth/2*0.8,
  settings.tileWidth/2*(1 -0.9539), settings.tileWidth/2*0.7,
  settings.tileWidth/2*(1 -0.9165), settings.tileWidth/2*0.6,
  settings.tileWidth/2*(1 -0.866), settings.tileWidth/2*0.5,
  settings.tileWidth/2*(1 - 0.8), settings.tileWidth/2*0.4,
  settings.tileWidth/2*0.3, settings.tileWidth/2*(1 - 0.7141),
  settings.tileWidth/2*0.4, settings.tileWidth/2*(1 - 0.8),
  settings.tileWidth/2*0.5, settings.tileWidth/2*(1 - 0.866),
  settings.tileWidth/2*0.6, settings.tileWidth/2*(1 - 0.9165),
  settings.tileWidth/2*0.7, settings.tileWidth/2*(1 - 0.9539),
  settings.tileWidth/2*0.8, settings.tileWidth/2*(1 - 0.9798),
  settings.tileWidth/2*0.9, settings.tileWidth/2*(1 - 0.995),
  settings.tileWidth/2, 0,
}

settings.incurve270 = { 0, 0, 
  settings.tileWidth*(1 - 0.9), settings.tileWidth*(1 - 0.995),
  settings.tileWidth*(1 - 0.8), settings.tileWidth*(1 - 0.9798),
  settings.tileWidth*(1 - 0.7), settings.tileWidth*(1 - 0.9539),
  settings.tileWidth*(1 - 0.6), settings.tileWidth*(1 - 0.9165),
  settings.tileWidth*(1 - 0.5), settings.tileWidth*(1 - 0.866),
  settings.tileWidth*(1 - 0.4), settings.tileWidth*(1 - 0.8),
  settings.tileWidth*0.7141, settings.tileWidth*0.3,
  settings.tileWidth*0.8, settings.tileWidth*0.4,
  settings.tileWidth*0.866, settings.tileWidth*0.5,
  settings.tileWidth*0.9165, settings.tileWidth*0.6,
  settings.tileWidth*0.9539, settings.tileWidth*0.7,
  settings.tileWidth*0.9798, settings.tileWidth*0.8,
  settings.tileWidth*0.995, settings.tileWidth*0.9,
  settings.tileWidth, settings.tileWidth,
  settings.tileWidth, 0,
}

settings.smallincurve270 = { 0, 0, 
  settings.tileWidth/2*(1 - 0.9), settings.tileWidth/2*(1 - 0.995),
  settings.tileWidth/2*(1 - 0.8), settings.tileWidth/2*(1 - 0.9798),
  settings.tileWidth/2*(1 - 0.7), settings.tileWidth/2*(1 - 0.9539),
  settings.tileWidth/2*(1 - 0.6), settings.tileWidth/2*(1 - 0.9165),
  settings.tileWidth/2*(1 - 0.5), settings.tileWidth/2*(1 - 0.866),
  settings.tileWidth/2*(1 - 0.4), settings.tileWidth/2*(1 - 0.8),
  settings.tileWidth/2*0.7141, settings.tileWidth/2*0.3,
  settings.tileWidth/2*0.8, settings.tileWidth/2*0.4,
  settings.tileWidth/2*0.866, settings.tileWidth/2*0.5,
  settings.tileWidth/2*0.9165, settings.tileWidth/2*0.6,
  settings.tileWidth/2*0.9539, settings.tileWidth/2*0.7,
  settings.tileWidth/2*0.9798, settings.tileWidth/2*0.8,
  settings.tileWidth/2*0.995, settings.tileWidth/2*0.9,
  settings.tileWidth/2, settings.tileWidth/2,
  settings.tileWidth/2, 0,
}

-- COLOR SETTINGS

settings.mainColor = {0/255,200/255,0/255}
settings.secondaryColor = {0/255,155/255,0/255}

settings.mainColorDark = {0/255,125/255,0/255}
settings.secondaryColorDark = {0/255,105/255,0/255}

settings.waterColor = {144/255,224/255,239/255}
settings.darkWaterColor = {72/255,202/255,228/255}

settings.offBlack = {27/255, 26/255, 24/255}

-- FONT SETTINGS

settings.mainFont = "assets/chevin.otf"

return settings