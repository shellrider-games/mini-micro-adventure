import "shellriderMath"
import "spriteSheetAnimationSystem"

DIRECTIONS = {}
DIRECTIONS.DOWN = 0
DIRECTIONS.LEFT = 1
DIRECTIONS.UP = 2
DIRECTIONS.RIGHT = 3

DIRECTIONS.textList = ["down", "left", "up", "right"]

PlayerCharacter = {}
PlayerCharacter.facing = DIRECTIONS.DOWN
PlayerCharacter.position = {"x": 0, "y" :0}
PlayerCharacter.speed = 150

PlayerCharacter.image = file.loadImage("assets/img/dwarf.png")
PlayerCharacter.spriteDimensions = {"w":20, "h": 28}


PlayerCharacter.init = function()
    self.animationSystem = new spriteSheetAnimationSystem.SpriteSheetAnimationSystem
    self.animationSystem.init "assets/img/dwarf.png",8,2
    self.animationSystem.addAnimation "idle_down", [[0,0]]
    self.animationSystem.addAnimation "idle_left", [[1,0]]
    self.animationSystem.addAnimation "idle_up", [[2,0]]
    self.animationSystem.addAnimation "idle_right",[[3,0]]
    self.animationSystem.addAnimation "walk_down", [[4,0],[4,1]], 4
    self.animationSystem.addAnimation "walk_left", [[5,0],[5,1]], 4
    self.animationSystem.addAnimation "walk_up", [[6,0],[6,1]], 4
    self.animationSystem.addAnimation "walk_right", [[7,0],[7,1]], 4
    self.animationSystem.switchAnimation "idle_down"
end function


PlayerCharacter.update = function(delta)
    inputVector = {"x": key.pressed("right") - key.pressed("left"), "y" : key.pressed("up") - key.pressed("down")}
    inputVector = shellriderMath.normaliseVector2(inputVector)
    if inputVector.y != 0 then 
        if inputVector.y > 0 then 
            self.facing = DIRECTIONS.UP
        else
            self.facing = DIRECTIONS.DOWN
        end if
    else
        if inputVector.x != 0 then
            if inputVector.x > 0 then
                self.facing = DIRECTIONS.RIGHT
            else
                self.facing = DIRECTIONS.LEFT
            end if
        end if
    end if
    animationString = ""
    if inputVector.x == 0 and inputVector.y == 0 then
        animationString = "idle_"
    else
        animationString = "walk_"
    end if
    animationString = animationString + DIRECTIONS.textList[self.facing]
    self.animationSystem.switchAnimation animationString
    self.animationSystem.update delta

    moveX = inputVector.x * self.speed * delta
    moveY = inputVector.y * self.speed * delta

    self.position.x = self.position.x + moveX
    self.position.y = self.position.y + moveY

    display(6).scrollX = display(6).scrollX + moveX
    display(6).scrollY = display(6).scrollY + moveY

    display(4).scrollX = display(4).scrollX + moveX
    display(4).scrollY = display(4).scrollY + moveY


end function

PlayerCharacter.render = function()
    frame = self.animationSystem.getFrame()
    sprite = new Sprite
    sprite.image = frame
    sprite.scale = 4
    sprite.x = self.position.x
    sprite.y = self.position.y
    display(4).sprites.push sprite
end function