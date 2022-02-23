import "qa"

Animation = {}
Animation.frames = []
Animation.initialised = false

Animation.resetNextFrameTimer = function()
    self.nextFrameTimer = 1/self.fps
end function

Animation.addToTimer = function()
    self.nextFrameTimer = self.nextFrameTimer + 1/self.fps
end function

Animation.init = function(frames,fps = 1, currentFrame = 0)
    self.frames = frames
    self.fps = fps
    self.currentFrame = currentFrame
    self.resetNextFrameTimer
end function

Animation.update = function(delta)
    self.nextFrameTimer = self.nextFrameTimer - delta
    if self.nextFrameTimer <= 0 then
        self.currentFrame = (self.currentFrame + 1) % self.frames.len
        self.addToTimer
    end if
end function

Animation.getFrame = function ()
    return self.frames[self.currentFrame]
end function

SpriteSheetAnimationSystem = {}
SpriteSheetAnimationSystem.initialised = false

SpriteSheetAnimationSystem.init = function(path, cols, rows)
    self.spriteSheet = file.loadImage(path)
    self.cols = cols
    self.rows = rows
    self.frameWidth = self.spriteSheet.width / self.cols
    qa.assert self.frameWidth % 1 == 0, "Width of frames is not a whole number, check your cols parameter!"
    self.frameHeight = self.spriteSheet.height / self.rows
    qa.assert self.frameHeight % 1 == 0, "Height of frames is not a whole number, check your rows parameter!"
    self.animations = {}
    self.initialised = true
end function

SpriteSheetAnimationSystem.imageAt = function(col, row)
    return self.spriteSheet.getImage(col,self.spriteSheet.height-self.frameHeight*(1+row))
end function

runUnitTests = function ()
    //test SpriteSheetAnimationSystem.init with tileset found in "/sys/pics"
    testSystem = new SpriteSheetAnimationSystem
    qa.assertEqual testSystem.initialised, false
    testSystem.init "/sys/pics/SimplePlatformTiles.png", 12, 8
    qa.assertEqual testSystem.initialised, true
end function

if globals == locals then runUnitTests