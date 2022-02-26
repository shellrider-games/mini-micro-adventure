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
PlayerCharacter.bounds = new Bounds
PlayerCharacter.bounds.x = PlayerCharacter.position.x
PlayerCharacter.bounds.y = PlayerCharacter.position.y - 8*4
PlayerCharacter.bounds.width = 15*4
PlayerCharacter.bounds.height = 12*4

PlayerCharacter.move = function(x, y)
    self.position.x = self.position.x + x
    self.position.y = self.position.y + y
    self.bounds.x = self.bounds.x + x
    self.bounds.y = self.bounds.y + y
end function

PlayerCharacter.collideWithLevel = function()
    retArray = [false, false, false, false]
    for i in range(0, self.bounds.corners.len-1)
        tileX = floor(self.bounds.corners[i][0]/display(6).cellSize)
        tileY = floor(self.bounds.corners[i][1]/display(6).cellSize)
        if display(6).cell(tileX, tileY) != 0 then retArray[i] = true
    end for
    return retArray
end function

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

    self.move moveX, moveY

    collisions = self.collideWithLevel

    collisionInfo = {}
    collisionInfo.left = collisions[0] and collisions[1]
    collisionInfo.top = collisions[1] and collisions[2]
    collisionInfo.right = collisions[2] and collisions[3]
    collisionInfo.bottom = collisions[3] and collisions[0]
    collisionInfo.bottomLeft = collisions[0] and not collisions[1] and not collisions[3]
    collisionInfo.topLeft = collisions[1] and not collisions[2] and not collisions[0]
    collisionInfo.topRight = collisions[2] and not collisions[3] and not collisions[1]
    collisionInfo.bottomRight = collisions[3] and not collisions[0] and not collisions[2]

    if collisionInfo.bottomLeft or collisionInfo.topLeft or collisionInfo.topRight or collisionInfo.bottomRight then
        self.move -moveX,-moveY
        moveX = 0
        moveY = 0
    end if

    if collisionInfo.left or collisionInfo.right then
        self.move -moveX,0
        moveX = 0
    end if
    if collisionInfo.top or collisionInfo.bottom then
        self.move 0,-moveY
        moveY = 0
    end if



    //move camera
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